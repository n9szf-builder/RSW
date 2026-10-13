// =====================================================================
//  WOOD ROOFWALK
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: roofwalk(), latwalk().
//  Print: boards down. Qty 1.
// =====================================================================

// =====================================================================
//  WOOD ROOFWALK  (same origin as the roof). Printed boards-down.
// =====================================================================

// short crosswise running board at the +X roof end, from the roofwalk
// out over the ladder top (the -X end is the same turned 180)
module latwalk() {
    bt = p(roofwalk_board_t);
    x1 = RL/2 - 0.3;
    x0 = x1 - p(latwalk_len);
    y0 = RWW/2 - 0.5;
    y1 = ladder_y0 * W + p(ladder_w) + p(2);
    gap = p(roofwalk_gap);
    bl = (x1 - x0 - (latwalk_boards - 1) * gap) / latwalk_boards;
    difference() {
        union() {
            for (i = [0 : latwalk_boards - 1])
                translate([x0 + i * (bl + gap), y0, walk_top - bt]) cube([bl, y1 - y0, bt]);
            // two saddles under it, shaped to the roof crown
            for (x = [x0 + p(saddle_w)/2, x1 - p(saddle_w)/2])
                translate([x, 0, 0])
                    along_x(p(saddle_w))
                        polygon(concat(
                            [for (j = [0 : 10]) let(y = y0 + j*(y1 - y0)/10) [y, roof_z(y) + 0.05]],
                            [[y1, walk_top - bt + 0.05], [y0, walk_top - bt + 0.05]]));
        }
        // let the ladder-top wire grabs pass through
        for (y = [ladder_y0 * W + ladder_stile/2, ladder_y0 * W + p(ladder_w) - ladder_stile/2])
            translate([RL/2 - p(6), y, 0]) cylinder(d = roof_grab_wire + 0.3, h = walk_top + 5, $fn = 10);
    }
}

module roofwalk() {
    latwalk();
    rotate([0, 0, 180]) latwalk();
    bt = p(roofwalk_board_t);
    bw = (RWW - (roofwalk_boards - 1) * p(roofwalk_gap)) / roofwalk_boards;
    // boards
    for (i = [0 : roofwalk_boards - 1])
        translate([-RL/2, -RWW/2 + i * (bw + p(roofwalk_gap)), walk_top - bt])
            cube([RL, bw, bt]);
    // saddles, shaped to the roof crown
    k = floor((body_length + 2*roof_end_overhang) / saddle_spacing);
    for (i = [0 : k])
        translate([p((i - k/2) * saddle_spacing), 0, 0])
            along_x(p(saddle_w))
                polygon(concat(
                    [for (j = [0 : 10]) let(y = -RWW/2 + j*RWW/10) [y, roof_z(y) + 0.05]],
                    [[RWW/2, walk_top - bt + 0.05], [-RWW/2, walk_top - bt + 0.05]]));
}
