// =====================================================================
//  PREVIEW-ONLY DETAILS
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: brass wire grabs, interior liner, A/B labels,
//  wheel ghosts, end_details(), placed_parts(). Never printed.
// =====================================================================

// =====================================================================
//  BRASS WIRE GRABS AND HANDRAILS  (preview only - bend from wire)
// =====================================================================

module wire_path(pts, d = side_grab_wire) {
    for (i = [0 : len(pts) - 2])
        hull() {
            translate(pts[i])     sphere(d = d, $fn = 10);
            translate(pts[i + 1]) sphere(d = d, $fn = 10);
        }
}

// all the wire on the +Y side (mirrored/rotated for the other side)
module side_wires(tb = true) {
    so = W/2 + p(rib_d) + p(grab_standoff);
    // long curved grabs at each end: vertical at the top, sweeping down
    // and back to horizontal at the bottom
    for (m = [0, 1]) mirror([m, 0, 0]) {
        xt = L/2 - p(side_grab_top[0]);    zt = p(side_grab_top[1]);
        xb = L/2 - p(side_grab_bottom[0]); zb = p(side_grab_bottom[1]);
        rx = xt - xb; rz = zt - zb;
        arc = [for (t = [0 : 10 : 90]) [xt - rx * (1 - cos(t)), so, zt - rz * sin(t)]];
        wire_path(concat([[xt, W/2 - 0.5, zt]], arc, [[xb, W/2 - 0.5, zb]]));
    }
    // grab beside the toolbox
    tx = p(toolbox_x - toolbox_w/2 - toolbox_grab_gap);
    if (tb) wire_path([[tx, W/2 - 0.5, p(toolbox_grab_z[0])], [tx, so, p(toolbox_grab_z[0])],
               [tx, so, p(toolbox_grab_z[1])], [tx, W/2 - 0.5, p(toolbox_grab_z[1])]]);
}

// all the wire on the +X end
module end_wires() {
    so = L/2 + p(grab_standoff + 1);
    // vertical grabs near the corners
    for (f = end_grab_y)
        wire_path([[L/2 - 0.5, f * W, p(end_grab_z[0])], [so, f * W, p(end_grab_z[0])],
                   [so, f * W, p(end_grab_z[1])], [L/2 - 0.5, f * W, p(end_grab_z[1])]]);
    // L-shaped handrails each side of the door
    for (sy = [-1, 1]) {
        yt = sy * end_rail_top[0] * W;    zt = p(end_rail_top[1]);
        yb = sy * end_rail_bottom[0] * W; zb = p(end_rail_bottom[1]);
        wire_path([[L/2 - 0.5, yt, zt], [so, yt, zt], [so, yb, zt],
                   [so, yb, zb], [L/2 - 0.5, yb, zb]]);
    }
}

module all_wires() {
    side_wires(tb_plus);
    other() side_wires(tb_minus);
    end_wires();
    rotate([0, 0, 180]) end_wires();
}

// =====================================================================
//  PREVIEW PAINT AND LABELS  (never part of a printed part)
// =====================================================================

// thin gray skin inside the body: walls, ceiling and floor
module interior_liner() {
    t = 0.05;
    difference() {
        translate([-L/2 + wall, -W/2 + wall, 0]) cube([L - 2*wall, W - 2*wall, H]);
        translate([-L/2 + wall + t, -W/2 + wall + t, t]) cube([L - 2*wall - 2*t, W - 2*wall - 2*t, H - 2*t]);
        side_cuts(tb_plus);
        other() side_cuts(tb_minus);
        end_cuts();
    }
}

module side_labels() {
    sz = 25; off = 30; zc = H * 0.6;
    // "B" on the +Y side, readable from that side
    multmatrix([[-1, 0, 0, 0], [0, 0, 1, W/2 + off], [0, 1, 0, zc], [0, 0, 0, 1]])
        linear_extrude(1) text("B", size = sz, halign = "center", valign = "center");
    // "A" on the -Y side
    multmatrix([[1, 0, 0, 0], [0, 0, -1, -W/2 - off], [0, 1, 0, zc], [0, 0, 0, 1]])
        linear_extrude(1) text("A", size = sz, halign = "center", valign = "center");
}

// wheels only, for checking clearance in the preview (not printed)
module wheel_ghosts() {
    for (x = [-p(truck_centers)/2, p(truck_centers)/2], ax = [-truck_wb/2, truck_wb/2], sy = [-1, 1])
        translate([x + ax, sy*(gauge/2 + 1.5), wheel_dia/2 - floor_above_rail])
            rotate([90, 0, 0]) cylinder(d = wheel_dia, h = 5, center = true, $fn = 40);
}

// everything on one end, for the preview
module end_details() {
    color(paint_black) railing();
    color(paint_black) translate([staff_x, staff_y, deck_h + p(brake_wheel_h)]) brake_wheel();
    color(paint_black) translate([staff_x, staff_y, -peg_len])
        cylinder(d = brake_staff_wire, h = staff_len, $fn = 12);
    color(paint_black) ladder();
}

// =====================================================================
//  OUTPUT
// =====================================================================

// bay (and toolbox, if that side has one) on side sy = +1 or -1.
// The bay and toolbox are symmetric end-to-end, so the far side uses the
// same parts turned around - which keeps the number reading correctly.
module placed_parts(sy, tb) {
    far = (sy < 0 && other_side == "rotated") ? -1 : 1;
    rz  = sy > 0 ? 0 : 180;
    translate([far * p(bay_x), sy * W/2, p(bay_bottom)]) rotate([0, 0, rz]) {
        color(paint_body) render() bay();
        color(paint_black) bay_number(number_relief + 0.05);
        color(paint_interior) render() bay_liner();
    }
    if (tb)
        color(paint_body) translate([far * p(toolbox_x), sy * W/2, p(toolbox_bottom)])
            rotate([0, 0, rz]) toolbox();
}
