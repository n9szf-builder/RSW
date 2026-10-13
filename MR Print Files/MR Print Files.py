#!/usr/bin/env python3
# =====================================================================
#  MR Print Files - make the print files for any Rib Side Works model
#
#  Lives in  RSW / MR Print Files  and finds the models in  RSW / export :
#     Passenger cars   export/Passenger cars/Fleet export/<train set>/<car>/Kit/...
#     Freight cars     export/Freight/<type>/<car>/print_parts.json
#     Stations         export/Stations/<state>/<city>/print_parts.json
#  A freight car or station is listed as soon as its folder has a print_parts.json
#  (which OpenSCAD file to use and the parts to make) - nothing to change in this program.
#
#  Pick the train set or group, the car or model, the scale and the printer, then choose
#      Colour  -> 3MF files for a multi-colour (AMS) print
#      One colour -> STL files
#  G scale: the car's two trucks are made too (sideframes, bolsters, cross beams, wheels) - the
#  truck is the one set in the car's own file, so it always matches the car.
#  The files are made on the spot from the car's stand-alone OpenSCAD file
#  (Kit/<scale>/OpenSCAD/), so no STL or 3MF has to be stored with the kit.
#
#  Needs:  OpenSCAD (free, openscad.org) and Python 3.
#          Mac: Python 3 is asked for the first time.  Windows: install it from python.org and
#          tick "Add python.exe to PATH".  Linux: it is already there.
#  Start:  Mac      double-click "MR Print Files.command"
#          Windows  double-click "MR Print Files.bat"
#          Linux    run "MR Print Files.sh"
#          any      python3 "MR Print Files.py"
#  OpenSCAD somewhere unusual?  Put its full path on one line in a text file called
#          "openscad_path.txt" next to this program (or start with --openscad PATH).
#  Windows: keep this folder somewhere short, e.g. C:\RSW - Windows stops at 260 characters.
#  The screen opens in your web browser (it only talks to this computer - nothing goes on line).
#  From another computer on the same network:  start it with --share (or the "share on network" launcher).
#          It then answers on port 8765: browse to  http://<this computer's address>:8765  from any computer,
#          tablet or phone on the network. The files are made on THIS computer and downloaded as a zip.
#  Sign-in:  put the people who may use it in  users.json  next to this program:
#              {"users": [{"name": "tom", "password": "something long"}]}
#          or add one with   python3 "MR Print Files.py" --add-user tom   (it asks for the password).
#          A password typed into the file is replaced by a scrambled form the next time the program starts.
#          With a users.json, every other computer has to sign in; without one there is no password at all.
#          Anyone can change their own password on the page: "Change password" (next to Sign out).
#          Reached through a tunnel or another program on this computer? Start with --public so that
#          every request has to sign in, including ones that seem to come from this computer.
#  No browser?  python3 "MR Print Files.py" --menu     (asks the same questions in the program window)
#
#  Free for personal use.  Commercial use: contact Tom Fleming, n9szf@mac.com.
# =====================================================================
import argparse, glob, json, os, queue, re, shutil, struct, subprocess, sys, tempfile, threading, time, zipfile
import urllib.parse, hashlib, hmac, secrets
from concurrent.futures import ThreadPoolExecutor, as_completed

HERE = os.path.dirname(os.path.abspath(__file__))
SCALES = [("G", "G scale 1:29"), ("O", "O scale 1:48"), ("HO", "HO scale 1:87")]
PRINTERS = [("P1S", "Bambu P1S (256 mm bed) - body, roof and floor in sections"),
            ("GIGA", "OrangeStorm Giga (800 mm bed) - body, roof and floor in one piece")]
SCHEMES = [("UP", "Union Pacific yellow + gray (1955-71) - body in 3 colours"),
           ("MILW", "Milwaukee Road orange + maroon (to 1955) - body in 2 colours"),
           ("none", "Gray - every part in one colour")]
REVIEW_FILE = "car_review.json"


def kind(colour):
    """colour = "" (STL) or a paint scheme key (3MF)."""
    return {"": "STL", "UP": "colour 3MF Union Pacific", "MILW": "colour 3MF Milwaukee Road", "none": "3MF gray"}.get(colour or "", "colour 3MF")
DEFAULT_OUT = os.path.join(os.path.expanduser("~"), "Downloads")


# ---------------------------------------------------------------- finding things
def find_root():
    """The folder that holds the year folders (each car has Kit/<scale>/OpenSCAD/<car>_<G|O|HO>.scad)."""
    for cand in (os.path.join(os.path.dirname(HERE), "export", "Passenger cars", "Fleet export"),
                 HERE, os.path.join(HERE, "Fleet export"), os.path.join(os.path.dirname(HERE), "Fleet export")):
        if glob.glob(os.path.join(cand, "*", "*", "Kit", "*", "OpenSCAD", "*.scad")):
            return cand
    return HERE


def find_cars(root):
    """{year: {car folder: {"slug":.., "scad": {"G": path, ...}}}} in folder order."""
    cars = {}
    for sc in sorted(glob.glob(os.path.join(root, "*", "*", "Kit", "*", "OpenSCAD", "*.scad"))):
        parts = sc.split(os.sep)
        year, car = parts[-6], parts[-5]
        base = os.path.basename(sc)[:-5]
        slug, _, key = base.rpartition("_")
        if key not in ("G", "O", "HO"):
            continue
        cars.setdefault(year, {}).setdefault(car, {"slug": slug, "scad": {}})["scad"][key] = sc
    return cars


def find_models(cars, review):
    """Freight cars, stations and anything else under export/ that has a print_parts.json, added to the same list
    as the passenger cars: group = the folders above it ("Freight - Caboose"), name = its own folder ("1939 Rib Side").
    print_parts.json:  {"slug": "...", "review": {"verified": false, "code": "TDQ-160", "note": "..."},
                        "docs": ["notes/x.pdf"], "picture": "notes/x.png",
                        "scales": {"G": {"scad": "scad/Main.scad", "printers": [["P1S", "label"]],
                                         "mode": "parts", "var": "part", "parts": [["body", 1], ["step", 4]]}}}
    mode "parts": one file per part, made with  -D <var>="<part>" ; the number is how many to print.
    mode "list":  the OpenSCAD file is asked for its own list (-D LIST=true prints PART|name|sections), then each
                  section is made with  -D PRINTER -D SHOW="<name>" -D TILE=<n>."""
    for exp in (os.path.join(os.path.dirname(HERE), "export"), os.path.join(HERE, "export")):
        if not os.path.isdir(exp):
            continue
        for mf in sorted(glob.glob(os.path.join(exp, "**", "print_parts.json"), recursive=True)):
            try:
                with open(mf, encoding="utf-8") as f: m = json.load(f)
            except (OSError, ValueError) as e:
                print(f"Skipped {mf}: {e}"); continue
            d = os.path.dirname(mf); rel = os.path.relpath(d, exp).split(os.sep)
            group, name = " - ".join(rel[:-1]) or "Other", rel[-1]
            scad = {k: os.path.join(d, *v["scad"].split("/")) for k, v in m.get("scales", {}).items()}
            scad = {k: v for k, v in scad.items() if os.path.exists(v)}
            if not scad:
                continue
            slug = m.get("slug") or name.replace(" ", "_")
            cars.setdefault(group, {})[name] = {"slug": slug, "scad": scad, "spec": {k: m["scales"][k] for k in scad}, "model": m, "dir": d}
            if m.get("review") is not None:
                review.setdefault(slug, m["review"])
        break
    return cars


def entry_spec(d, key):
    return (d.get("spec") or {}).get(key)


def entry_printers(d, key):
    sp = entry_spec(d, key)
    if sp is not None:
        return [tuple(x) for x in (sp.get("printers") or [["P1S", "As drawn"]])]
    return [x for x in PRINTERS if not (key == "HO" and x[0] == "GIGA")]


def entry_docs(d, key):
    if entry_spec(d, key) is None:
        return car_docs(d["scad"][key])
    return [x for x in (os.path.join(d["dir"], *y.split("/")) for y in d["model"].get("docs", [])) if os.path.exists(x)]


def entry_preview(d, key):
    if entry_spec(d, key) is None:
        return car_preview(d["scad"][key], d["slug"], key)
    pic = entry_spec(d, key).get("picture") or d["model"].get("picture")
    pth = pic and os.path.join(d["dir"], *pic.split("/"))
    return pth if pth and os.path.exists(pth) else None


def make_job(osc, d, key, printer, colour, out, **kw):
    return Job(osc, d["scad"][key], d["slug"], key, printer, colour, out, spec=entry_spec(d, key), docs=entry_docs(d, key), **kw)


def _console_openscad(path):
    """Windows: openscad.exe prints nothing; openscad.com next to it is the same program with its messages."""
    if os.name == "nt" and path.lower().endswith(".exe"):
        com = path[:-4] + ".com"
        if os.path.exists(com):
            return com
    return path


def find_openscad(given=None):
    """--openscad PATH, then the OPENSCAD setting, then openscad_path.txt next to this program, then the usual places."""
    cands = [given, os.environ.get("OPENSCAD")]
    try:
        with open(os.path.join(HERE, "openscad_path.txt"), encoding="utf-8", errors="replace") as f:
            cands.append(f.readline().strip().strip('"'))
    except OSError:
        pass
    cands += ["/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD",
              "/Applications/OpenSCAD-Nightly.app/Contents/MacOS/OpenSCAD",
              os.path.expanduser("~/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD")]
    if os.name == "nt":
        for base in (os.environ.get("ProgramFiles"), os.environ.get("ProgramW6432"), os.environ.get("ProgramFiles(x86)"),
                     os.path.join(os.environ.get("LOCALAPPDATA", ""), "Programs")):
            if base:
                for folder in ("OpenSCAD (Nightly)", "OpenSCAD"):
                    cands.append(os.path.join(base, folder, "openscad.exe"))
    for c in cands:
        if c and os.path.isfile(c):
            return _console_openscad(c)
    for name in ("openscad-nightly", "openscad", "OpenSCAD"):
        p = shutil.which(name)
        if p:
            return _console_openscad(p)
    return None


