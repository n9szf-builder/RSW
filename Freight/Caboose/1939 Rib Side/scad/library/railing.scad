// =====================================================================
//  END RAILING
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: railing_frame_flat(), railing(), end_holes().
//  Print: flat. Qty 2.
// =====================================================================

// =====================================================================
//  END RAILING + BRAKE  (+X end; the -X end is the same turned 180)
//  The railing is one printed frame (posts + two rails) that prints
//  flat and pegs into the deck. The brake staff is brass wire through
//  the deck, a ratchet base and a bracket on the top rail; the printed
//  wheel slips onto the top of the staff.
// =====================================================================


// frame drawn flat for printing: u across the car, v up, w = thickness
// (w grows inboard). staff_u = where the brake staff bracket goes.
module railing_frame_flat(staff_u) {
    vt = p(rail_top);
    sw = p(stanchion_w);
    d  = rail_x - staff_x;                // railing to staff
    // corner and roof posts, deck to roof
    for (u = corner_posts_u())
        translate([u - RM/2, 0, 0]) cube([RM, post_h, RM]);
    for (u = inner_posts_u())
        translate([u - RM/2, 0, 0]) cube([RM, inner_post_h, RM]);
    // flat stanchions, deck to top rail
    for (u = stanchions_u())
        translate([u - sw/2, 0, 0]) cube([sw, vt, RM]);
    // pegs
    for (u = peg_u())
        translate([u - 0.8, -peg_len, (RM - 1.6)/2]) cube([1.6, peg_len + 0.01, 1.6]);
    // top rail
    translate([-W/2, vt - RM/2, 0]) cube([W, RM, RM]);
    // brake staff bracket off the inboard face of the top rail
    difference() {
        translate([staff_u - 1.6, vt - RM/2, RM - 0.01]) cube([3.2, RM, d + 1.6 - RM/2]);
        translate([staff_u, vt - RM/2 - 1, RM/2 + d])
            rotate([-90, 0, 0]) cylinder(d = brake_staff_wire + 0.2, h = RM + 2, $fn = 12);
    }
}

// railing frame in place on the +X end
module railing() {
    multmatrix([[0, 0, -1, rail_x + RM/2],
                [-1, 0, 0, 0],
                [0, 1, 0, deck_h],
                [0, 0, 0, 1]])
        railing_frame_flat(-staff_y);
}

// holes for the railing pegs and the brake staff (+X end), from z_top down
module end_holes(z_top, depth) {
    for (u = peg_u())
        translate([rail_x, -u, z_top - depth]) cylinder(d = 2.4, h = depth + 1, $fn = 12);
    translate([staff_x, staff_y, z_top - depth])
        cylinder(d = brake_staff_wire + 0.2, h = depth + 1, $fn = 12);
}
