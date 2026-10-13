// =====================================================================
//  UNDERFRAME
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: underframe(), rod(), underside_details().
//  Print: upside down. Qty 1.
// =====================================================================

// =====================================================================
//  UNDERFRAME  (origin: car center, z = 0 = top of plate = body bottom)
//  Print upside down: plate top on the bed, sills and pads pointing up.
// =====================================================================


module underframe() {
    tz  = truck_bolster_h - floor_above_rail;          // truck bolster top, local z
    txs = [-p(truck_centers)/2, p(truck_centers)/2];
    // lateral wheel swing at the far axle when the truck turns
    swing = (truck_wb/2) * sin(truck_swing);
    lane_x = truck_wb/2 + wheel_dia/2 + 5;
    // the part of each wheel (with its flange) that stands above the plate
    // underside reaches fore and aft of the axle, so it swings in further
    wheel_r  = wheel_dia/2 + 2;                                  // tread radius + 2 mm flange
    rise     = floor_above_rail - plate_t - wheel_dia/2;         // axle centre up to the plate underside
    chord    = wheel_r > rise ? sqrt(wheel_r*wheel_r - rise*rise) : 0;
    lane_in  = (gauge/2 - 2.25) * cos(truck_swing) - (truck_wb/2 + chord) * sin(truck_swing) - 0.75;   // flange back face, swung in
    lane_out = gauge/2 + 5 + swing;     // wheel tread/flange, swung out
    difference() {
        union() {
            // floor plate
            translate([-UL/2, -W/2, -plate_t]) cube([UL, W, plate_t]);
            // center sill (plain block; replaced by channels when detailed)
            if (!underside_detail)
                translate([-UL/2 + end_sill_t, -center_sill_w/2, -plate_t - center_sill_d])
                    cube([UL - 2*end_sill_t, center_sill_w, center_sill_d + 0.01]);
            // end sills
            for (sx = [-1, 1])
                translate([sx > 0 ? UL/2 - end_sill_t : -UL/2, -W/2, -plate_t - end_sill_d])
                    cube([end_sill_t, W, end_sill_d + 0.01]);
            // body bolster pads the trucks screw into
            for (x = txs)
                translate([x, 0, tz]) cylinder(d = 14, h = -tz - plate_t + 0.01, $fn = 40);
            if (underside_detail) underside_details(txs, tz, lane_in);
        }
        // scribed floor boards across the underside, between the ends
        if (underside_detail)
            for (x = [-L/2 + p(floor_board) : p(floor_board) : L/2 - 1])
                translate([x - 0.2, -W/2 - 1, -plate_t - 0.01]) cube([0.4, W + 2, 0.3]);
        // truck screw pilot holes
        for (x = txs)
            translate([x, 0, tz - 1]) cylinder(d = truck_screw_pilot, h = -tz - plate_t + 0.5, $fn = 16);
        // wheel clearance lanes (both rails, both trucks)
        for (x = txs, sy = [-1, 1])
            translate([x - lane_x, sy > 0 ? lane_in : -lane_out, -plate_t - 10])
                cube([2*lane_x, lane_out - lane_in, 10 + plate_t - plate_min_t]);
        // coupler pockets: through the plate and the top of the end sill,
        // from the body end out to the car end
        for (sx = [-1, 1])
            translate([sx > 0 ? L/2 + 0.3 : -UL/2 - 1, -coupler_pocket_w/2, -plate_t - kadee_box_h])
                cube([UL/2 - L/2 + 0.7, coupler_pocket_w, kadee_box_h + plate_t + 1]);
        // stairwell openings at the four platform corners
        for (mx = [0, 1], my = [0, 1])
            mirror([mx, 0, 0]) mirror([0, my, 0])
                translate([step_x0 + hanger_t, W/2 - p(step_depth) + riser_t, -plate_t - 1])
                    cube([step_x1 - step_x0 - 2*hanger_t, p(step_depth), plate_t + 2]);
        // railing peg and brake staff holes in the plate top
        end_holes(0.01, peg_len);
        rotate([0, 0, 180]) end_holes(0.01, peg_len);
        // body screw holes (match the body's bosses), countersunk underneath
        bx = L/2 - wall - boss/2;
        by = W/2 - wall - boss/2;
        for (x = [-bx, 0, bx], y = [-by, by])
            translate([x, y, 0]) {
                translate([0, 0, -plate_t - 1]) cylinder(d = body_screw_clear, h = plate_t + 2, $fn = 16);
                translate([0, 0, -plate_t - 0.01]) cylinder(d1 = 5.5, d2 = body_screw_clear, h = 1.5, $fn = 24);
            }
    }
}

