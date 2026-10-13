// =====================================================================
//  BAY WINDOW
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: bay(), bay_shell(), window cuts, hollow, liner, bay number.
//  Print: top-down (sloped top flat on the bed). Qty 2.
// =====================================================================

// =====================================================================
//  BAY WINDOW  (origin: back face, bay center, bottom of box)
//  Top is flat and flush with the roof line - print it top-down.
// =====================================================================

// region below a 45-degree line rising outward from the car side,
// raised by `lift` (used for the outer slope and the inner floor)
module bay_wedge(len, bp, lift) {
    along_x(len)
        polygon([[-0.01, -1], [bp + 1, -1], [bp + 1, bp + 1 + lift], [-0.01, lift - 0.01]]);
}

// bay plan outline (y = 0 at the car side). With canted ends the front
// is narrower than the back by twice the projection.
function bay_outline(bw, bp) = bay_canted
    ? [[-bw/2, 0], [bw/2, 0], [bw/2 - bp, bp], [-bw/2 + bp, bp]]
    : [[-bw/2, 0], [bw/2, 0], [bw/2, bp], [-bw/2, bp]];

module bay() {
    union() { bay_shell(); if (show_lettering) bay_number(); }
}

module bay_shell() {
    bw = p(bay_w); bp = p(bay_proj); bh = p(bay_h);
    tw = bw - 2*wall - 2*fit;
    th = bh - 2*wall - 2*fit;
    wz = p(bay_window_bottom);
    wh = p(bay_window_h);
    ew = p(bay_end_window_w);
    difference() {
        union() {
            linear_extrude(bh) polygon(bay_outline(bw, bp));
            translate([-tw/2, -wall, wall + fit]) cube([tw, wall + 0.05, th]);
        }
        if (bay_slope) bay_wedge(bw + 2, bp, 0);
        // sloped top: remove everything above a plane falling at
        // bay_top_slope percent from the car side out to the front
        along_x(bw + 2)
            polygon([[-wall - 1, bh + (wall + 1) * bay_top_slope/100],
                     [bp + 1,   bh - (bp + 1) * bay_top_slope/100],
                     [bp + 1,   bh + 10],
                     [-wall - 1, bh + 10]]);
        // hollow: outline inset by the wall, open at the back
        difference() {
            intersection() {
                translate([0, 0, wall])
                    linear_extrude(bh - 2*wall)
                        offset(delta = -wall)
                            polygon(concat([[-bw/2, -10], [bw/2, -10]],
                                           [for (i = [1 : 3]) bay_outline(bw, bp)[i]],
                                           [bay_outline(bw, bp)[0]]));
                translate([-bw, 0, 0]) cube([2*bw, bp, bh]);
            }
            if (bay_slope) bay_wedge(bw, bp, wall * sqrt(2));
        }
        // hollow tongue
        translate([-tw/2 + tongue_t, -wall - 1, wall + fit + tongue_t])
            cube([tw - 2*tongue_t, wall + 2, th - 2*tongue_t]);
        bay_window_cuts(bw, bp, wz, wh, ew);
        // scribed belt lines around the bay, above and below the windows
        for (bz = [p(bay_window_bottom - 2), p(bay_window_bottom + bay_window_h + 2)])
            translate([0, 0, bz])
                linear_extrude(0.5)
                    intersection() {
                        difference() {
                            offset(delta = 1) polygon(bay_outline(bw, bp));
                            offset(delta = -0.4) polygon(bay_outline(bw, bp));
                        }
                        translate([-bw, 0.05]) square([2*bw, bp + 2]);
                    }
    }
}

module bay_window_cuts(bw, bp, wz, wh, ew) {
    // front windows
    for (w = bay_front_windows) {
        translate([p(w[0]) - p(w[1])/2, bp - wall - 1, wz])
            cube([p(w[1]), wall + 2, wh]);
        translate([p(w[0]) - p(w[1])/2 - glaze_lip, bp - wall - 1, wz - glaze_lip])
            cube([p(w[1]) + 2*glaze_lip, 1 + glaze_rabbet, wh + 2*glaze_lip]);
    }
    // end windows
    if (ew > 0)
        for (sx = [-1, 1])
            if (bay_canted)
                // centered on the angled face, cut square to it
                // (local +y points into the bay on both faces)
                translate([sx*(bw/2 - bp/2), bp/2, wz])
                    rotate([0, 0, sx > 0 ? 135 : 225]) {
                        translate([-ew/2, -(wall + 1), 0]) cube([ew, 2*wall + 2, wh]);
                        translate([-ew/2 - glaze_lip_bay_end, wall - glaze_rabbet, -glaze_lip_bay_end])
                            cube([ew + 2*glaze_lip_bay_end, glaze_rabbet + 1, wh + 2*glaze_lip_bay_end]);
                    }
            else
                translate([sx*bw/2 - (wall + 1), (bp - wall)/2 - ew/2, wz])
                    cube([2*wall + 2, ew, wh]);
}

// bay hollow, inset by `ins` (0 = the actual hollow); open at the back
module bay_hollow(ins = 0, back = 0) {
    bw = p(bay_w); bp = p(bay_proj); bh = p(bay_h);
    intersection() {
        translate([0, 0, wall + ins])
            linear_extrude(bh - 2*wall - 2*ins)
                offset(delta = -wall - ins)
                    polygon(concat([[-bw/2, -10], [bw/2, -10]],
                                   [for (i = [1 : 3]) bay_outline(bw, bp)[i]],
                                   [bay_outline(bw, bp)[0]]));
        translate([-bw, -back, 0]) cube([2*bw, bp + back, bh]);
    }
}

// thin gray skin on the inside faces of the bay (preview paint only)
module bay_liner() {
    bw = p(bay_w); bp = p(bay_proj);
    difference() {
        bay_hollow(0, 0);
        bay_hollow(0.05, 1);
        bay_window_cuts(bw, bp, p(bay_window_bottom), p(bay_window_h), p(bay_end_window_w));
    }
}

// on the bay front, centered in the number board above the windows
// (bay local coordinates: y = 0 at the car side, z = 0 at bay bottom)
module bay_number(relief = number_relief) {
    zc = (bay_window_bottom + bay_window_h + 2 + bay_h) / 2;   // board center
    multmatrix([[-1, 0, 0, 0], [0, 0, 1, p(bay_proj) - 0.01], [0, 1, 0, p(zc)], [0, 0, 0, 1]])
        linear_extrude(relief)
            text(road_number, size = p(number_h_bay), font = number_font,
                 halign = "center", valign = "center");
}
