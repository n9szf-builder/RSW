// =====================================================================
//  PARAMETERS, DERIVED VALUES AND SHARED HELPERS
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: every adjustable setting, plus values and helper functions
//  that more than one part needs. Edit settings HERE.
//  `part` is NOT set here - the Main file or a View file sets it.
// =====================================================================

preview_textures = false;  // true = show the deck tread-plate texture in
                           //   the full-car preview (slow; may hit the
                           //   preview element limit). Always in the STL.
other_side = "mirrored"; // "mirrored" = bay and windows at the same
                         //   positions along the car on both sides, as
                         //   the HO model's Side A / Side B photos show
                         // "rotated" = far side is the near side turned
                         //   end-for-end
// Sides as in the photos: Side A is -Y, Side B is +Y.
// The toolbox (access door) is on Side A only.
toolbox_sy = -1;         // -1 = Side A, 1 = Side B, 0 = both sides

// ---------------- scale ----------------
scale_ratio = 29;
S = 25.4 / scale_ratio;           // mm per prototype inch
function p(inches) = inches * S;

// ---------------- body (inches) ----------------
body_length = 335;   // over end sheets (~27'-11")
body_width  = 110;   // over side sheets (9'-2")          ESTIMATE
side_height = 82;    // bottom of sill to roof line
sill_band_h = 8;
sill_band_d = 0.75;  //                                   ESTIMATE

// ---------------- horizontal ribs (inches) ----------------
// Build-year variants (per George Toman / Resin Car Works blog):
//   "1939" original large hat-section ribs
//   "1944" smaller hat ribs PLUS a 1" intermediate rib between each pair
//          (built this way for one year only)
//   "1946" smaller hat ribs, no intermediate ribs (e.g. IRM 01984)
rib_style = "1939";

// the lowest rib should line up with about the middle of the toolbox door
rib_z     = [23, 38.5, 54, 69.5];  // hat rib centerlines above bottom of sill

rib_large = [3,    1,    1  ];  // [base height, outer face height, depth] ESTIMATE
rib_small = [2.25, 0.75, 0.7];  //                                         ESTIMATE
rib_w     = (rib_style == "1939") ? rib_large[0] : rib_small[0];
rib_top_w = (rib_style == "1939") ? rib_large[1] : rib_small[1];
rib_d     = (rib_style == "1939") ? rib_large[2] : rib_small[2];
intermediate_ribs = (rib_style == "1944");
int_rib_dia = 1;   // 1" intermediate rib (modeled as a half-round)
// keep (rib_w - rib_top_w)/2 >= rib_d so the rib undersides are
// 45 degrees or steeper and print upright without supports

// ---------------- side windows (inches) ----------------
// centers measured from car center; + = toward the toolbox end
side_windows  = [-109, 54, 141];
window_w      = 21.5;   // glass opening (HO close-up: ~21.5 x 21)
window_h      = 21;
window_bottom = 46.2;   // above bottom of sill
frame_w       = 1.5;    // raised frame border width
frame_d       = 0.6;    // frame projection               ESTIMATE

// ---------------- side grab irons ----------------
// Long curved grab at each end of each side (HO model): holes for bent
// brass wire. [inches in from the body end, inches above bottom of sill]
side_grab_top    = [6, 44];
side_grab_bottom = [32, 8];
// vertical grab beside the toolbox: [top, bottom] inches above sill bottom,
// placed this far outside the toolbox edge (toward the car center)
toolbox_grab_z   = [30, 12];
toolbox_grab_gap = 3;
// vertical grabs on the body ends, one near each corner:
// fraction of body width across, [top, bottom] inches above sill bottom
end_grab_y = [-0.34, 0.36];
end_grab_z = [67, 51];
side_grab_wire   = 1.2;   // mm (about 1.4" at 1:29)

