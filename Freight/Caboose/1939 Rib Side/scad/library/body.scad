// =====================================================================
//  BODY SHELL
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: body() with ribs, windows, end doors, grab holes,
//  roof tabs, screw bosses, door knobs and end road numbers.
//  Print: upright, as modeled. Qty 1.
// =====================================================================

// =====================================================================
//  BODY
// =====================================================================

// one horizontal rib along the full length, centered on z = 0
module hrib() {
    w = p(rib_w); t = p(rib_top_w); d = p(rib_d);
    rotate([90, 0, 90])
        linear_extrude(L, center = true)
            polygon([[-0.05, -w/2], [-0.05, w/2], [d, t/2], [d, -t/2]]);
}

function frame_ow() = p(window_w) + 2*p(frame_w);
function frame_oh() = p(window_h) + 2*p(frame_w);

// areas on the side where ribs must be cleared (+Y side)
module rib_clear(tb = true) {
    for (x = side_windows)
        translate([p(x) - frame_ow()/2 - fit, W/2 - 0.1, p(window_bottom) - p(frame_w) - fit])
            cube([frame_ow() + 2*fit, 20, frame_oh() + 2*fit]);
    translate([p(bay_x) - p(bay_w)/2 - fit, W/2 - 0.1, p(bay_bottom) - fit])
        cube([p(bay_w) + 2*fit, 20, p(bay_h) + 2*fit]);
    if (tb)
        translate([p(toolbox_x) - p(toolbox_w)/2 - fit, W/2 - 0.1, p(toolbox_bottom) - fit])
            cube([p(toolbox_w) + 2*fit, 20, p(toolbox_h) + 2*fit]);
}

// raised detail on the +Y side
module side_add(tb = true) {
    translate([-L/2, W/2 - 0.05, 0])
        cube([L, p(sill_band_d) + 0.05, p(sill_band_h)]);
    difference() {
        union() {
            for (z = rib_z) translate([0, W/2, p(z)]) hrib();
            if (intermediate_ribs)
                for (i = [0 : len(rib_z) - 2])
                    translate([0, W/2, p((rib_z[i] + rib_z[i+1]) / 2)])
                        rotate([0, 90, 0])
                            cylinder(d = p(int_rib_dia), h = L, center = true, $fn = 16);
        }
        rib_clear(tb);
    }
    for (x = side_windows)
        translate([p(x) - frame_ow()/2, W/2 - 0.05, p(window_bottom) - p(frame_w)])
            cube([frame_ow(), p(frame_d) + 0.05, frame_oh()]);
}

// openings on the +Y side
module side_cuts(tb = true) {
    depth = wall + 10;
    for (x = side_windows) {
        translate([p(x) - p(window_w)/2, W/2 - wall - 1, p(window_bottom)])
            cube([p(window_w), depth, p(window_h)]);
        // glazing rabbet on the inside face
        translate([p(x) - p(window_w)/2 - glaze_lip, W/2 - wall - 1, p(window_bottom) - glaze_lip])
            cube([p(window_w) + 2*glaze_lip, 1 + glaze_rabbet, p(window_h) + 2*glaze_lip]);
    }
    bo_w = p(bay_w) - 2*wall;
    bo_h = p(bay_h) - 2*wall;
    translate([p(bay_x) - bo_w/2, W/2 - wall - 1, p(bay_bottom) + wall])
        cube([bo_w, depth, bo_h]);
    // curved grab iron holes, both ends
    for (sx = [-1, 1], pt = [side_grab_top, side_grab_bottom])
        translate([sx * (L/2 - p(pt[0])), W/2 - wall - 1, p(pt[1])])
            rotate([-90, 0, 0]) cylinder(d = side_grab_wire + 0.15, h = depth, $fn = 12);
    // toolbox grab holes
    if (tb) for (z = toolbox_grab_z)
        translate([p(toolbox_x - toolbox_w/2 - toolbox_grab_gap), W/2 - wall - 1, p(z)])
            rotate([-90, 0, 0]) cylinder(d = side_grab_wire + 0.15, h = depth, $fn = 12);
}

