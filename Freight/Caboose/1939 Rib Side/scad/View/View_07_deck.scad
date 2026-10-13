// =====================================================================
//  VIEW 07: DECK  -  print 2
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Platform deck (tread plate)
//  Print orientation: flat
//
//  Open this file in OpenSCAD to look at just this part.
//  To export this part's STL: Render (F6), then File > Export > STL.
//  The part's code lives in library/deck.scad; settings in
//  library/caboose_params.scad.
// =====================================================================

part     = "deck";    // which part - leave as is
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
echo(str("deck: print 2"));
