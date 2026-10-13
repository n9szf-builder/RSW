// =====================================================================
//  VIEW 06: UNDERFRAME  -  print 1
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Floor plate, end sills, truck pads, coupler pockets, underside detail
//  Print orientation: upside down
//
//  Open this file in OpenSCAD to look at just this part.
//  To export this part's STL: Render (F6), then File > Export > STL.
//  The part's code lives in library/underframe.scad; settings in
//  library/caboose_params.scad.
// =====================================================================

part     = "underframe";    // which part - leave as is
view     = "print";  // "print"     = laid out as it goes on the printer bed
                     //               (same as the exported STL)
                     // "installed" = in its place on the car (all copies)
show_car = false;    // with "installed": faint see-through body, roof and
                     //   underframe around it for context

include <../library/caboose_all.scad>

if (view == "installed") {
    caboose_installed(part);
    if (show_car) car_ghost();
} else {
    caboose_print(part);
}
echo(str("underframe: print 1"));
