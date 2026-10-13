// =====================================================================
//  TOOLBOX
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: toolbox().
//  Print: on its back. Qty 1 (Side A only).
// =====================================================================

// =====================================================================
//  TOOLBOX  (origin: back face, center, bottom) - print on its back
// =====================================================================

module toolbox() {
    tw = p(toolbox_w); th = p(toolbox_h); td = p(toolbox_d);
    union() {
        translate([-tw/2, 0, 0]) cube([tw, td, th]);
        // lid lip
        translate([-tw/2 - p(0.5), 0, th - p(2)]) cube([tw + p(1), td + p(0.5), p(2)]);
    }
}
