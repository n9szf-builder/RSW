// =====================================================================
//  CORNER STEPS
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: step(), four_steps().
//  Print: lying on one stringer. Qty 4.
// =====================================================================

// =====================================================================
//  CORNER STEPS  (+X +Y corner shown; all four are identical - print 4)
//  Three treads between solid side stringers, closed risers at the back,
//  open to the car side. Print lying on one stringer: no supports.
// =====================================================================


module step() {
    x0 = step_x0; x1 = step_x1;
    y1 = W/2;
    y0 = W/2 - p(step_depth);
    dep = y1 - y0;
    st = p(step_stagger);
    ztop = -plate_t;
    n = len(step_treads);
    zt = [for (t = step_treads) t - floor_above_rail];   // tread tops, local z
    difference() {
        union() {
            // mounting rim glued to the underside of the floor plate
            // around the stairwell opening (open in the middle)
            difference() {
                translate([x0 - 2, y0, ztop - 1.2]) cube([x1 - x0 + 2, dep, 1.2]);
                translate([x0 + hanger_t, y0 + riser_t, ztop - 2])
                    cube([x1 - x0 - 2*hanger_t, dep, 3]);
            }
            // sloped side stringers: hull of the mounting plate and every tread
            for (x = [x0, x1 - hanger_t])
                hull() {
                    translate([x, y0, ztop - 1.2]) cube([hanger_t, dep, 1.2]);
                    for (i = [0 : n - 1])
                        translate([x, y0 + i*st, zt[i] - step_t]) cube([hanger_t, dep, step_t]);
                }
            // treads, each stepping out by the stagger
            for (i = [0 : n - 1])
                translate([x0, y0 + i*st, zt[i] - step_t]) cube([x1 - x0, dep, step_t]);
            // closed risers at the back of each tread, up to the one above
            for (i = [0 : n - 1])
                translate([x0, y0 + i*st, zt[i] - 0.01])
                    cube([x1 - x0, riser_t, (i == 0 ? ztop - 1.2 : zt[i-1] - step_t) - zt[i] + 0.02]);
        }
        // anti-slip grooves across each tread
        for (i = [0 : n - 1], g = [riser_t + tread_groove : tread_groove : dep - 1])
            translate([x0 + hanger_t, y0 + i*st + g, zt[i] - 0.4])
                cube([x1 - x0 - 2*hanger_t, 0.5, 1]);
    }
}

module four_steps() {
    step();
    mirror([1, 0, 0]) step();
    mirror([0, 1, 0]) step();
    mirror([1, 0, 0]) mirror([0, 1, 0]) step();
}
