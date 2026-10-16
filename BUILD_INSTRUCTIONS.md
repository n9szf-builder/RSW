# Building a Rib Side Works kit

Every car has a stand-alone OpenSCAD file in three scales. Find it at:

`<train group>/<car>/Kit/<G scale 1-29 | O scale 1-48 | HO scale 1-87>/OpenSCAD/<car>_<G|O|HO>.scad`

Each file is a single file. It needs no libraries and no other files.

Each car's `Kit` folder also holds its own illustrated **How to build** PDF (`Kit/How to build - <car>.pdf`). Start there for the part list, print order and assembly steps.

## What you need
- **OpenSCAD 2025 or newer.** Use the Manifold engine (Edit > Preferences > Features > manifold), which makes renders fast.
- A slicer for your printer.

## Steps
1. Open the kit's `.scad` file in OpenSCAD.
2. Open the Customizer (Window > Customizer). Choose:
   - `PART` and `SECTION`: which piece to print (car sections are sized to fit a print bed).
   - `PRINTER`: your printer's bed size.
   - `COLOR_PART`: for multi-color printing.
3. Press **F6** to render.
4. File > Export > Export as STL (or 3MF for color).
5. Slice and print.

Repeat for each part and section.

## Notes
- The models carry no exterior lettering. Add decals or paint.
- The brake wheel is a separate part (`brake_wheel`). Print it on its own.
- Trucks are a separate project (see `Trucks`).
- HO kits use purchased trucks.
- Some details are unverified against prototype records. Check the notes before relying on them, especially for the 1935 Hiawatha cars, which are on hold.

Questions or comments on a model: ribsideworks@gmail.com or N9szf (n9szf@mac.com).