// =====================================================================
//  UNDERSIDE DETAIL  (part of the underframe; prints face-up with it)
// =====================================================================

// round bar from a to b, fused against the plate underside
module rod(a, b) {
    hull() {
        translate(a) sphere(d = rod_mm, $fn = 10);
        translate(b) sphere(d = rod_mm, $fn = 10);
    }
}

module underside_details(txs, tz, lane_in) {
    zb = -plate_t;                       // plate underside
    rz = zb - rod_mm/2 + 0.2;            // rod centers, just touching the plate
    // channel center sill: two webs with bottom flanges
    for (sy = [-1, 1])
        translate([-UL/2 + end_sill_t, sy > 0 ? center_sill_w/2 - 1.5 : -center_sill_w/2, zb - center_sill_d - 1])
            cube([UL - 2*end_sill_t, 1.5, center_sill_d + 1.01]);
    for (sy = [-1, 1])
        translate([-UL/2 + end_sill_t, sy > 0 ? center_sill_w/2 - 1.5 : -center_sill_w/2 - 1.5, zb - center_sill_d - 1])
            cube([UL - 2*end_sill_t, 3, 1]);
    // fish-belly crossbearers, deep at the sill, shallow at the sides
    for (x = crossbearer_x, sy = [-1, 1])
        hull() {
            translate([p(x) - crossbearer_w/2, sy > 0 ? center_sill_w/2 : -center_sill_w/2 - 0.1, zb - center_sill_d])
                cube([crossbearer_w, 0.1, center_sill_d + 0.01]);
            translate([p(x) - crossbearer_w/2, sy > 0 ? W/2 - 1.1 : -W/2 + 1, zb - 1.5])
                cube([crossbearer_w, 0.1, 1.51]);
        }
    // body bolster stubs over the truck bolsters (kept inside the wheel
    // lanes and 1 mm above the truck so it can still swivel and rock)
    for (x = txs)
        translate([x - 3, -(lane_in - 1), tz + 1])
            cube([6, 2*(lane_in - 1), -tz - plate_t - 1 + 0.01]);
    // KC brake cylinder + reservoir, mounted up against the floor
    kr = p(kc_dia)/2;
    ky = kc_y * W;
    kx0 = p(kc_x) - p(kc_len)/2;
    hull() {
        translate([kx0, ky, zb - kr]) rotate([0, 90, 0]) cylinder(r = kr, h = p(kc_len), $fn = 32);
        translate([kx0, ky - kr*0.6, zb - 0.5]) cube([p(kc_len), 2*kr*0.6, 0.51]);
    }
    // cylinder head (slightly larger) at the lever end
    translate([kx0 + p(kc_len), ky, zb - kr]) rotate([0, 90, 0]) cylinder(r = kr + 0.4, h = 1.5, $fn = 32);
    // triple valve on the other end
    translate([kx0 - p(6), ky - p(4), zb - p(8)]) cube([p(6) + 0.01, p(8), p(8)]);
    // push rod out to the live lever
    rod([kx0 + p(kc_len) + 1.5, ky, zb - kr], [p(brake_lever_x), ky, zb - kr]);
    // live lever across the car, up against the floor
    lx = p(brake_lever_x);
    translate([lx - 0.8, -W/2 + 12, zb - kr - 1]) cube([1.6, W/2 - 12 - center_sill_w/2 - 0.5, 2]);
    for (hy = [-W/2 + 12, -center_sill_w/2 - 1.5])                           // hangers
        translate([lx - 0.8, hy, zb - kr - 1]) cube([1.6, 1, kr + 1]);
    // brake rods to each truck (stop short of the wheel lanes)
    lane_start = p(truck_centers)/2 - (truck_wb/2 + wheel_dia/2 + 5) - 1;
    rod([lx, -W/2 + 13, zb - kr], [ lane_start, -W/2 + 13, rz]);
    rod([lx, -center_sill_w/2 - 1.5, zb - kr], [-lane_start, -center_sill_w/2 - 1.5, rz]);
    // train line along the sill, end sill to end sill
    rod([-UL/2 + end_sill_t, center_sill_w/2 + 1.2, rz], [UL/2 - end_sill_t, center_sill_w/2 + 1.2, rz]);
}