NO_OPENSCAD = ("OpenSCAD was not found. Install it from openscad.org (free), then start this program again. "
               "If it is installed somewhere unusual, put its full path in a text file called openscad_path.txt next to this program.")


def load_review(root):
    """car_review.json: {"<slug>": {"verified": true/false, "code": "TDQ-37", "date": "...", "note": "..."}}"""
    for cand in (os.path.join(root, REVIEW_FILE), os.path.join(HERE, REVIEW_FILE)):
        try:
            return json.load(open(cand))
        except (OSError, ValueError):
            pass
    return {}


def review_text(review, slug, key=None):
    """verified: true = every scale;  "verified_scales": ["G"] = only those scales."""
    r = review.get(slug)
    if r and (r.get("verified") or (key and key in r.get("verified_scales", []))):
        return True, "Reviewed and ready" + (f" ({r['date']})" if r.get("date") else "") + (f" - {r['note']}" if r.get("note") else "")
    code = f" ({r['code']})" if r and r.get("code") else ""
    note = f"  {r['note']}" if r and r.get("note") else ""
    other = f" Only {', '.join(r['verified_scales'])} scale has been reviewed." if r and r.get("verified_scales") else ""
    return False, f"NOT VERIFIED - this model has not been reviewed yet{code}.{other} Dimensions and fits may still change." + ("" if other else note)


# ---------------------------------------------------------------- STL in, 3MF out
def read_stl(path):
    """-> (vertices [(x, y, z) as text-safe floats], triangles [(a, b, c)]) with shared vertices merged."""
    data = open(path, "rb").read()
    verts, index, tris = [], {}, []

    def vid(v):
        i = index.get(v)
        if i is None:
            i = index[v] = len(verts)
            verts.append(v)
        return i

    nb = struct.unpack("<I", data[80:84])[0] if len(data) >= 84 else -1
    if len(data) == 84 + 50 * nb:                                   # binary STL
        off = 84
        for _ in range(nb):
            f = struct.unpack("<12f", data[off:off + 48])
            a, b, c = vid(f[3:6]), vid(f[6:9]), vid(f[9:12])
            if a != b and b != c and a != c:
                tris.append((a, b, c))
            off += 50
    else:                                                           # ASCII STL
        cur = []
        for line in data.decode("ascii", "replace").splitlines():
            p = line.split()
            if len(p) == 4 and p[0] == "vertex":
                cur.append(vid((float(p[1]), float(p[2]), float(p[3]))))
                if len(cur) == 3:
                    if cur[0] != cur[1] and cur[1] != cur[2] and cur[0] != cur[2]:
                        tris.append(tuple(cur))
                    cur = []
    return verts, tris


def write_3mf(out, name, parts, cx, cy):
    """parts = [(stl path, part name, filament number)].  One object, one part per STL, each on its own
    filament; parts keep their relative positions, the object is centred on (cx, cy) with its base at z = 0.
    Opens in Bambu Studio / Orca Slicer with the filaments already assigned."""
    meshes = []
    for path, pname, ex in parts:
        if os.path.exists(path) and os.path.getsize(path) > 0:
            v, t = read_stl(path)
            if t:
                meshes.append((v, t, pname, ex))
    if not meshes:
        return False
    xs = [p[0] for m in meshes for p in m[0]]; ys = [p[1] for m in meshes for p in m[0]]; zs = [p[2] for m in meshes for p in m[0]]
    tr = "1 0 0 0 1 0 0 0 1 %.4f %.4f %.4f" % (cx - (min(xs) + max(xs)) / 2, cy - (min(ys) + max(ys)) / 2, -min(zs))
    top = len(meshes) + 1
    esc = lambda s: s.replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;")
    m = ['<?xml version="1.0" encoding="UTF-8"?>',
         '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021">',
         ' <metadata name="Application">BambuStudio-02.00.00.00</metadata>', ' <metadata name="BambuStudio:3mfVersion">1</metadata>',
         f' <metadata name="Title">{esc(name)}</metadata>', ' <metadata name="Designer">Tom Fleming</metadata>', ' <resources>']
    for i, (v, t, _, _) in enumerate(meshes, 1):
        m.append(f'  <object id="{i}" type="model">\n   <mesh>\n    <vertices>')
        m.extend('     <vertex x="%.6g" y="%.6g" z="%.6g"/>' % p for p in v)
        m.append('    </vertices>\n    <triangles>')
        m.extend('     <triangle v1="%d" v2="%d" v3="%d"/>' % q for q in t)
        m.append('    </triangles>\n   </mesh>\n  </object>')
    m.append(f'  <object id="{top}" type="model">\n   <components>')
    m.extend(f'    <component objectid="{i}" transform="1 0 0 0 1 0 0 0 1 0 0 0"/>' for i in range(1, top))
    m += ['   </components>\n  </object>', ' </resources>', ' <build>',
          f'  <item objectid="{top}" transform="{tr}" printable="1"/>', ' </build>', '</model>']
    cfg = ['<?xml version="1.0" encoding="UTF-8"?>', '<config>', f'  <object id="{top}">',
           f'    <metadata key="name" value="{esc(name)}"/>', f'    <metadata key="extruder" value="{meshes[0][3]}"/>']
    for i, (_, _, pname, ex) in enumerate(meshes, 1):
        cfg.append(f'    <part id="{i}" subtype="normal_part">\n      <metadata key="name" value="{esc(pname)}"/>\n'
                   f'      <metadata key="matrix" value="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"/>\n      <metadata key="extruder" value="{ex}"/>\n    </part>')
    cfg += ['  </object>', '</config>']
    tmp = out + ".part"
    with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", '<?xml version="1.0" encoding="UTF-8"?>\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>\n <Default Extension="config" ContentType="text/xml"/>\n</Types>\n')
        z.writestr("_rels/.rels", '<?xml version="1.0" encoding="UTF-8"?>\n<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n <Relationship Target="/3D/3dmodel.model" Id="rel-1" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n</Relationships>\n')
        z.writestr("3D/3dmodel.model", "\n".join(m) + "\n")
        z.writestr("Metadata/model_settings.config", "\n".join(cfg) + "\n")
    os.replace(tmp, out)
    return True


# ---------------------------------------------------------------- the job
# A car's stand-alone file holds its truck (the frame style, wheelbase, wheel size and ride height that
# car uses) but only shows it in the assembly view. This small file sits on top of the car file and hands
# out the truck's print parts, each laid as it goes on the printer bed. The car file is not changed.
TRUCK_WRAPPER = """include <%s>
TRUCK_PART = "none";
module _mr_truck_out() {
    wb = ft(TRUCK_WHEELBASE_FT);
    beams = TRUCK_AXLES == 2 && (EQ || S38);
    if (TRUCK_PART == "info") echo(str("MRTRUCK;", TRUCK_AXLES, ";", beams ? 1 : 0, ";", AXLE_TIP_LEN, ";", AXLE_D, ";", AXLE_BEARING, ";", TRUCK_WHEELBASE_FT));
    else if (TRUCK_PART == "sideframe") translate([0, 0, -T_YI]) rotate([90, 0, 0]) mr_sideframe(TRUCK_AXLES, wb);
    else if (TRUCK_PART == "bolster") {
        if (TRUCK_AXLES == 3) translate([0, 0, mr_bolster6_top()]) rotate([180, 0, 0]) mr_truck_bolster(TRUCK_AXLES, wb);
        else translate([0, 0, -(T_ZTOP - inch(9))]) mr_truck_bolster(TRUCK_AXLES, wb);
    }
    else if (TRUCK_PART == "cross_beam") { if (beams) mr_end_beam(); }
    else if (TRUCK_PART == "wheel") mr_wheel();
}
_mr_truck_out();
"""


