// =====================================================================
//  VIEW 16: TRUCK  -  per car: 4 sideframes, 2 bolsters, 8 wheels
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Printed Bettendorf-style truck: wheels on 3 mm brass axles in F683ZZ
//  ball bearings, the same bought parts as the passenger car trucks.
//  Print orientation: sideframe inner face down, bolster flat,
//  wheel flange face down.
//
//  Open this file in OpenSCAD to look at just this part.
//  To export this part's STL: Render (F6), then File > Export > STL.
//  The part's code lives in library/truck.scad; settings in
//  library/truck.scad and library/caboose_params.scad.
// =====================================================================

part     = "truck";  // "truck"           = the whole truck on the rail, to look at
                     // "truck_sideframe" = print 4
                     // "truck_bolster"   = print 2
                     // "truck_wheel"     = print 8
view     = "print";  // "print"     = laid out as it goes on the printer bed
                     //               (same as the exported STL)
                     // "installed" = both trucks in their place under the car
show_car = false;    // with "installed": faint see-through body, roof and
                     //   underframe around it for context

include <../library/caboose_all.scad>

if (view == "installed") {
    caboose_installed(part);
    if (show_car) car_ghost();
} else {
    caboose_print(part);
}
echo(str("truck: per car print 4 sideframes, 2 bolsters, 8 wheels"));
