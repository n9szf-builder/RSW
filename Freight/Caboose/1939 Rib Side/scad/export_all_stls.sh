#!/bin/bash
# =====================================================================
#  Export every printed part of the Milwaukee Road rib side caboose
#  to its own STL, using the OpenSCAD command line.
#
#  Put this script in the same folder as MIL_Rib_1939_caboose_Main.scad
#  and run it from Terminal:
#       chmod +x export_all_stls.sh
#       ./export_all_stls.sh
#
#  STLs are written to a "stl" folder next to the script. Each file name
#  includes how many to print (x1, x2, x4).
# =====================================================================

cd "$(dirname "$0")"
SCAD="MIL_Rib_1939_caboose_Main.scad"
OUT="stl"

# find OpenSCAD (macOS app, or on the PATH)
if [ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]; then
    OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
elif [ -x "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD" ]; then
    OPENSCAD="/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD"
elif command -v openscad >/dev/null 2>&1; then
    OPENSCAD="openscad"
else
    echo "Could not find OpenSCAD. Edit the OPENSCAD= line in this script to point to it."
    exit 1
fi

if [ ! -f "$SCAD" ]; then
    echo "Can't find $SCAD - put this script in the same folder as the .scad file."
    exit 1
fi

mkdir -p "$OUT"

# part name : how many to print
PARTS=(
    "body:1"
    "bay:2"
    "toolbox:1"
    "roof:1"
    "roofwalk:1"
    "underframe:1"
    "deck:2"
    "step:4"
    "railing:2"
    "brakewheel:2"
    "ladder:2"
    "smokestack:1"
    "lanternjack:1"
    "glazing:1"
    "restroom:1"
    "truck_sideframe:4"
    "truck_bolster:2"
    "truck_wheel:8"
)

n=0
total=${#PARTS[@]}
failed=()
for entry in "${PARTS[@]}"; do
    part="${entry%%:*}"
    qty="${entry##*:}"
    n=$((n + 1))
    file=$(printf "%s/%02d_%s_x%s.stl" "$OUT" "$n" "$part" "$qty")
    echo "[$n/$total] $part  (print $qty)  ->  $file"
    if ! "$OPENSCAD" -o "$file" -D "part=\"$part\"" "$SCAD" 2> "$OUT/${part}.log"; then
        failed+=("$part")
        echo "      FAILED - see $OUT/${part}.log"
    else
        rm -f "$OUT/${part}.log"
    fi
done

echo
if [ ${#failed[@]} -eq 0 ]; then
    echo "All $total parts exported to ./$OUT"
else
    echo "Done, but these parts failed: ${failed[*]}"
    echo "Open the matching .log file in ./$OUT to see why."
fi

cat <<'EOF'

Not printed - bend from brass wire:
  - long curved side grabs (4), toolbox grab (1), end corner grabs (4),
    L-shaped end handrails (4), ladder-top roof grabs      (1.2 mm / 1.0 mm wire)
  - brake staffs (2)                                       (1/16" wire)
Also needed: USA Trains trucks (2), Kadee #906 couplers (2),
screws for the body and trucks, and optional brass tube for the stacks.
EOF
