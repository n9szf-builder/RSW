// =====================================================================
//  PLATFORM DECK
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: deck_plate(), deck().
//  Print: flat. Qty 2.
// =====================================================================

// =====================================================================
//  PLATFORM DECK  (+X end shown; print two). Glues onto the plate
//  between the body end and the car end. Prints flat as modeled.
//  Thin wood deck; the Kadee box is glued up against its underside.
// =====================================================================

module deck_plate() {
    x0 = L/2 + fit;
    dl = UL/2 - x0;
    difference() {
        union() {
            // deck in front of the door, between the stairwells
            translate([x0, -(W/2 - p(step_depth)), 0])
                cube([dl, W - 2*p(step_depth), deck_h]);
            // end beam across the full width (carries the corner posts)
            translate([UL/2 - end_sill_t, -W/2, 0]) cube([end_sill_t, W, deck_h]);
        }
        if (deck_style == "boards") {
            n = floor(body_width / deck_board);
            for (i = [1 : n - 1])
                translate([x0 - 1, -W/2 + i * W/n - 0.2, deck_h - 0.4])
                    cube([dl + 2, 0.4, 1]);
        } else if (part == "deck" || preview_textures) {
            // crosshatch tread-plate texture, clipped to the deck
            intersection() {
                translate([x0 + 0.8, -W/2 + 0.8, deck_h - 0.3]) cube([dl - 1.6, W - 1.6, 1]);
                union() {
                    span = dl + W;
                    for (a = [45, -45], i = [-span/checker_pitch : span/checker_pitch])
                        translate([x0 + dl/2, 0, deck_h - 0.3])
                            rotate([0, 0, a])
                                translate([-span, i * checker_pitch - 0.2, 0])
                                    cube([2*span, 0.4, 1]);
                }
            }
        }
    }
}

// deck with the railing peg holes, staff hole and ratchet base
module deck() {
    difference() {
        union() {
            deck_plate();
            translate([staff_x - p(2), staff_y - p(2), deck_h - 0.01])
                cube([p(4), p(4), p(2.5)]);
        }
        end_holes(deck_h + p(2.5), deck_h + p(2.5) + 1);
    }
}