// ---------------- end doors (inches) ----------------
// door is scribed into the end sheet (not cut through) with a window in it
door_w      = 24;   // from HO end view
door_h      = 76;
door_bottom = 2;    // at platform deck level
door_y      = 0;    // offset from centerline                  ESTIMATE
door_window_w      = 9;    // small square light, upper door
door_window_h      = 9;
door_window_bottom = 58;   // above bottom of sill
door_groove_w = 0.8;       // mm, scribed outline width
door_groove_d = 0.6;       // mm, scribed outline depth

// ---------------- bay window (inches) ----------------
bay_x      = -17.3;  // bay center from car center (it is off-center)
bay_w      = 74.7;
bay_bottom = 8;      // sits on top of the sill band
bay_h      = 74;     // up to the roof line
bay_proj   = 9;      // from 10'-8" width over bays       ESTIMATE
// front windows: [center from bay center, width]; - = toward the
// single-window end of the car. The bay design changed between build years.
//   "drawing" = Walthers elevation (#063): centered pair. The narrow
//               "slits" in the drawing are the windows on the canted
//               ends seen edge-on, so they're modeled there instead.
//   "1944"    = Toman's 1944 model photo (rough)
bay_style = "drawing";
bay_front_windows = (bay_style == "1944")
    ? [[-7, 12], [7, 12]]
    : [[-8, 10.4], [8, 10.4]];
bay_window_bottom = 38.2;   // above bottom of bay
bay_window_h      = 22.3;
bay_canted        = true;   // 45-degree angled ends (front is narrower)
bay_end_window_w  = 7;      // windows in the angled ends, 0 = none
bay_top_slope     = 5;      // percent, top falls from the car side to the front
bay_slope         = false;  // bottom is square (90 degrees) on these cars   // 45-degree sloped underside, running from
                            //   the car side out to the bay front

// ---------------- toolbox (inches) ----------------
toolbox_x      = 102.8;
toolbox_w      = 27.5;
toolbox_bottom = 8.7;
toolbox_h      = 27.5;
toolbox_d      = 2;         // shallow box, per the HO model


// ---------------- roof (inches) ----------------
roof_end_overhang  = 31;   // past each body end, covers the platforms
roof_side_overhang = 0;    // roof is the same width as the body
fascia_h     = 9.7;        // edge band depth
roof_crown   = 3;          // rise at centerline                         ESTIMATE
seam_spacing = 48;         // raised roof panel seams                    ESTIMATE
seam_w       = 1;
seam_h       = 0.5;
// 1939 cars: coal stove -> tall smokejack; plus a short lantern jack.
// Both are sockets for brass tube (sturdier than printed pipes).
smokejack_x    = 46.6;     // from car center (+ = toolbox end)
smokejack_y    = 18;       // off centerline so it clears the roofwalk  ESTIMATE
smokejack_tube = 4.76;     // mm, 3/16" brass tube (about 5.4" at 1:29)
lanternjack_x    = -50;
lanternjack_y    = -18;    //                                           ESTIMATE
lanternjack_tube = 3.18;   // mm, 1/8" brass tube
roof_tab    = 5;           // mm, corner locating tabs on the body top
roof_tab_h  = 2;           // mm the tabs stand above the wall tops

// ---------------- wood roofwalk (inches) - 1939 cars ----------------
roofwalk_w       = 20.5;   // ESTIMATE
roofwalk_boards  = 3;
roofwalk_gap     = 0.5;
roofwalk_board_t = 1.5;
roofwalk_h       = 4;      // top of boards above the roof crown        ESTIMATE
saddle_spacing   = 48;
saddle_w         = 3;


// ---------------- underframe / trucks ----------------
// The plate is the car floor AND the two end platform decks, one piece.
// Its top is the bottom of the body; body screws up through it into the
// body's screw bosses.
floor_above_rail = 33;    // mm, rail top to bottom of body / top of plate.
                          //   Drawing gives ~31.4; raised a little so the
                          //   wheels clear the plate.                    CHECK
