// =====================================================================
//  LANTERN JACK
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: lanternjack().
//  Print: upright. Qty 1.
// =====================================================================

module lanternjack() {
    d = p(lantern_d);
    translate([0, 0, -5]) cylinder(d = lanternjack_tube, h = 5.01, $fn = 24);   // plug
    cylinder(d = d + 2, h = 0.8, $fn = 32);                                      // flange
    cylinder(d = d, h = p(lantern_h), $fn = 24);                                 // pipe
    translate([0, 0, p(lantern_h)])                                              // tee hood
        rotate([0, 90, 0]) cylinder(d = d + 0.6, h = d * 2.2, center = true, $fn = 24);
}