class Job:
    """Makes every print file for one car / scale / printer / colour choice."""

    def __init__(self, openscad, scad, slug, key, printer, colour, outdir, log=print, progress=None, workers=None, only=None, zipped=False, zip_to=None, docs=(), spec=None):
        self.spec, self.trucks = spec, None       # spec = a freight car's / station's entry from its print_parts.json
        self.osc, self.scad, self.slug, self.key, self.printer, self.colour = openscad, scad, slug, key, printer, colour
        self.out, self.log, self.progress, self.only = outdir, log, progress or (lambda done, total: None), only
        self.workers = workers or max(1, min(12, (os.cpu_count() or 4) // 2))
        self.zipped, self.result, self.zip_to, self.docs = zipped, outdir, zip_to, list(docs)
        self.cancelled = False
        self.procs = set()
        self.tmp = tempfile.mkdtemp(prefix="mrprint_")
        if os.name == "nt" and not spec:     # the stand-alone car file needs no other file, so a copy works the same
            try:
                short = os.path.join(self.tmp, os.path.basename(scad)); shutil.copy2(scad, short); self.scad = short
            except OSError:
                pass

    def cancel(self):
        self.cancelled = True
        for p in list(self.procs):
            try: p.kill()
            except OSError: pass

    def _run(self, args, scad=None):
        if self.cancelled:
            return ""
        p = subprocess.Popen([self.osc] + args + [scad or self.scad], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                             encoding="utf-8", errors="replace", stdin=subprocess.DEVNULL,
                             creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        self.procs.add(p)
        try:
            return p.communicate()[0] or ""
        finally:
            self.procs.discard(p)

    def render(self, part, section, colour_part, dest):
        if os.path.exists(dest):
            os.remove(dest)
        if self.spec:
            if self.spec.get("mode") == "list": args = ["-D", f'PRINTER="{self.printer}"', "-D", f'SHOW="{part}"', "-D", f"TILE={section}"]
            else: args = ["-D", f'{self.spec.get("var", "part")}="{part}"']
            out = self._run(["-o", dest] + args)
        elif part.startswith("truck:"):
            out = self._run(["-o", dest, "-D", 'PART="info"', "-D", f'TRUCK_PART="{part[6:]}"'], self.truck_scad)
        else:
            out = self._run(["-o", dest, "-D", f'PRINTER="{self.printer}"', "-D", f'PART="{part}"', "-D", f"SECTION={section}", "-D", f'COLOR_PART="{colour_part}"'])
        ok = os.path.exists(dest) and os.path.getsize(dest) > 200
        if not ok and not self.cancelled and "object is empty" not in out:      # a real OpenSCAD error: show it
            bad = [l.strip() for l in out.splitlines() if "ERROR" in l or "error" in l.lower() and "overwritten" not in l]
            tag = f"{part} {section}" + ("" if colour_part == "all" else f" ({colour_part})")
            self.log(f"   !!    {tag}: OpenSCAD error - " + (" | ".join(bad[-3:]) if bad else (out.strip().splitlines() or ["no message"])[-1])[:400])
        return ok

    def info(self):
        echo = os.path.join(self.tmp, "info.echo")
        out = self._run(["-o", echo, "-D", f'PRINTER="{self.printer}"', "-D", 'PART="info"'])
        txt = out + (open(echo, errors="replace").read() if os.path.exists(echo) else "")
        m = re.search(r"MRINFO;(\d+);(\d+);(\d);(\d);(\d)", txt)
        if not m:
            raise RuntimeError("OpenSCAD could not read this car's file. Open it in OpenSCAD to see the error.\n" + txt[-600:])
        return [int(x) for x in m.groups()]

    def truck_info(self):
        """-> (axles per truck, cross beams?, axle length mm, axle dia mm, bearing, wheelbase ft) or None if this car file has no truck to print."""
        self.truck_scad = os.path.join(self.tmp, "truck_parts.scad")
        with open(self.truck_scad, "w", encoding="utf-8") as f:
            f.write(TRUCK_WRAPPER % self.scad.replace("\\", "/"))
        echo = os.path.join(self.tmp, "truck.echo")
        out = self._run(["-o", echo, "-D", 'PART="info"', "-D", 'TRUCK_PART="info"'], self.truck_scad)
        txt = out + (open(echo, errors="replace").read() if os.path.exists(echo) else "")
        m = re.search(r"MRTRUCK;(\d+);(\d);([\d.]+);([\d.]+);([^;\"]*);([\d.]+)", txt)
        return (int(m.group(1)), m.group(2) == "1", float(m.group(3)), float(m.group(4)), m.group(5), float(m.group(6))) if m else None

    def plan_model(self):
        """A freight car or station: the files to make, from its print_parts.json."""
        sp, names = self.spec, []
        if sp.get("mode") == "list":
            echo = os.path.join(self.tmp, "list.echo")
            out = self._run(["-o", echo, "-D", f'PRINTER="{self.printer}"', "-D", "LIST=true"])
            txt = out + (open(echo, errors="replace").read() if os.path.exists(echo) else "")
            found = re.findall(r'PART\|([^|"\s]+)\|(\d+)', txt)
            if not found:
                raise RuntimeError("OpenSCAD could not read this model's parts list. Open the file in OpenSCAD to see the error.\n" + txt[-600:])
            for nm, cnt in found:
                for t in range(int(cnt)):
                    names.append((f"{nm.split('_')[0]}/{nm}_{self.printer}_part{t + 1:02d}", nm, t))
        else:
            for i, (part, qty) in enumerate(sp.get("parts", []), 1):
                names.append((f"{i:02d}_{part}_x{qty}", part, 0))
        if self.only:
            names = [n for n in names if any(o.lower() in n[0].lower() for o in self.only)]
        return 0, 0, names

    def one_model(self, name, part, section):
        leaf = name.split("/")[-1]
        dest = os.path.join(self.out, *name.split("/")) + (".3mf" if self.colour else ".stl")
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        if not self.colour:
            ok = self.render(part, section, "all", dest)
        else:                                                  # one-colour 3MF
            tmp = os.path.join(self.tmp, name.replace("/", "_") + ".stl")
            centre = 400 if self.printer == "GIGA" else 128
            ok = self.render(part, section, "all", tmp) and write_3mf(dest, leaf, [(tmp, leaf, 1)], centre, centre)
            try: os.remove(tmp)
            except OSError: pass
        return name, (os.path.relpath(dest, self.out) if ok else None)

    def plan(self):
        if self.spec:
            return self.plan_model()
        nb, nf, ni, np_, ne = self.info()
        names = []                                            # (file name, part, section)
        for i in range(1, nb + 1):
            names += [(f"body_{i}", "body", i), (f"roof_{i}", "roof", i)]
        for i in range(1, nf + 1):
            names.append((f"floor_{i}", "floor", i))
            if ni: names.append((f"interior_{i}", "interior", i))
        if np_: names.append(("railing", "railing", 1))
        if ne: names.append(("equipment", "equipment", 1))
        names.append(("windows", "windows", 1))
        self.trucks = None
        if self.key == "G":
            names += [("steps", "steps", 1), ("battery_box", "battery_box", 1)]
            self.trucks = self.truck_info()                   # two trucks per car; "x4" in a file name = print it 4 times
            if self.trucks:
                ax, beams = self.trucks[0], self.trucks[1]
                names += [("truck_sideframe_x4", "truck:sideframe", 1), ("truck_bolster_x2", "truck:bolster", 1)]
                if beams: names.append(("truck_cross_beam_x4", "truck:cross_beam", 1))
                names.append((f"truck_wheel_x{4 * ax}", "truck:wheel", 1))
        if self.only:
            names = [n for n in names if any(o in n[0] for o in self.only)]
        return nb, nf, names

    def one(self, name, part, section):
        """Make one output file; returns (name, file name or None)."""
        if self.spec:
            return self.one_model(name, part, section)
        base = f"{self.slug}_{self.key}_{name}"
        centre = 400 if self.printer == "GIGA" else 128
        if not self.colour:
            dest = os.path.join(self.out, base + ".stl")
            return name, (os.path.basename(dest) if self.render(part, section, "all", dest) else None)
        t = lambda s: os.path.join(self.tmp, f"{base}_{s}.stl")
        sch = self.colour if self.colour in ("UP", "MILW", "none") else "UP"
        gray = {"UP": 2, "MILW": 3, "none": 1}[sch]            # filament used for the gray parts (roof, window rims)
        if part == "body" and sch != "none":
            split = {"UP": (("body", "sides - Armour Yellow", 1), ("skirt", "lower band + ends - Harbor Mist Gray", 2), ("stripe", "pinstripes - red", 3)),
                     "MILW": (("milw_orange", "sides + ends - orange (main colour)", 1), ("milw_maroon", "window band + letterboard - maroon (second colour)", 2), ("milw_upper", "letterboard + lower band - third colour, special cars only", 3))}[sch]
            parts = []
            for cp, label, fil in split:
                if self.render("body", section, cp, t(cp)): parts.append((t(cp), label, fil))
        elif part == "windows":
            parts = []
            for p2, label, fil in (("window_rims", "rims - gray / silver", gray), ("window_glass", "glass - clear or smoke", 4)):
                if self.render(p2, 1, "all", t(p2)): parts.append((t(p2), label, fil))
        else:
            parts = [(t("all"), name, gray if (part == "roof" or part.startswith("truck:")) else 1)] if self.render(part, section, "all", t("all")) else []
        if self.cancelled or not parts:
            return name, None
        dest = os.path.join(self.out, base + ".3mf")
        ok = write_3mf(dest, f"{self.slug} {self.key} {name}", parts, centre, centre)
        for p in parts:
            try: os.remove(p[0])
            except OSError: pass
        return name, (os.path.basename(dest) if ok else None)

    def run(self):
        t0 = time.time()
        os.makedirs(self.out, exist_ok=True)
        try:
            self.log("Reading the model file ...")
            nb, nf, names = self.plan()
            if self.spec:
                self.log(f"{len(names)} files to make, {self.workers} at a time." + (" That is the whole model: to make only part of it, stop and fill in 'Only these parts'." if len(names) > 60 else "")
                         + (" In a file name, x4 means print it 4 times." if self.spec.get("mode") != "list" else ""))
            else:
                self.log(f"{nb} body + {nb} roof + {nf} floor section(s); {len(names)} files to make, {self.workers} at a time.")
            if self.trucks and any(n[1].startswith("truck:") for n in names):
                ax, beams, alen, adia, brg, wbft = self.trucks
                self.log(f"Trucks: two {'six' if ax == 3 else 'four'}-wheel trucks, {wbft:g} ft wheelbase. Print each truck file as many times as its name says (x4 = print 4). "
                         f"To buy: {adia:g} mm brass rod for {2 * ax} axles cut {alen:g} mm long" + (f", {4 * ax} {brg}ZZ ball bearings" if brg and brg != "none" else "") + ", 2 pivot screws (M3).")
            elif self.key == "G" and not self.trucks and not self.spec:
                self.log("   --    trucks: this car file has no truck parts to print")
            made, failed, done = [], [], 0
            self.progress(0, len(names))
            with ThreadPoolExecutor(self.workers) as ex:
                futs = [ex.submit(self.one, *n) for n in names]
                for f in as_completed(futs):
                    name, fn = f.result()
                    done += 1
                    if self.cancelled: continue
                    (made if fn else failed).append(fn or name)
                    self.log(("   made  " + fn) if fn else f"   --    {name}: not made (nothing to print for this car, unless an error is shown above)")
                    self.progress(done, len(names))
            if self.cancelled:
                self.log("Stopped.")
                return False
            for d in self.docs:                                   # build instructions go with the print files
                try:
                    shutil.copy2(d, os.path.join(self.out, os.path.basename(d))); made.append(os.path.basename(d))
                    self.log("   added " + os.path.basename(d))
                except OSError as e:
                    self.log(f"   --    could not add {os.path.basename(d)}: {e}")
            if self.zipped and made:
                zp = self.zip_to or (self.out.rstrip("/\\") + ".zip")
                os.makedirs(os.path.dirname(zp) or ".", exist_ok=True)
                with zipfile.ZipFile(zp + ".part", "w", zipfile.ZIP_DEFLATED) as z:
                    for fn in sorted(made): z.write(os.path.join(self.out, fn), fn.replace(os.sep, "/"))
                os.replace(zp + ".part", zp)
                shutil.rmtree(self.out, ignore_errors=True)
                self.result = zp
                self.log(f"Zipped into one file ({os.path.getsize(zp) / 1e6:.1f} MB).")
            self.log(f"Done: {len(made)} file(s){', build instructions included,' if self.docs else ''} in {(time.time() - t0) / 60:.1f} min  ->  {self.result}")
            real_fail = [n for n in failed if self.spec or n.split("_")[0] in ("body", "roof", "floor")]
            if real_fail:
                self.log(("PROBLEM: these parts did not come out: " if self.spec else "PROBLEM: these main parts did not come out: ") + ", ".join(sorted(real_fail)))
            return not real_fail
        finally:
            shutil.rmtree(self.tmp, ignore_errors=True)


def car_docs(scad):
    """The build instructions that go with a car: Kit/How to build - *.pdf and the build book next to Kit."""
    kit = os.path.dirname(os.path.dirname(os.path.dirname(scad)))
    return sorted(glob.glob(os.path.join(kit, "How to build*.pdf"))) + sorted(glob.glob(os.path.join(os.path.dirname(kit), "*build book.pdf")))


def car_preview(scad, slug, key):
    scale_dir = os.path.dirname(os.path.dirname(scad)); car_dir = os.path.dirname(os.path.dirname(scale_dir))
    for cand in (os.path.join(scale_dir, "Pictures", f"{slug}_{key}_assembly.png"), os.path.join(car_dir, f"{slug} - render.png"),
                 os.path.join(os.path.dirname(scale_dir), "G scale 1-29", "Pictures", f"{slug}_G_assembly.png")):
        if os.path.exists(cand): return cand
    return None


def zip_file(base, slug, key, printer, colour):
    return os.path.join(base, f"{slug}_{key} - {'Giga' if printer == 'GIGA' else 'P1S'} - {kind(colour)}.zip")


def out_folder(base, year, car, key, printer, colour):
    scale = dict(SCALES)[key].replace(':', '-')
    return os.path.join(base, year, car, f"{scale} - {'Giga' if printer == 'GIGA' else 'P1S'} - {kind(colour)}")


# ---------------------------------------------------------------- window
def gui(root_dir, cars, review, osc):
    import tkinter as tk
    from tkinter import ttk, filedialog, messagebox
    w = tk.Tk(); w.title("Rib Side Works - make print files"); w.minsize(760, 560)
    q = queue.Queue(); state = {"job": None}
    f = ttk.Frame(w, padding=12); f.pack(fill="both", expand=True); f.columnconfigure(1, weight=1)
    year = tk.StringVar(); car = tk.StringVar(); scale = tk.StringVar(value="G"); printer = tk.StringVar(value="P1S")
    colour = tk.StringVar(value="stl"); outdir = tk.StringVar(value=DEFAULT_OUT)

    def row(r, label):
        ttk.Label(f, text=label).grid(row=r, column=0, sticky="nw", pady=4, padx=(0, 10))
    row(0, "1. Train set or group"); cby = ttk.Combobox(f, textvariable=year, values=list(cars), state="readonly"); cby.grid(row=0, column=1, sticky="ew", pady=4)
    row(1, "2. Car or model"); cbc = ttk.Combobox(f, textvariable=car, state="readonly"); cbc.grid(row=1, column=1, sticky="ew", pady=4)
    row(2, "3. Scale"); fs = ttk.Frame(f); fs.grid(row=2, column=1, sticky="w"); sbtn = {}
    for k, lab in SCALES:
        sbtn[k] = ttk.Radiobutton(fs, text=lab, value=k, variable=scale, command=lambda: refresh()); sbtn[k].pack(side="left", padx=(0, 14))
    row(3, "4. Printer"); fp = ttk.Frame(f); fp.grid(row=3, column=1, sticky="w"); pbtn = {}
    for k, lab in PRINTERS:
        pbtn[k] = ttk.Radiobutton(fp, text=lab, value=k, variable=printer, command=lambda: refresh()); pbtn[k].pack(anchor="w")
    row(4, "5. Print in colour?"); fc = ttk.Frame(f); fc.grid(row=4, column=1, sticky="w")
    ttk.Radiobutton(fc, text="Yes - 3MF files (body in three colours, windows in two; for an AMS)", value="3mf", variable=colour, command=lambda: refresh()).pack(anchor="w")
    ttk.Radiobutton(fc, text="No - STL files (one colour, to paint)", value="stl", variable=colour, command=lambda: refresh()).pack(anchor="w")
    row(5, "Save in"); fo = ttk.Frame(f); fo.grid(row=5, column=1, sticky="ew"); fo.columnconfigure(0, weight=1)
    ttk.Entry(fo, textvariable=outdir).grid(row=0, column=0, sticky="ew")
    ttk.Button(fo, text="Choose ...", command=lambda: (lambda d: d and (outdir.set(d), refresh()))(filedialog.askdirectory(initialdir=outdir.get() or "~"))).grid(row=0, column=1, padx=(6, 0))
    banner = tk.Label(f, text="", anchor="w", justify="left", wraplength=720, padx=8, pady=6, font=("Helvetica", 13, "bold")); banner.grid(row=6, column=0, columnspan=2, sticky="ew", pady=(10, 4))
    where = ttk.Label(f, text="", wraplength=720, foreground="#555"); where.grid(row=7, column=0, columnspan=2, sticky="w")
    fb = ttk.Frame(f); fb.grid(row=8, column=0, columnspan=2, sticky="ew", pady=8)
    go = ttk.Button(fb, text="Make the print files"); go.pack(side="left")
    stop = ttk.Button(fb, text="Stop", state="disabled"); stop.pack(side="left", padx=6)
    opn = ttk.Button(fb, text="Open the folder"); opn.pack(side="left")
    bar = ttk.Progressbar(f, mode="determinate"); bar.grid(row=9, column=0, columnspan=2, sticky="ew")
    log = tk.Text(f, height=12, wrap="word", state="disabled"); log.grid(row=10, column=0, columnspan=2, sticky="nsew", pady=(8, 0)); f.rowconfigure(10, weight=1)

    def say(s):
        log.configure(state="normal"); log.insert("end", s + "\n"); log.see("end"); log.configure(state="disabled")

    def current():
        c = cars.get(year.get(), {}).get(car.get())
        return c, (c["scad"].get(scale.get()) if c else None)

    def target():
        return out_folder(outdir.get(), year.get(), car.get(), scale.get(), printer.get(), colour.get() == "3mf")

    def refresh(*_):
        c, scad = current()
        if c:
            for k, _ in SCALES:
                sbtn[k].configure(state="normal" if k in c["scad"] else "disabled")
            if scale.get() not in c["scad"]: scale.set(sorted(c["scad"])[0]); scad = c["scad"][scale.get()]
            pbtn["GIGA"].configure(state="disabled" if scale.get() == "HO" else "normal")
            if scale.get() == "HO": printer.set("P1S")
            ok, txt = review_text(review, c["slug"])
            banner.configure(text=("\u2713  " if ok else "\u26a0  ") + txt, bg="#DFF3E3" if ok else "#FFE3B3", fg="#1E5B2A" if ok else "#7A3B00")
            where.configure(text="Files will go to:  " + target())
        go.configure(state="normal" if (scad and osc and not state["job"]) else "disabled")

    def pick_year(*_):
        names = list(cars.get(year.get(), {})); cbc.configure(values=names); car.set(names[0] if names else ""); refresh()
    cby.bind("<<ComboboxSelected>>", pick_year); cbc.bind("<<ComboboxSelected>>", refresh)

    def start():
        c, scad = current()
        ok, txt = review_text(review, c["slug"])
        if not ok and not messagebox.askyesno("Car not verified", txt + "\n\nMake the print files anyway?", icon="warning"):
            return
        job = Job(osc, scad, c["slug"], scale.get(), printer.get(), colour.get() == "3mf", target(), spec=entry_spec(c, scale.get()),
                  log=lambda s: q.put(("log", s)), progress=lambda d, t: q.put(("bar", d, t)))
        state["job"] = job; go.configure(state="disabled"); stop.configure(state="normal"); bar.configure(value=0)
        say(f"--- {year.get()} / {car.get()} / {scale.get()} / {printer.get()} / {'colour 3MF' if colour.get() == '3mf' else 'STL'}")
        def work():
            try: res = job.run()
            except Exception as e: q.put(("log", "PROBLEM: " + str(e))); res = False
            q.put(("end", res))
        threading.Thread(target=work, daemon=True).start()

    def pump():
        try:
            while True:
                m = q.get_nowait()
                if m[0] == "log": say(m[1])
                elif m[0] == "bar": bar.configure(maximum=max(m[2], 1), value=m[1])
                elif m[0] == "end":
                    state["job"] = None; stop.configure(state="disabled"); refresh()
        except queue.Empty:
            pass
        w.after(150, pump)

    def open_folder():
        d = target() if os.path.isdir(target()) else outdir.get()
        if not os.path.isdir(d): messagebox.showinfo("Nothing there yet", "No files have been made for this choice yet."); return
        if sys.platform == "darwin": subprocess.Popen(["open", d])
        elif os.name == "nt": os.startfile(d)
        else: subprocess.Popen(["xdg-open", d])

    go.configure(command=start); stop.configure(command=lambda: state["job"] and state["job"].cancel()); opn.configure(command=open_folder)
    if not cars:
        say("No car files found. Keep this program in the folder that holds the year folders (each car has Kit/<scale>/OpenSCAD).")
    if not osc:
        say(NO_OPENSCAD)
    else:
        say("OpenSCAD: " + osc)
    if cars:
        year.set(list(cars)[0]); pick_year()
    pump(); w.mainloop()


# ---------------------------------------------------------------- screen in the web browser (default)
PAGE = r"""<!doctype html><html><head><meta charset="utf-8"><title>Milwaukee Road - make print files</title>
<style>
body{font:16px -apple-system,Helvetica,Arial,sans-serif;background:#0E2A4D;color:#EAF0F8;margin:0}
main{max-width:1180px;margin:0 auto;padding:20px 20px 40px}
header{display:flex;align-items:center;gap:18px;margin-bottom:16px}
header img{height:92px;width:auto} h1{font-size:24px;margin:0 0 4px;color:#fff} .sub{color:#B9C7DA;margin:0;font-size:14px}
.cols{display:grid;grid-template-columns:1fr 1.3fr .8fr 1.6fr;grid-template-rows:auto 1fr;gap:12px;align-items:start}
.col4{grid-column:4;grid-row:1 / span 2}
#prev{display:none;grid-column:1 / span 2;grid-row:2;width:100%;max-height:420px;object-fit:contain;background:#fff;border-radius:8px}
@media (max-width:900px){.cols{grid-template-columns:1fr 1fr;grid-template-rows:none} .col{order:2} .col:nth-child(1),.col:nth-child(2){order:0} .col4{grid-column:auto;grid-row:auto} #prev{grid-row:auto;order:1}}
@media (max-width:560px){.cols{grid-template-columns:1fr} #prev{grid-column:1}}
.step{background:#17406E;border:1px solid #2C5C92;border-radius:8px;padding:12px 14px}
.step+.step{margin-top:12px} .col>.step:first-child{margin-top:0}
.step b{display:block;margin-bottom:8px;color:#FFB45C} select,input[type=text]{font-size:16px;padding:7px;width:100%;box-sizing:border-box;border-radius:6px;border:1px solid #89A3C4;background:#fff;color:#111}
label{display:block;padding:3px 0} label.off{color:#7F95B2}
#banner{padding:12px 14px;border-radius:8px;font-weight:700;margin:16px 0 6px}
.bad{background:#FFE3B3;color:#7A3B00;border:1px solid #E0A040} .good{background:#DFF3E3;color:#1E5B2A;border:1px solid #7DBE8A}
#where{font-size:13px;color:#B9C7DA;word-break:break-all;margin-bottom:12px}
button{font-size:16px;padding:9px 16px;border-radius:7px;border:1px solid #89A3C4;background:#fff;color:#111;cursor:pointer;margin-right:8px}
button.go{background:#FF870F;border-color:#c96500;color:#fff;font-weight:700} button:disabled{opacity:.45;cursor:default}
progress{width:100%;height:16px;margin-top:14px} pre{background:#071A30;color:#E8EEF6;border:1px solid #2C5C92;padding:10px;border-radius:8px;height:230px;overflow:auto;font-size:13px;white-space:pre-wrap}
</style></head><body><main>
<header><img src="/logo" alt="" onerror="this.style.display='none'">
<div><h1>Rib Side Works &ndash; make print files</h1>
<p class="sub">Passenger cars, freight cars and stations. The files are made on this computer from the model's OpenSCAD file. Keep this page and the program window (the one with the text) open while it works.</p>
<p class="sub" id="who" style="display:none;margin-top:6px"></p></div></header>
<div class="cols">
<div class="col"><div class="step"><b>1. Train set or group</b><select id="year"></select></div></div>
<div class="col"><div class="step"><b>2. Car or model</b><select id="car"></select></div></div>
<div class="col"><div class="step"><b>3. Scale</b><div id="scale"></div></div></div>
<div class="col col4"><div class="step"><b>4. Printer</b><div id="printer"></div></div>
<div class="step"><b>5. Print in colour?</b>
 <label><input type="radio" name="col" value="1"> Yes &ndash; 3MF files for a multi-colour (AMS) print</label>
 <label><input type="radio" name="col" value="0" checked> No &ndash; STL files (one colour, to paint)</label></div>
<div class="step"><b>6. Colours</b><div id="scheme"></div><div class="sub" id="schnote" style="margin-top:6px"></div></div>
<div class="step"><b>Save in</b><input type="text" id="out">
 <label style="margin-top:8px"><input type="checkbox" id="zip" checked> Put all the files in one zip file</label>
 <label style="margin-top:8px">Only these parts (optional)<input type="text" id="only" placeholder="e.g. truck   or   Wall Roof"></label></div></div>
<img id="prev" alt="">
</div>
<div id="banner"></div>
<div id="where"></div>
<button class="go" id="go">Make the print files</button><button id="stop" disabled>Stop</button><button id="open">Open the folder</button><button id="docs">Build instructions</button><button id="quit">Quit</button>
<a id="dl" style="display:none;margin:12px 0 0;padding:10px 16px;border-radius:7px;background:#2E7D32;color:#fff;font-weight:700;text-decoration:none"></a>
<progress id="bar" value="0" max="1"></progress><pre id="log"></pre>
</main><script>
let D=null, running=false;
const $=id=>document.getElementById(id), val=n=>document.querySelector('input[name='+n+']:checked').value;
function radios(el,name,opts,cur){el.innerHTML='';opts.forEach(o=>{const l=document.createElement('label');if(o.off)l.className='off';
 l.innerHTML='<input type="radio" name="'+name+'" value="'+o.k+'"'+(o.off?' disabled':'')+(o.k==cur?' checked':'')+'> '+o.t;el.appendChild(l);});
 el.querySelectorAll('input').forEach(i=>i.onchange=refresh);}
function car(){return D.cars[$('year').value][$('car').value];}
function fillCars(){const c=$('car');c.innerHTML='';Object.keys(D.cars[$('year').value]).forEach(n=>c.add(new Option(n,n)));refresh();}
function refresh(){const c=car();let s=document.querySelector('input[name=scale]:checked');s=s?s.value:'G';if(!c.scales.includes(s))s=c.scales[0];
 radios($('scale'),'scale',D.scales.map(x=>({k:x[0],t:x[1],off:!c.scales.includes(x[0])})),s);
 let p=document.querySelector('input[name=printer]:checked');p=p?p.value:'P1S';const pl=c.printers[s];if(!pl.some(x=>x[0]==p))p=pl[0][0];
 radios($('printer'),'printer',pl.map(x=>({k:x[0],t:x[1],off:false})),p);
 const rv=c.rev[s];c.ok=rv[0];c.text=rv[1];
 const b=$('banner');b.className=c.ok?'good':'bad';b.textContent=(c.ok?'✓  ':'⚠  ')+c.text;
 const pv=$('prev');pv.onerror=()=>pv.style.display='none';pv.onload=()=>pv.style.display='block';
 const u='/preview?year='+encodeURIComponent($('year').value)+'&car='+encodeURIComponent($('car').value)+'&scale='+s;if(pv.dataset.u!=u){pv.dataset.u=u;pv.src=u;}
 $('docs').disabled=!c.docs;
 const sc=D.scales.find(x=>x[0]==s)[1].replace(':','-');
 let sm=document.querySelector('input[name=scheme]:checked');sm=sm?sm.value:'UP';const stl=val('col')!='1';
 radios($('scheme'),'scheme',D.schemes.map(x=>({k:x[0],t:x[1],off:stl||c.simple})),sm);if(c.simple)sm='none';
 $('schnote').textContent=(c.simple&&!stl)?'One-colour 3MF files (filament 1). Colour schemes are for the passenger cars.':stl?'STL files are one colour - choose Yes above to pick a colour scheme.':(sm=='MILW'?'Filaments: 1 orange, 2 maroon, 3 gray (roof, window rims), 4 glass.':sm=='UP'?'Filaments: 1 yellow, 2 gray, 3 red, 4 glass.':'Filament 1 for everything; 4 for the window glass.');
 const kind=(p=='GIGA'?'Giga':'P1S')+' - '+D.kinds[stl?'':sm];
 if(D.remote)$('where').textContent='The files are made on '+D.host+', put in one zip file, and offered here as a download.';else
 $('where').textContent='Files will go to:  '+($('zip').checked? $('out').value+'/'+c.slug+'_'+s+' - '+kind+'.zip' : $('out').value+'/'+$('year').value+'/'+$('car').value+'/'+sc+' - '+kind)+'   (print files + build instructions)';
 $('go').disabled=running||!D.openscad;}
function choice(){return{year:$('year').value,car:$('car').value,scale:val('scale'),printer:val('printer'),colour:(val('col')=='1'?(car().simple?'none':val('scheme')):''),out:$('out').value,zip:$('zip').checked,only:$('only').value};}
async function post(u,b){const r=await fetch(u,{method:'POST',body:JSON.stringify(b||{})});if(r.status==401){location.reload();return {};}return r.json();}
$('go').onclick=async()=>{const c=car();if(!c.ok&&!confirm(c.text+'\n\nMake the print files anyway?'))return;const r=await post('/api/start',choice());if(!r.ok)alert(r.msg||'MR Print Files is busy making another set of files (or OpenSCAD is missing on that computer). Try again when it has finished.');poll();};
$('stop').onclick=()=>post('/api/stop');$('docs').onclick=async()=>{const r=await post('/api/docs',choice());if(r.msg)alert(r.msg);};$('open').onclick=async()=>{const r=await post('/api/open',choice());if(r.msg)alert(r.msg);};
$('quit').onclick=async()=>{await post('/api/quit');document.body.innerHTML='<main><h1>Closed.</h1><p class="sub">You can close this tab and the program window.</p></main>';};
async function poll(){let s;try{const r=await fetch('/api/status');if(r.status==401){location.reload();return;}s=await r.json();}catch(e){$('log').textContent+='\n(The program has been closed.)';return;}
 running=s.running;$('log').textContent=s.log.join('\n');$('log').scrollTop=1e9;$('bar').max=Math.max(s.total,1);$('bar').value=s.done;
 $('stop').disabled=!running;$('go').disabled=running||!D.openscad;
 const dl=$('dl');if(s.download&&!running){dl.href='/download/'+encodeURIComponent(s.download);dl.textContent='\u2B07 Download '+s.download;dl.style.display='inline-block';}else dl.style.display='none';
 if(running)setTimeout(poll,700);}
(async()=>{D=await (await fetch('/api/cars')).json();$('out').value=D.out;
 if(D.user||D.users_on){const w=$('who');w.style.display='block';w.textContent=D.user?'Signed in as '+D.user+'.  ':'';
  const lk=(t,f)=>{const a=document.createElement('a');a.href='#';a.textContent=t;a.style.color='#FFB45C';a.style.marginRight='14px';a.onclick=e=>{e.preventDefault();f();};w.appendChild(a);};
  lk('Change password',()=>pwBox(D.user||''));
  if(D.user)lk('Sign out',async()=>{await post('/api/logout');location.reload();});}
 if(D.remote){$('out').value='(downloaded to this computer)';$('out').disabled=true;$('zip').checked=true;$('zip').disabled=true;$('open').style.display='none';$('quit').style.display='none';$('docs').style.display='none';}const y=$('year');Object.keys(D.cars).forEach(n=>y.add(new Option(n,n)));
 y.onchange=fillCars;$('car').onchange=refresh;$('out').oninput=refresh;$('zip').onchange=refresh;document.querySelectorAll('input[name=col]').forEach(i=>i.onchange=refresh);
 if(!Object.keys(D.cars).length){$('banner').className='bad';$('banner').textContent='No car files found. Keep this program in the folder that holds the year folders.';return;}
 fillCars();poll();})();
</script><script>
function pwBox(me){if(document.getElementById('pwbox'))return;
 const d=document.createElement('div');d.id='pwbox';
 d.style.cssText='position:fixed;inset:0;background:rgba(0,0,0,.55);display:flex;align-items:center;justify-content:center;z-index:99';
 d.innerHTML='<form style="background:#17406E;border:1px solid #2C5C92;border-radius:10px;padding:22px 24px;width:min(340px,88vw);color:#EAF0F8;font:15px -apple-system,Helvetica,Arial,sans-serif">'
 +'<div style="font-size:18px;font-weight:700;margin-bottom:6px">Change password</div>'
 +'<label style="display:block;margin:10px 0 3px;color:#FFB45C;font-weight:700">Name</label><input id="pw_n" autocomplete="username" required>'
 +'<label style="display:block;margin:10px 0 3px;color:#FFB45C;font-weight:700">Current password</label><input id="pw_o" type="password" autocomplete="current-password" required>'
 +'<label style="display:block;margin:10px 0 3px;color:#FFB45C;font-weight:700">New password (8 or more characters)</label><input id="pw_1" type="password" autocomplete="new-password" required>'
 +'<label style="display:block;margin:10px 0 3px;color:#FFB45C;font-weight:700">New password again</label><input id="pw_2" type="password" autocomplete="new-password" required>'
 +'<label style="display:flex;align-items:center;gap:8px;margin-top:10px;color:#B9C7DA;cursor:pointer"><input id="pw_s" type="checkbox" style="width:auto;margin:0"> Show passwords</label>'
 +'<div id="pw_m" style="min-height:20px;margin-top:10px;color:#FFD0A0;font-size:14px"></div>'
 +'<div style="display:flex;gap:10px;margin-top:8px"><button style="flex:1;padding:9px;border-radius:7px;border:1px solid #c96500;background:#FF870F;color:#fff;font-weight:700;cursor:pointer">Save</button>'
 +'<button type="button" id="pw_c" style="flex:1;padding:9px;border-radius:7px;border:1px solid #89A3C4;background:transparent;color:#EAF0F8;cursor:pointer">Cancel</button></div></form>';
 document.body.appendChild(d);
 d.querySelectorAll('input:not([type=checkbox])').forEach(i=>i.style.cssText='font-size:15px;padding:8px;width:100%;box-sizing:border-box;border-radius:6px;border:1px solid #89A3C4');
 const g=id=>document.getElementById(id), n=g('pw_n');
 n.value=me; if(me){n.readOnly=true;n.style.opacity='.7';g('pw_o').focus();}else n.focus();
 g('pw_s').onchange=e=>['pw_o','pw_1','pw_2'].forEach(id=>g(id).type=e.target.checked?'text':'password');
 g('pw_c').onclick=()=>d.remove();
 d.querySelector('form').onsubmit=async e=>{e.preventDefault();const m=g('pw_m');m.textContent='';
  if(g('pw_1').value.length<8){m.textContent='Use at least 8 characters.';return;}
  if(g('pw_1').value!==g('pw_2').value){m.textContent='The two new passwords do not match.';return;}
  try{const r=await (await fetch('/api/password',{method:'POST',body:JSON.stringify({name:n.value,old:g('pw_o').value,new:g('pw_1').value})})).json();
   if(r.ok){m.style.color='#9FE29F';m.textContent='Saved. Use the new password next time you sign in.';setTimeout(()=>d.remove(),1800);}
   else m.textContent=r.msg||'Not changed.';}catch(x){m.textContent='Could not reach the program.';}};}
</script></body></html>"""


SHARE_PORT = 8765
USERS_FILE = os.path.join(HERE, "users.json")
PW_ROUNDS = 200000
SESSION_HOURS = 12


def _pw_hash(password, salt=None, rounds=PW_ROUNDS):
    salt = salt or secrets.token_hex(16)
    return salt, hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), bytes.fromhex(salt), int(rounds)).hex()


def _users_raw(path=USERS_FILE):
    try:
        with open(path, encoding="utf-8") as f: data = json.load(f)
    except FileNotFoundError:
        return {"users": []}
    except (OSError, ValueError) as e:
        sys.exit(f"users.json could not be read ({e}). Fix it or remove it, then start again.")
    if not isinstance(data, dict) or not isinstance(data.get("users", []), list):
        sys.exit('users.json should look like  {"users": [{"name": "tom", "password": "..."}]}')
    data.setdefault("users", [])
    return data


def _users_save(data, path=USERS_FILE):
    tmp = path + ".part"
    with open(tmp, "w", encoding="utf-8") as f: json.dump(data, f, indent=2)
    os.replace(tmp, path)
    try: os.chmod(path, 0o600)
    except OSError: pass


def load_users(path=USERS_FILE):
    """users.json -> {name in lower case: entry}. A password written in plain text is replaced by its salted hash."""
    data, changed, users = _users_raw(path), False, {}
    for u in data["users"]:
        name = str(u.get("name", "")).strip()
        if not name:
            continue
        if u.get("password"):
            salt, h = _pw_hash(str(u.pop("password"))); u.update(salt=salt, hash=h, rounds=PW_ROUNDS); changed = True
        u.pop("password", None)
        if u.get("salt") and u.get("hash"):
            users[name.lower()] = u
    if changed:
        _users_save(data, path); print("users.json: the passwords typed in it have been scrambled (they can no longer be read from the file).")
    return users


def check_password(users, name, password):
    """-> the user's name as written in users.json, or None."""
    u = users.get(str(name).strip().lower())
    if not u:
        _pw_hash(password, "00" * 16)                      # take the same time for a name that does not exist
        return None
    _, h = _pw_hash(password, u["salt"], u.get("rounds", PW_ROUNDS))
    return u["name"] if hmac.compare_digest(h, u["hash"]) else None


def user_admin(a):
    """--users / --add-user NAME / --remove-user NAME"""
    data = _users_raw()
    if a.add_user:
        import getpass
        name = a.add_user.strip()
        pw = getpass.getpass(f"Password for {name}: ")
        if len(pw) < 8: sys.exit("Use at least 8 characters.")
        if pw != getpass.getpass("Again: "): sys.exit("The two did not match - nothing changed.")
        salt, h = _pw_hash(pw)
        data["users"] = [u for u in data["users"] if str(u.get("name", "")).strip().lower() != name.lower()] + [{"name": name, "salt": salt, "hash": h, "rounds": PW_ROUNDS}]
        _users_save(data); print(f"{name} can now sign in.")
    elif a.remove_user:
        keep = [u for u in data["users"] if str(u.get("name", "")).strip().lower() != a.remove_user.strip().lower()]
        if len(keep) == len(data["users"]): sys.exit(f"No user called {a.remove_user}.")
        data["users"] = keep; _users_save(data); print(f"{a.remove_user} removed.")
    names = [str(u.get("name")) for u in data["users"]]
    print(("Users: " + ", ".join(names)) if names else "No users yet: there is no sign-in until users.json has one.")
    return 0


LOGIN_PAGE = r"""<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Rib Side Works - sign in</title>
<style>body{font:16px -apple-system,Helvetica,Arial,sans-serif;background:#0E2A4D;color:#EAF0F8;margin:0;display:flex;min-height:100vh;align-items:center;justify-content:center}
form{background:#17406E;border:1px solid #2C5C92;border-radius:10px;padding:26px 28px;width:min(340px,86vw)}
img{display:block;height:84px;margin:0 auto 12px} h1{font-size:20px;margin:0 0 4px;text-align:center;color:#fff} p{color:#B9C7DA;font-size:14px;text-align:center;margin:0 0 16px}
label{display:block;margin:12px 0 4px;color:#FFB45C;font-weight:700} input{font-size:16px;padding:9px;width:100%;box-sizing:border-box;border-radius:6px;border:1px solid #89A3C4}
button{margin-top:18px;width:100%;font-size:16px;padding:10px;border-radius:7px;border:1px solid #c96500;background:#FF870F;color:#fff;font-weight:700;cursor:pointer}
#msg{min-height:20px;margin-top:12px;color:#FFD0A0;text-align:center;font-size:14px}
label.show{display:flex;align-items:center;gap:8px;color:#B9C7DA;font-weight:400;font-size:14px;margin-top:8px;cursor:pointer} label.show input{width:auto;margin:0}</style></head><body>
<form id="f"><img src="/logo" alt="" onerror="this.style.display='none'"><h1>Rib Side Works</h1><p>Sign in to make print files.</p>
<label for="n">Name</label><input id="n" autocomplete="username" autofocus required>
<label for="p">Password</label><input id="p" type="password" autocomplete="current-password" required>
<label class="show"><input type="checkbox" onchange="document.getElementById('p').type=this.checked?'text':'password'"> Show password</label>
<button>Sign in</button><div id="msg"></div></form>
<script>document.getElementById('f').onsubmit=async e=>{e.preventDefault();const m=document.getElementById('msg');m.textContent='';
 try{const r=await (await fetch('/api/login',{method:'POST',body:JSON.stringify({name:document.getElementById('n').value,password:document.getElementById('p').value})})).json();
 if(r.ok)location.reload();else m.textContent=r.msg||'Name or password not right.';}catch(x){m.textContent='Could not reach the program.';}};</script></body></html>"""


def lan_address():
    """This computer's address on the local network, or None."""
    import socket
    try:
        k = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            k.connect(("10.255.255.255", 1)); return k.getsockname()[0]
        finally:
            k.close()
    except OSError:
        return None


def web(cars, review, osc, open_browser=True, share=False, port=0, public=False):
    import http.server, webbrowser, socket
    users = load_users()
    if public and not users:
        sys.exit('--public needs at least one user. Add one with:  python3 "MR Print Files.py" --add-user NAME')
    sessions, fails = {}, {}            # sign-in cookie -> (name, good until);  address -> [wrong tries, locked until]
    LOCAL = ("127.0.0.1", "::1", "::ffff:127.0.0.1")
    st = {"job": None, "log": [("OpenSCAD: " + osc) if osc else NO_OPENSCAD],
          "done": 0, "total": 1, "running": False, "download": None}
    # files asked for from another computer are made here, zipped, and handed over as a download
    share_dir = os.path.join(tempfile.gettempdir(), "MR Print Files - network downloads")
    host_name = socket.gethostname()
    if share:
        os.makedirs(share_dir, exist_ok=True)
        for old in glob.glob(os.path.join(share_dir, "*.zip")):          # tidy up downloads more than a day old
            try:
                if time.time() - os.path.getmtime(old) > 86400: os.remove(old)
            except OSError: pass
    lock = threading.Lock()

    def say(s):
        with lock: st["log"].append(s); del st["log"][:-400]

    def target(c):
        return out_folder(os.path.expanduser(c["out"]), c["year"], c["car"], c["scale"], c["printer"], c["colour"])

    class H(http.server.BaseHTTPRequestHandler):
        def log_message(self, *a): pass

        def remote(self):                      # asked from another computer (not this one)?  --public: everyone counts as remote
            return public or self.client_address[0] not in LOCAL

        def ip(self):                          # who is asking: behind a tunnel or proxy on this computer, the address it passes on
            a = self.client_address[0]
            if a in LOCAL and self.headers.get("X-Forwarded-For"):
                return self.headers["X-Forwarded-For"].split(",")[0].strip()[:60] or a
            return a

        def user(self):
            """"" = no sign-in needed (this computer, or no users.json); a name = signed in; None = must sign in first."""
            if not users or not self.remote():
                return ""
            for part in (self.headers.get("Cookie") or "").split(";"):
                k, _, v = part.strip().partition("=")
                if k == "mrpf":
                    got = sessions.get(v)
                    if got and got[1] > time.time(): return got[0]
                    sessions.pop(v, None)
            return None

        def send(self, body, ctype="application/json", headers=()):
            b = body.encode() if isinstance(body, str) else json.dumps(body).encode()
            self.send_response(200); self.send_header("Content-Type", ctype + "; charset=utf-8"); self.send_header("Content-Length", str(len(b)))
            for k, v in headers: self.send_header(k, v)
            self.send_header("Cache-Control", "no-store"); self.end_headers(); self.wfile.write(b)

        def do_GET(self):
            who = self.user()
            if who is None:                    # not signed in: the sign-in page (and its logo), nothing else
                if self.path == "/": return self.send(LOGIN_PAGE, "text/html")
                if self.path != "/logo": return self.send_error(401)
            if self.path == "/":
                self.send(PAGE, "text/html")
            elif self.path == "/logo":
                for cand in (os.path.join(HERE, "MR Print Files logo.png"), os.path.join(HERE, "_assets", "milwaukee_road_logo.png")):
                    if os.path.exists(cand):
                        b = open(cand, "rb").read()
                        self.send_response(200); self.send_header("Content-Type", "image/png"); self.send_header("Content-Length", str(len(b))); self.end_headers(); self.wfile.write(b)
                        return
                self.send_error(404)
            elif self.path.startswith("/preview?"):
                qs = urllib.parse.parse_qs(self.path.split("?", 1)[1]); g = lambda k: qs.get(k, [""])[0]
                d = cars.get(g("year"), {}).get(g("car")); pth = d and g("scale") in d["scad"] and entry_preview(d, g("scale"))
                if not pth: return self.send_error(404)
                b = open(pth, "rb").read()
                self.send_response(200); self.send_header("Content-Type", "image/png"); self.send_header("Content-Length", str(len(b))); self.end_headers(); self.wfile.write(b)
            elif self.path == "/api/cars":
                out = {}
                for y in cars:
                    for c, d in cars[y].items():
                        ks = [k for k, _ in SCALES if k in d["scad"]]
                        out.setdefault(y, {})[c] = {"scales": ks, "slug": d["slug"], "rev": {k: review_text(review, d["slug"], k) for k in ks},
                                                    "docs": bool(entry_docs(d, ks[0])), "simple": bool(d.get("spec")),
                                                    "printers": {k: entry_printers(d, k) for k in ks}}
                self.send({"cars": out, "scales": SCALES, "printers": PRINTERS, "schemes": SCHEMES, "kinds": {k: kind(k) for k in ("", "UP", "MILW", "none")}, "out": DEFAULT_OUT, "openscad": bool(osc),
                           "remote": self.remote(), "host": host_name, "user": who, "users_on": bool(users)})
            elif self.path == "/api/status":
                with lock: self.send({k: st[k] for k in ("log", "done", "total", "running", "download")})
            elif self.path.startswith("/download/"):
                name = os.path.basename(urllib.parse.unquote(self.path[len("/download/"):]))
                pth = os.path.join(share_dir, name)
                if not (name.lower().endswith(".zip") and os.path.isfile(pth)): return self.send_error(404)
                self.send_response(200); self.send_header("Content-Type", "application/zip"); self.send_header("Content-Length", str(os.path.getsize(pth)))
                self.send_header("Content-Disposition", "attachment; filename*=UTF-8\'\'" + urllib.parse.quote(name)); self.end_headers()
                with open(pth, "rb") as f: shutil.copyfileobj(f, self.wfile)
            else:
                self.send_error(404)

        def do_POST(self):
            try: n = int(self.headers.get("Content-Length") or 0)
            except ValueError: n = -1
            if n < 0 or n > 65536: return self.send_error(413)
            try: c = json.loads(self.rfile.read(n) or b"{}")
            except ValueError: c = {}
            if not isinstance(c, dict): c = {}
            if self.path == "/api/login":
                ip, now = self.ip(), time.time(); f = fails.get(ip, [0, 0])
                if f[1] > now:
                    return self.send({"ok": False, "msg": f"Too many wrong tries. Wait {int((f[1] - now) // 60) + 1} minutes and try again."})
                name = check_password(users, c.get("name", ""), str(c.get("password", ""))) if users else None
                if not name:
                    f[0] += 1
                    if f[0] >= 5: f = [0, now + 300]; say(f"   (five wrong sign-in tries from {ip} - that address is locked out for 5 minutes)")
                    fails[ip] = f; time.sleep(0.6)
                    return self.send({"ok": False, "msg": "Name or password not right."})
                fails.pop(ip, None)
                for k in [k for k, v in sessions.items() if v[1] < now]: sessions.pop(k, None)
                tok = secrets.token_urlsafe(32); sessions[tok] = (name, now + SESSION_HOURS * 3600)
                say(f"   ({name} signed in from {ip})")
                return self.send({"ok": True}, headers=[("Set-Cookie", f"mrpf={tok}; HttpOnly; SameSite=Strict; Path=/; Max-Age={SESSION_HOURS * 3600}")])
            who = self.user()
            if self.path == "/api/password":        # change your own password: name + current password + new one
                if not users or who is None: return self.send({"ok": False, "msg": "Sign in first."})
                ip, now = self.ip(), time.time(); f = fails.get(ip, [0, 0])
                if f[1] > now:
                    return self.send({"ok": False, "msg": f"Too many wrong tries. Wait {int((f[1] - now) // 60) + 1} minutes and try again."})
                nm, new = str(c.get("name", "")).strip(), str(c.get("new", ""))
                if who and nm.lower() != who.lower(): return self.send({"ok": False, "msg": "You can only change your own password."})
                name = check_password(users, nm, str(c.get("old", "")))
                if not name:
                    f[0] += 1
                    if f[0] >= 5: f = [0, now + 300]; say(f"   (five wrong password tries from {ip} - that address is locked out for 5 minutes)")
                    fails[ip] = f; time.sleep(0.6)
                    return self.send({"ok": False, "msg": "Name or current password not right."})
                if len(new) < 8: return self.send({"ok": False, "msg": "Use at least 8 characters."})
                fails.pop(ip, None)
                salt, h = _pw_hash(new)
                with lock:
                    data = _users_raw()
                    for u in data["users"]:
                        if str(u.get("name", "")).strip().lower() == name.lower():
                            u.pop("password", None); u.update(salt=salt, hash=h, rounds=PW_ROUNDS)
                    _users_save(data)
                    users[name.lower()].update(salt=salt, hash=h, rounds=PW_ROUNDS)
                say(f"   ({name} changed their password)")
                return self.send({"ok": True})
            if self.path == "/api/logout":
                for part in (self.headers.get("Cookie") or "").split(";"):
                    k, _, v = part.strip().partition("=")
                    if k == "mrpf": sessions.pop(v, None)
                return self.send({"ok": True}, headers=[("Set-Cookie", "mrpf=; HttpOnly; SameSite=Strict; Path=/; Max-Age=0")])
            if who is None: return self.send_error(401)
            if self.path == "/api/start":
                if st["running"] or not osc: return self.send({"ok": False})
                try:                           # only choices the screen offers: nothing a visitor types reaches OpenSCAD
                    d = cars[c["year"]][c["car"]]
                    if (c["scale"] not in d["scad"] or c["printer"] not in [x[0] for x in entry_printers(d, c["scale"])]
                            or (c.get("colour") or "") not in ("", "UP", "MILW", "none") or not isinstance(c.get("only", ""), str)
                            or not isinstance(c.get("out", ""), str)):
                        raise KeyError
                except (KeyError, TypeError):
                    return self.send({"ok": False, "msg": "That choice is not on the list."})
                c.setdefault("out", DEFAULT_OUT)
                away = self.remote()
                if away: c["out"], c["zip"] = share_dir, True          # made here, zipped, downloaded by the other computer
                job = make_job(osc, d, c["scale"], c["printer"], c["colour"] or "", target(c), log=say, zipped=bool(c.get("zip")),
                               zip_to=zip_file(os.path.expanduser(c["out"]), d["slug"], c["scale"], c["printer"], c["colour"] or ""),
                               only=(re.split(r"[,\s]+", c.get("only", "").strip()) if c.get("only", "").strip() else None),
                               progress=lambda a, b: st.update(done=a, total=b))
                st.update(job=job, running=True, done=0, total=1, download=None)
                say(f"--- {c['year']} / {c['car']} / {c['scale']} / {c['printer']} / {kind(c['colour'] or '')}" + (f"   (asked for by {who + ' at ' if who else ''}{self.ip()})" if away else ""))
                def work():
                    try: job.run()
                    except Exception as e: say("PROBLEM: " + str(e))
                    res = job.result if away and str(job.result).lower().endswith(".zip") and os.path.isfile(job.result) else None
                    st.update(running=False, job=None, download=os.path.basename(res) if res else None)
                threading.Thread(target=work, daemon=True).start()
                self.send({"ok": True})
            elif self.path == "/api/stop":
                if st["job"]: st["job"].cancel()
                self.send({"ok": True})
            elif self.path in ("/api/open", "/api/docs", "/api/quit") and self.remote():
                self.send({"msg": {"/api/open": "The folder is on the computer that runs MR Print Files. Use the Download link here instead.",
                                   "/api/docs": "The build instructions are in the zip file you download.",
                                   "/api/quit": "Only the computer that runs MR Print Files can close it."}[self.path]})
            elif self.path == "/api/open":
                d = target(c)
                if c.get("zip") or not os.path.isdir(d): d = os.path.expanduser(c.get("out", ""))
                if not os.path.isdir(d): return self.send({"msg": "No files have been made for this choice yet."})
                if sys.platform == "darwin": subprocess.Popen(["open", d])
                elif os.name == "nt": os.startfile(d)
                else: subprocess.Popen(["xdg-open", d])
                self.send({})
            elif self.path == "/api/docs":
                d = cars[c["year"]][c["car"]]; docs = entry_docs(d, c["scale"])
                if not docs: return self.send({"msg": "No build instructions have been made for this model yet."})
                for x in docs:
                    if sys.platform == "darwin": subprocess.Popen(["open", x])
                    elif os.name == "nt": os.startfile(x)
                    else: subprocess.Popen(["xdg-open", x])
                self.send({})
            elif self.path == "/api/quit":
                if st["job"]: st["job"].cancel()
                self.send({}); threading.Thread(target=srv.shutdown, daemon=True).start()
            else:
                self.send_error(404)

    try:
        srv = http.server.ThreadingHTTPServer(("0.0.0.0" if share else "127.0.0.1", port or (SHARE_PORT if (share or public) else 0)), H)
    except OSError as e:
        sys.exit(f"Could not start on port {port or SHARE_PORT}: {e}\nIs MR Print Files already running? Close the other one, or start with --port and another number.")
    url = f"http://127.0.0.1:{srv.server_address[1]}/"
    print("MR Print Files is open in your web browser:  " + url + "\nLeave this window open while you use it. Press Ctrl-C here (or Quit on the page) to finish.")
    if share:
        ip = lan_address()
        print("\nSHARED ON THE NETWORK. From another computer, tablet or phone on the same network, browse to:\n      "
              + (f"http://{ip}:{srv.server_address[1]}/" if ip else f"http://<this computer's address>:{srv.server_address[1]}/")
              + f"\n   (or  http://{host_name}.local:{srv.server_address[1]}/  if that name works on your network)"
              + ("\nSign-in is ON: " + str(len(users)) + " user(s) in users.json." if users else
                 "\nThere is NO password - anyone on the network can make and download files. To add sign-in: --add-user NAME")
              + ("\nPUBLIC: every request has to sign in, including ones from this computer." if public else "")
              + "\nThe first time, the computer may ask whether to allow incoming connections: say Allow.")
    if open_browser: webbrowser.open(url)
    try: srv.serve_forever()
    except KeyboardInterrupt: pass
    if st["job"]: st["job"].cancel()
    return 0


# ---------------------------------------------------------------- Terminal menu (no window)
def menu(cars, review, osc):
    def ask(title, options):
        print("\n" + title)
        for i, o in enumerate(options, 1): print(f"  {i}. {o}")
        while True:
            a = input("  number: ").strip()
            if a.isdigit() and 1 <= int(a) <= len(options): return int(a) - 1
    years = list(cars); y = years[ask("Train set or group", years)]
    names = list(cars[y]); c = names[ask("Car or model", names)]; car = cars[y][c]
    keys = [k for k, _ in SCALES if k in car["scad"]]; key = keys[ask("Scale", [dict(SCALES)[k] for k in keys])]
    prs = entry_printers(car, key); pr = prs[ask("Printer", [p[1] for p in prs])][0]
    col = ["UP", "MILW", "none", ""][ask("Colours", [s[1] + " (3MF)" for s in SCHEMES] + ["STL files - one colour, to paint"])]
    ok, txt = review_text(review, car["slug"], key); print("\n" + ("" if ok else "*** ") + txt)
    if not ok and input("Make the print files anyway? (y/n) ").strip().lower() != "y": return 1
    out = out_folder(DEFAULT_OUT, y, c, key, pr, col)
    return 0 if make_job(osc, car, key, pr, col, out).run() else 1


def main():
    ap = argparse.ArgumentParser(description="Make the print files for one Milwaukee Road car from its OpenSCAD file.")
    ap.add_argument("--menu", action="store_true", help="ask the questions in the program window instead of the web browser")
    ap.add_argument("--window", action="store_true", help="old-style window (needs a working tkinter) instead of the web browser")
    ap.add_argument("--no-browser", action="store_true", help=argparse.SUPPRESS)
    ap.add_argument("--share", action="store_true", help=f"let other computers on the same network use it: browse to http://<this computer's address>:{SHARE_PORT} ; sign-in if there is a users.json")
    ap.add_argument("--port", type=int, default=0, help=f"port number for the web page (with --share the usual one is {SHARE_PORT})")
    ap.add_argument("--list", action="store_true", help="list the cars and whether each is verified")
    ap.add_argument("--car", help='part of "group/model folder", e.g. "1948 Twin Cities Hiawatha/02 Coach", "Caboose" or "Janesville" (no window)')
    ap.add_argument("--scale", default="G", choices=["G", "O", "HO"]); ap.add_argument("--printer", default="P1S", choices=["P1S", "GIGA"])
    ap.add_argument("--colour", "--color", nargs="?", const="UP", default="", choices=["UP", "MILW", "none"], help="3MF colour files instead of STL: UP, MILW or none (gray)")
    ap.add_argument("--zip", action="store_true", help="put the files in one zip file"); ap.add_argument("--out", default=DEFAULT_OUT); ap.add_argument("--only", nargs="*", help=argparse.SUPPRESS)
    ap.add_argument("--scad", help=argparse.SUPPRESS); ap.add_argument("--jobs", type=int, default=None, help="how many parts to render at once")
    ap.add_argument("--openscad", help="full path of the OpenSCAD program, if it is not found by itself")
    ap.add_argument("--public", action="store_true", help="like --share, but every request must sign in - use this when it is reached through a tunnel or proxy on this computer")
    ap.add_argument("--add-user", metavar="NAME", help="add a person who may sign in, or change their password (asks for the password)")
    ap.add_argument("--remove-user", metavar="NAME", help="take a person off the sign-in list")
    ap.add_argument("--users", action="store_true", help="list who may sign in")
    a = ap.parse_args()
    if a.add_user or a.remove_user or a.users:
        return user_admin(a)
    root = find_root(); review = load_review(root); cars = find_models(find_cars(root), review); osc = find_openscad(a.openscad)
    if a.list:
        for y in cars:
            for c, d in cars[y].items():
                print(("ok  " if review_text(review, d["slug"])[0] else "--  ") + f"{y} / {c}   [{', '.join(d['scad'])}]")
        return 0
    if a.scad or a.car:
        if not osc: sys.exit(NO_OPENSCAD)
        if a.scad:
            base = os.path.basename(a.scad)[:-5]; slug, _, key = base.rpartition("_"); y, c, scad, d = "test", slug, a.scad, None
        else:
            hits = [(y, c, d) for y in cars for c, d in cars[y].items() if a.car in f"{y}/{c}" and a.scale in d["scad"]]
            if len(hits) != 1: sys.exit(f"{len(hits)} cars match '{a.car}' - be more exact:\n" + "\n".join(f"  {y}/{c}" for y, c, _ in hits))
            y, c, d = hits[0]; slug, key, scad = d["slug"], a.scale, d["scad"][a.scale]
        ok, txt = review_text(review, slug, key); print(txt)
        pr = a.printer if d is None or a.printer in [x[0] for x in entry_printers(d, key)] else entry_printers(d, key)[0][0]
        kw = dict(workers=a.jobs, only=a.only, zipped=a.zip, zip_to=zip_file(a.out, slug, key, pr, a.colour))
        job = (Job(osc, scad, slug, key, pr, a.colour, out_folder(a.out, y, c, key, pr, a.colour), docs=car_docs(scad), **kw) if d is None
               else make_job(osc, d, key, pr, a.colour, out_folder(a.out, y, c, key, pr, a.colour), **kw))
        return 0 if job.run() else 1
    if a.window:
        gui(root, cars, review, osc); return 0
    if not a.menu:
        return web(cars, review, osc, open_browser=not a.no_browser, share=a.share or a.public, port=a.port, public=a.public)
    if not cars: sys.exit("No car files found next to this program.")
    if not osc: sys.exit(NO_OPENSCAD)
    return menu(cars, review, osc)


if __name__ == "__main__":
    sys.exit(main())