truck_centers   = 222;    // inches, bolster to bolster (from drawing)
// Printed Bettendorf-style truck (library/truck.scad). For bought trucks
// instead (e.g. USA Trains), MEASURE YOURS and put the numbers here:
truck_bolster_h = 22;     // mm, rail top to top of truck bolster (where
                          //   the car rests)
truck_wb        = p(66);  // mm, axle to axle: 5'-6" wheelbase = 57.8 mm
                          //   (was 60, a guess for the USA Trains truck)
wheel_dia       = 29;     // mm (33" wheels at 1:29)
truck_screw_pilot = 2.4;  // mm, for a ~3 mm self-tapping truck screw
truck_swing     = 15;     // degrees of truck rotation to clear
plate_t         = 5;      // mm
plate_min_t     = 1.5;    // mm left above the wheel clearance lanes
center_sill_w   = 10;     // mm
center_sill_d   = 4;      // mm below the plate
end_sill_d      = p(12);  // prototype ~12" deep end sill              ESTIMATE
end_sill_t      = 4;      // mm
// Coupler pockets, set up for Kadee #906 (G scale, body-mount box).
// The pocket goes through the plate; the box top butts against the
// underside of the deck and is glued (epoxy) in the pocket - a caboose
// coupler only ever pulls its own car. Kadee's G-scale standard puts the
// coupler centerline 1-1/8" (28.6 mm) above the rail. With the box top at
// the plate top (33 mm), a box about 9 mm tall puts it at ~28.5 mm.
kadee_box_h      = 9;     // mm                                         CHECK
coupler_pocket_w = 21;    // mm                                         CHECK
body_screw_clear = 2.9;   // mm, M2.5 clearance

// ---------------- platforms and steps ----------------
deck_h        = p(2);   // deck top sits just above the body bottom
deck_style    = "checker";  // "checker" (tread plate, as on the brass model)
                           //   or "boards" (scribed wood planks)
deck_board    = 5.5;    // inches, plank width for "boards"            ESTIMATE
checker_pitch = 1.5;    // mm, crosshatch spacing for "checker"
// deck top is ~34.8 mm above rail; three even risers of ~8.8 mm
step_treads   = [26.2, 17.4, 8.6];  // mm above rail, top of each tread
step_depth    = 15;     // inches: stairwell width in from the car side,
                        //   also the tread depth. The deck in front of the
                        //   door is narrowed by this much on each side.
step_stagger  = 4;      // inches each lower tread steps out past the
                        //   one above (top tread is flush with the side)
step_t        = 1.6;    // mm tread thickness
hanger_t      = 1.4;    // mm side stringer thickness
riser_t       = 1.2;    // mm closed riser at the back of each tread
tread_groove  = 1.5;    // mm spacing of anti-slip grooves on the treads

// ---------------- end railing & brake (inches unless noted) ----------------
rail_member   = 1.8;    // mm, printed post and rail size
// Per the HO model: corner posts run deck-to-roof and carry the roof
// overhang, one inner post also runs to the roof, a single top rail,
// and two wide flat stanchions from the deck up to the top rail.
// Positions across the end are fractions of body width (+ = +Y side).
rail_top      = 34;     // top rail above the deck
roof_posts_y  = [-0.31];        // inner posts that run up to the roof
stanchion_y   = [-0.30, 0.29];  // flat stanchions, deck to top rail
stanchion_w   = 10;     // inches wide
peg_len       = 3;      // mm, post pegs into the deck and plate
// 1939 cars: horizontal brake wheel on a vertical staff at each end
// (seen edge-on in the drawing), about 48" above the deck.
brake_wheel_h = 48;
brake_wheel_d = 16;
brake_inset   = 4;      // staff inboard of the railing
brake_y       = -0.18;  // staff position across the end, fraction of
                        //   body width (from the HO model end view)
brake_staff_wire = 1.6; // mm, 1/16" brass wire staff

