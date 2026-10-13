// =====================================================================
//  WINDOW GLAZING
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: glass helpers, glazing_sheet(), side/bay/door glazing.
//  Print: flat sheet (clear/translucent). Qty 1 sheet.
// =====================================================================

// =====================================================================
//  WINDOW GLAZING  (printed separately - flat inserts, drop in from inside)
// =====================================================================

function glass_size(w, h, lip) = [w + 2*lip - 2*glaze_fit, h + 2*lip - 2*glaze_fit];

// flat insert, lying in XY, centered
module glass(sz) { translate([-sz[0]/2, -sz[1]/2, 0]) cube([sz[0], sz[1], glaze_t]); }

// all inserts laid out flat for printing (both sides, both bays, both doors)
module glazing_sheet() {
    gap = 3;
    side = glass_size(p(window_w), p(window_h), glaze_lip);
    endw = glass_size(p(bay_end_window_w), p(bay_window_h), glaze_lip_bay_end);
    door = glass_size(p(door_window_w), p(door_window_h), glaze_lip);
    // row 1: six side windows
    for (i = [0 : 2 * len(side_windows) - 1])
        translate([i * (side[0] + gap), 0, 0]) glass(side);
    // row 2: bay front windows for both bays
    r2 = side[1]/2 + gap + glass_size(1, p(bay_window_h), glaze_lip)[1]/2;
    for (b = [0, 1], j = [0 : len(bay_front_windows) - 1]) {
        fs = glass_size(p(bay_front_windows[j][1]), p(bay_window_h), glaze_lip);
        translate([(b * len(bay_front_windows) + j) * (fs[0] + gap), r2, 0]) glass(fs);
    }
    // row 3: bay end windows (4) and door windows (2)
    r3 = r2 + glass_size(1, p(bay_window_h), glaze_lip)[1]/2 + gap + endw[1]/2;
    for (i = [0 : 3]) translate([i * (endw[0] + gap), r3, 0]) glass(endw);
    for (i = [0 : 1]) translate([4 * (endw[0] + gap) + i * (door[0] + gap), r3, 0]) glass(door);
}

// glazing in place, for the preview (+Y side)
module side_glazing() {
    sz = glass_size(p(window_w), p(window_h), glaze_lip);
    for (x = side_windows)
        translate([p(x), W/2 - wall + glaze_rabbet - glaze_t, p(window_bottom) + p(window_h)/2])
            rotate([-90, 0, 0]) glass(sz);
}

// bay glazing in bay local coordinates
module bay_glazing() {
    bw = p(bay_w); bp = p(bay_proj);
    wz = p(bay_window_bottom); wh = p(bay_window_h); ew = p(bay_end_window_w);
    for (w = bay_front_windows)
        translate([p(w[0]), bp - wall + glaze_rabbet - glaze_t, wz + wh/2])
            rotate([-90, 0, 0]) glass(glass_size(p(w[1]), wh, glaze_lip));
    if (ew > 0 && bay_canted)
        for (sx = [-1, 1])
            translate([sx*(bw/2 - bp/2), bp/2, wz])
                rotate([0, 0, sx > 0 ? 135 : 225])
                    translate([0, wall - glaze_rabbet, wh/2])
                        rotate([-90, 0, 0]) glass(glass_size(ew, wh, glaze_lip_bay_end));
}

// door glazing on the +X end
module door_glazing() {
    translate([L/2 - wall + glaze_rabbet - glaze_t, p(door_y), p(door_window_bottom) + p(door_window_h)/2])
        rotate([0, 90, 0]) rotate([0, 0, 90])
            glass(glass_size(p(door_window_w), p(door_window_h), glaze_lip));
}
