// =====================================================================
//  BRAKE WHEEL
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: brake_wheel().
//  Print: flat. Qty 2.
// =====================================================================

module brake_wheel() {
    d = p(brake_wheel_d); rim = 1.2; t = 1.2;
    difference() {
        union() {
            difference() {
                cylinder(d = d, h = t, $fn = 48);
                translate([0, 0, -1]) cylinder(d = d - 2*rim, h = t + 2, $fn = 48);
            }
            for (a = [0, 60, 120])
                rotate([0, 0, a]) translate([-d/2 + 0.5, -0.5, 0]) cube([d - 1, 1, t]);
            cylinder(d = 3.4, h = 2.4, $fn = 24);
        }
        translate([0, 0, -1]) cylinder(d = brake_staff_wire + 0.15, h = 5, $fn = 12);
    }
}