// ---------------- end ladder (inches unless noted) ----------------
// One ladder per end, deck to roof edge, standing just outboard of the
// railing. Per the HO model it sits inboard, not at the corner, on the
// side opposite the brake staff.
ladder_w       = 21;    // outside width of stiles
ladder_y0      = 0.10;  // inner stile position, fraction of body width
ladder_rung    = 12;    // rung spacing                            ESTIMATE
ladder_stile   = 1.6;   // mm
ladder_rung_t  = 1.2;   // mm
ladder_t       = 1.6;   // mm thickness (prints flat)
roof_grab_wire = 1.0;   // mm brass wire for the curved grabs at the top

// ---------------- smokestack & lantern jack (inches) ----------------
stack_h     = 48;       // coal-stove stack above the roof (from drawing)
stack_d     = 5.4;
stack_cap_d = 7;
lantern_h   = 11;       // short lantern jack above the roof (from drawing)
lantern_d   = 3.5;

// ---------------- underside detail (inches unless noted) ----------------
underside_detail = true;
crossbearer_x    = [-36, 36];  // from car center
crossbearer_w    = 3;          // mm
// 1939 cars: K brakes - a KC combined brake cylinder and reservoir
kc_len   = 40;
kc_dia   = 12;
kc_x     = -6;                 // center of the unit, from car center
kc_y     = -0.25;              // fraction of body width
brake_lever_x = 18;            // live lever location
rod_mm        = 1.2;           // mm, brake rod / train line size
floor_board   = 6;             // underside floor board width

// ---------------- paint (preview colors) and lettering ----------------
paint_body  = "#D2691E";   // Milwaukee Road caboose orange
paint_black = "#1E1E1E";   // roof, underframe, railings, steps
paint_roof  = "#2A2A2A";
road_number = "01876";
number_font = "Liberation Serif";  // Roman serif like the HO model
number_h_bay = 7;          // inches, number on the bay number board
number_h_end = 4;          // inches, number above the end doors
number_relief = 0.4;       // mm raised - a guide for painting or decals
show_lettering = false;    // true = raised road numbers on the ends and bay (off for printing)

// ---------------- brass wire grabs & handrails (preview only) ----------------
// These are bent from brass wire; they show in the full-car preview and
// are never part of a printed STL.
show_wire_grabs = true;
show_wheel_ghosts = false; // see-through wheels for checking clearance
show_trucks = true;        // the printed trucks under the car in the full-car preview
paint_white     = "#F2F2F2";
grab_standoff   = 2;       // inches the wire stands off the car
// L-shaped end handrail each side of the door: runs across the end sheet
// from beside the door to the corner, then down the corner.
// [fraction of body width, inches above sill bottom] for the two holes
end_rail_top    = [0.14, 39];
end_rail_bottom = [0.48, 10];

// ---------------- short crosswise running board at the roof ends ----------------
latwalk_len    = 22;      // inches along the car
latwalk_boards = 2;

// ---------------- preview helpers ----------------
show_side_labels = false;    // big "A" (-Y side) and "B" (+Y side) floating
                             //   beside the car in the preview - not printed
paint_interior   = "#848884"; // battleship gray, inside the body and bays
// door knob on each end door
door_knob_side  = 1;          // 1 = on the right as you face the door, -1 = left
door_knob_in    = 3.5;        // inches in from the edge of the door
door_knob_h     = 36;         // inches above the deck

// ---------------- window glazing (printed separately) ----------------
// Every window gets a rabbet (notch) on the inside face; a flat glazing
// insert drops into it from inside the car.
glaze_lip   = 1.2;    // mm the rabbet extends past the opening all round
glaze_lip_bay_end = 1.0;  // mm, smaller on the narrow angled bay faces
glaze_rabbet = 1.0;   // mm deep, from the inside face
glaze_t     = 0.8;    // mm glazing thickness
glaze_fit   = 0.15;   // mm clearance per side
paint_glass = [0.25, 0.45, 0.95, 0.9];   // blue, 10% transparent

