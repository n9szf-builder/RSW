// =====================================================================
//  RESTROOM
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: restroom().
//  Print: upright. Qty 1.
// =====================================================================

// =====================================================================
//  RESTROOM  (separate print; stands on the floor plate inside the body)
// =====================================================================

module restroom() {
    mirror([rr_end < 0 ? 1 : 0, 0, 0]) mirror([0, rr_side < 0 ? 1 : 0, 0]) {
        x1 = L/2 - wall - 0.3;     x0 = x1 - p(rr_len);
        y1 = W/2 - wall - 0.3;     y0 = y1 - p(rr_depth);
        hz = H - 0.8;
        // partition along the car, with the door opening
        difference() {
            translate([x0, y0, 0]) cube([x1 - x0, rr_wall, hz]);
            translate([(x0 + x1)/2 - p(rr_door_w)/2, y0 - 1, -1]) cube([p(rr_door_w), rr_wall + 2, p(rr_door_h) + 1]);
        }
        // partition across the car
        translate([x0, y0, 0]) cube([rr_wall, y1 - y0, hz]);
        // toilet: bowl box and tank against the end wall
        yc = (y0 + y1)/2;
        translate([x1 - p(22), yc - p(8), 0]) cube([p(15), p(16), p(15)]);
        translate([x1 - p(7), yc - p(9), 0]) cube([p(7), p(18), p(30)]);
    }
}
