// =====================================================================
//  MR1937_Express.scad  -  MAIN MODEL
//  Milwaukee Road 1937 Hiawatha  -  Express Car
//
//  Pick PART (and SECTION) in the Customizer, F6 render, then File > Export.
//    assembly       whole car (check fit, not for printing)
//    shape          body + roof only, plain light gray - no paint, glass, floor or interior (check the form)
//    battery_box    lighting-pack box (battery, charger, ESP32-C6) - screws under the floor
//    steps          vestibule step boxes, printed on their sides - 2 x M2.5 x 8 each, down through the floor
//    windows        window inserts, flange down (one colour; paint the rim silver)
//    window_rims / window_glass   the same inserts split for a two-colour print (silver rim + tinted pane)
//    body N         sides + ends up to the eave (prints upright, open top and bottom)
//    roof N         removable roof: lip, magnet bosses, LED channel (prints upright on its lip)
//    floor N        floor with truck bolster pads (prints upside down)
//    interior N     seats / partitions, glued onto the floor (only if INTERIOR = true)
//    drawing_side / _top / _end / _plan   2D tech drawing -> export SVG/DXF/PDF into ./output
//  Sections are sized for the printer bed (BED_X in common/mr_config.scad; Bambu P1S = 256).
//  Each printed section has its car, part and number engraved inside (B = body, R = roof, F = floor).
//  Prototype data:  lib/MR1937_Express_lib.scad
//  Parts viewer:    view/MR1937_Express_view.scad
//  Batch export:    ../../tools/export_all.sh "MR1937_Express"
// =====================================================================
include <lib/MR1937_Express_lib.scad>

/* [Export] */
PART    = "assembly"; // [assembly, exploded, shape, body, body_colours, roof, floor, interior, battery_box, equipment, steps, windows, window_rims, window_glass, drawing_side, drawing_top, drawing_end, drawing_plan, info]
SECTION = 1;          // [1:1:8]

/* [Show in the assembly view] */
SHOW_BODY      = true;
SHOW_ROOF      = true;
SHOW_FLOOR     = true;
SHOW_INTERIOR  = true;
SHOW_WINDOWS   = true;
SHOW_STEPS     = true;
SHOW_TRUCKS    = true;
SHOW_COUPLERS  = true;
SHOW_LIGHT_BOX = true;
SHOW_EQUIPMENT = true;

/* [Car frame] */
// print the floor / frame as ONE part (needs a big bed, e.g. the OrangeStorm Giga)
FRAME_ONE_PIECE = false;
// underbody boxes and tanks as separate parts fixed by holes in the frame
EQUIP_SEPARATE  = true;
EQUIP_FIX       = "pin";   // [pin, screw]

/* [Paint] */
// UP = Armour Yellow + Harbor Mist Gray; MILW = orange + maroon; none = plain, as printed in one colour
PAINT_SCHEME   = "MILW";   // [UP, MILW, none]
SHOW_LETTERING = true;

mr_part(PART, SECTION);
