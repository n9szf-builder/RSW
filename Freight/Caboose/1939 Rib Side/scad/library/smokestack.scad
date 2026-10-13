// =====================================================================
//  SMOKESTACK
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: smokestack().
//  Print: upright. Qty 1.
// =====================================================================

// =====================================================================
//  SMOKESTACK and LANTERN JACK  (origin: base on the roof surface)
//  Plugs drop into the roof sockets. Print upright.
// =====================================================================

module smokestack() {
    d = p(stack_d);
    translate([0, 0, -6]) cylinder(d = smokejack_tube, h = 6.01, $fn = 32);     // plug
    cylinder(d = d + 2.5, h = 1, $fn = 40);                                     // roof flange
    cylinder(d = d, h = p(stack_h), $fn = 32);                                  // pipe
    // tee cap running across the car (reads as a "T" from the end)
    translate([0, 0, p(stack_h) - d/2])
        rotate([90, 0, 0]) cylinder(d = d + 0.4, h = d * 2.4, center = true, $fn = 32);
}