// one end (+X); the other end is the same turned around
module end_cut_one() {
    dw = p(door_w); dh = p(door_h);
    // scribed door outline
    translate([L/2 - door_groove_d, p(door_y) - dw/2, p(door_bottom)])
        difference() {
            cube([door_groove_d + 1, dw, dh]);
            translate([-1, door_groove_w, door_groove_w])
                cube([door_groove_d + 3, dw - 2*door_groove_w, dh - 2*door_groove_w]);
        }
    // door window, cut through, with a glazing rabbet inside
    translate([L/2 - wall - 1, p(door_y) - p(door_window_w)/2, p(door_window_bottom)])
        cube([wall + 2, p(door_window_w), p(door_window_h)]);
    translate([L/2 - wall - 1, p(door_y) - p(door_window_w)/2 - glaze_lip, p(door_window_bottom) - glaze_lip])
        cube([1 + glaze_rabbet, p(door_window_w) + 2*glaze_lip, p(door_window_h) + 2*glaze_lip]);
    // end handrail holes (both sides of the door)
    for (sy = [-1, 1], pt = [end_rail_top, end_rail_bottom])
        translate([L/2 - wall - 1, sy * pt[0] * W, p(pt[1])])
            rotate([0, 90, 0]) cylinder(d = side_grab_wire + 0.15, h = wall + 2, $fn = 12);
    // end grab iron holes
    for (f = end_grab_y, z = end_grab_z)
        translate([L/2 - wall - 1, f * W, p(z)])
            rotate([0, 90, 0]) cylinder(d = side_grab_wire + 0.15, h = wall + 2, $fn = 12);
}

module end_cuts() {
    end_cut_one();
    rotate([0, 0, 180]) end_cut_one();
}

// corner tabs standing up from the wall tops to locate the roof.
// 45-degree underside so the body still prints upright with no supports.
module roof_tabs() {
    t = roof_tab;
    for (sx = [-1, 1], sy = [-1, 1])
        mirror([sx < 0 ? 1 : 0, 0, 0]) mirror([0, sy < 0 ? 1 : 0, 0])
            hull() {
                translate([L/2 - wall - t, W/2 - wall - t, H - 1]) cube([t, t, roof_tab_h + 1]);
                translate([L/2 - wall - 0.2, W/2 - wall - 0.2, H - 1 - t]) cube([0.2, 0.2, 0.1]);
            }
}

module bosses() {
    bx = L/2 - wall - boss/2;
    by = W/2 - wall - boss/2;
    for (x = [-bx, 0, bx], y = [-by, by])
        translate([x, y, 0])
            difference() {
                translate([-boss/2, -boss/2, 0]) cube([boss, boss, boss_h]);
                translate([0, 0, -1]) cylinder(d = screw_d, h = boss_h - 1);
            }
}

module body() {
    difference() {
        union() {
            difference() {
                translate([-L/2, -W/2, 0]) cube([L, W, H]);
                translate([-L/2 + wall, -W/2 + wall, -1])
                    cube([L - 2*wall, W - 2*wall, H + 2]);
            }
            side_add(tb_plus);
            other() side_add(tb_minus);
            bosses();
            // door knobs on both end doors
            door_knob();
            rotate([0, 0, 180]) door_knob();
            // road number on both ends
            if (show_lettering) {
                end_number();
                rotate([0, 0, 180]) end_number();
            }
            // end walls continue up into the roof, to the underside of the
            // roof sheet over the platforms (inside the roof's side fascia)
            for (sx = [-1, 1])
                translate([sx > 0 ? L/2 - wall : -L/2, -(W/2 - 1.6 - fit), H - 0.01])
                    cube([wall, W - 2*(1.6 + fit), FH - 2 - 0.3]);
            roof_tabs();
        }
        side_cuts(tb_plus);
        other() side_cuts(tb_minus);
        end_cuts();
    }
}

// on the +X end sheet, centered above the door
module end_number(relief = number_relief) {
    zc = door_bottom + door_h + number_h_end/2 + 1.5;
    multmatrix([[0, 0, 1, L/2 - 0.01], [1, 0, 0, 0], [0, 1, 0, p(zc)], [0, 0, 0, 1]])
        linear_extrude(relief)
            text(road_number, size = p(number_h_end), font = number_font,
                 halign = "center", valign = "center");
}

// door knob and round backplate on the +X end door (printed with the body)
module door_knob() {
    y = door_knob_side * (p(door_w)/2 - p(door_knob_in)) + p(door_y);
    z = p(door_bottom + door_knob_h);
    translate([L/2 - 0.01, y, z]) rotate([0, 90, 0]) {
        cylinder(d = p(3.5), h = 0.5, $fn = 24);                   // rose
        cylinder(d = p(1.2), h = p(2.2), $fn = 16);                // shank
        translate([0, 0, p(2.2)]) sphere(d = p(2.4), $fn = 20);    // knob
    }
}
