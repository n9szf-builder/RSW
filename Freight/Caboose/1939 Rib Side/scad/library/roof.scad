// =====================================================================
//  ROOF
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: roof(), roof_seams(), roof_ladder_cuts().
//  Print: right side up. Qty 1.
// =====================================================================

// =====================================================================
//  ROOF  (origin: car center, z = 0 at the top of the body walls)
//  Prints right side up, flat underside on the bed. Use normal sparse
//  infill; the slicer's infill carries the crowned top.
// =====================================================================

module roof_seams() {
    k = floor((body_length + 2*roof_end_overhang) / seam_spacing);
    for (i = [1 : k - 1])
        translate([p((i - k/2) * seam_spacing), 0, 0])
            along_x(p(seam_w))
                polygon(concat(
                    [for (pt = roof_top_pts(-0.1)) pt],
                    [for (i = [40 : -1 : 0]) let(pt = roof_top_pts(p(seam_h))[i]) pt]));
}


module roof() {
    ft  = 1.6;   // fascia wall where the underside is hollowed
    top = 2;     // roof sheet thickness over the hollows
    difference() {
        union() {
            along_x(RL) polygon(concat([[-RW/2, 0], [RW/2, 0]], roof_top_pts()));
            roof_seams();
        }
        // pockets for the body's corner locating tabs
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (L/2 - wall - roof_tab/2), sy * (W/2 - wall - roof_tab/2), -1])
                cube([roof_tab + 2*fit, roof_tab + 2*fit, 2*(roof_tab_h + 0.3 + 1)], center = true);
        // hollow undersides over the end platforms
        for (sx = [-1, 1])
            // open right out through the end: no fascia across the end,
            // just the roof sheet running to the end of the car
            translate([sx > 0 ? L/2 : -RL/2 - 1, -RW/2 + ft, -1])
                cube([RL/2 - L/2 + 1, RW - 2*ft, FH - top + 1]);
        // slots that take the raised tops of the body end walls
        for (sx = [-1, 1])
            translate([sx > 0 ? L/2 - wall - fit : -L/2 - fit, -RW/2 + ft, -1])
                cube([wall + 2*fit, RW - 2*ft, FH - top + 1]);
        // ladder notch and roof grab holes, both ends
        roof_ladder_cuts();
        rotate([0, 0, 180]) roof_ladder_cuts();
        // stack sockets
        translate([p(smokejack_x), p(smokejack_y), -1])
            cylinder(d = smokejack_tube + 0.2, h = FH + CR + 5);
        translate([p(lanternjack_x), p(lanternjack_y), -1])
            cylinder(d = lanternjack_tube + 0.2, h = FH + CR + 5);
    }
}

// roof: shallow notch so the ladder can lie flat against the railing,
// and holes for the wire grabs (+X end)
module roof_ladder_cuts() {
    translate([ladder_face, ladder_ya - 0.2, -1]) cube([5, LW + 0.4, FH + CR + 2]);
    for (y = [ladder_ya + ladder_stile/2, ladder_ya + LW - ladder_stile/2])
        translate([RL/2 - p(6), y, FH - 5]) cylinder(d = roof_grab_wire + 0.15, h = 10, $fn = 10);
}
