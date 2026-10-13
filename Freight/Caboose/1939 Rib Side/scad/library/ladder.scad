// =====================================================================
//  END LADDER
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: ladder_flat(), ladder().
//  Print: flat. Qty 2.
// =====================================================================

// =====================================================================
//  END LADDER  (+X end; the -X end is the same turned 180). Prints flat.
//  Glues to the outboard face of the railing and the roof end.
//  Bend 1 mm wire grabs from the ladder top into the roof holes.
// =====================================================================


// u across (0..LW), v up (0..ladder_len), w thickness (w = 0 outboard)
module ladder_flat() {
    st = ladder_stile;
    for (u = [0, LW - st]) translate([u, 0, 0]) cube([st, ladder_len, ladder_t]);
    for (i = [1 : ladder_rungs])
        translate([st - 0.01, i * p(ladder_rung) - ladder_rung_t/2, 0])
            cube([LW - 2*st + 0.02, ladder_rung_t, ladder_rung_t]);
}

// placed inboard on the +X end, from ladder_y0 across

module ladder() {
    multmatrix([[0, 0, -1, ladder_face + ladder_t],
                [-1, 0, 0, ladder_ya + LW],
                [0, 1, 0, deck_h],
                [0, 0, 0, 1]])
        ladder_flat();
}