// ---------------- restroom (Side A, right-hand end) ----------------
// Side A is -Y; "right" as you face Side A is the +X end.
rr_end   = 1;         // +1 = +X end, -1 = -X end
rr_side  = -1;        // -1 = Side A, +1 = Side B
rr_len   = 48;        // inches along the car
rr_depth = 36;        // inches across the car, from the side wall
rr_wall  = 1.5;       // mm partition thickness
rr_door_w = 22;       // inches
rr_door_h = 70;       // inches

// ---------------- model construction (real mm) ----------------
wall     = 2.8;
fit      = 0.25;
boss     = 7;
boss_h   = 9;      // kept below the bay opening
screw_d  = 2.2;    // pilot for M2.5 or #2 self-tappers
tongue_t = 1.2;
$fn = 24;

// ---------------- derived ----------------
L = p(body_length);
W = p(body_width);
H = p(side_height);

// does the +Y side (plus) / the other side (minus) carry the toolbox?
tb_plus  = (toolbox_sy >= 0);
tb_minus = (toolbox_sy <= 0);

module other() {
    if (other_side == "rotated") rotate([0, 0, 180]) children();
    else mirror([0, 1, 0]) children();
}

// =====================================================================
//  SHARED DERIVED VALUES AND HELPERS (moved here from the part sections
//  because several parts use them)
// =====================================================================

// ---- roof shape (used by body, roof, roofwalk, ladder) ----
RL = L + 2*p(roof_end_overhang);
RW = W + 2*p(roof_side_overhang);
FH = p(fascia_h);
CR = p(roof_crown);
function roof_z(y) = FH + CR * (1 - pow(2*y/RW, 2));
function roof_top_pts(extra = 0) =
    [for (i = [0 : 40]) let(y = RW/2 - i*RW/40) [y, roof_z(y) + extra]];

// profile in (y, z), extruded along X
module along_x(len) { rotate([90, 0, 90]) linear_extrude(len, center = true) children(); }

// ---- roofwalk ----
RWW = p(roofwalk_w);
walk_top = roof_z(0) + p(roofwalk_h);

// ---- underframe / track ----
UL = RL;   // plate runs the full length, under both platforms
gauge = 45;

// ---- stairwells (used by underframe and steps) ----
step_x0 = L/2 + 1;
step_x1 = RL/2 - end_sill_t - 0.5;

// ---- end railing & brake staff positions (railing, deck, underframe) ----
RM      = rail_member;
rail_x  = UL/2 - RM/2 - 0.3;           // centerline of the railing frame
staff_x = rail_x - p(brake_inset);
staff_y = brake_y * W;
staff_len = peg_len + deck_h + p(brake_wheel_h) + 2.4;

// frame coordinate u = -y (car), so positions are negated below
post_h = H - deck_h;                       // corner posts: up under the side fascia
inner_post_h = H + FH - 2 - deck_h;        // inner roof posts: up to the roof sheet
function corner_posts_u() = [-W/2 + RM/2, W/2 - RM/2];
function inner_posts_u()  = [for (f = roof_posts_y) -f * W];
function tall_posts_u() = concat(corner_posts_u(), inner_posts_u());
function stanchions_u() = [for (f = stanchion_y) -f * W];
function peg_u() = concat(tall_posts_u(), stanchions_u());

// ---- end ladder (ladder, roof, roofwalk) ----
LW = p(ladder_w);
// deck top up to the roof surface at the ladder's inner stile (the roof
// is crowned, so this is higher than the roof edge)
ladder_len = H + roof_z(ladder_y0 * W) - deck_h;
ladder_face = rail_x + RM/2;              // railing outboard face
ladder_rungs = floor((ladder_len - 2) / p(ladder_rung));

ladder_ya = ladder_y0 * W;                 // inner stile edge (car y)
