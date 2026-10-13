// =====================================================================
//  MR1934_Coach4400_lib.scad  -  prototype data: Coach 4400  (1934, filed with the 1935 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Coach 4400";
CAR_TRAIN = "1935 Hiawatha";

// ---- body ----
LEN_FT = 80;    // over body (end sheet to end sheet)
WIDTH_FT = 10.08;    // over side sheets
SIDE_FT      = 7.75;   // bottom of side sill to eave
ROOF_RISE_FT = 1.85;   // eave to roof peak

// ---- ends ----
END_B        = "flat";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 0;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
END_DOORS    = true;

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in]  (x from A end, sill above side-sill bottom)
WINDOWS = [
    [5.5, 29, 32, 39, 0, 3],
    [12.55, 29, 32, 39, 0, 3],
    [16.6, 29, 32, 39, 0, 3],
    [24.90, 29, 32, 39, 0, 3],
    [28.94, 29, 32, 39, 0, 3],
    [32.98, 29, 32, 39, 0, 3],
    [37.02, 29, 32, 39, 0, 3],
    [41.06, 29, 32, 39, 0, 3],
    [45.10, 29, 32, 39, 0, 3],
    [49.14, 29, 32, 39, 0, 3],
    [53.18, 29, 32, 39, 0, 3],
    [57.22, 29, 32, 39, 0, 3],
    [61.26, 29, 32, 39, 0, 3],
    [67.5, 29, 32, 39, 0, 3],
    [74.4, 29, 32, 39, 0, 3]
];
DOME_WINDOWS = [];
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [
    [1.9, 30, 80, 6],
    [78.1, 30, 80, 6]
];

// ---- side treatment ----
FLUTES         = "none";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 0;
FLUTE_Z0_IN    = 8;
FLUTE_PITCH_IN = 3;
FLUTE_H_IN     = 1.5;
FLUTE_D        = 0.6;   // model mm
REAR_FINS      = false;

// ---- dome ----
DOME          = false;
DOME_START_FT = 0;
DOME_END_FT   = 0;
DOME_RISE_FT  = 0;
DOME_SLOPE_FT = 6;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [9, 43.1, 71];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.6],
    ["toilet", 4, 9],
    ["lounge", 9.3, 21.8],
    ["bulkhead", 22.3],
    ["coach", 22.7, 63.2],
    ["bulkhead", 63.6],
    ["lounge", 64, 71],
    ["toilet", 71.3, 76],
    ["bulkhead", 76.4]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.75, 68.25];

// ---- printing ----
BODY_JOINTS_FT = [];   // [] = automatic from bed size; or e.g. [26.5, 52.5] to land on window piers

// ---- colours (preview only) ----  fleet paint scheme: PAINT_SCHEME in common/mr_config.scad
BODY_COLOR     = PAINT_BODY;
BODY_COLOR_ALT = PAINT_BODY;
ROOF_COLOR     = PAINT_ROOF;
FLOOR_COLOR    = "#4A4A4A";
INTERIOR_COLOR = "#7A3B2E";


// ---- added by build_tree.py (new options; edit as needed) ----
DOOR_PANELS = [];
ROOF_HOUSINGS = [];
LETTERING = "THE MILWAUKEE ROAD";
LETTER_X0_FT = 22;
LETTER_X1_FT = 58;
LETTER_Z_IN = 81;
LETTER_H_IN = 6;


// ---- added by build_tree.py (new options; edit as needed) ----
END_RIBS = 0;
END_RIB_Z0_IN = 3;
END_RIB_PITCH_IN = 10.7;
END_RIB_H_IN = 1.5;
END_RIB_D = 0.6;
END_RIB_MARGIN_IN = 3;


// ---- added by build_tree.py (new options; edit as needed) ----
END_DOOR_STYLE = "closed";
END_DOOR_W_IN = 30;
END_DOOR_H_IN = 78;
END_DOOR_SILL_IN = 6;
END_DOOR_RECESS = 0.8;
END_DOOR_WINDOW = true;
END_DIAPHRAGM = true;
DIAPHRAGM_W_IN = 5;
DIAPHRAGM_D = 2.5;
DIAPHRAGM_TOP_IN = 88;


// ---- added by build_tree.py (new options; edit as needed) ----
END_RIB_STYLE = "bead";
END_POSTS = false;
END_POST_W_IN = 6.6;
END_POST_GAP_IN = 42;
END_POST_D = 1;
END_FRAME = false;
END_FRAME_HEADER_IN = 7;
END_FRAME_D = 0.8;
END_SILL_H_IN = 0;
END_SILL_D = 0.8;


// ---- added by build_tree.py (new options; edit as needed) ----
END_DOOR_WINDOW_SHAPE = "rect";
END_DOOR_PORT_IN = 20;
END_DOOR_PORT_Z_IN = 57;


// ---- added by build_tree.py (new options; edit as needed) ----
EXTRA_TEXT = [];


// ---- added by build_tree.py (new options; edit as needed) ----
ROOF_RIBS = 0;
ROOF_RIB_R = 0.5;
ROOF_RIB_SPAN = 0.85;
ROOF_RIB_END_FT = 0;
ROOF_VENTS = [];
VENT_L_IN = 16;
VENT_W_IN = 12;
VENT_H_IN = 6;
VENT_MESH = true;


// ---- added by build_tree.py (new options; edit as needed) ----
UNDERFRAME = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT = [29.75, 34.2, 49.5, 52];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN = 30;
UNDER_EQUIP = [
    ["box", 21.8, 0, 36, 22, 22],
    ["box", 39.6, 0, 100, 50, 27],
    ["tankx", 46.1, 0, 16, 44],
    ["tankx", 47.4, 0, 16, 44],
    ["box", 50.1, 0, 32, 30, 10],
    ["box", 53.7, 0, 28, 20, 16],
    ["box", 57.5, 0, 59, 70, 30]
];


// ---- added by build_tree.py (new options; edit as needed) ----
SKY_DROP_FT = 0;
SKY_SILL_IN = 0;
SKY_SPINE_IN = 0;
SKY_MULLION = 0.18;


// ---- added by build_tree.py (new options; edit as needed) ----
SKY_TOP_PTS = [];
SKY_PANES = [];
SKY_REAR_PANES = [];
SKY_CROWN_PANES = [];


// ---- added by build_tree.py (new options; edit as needed) ----
SKY_BAND = [];
SKY_BAND_COLOR = "#C9CED3";
SKY_MARKER = [];


// ---- added by build_tree.py (new options; edit as needed) ----
SKY_WINS = [];


// ---- added by build_tree.py (new options; edit as needed) ----
ELEC_BOX_X_FT = 0;


// ---- added by build_tree.py (new options; edit as needed) ----
SKY_FLUTES = [];


// ---- added by build_tree.py (new options; edit as needed) ----
STEPWELLS = "auto";


// ---- added by build_tree.py (new options; edit as needed) ----
LETTER_POS_FT = [];


// ---- added by build_tree.py (new options; edit as needed) ----
PLAT_STYLE = "basic";
PLAT_CORNER_IN = 30;
PLAT_END_WINS = [];
PLAT_RAIL_BARS = 7;
PLAT_DRUMHEAD = [];
PLAT_MARKER_IN = 0;
PLAT_SKIRT_IN = 0;

// ---- Coach 4400: RME Oct 1934 pp. 361-363 + builder's photos of 2 Feb 1934 (drawings/01-07) + Progress Coach brochure ----
// CORRECTED 7 Oct 2026: "72 ft 6 in" is the BODY between the end posts; with a 3 ft 9 in vestibule at EACH end the car is
// 80 ft over the end sills (81 ft 8 in over couplers), truck centres 56 ft 6 in = 11 ft 9 in from each end.  The first
// version of this lib (72.5 ft, one vestibule) was wrong.  Window positions measured from the side photo of the
// generator-truck end (truck wheelbase taken as 8 ft): toilet 5.5 ft, smoking room 12.55 and 16.6 ft, main room from
// 24.9 ft at 48 1/2 in pitch (10 windows); the women's lounge end is not in the photo - two windows placed by eye.
// Windows arched top (shape 3: oval at the top, square at the bottom - Tom 10/6, RME Oct 1934, 4448 photos), 29 wide x 32 high, sill 39 in.
// Paint as built (photos): light body, dark letterboard, no window band - same treatment as the 1938 branch cars.
MILW_BAND_Z0_IN = 78.5;   // band of zero height = no window band
MILW_BAND_Z1_IN = 78.5;
MILW_STRIPE_IN  = 0.5;    // letterboard from 79 in
TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Luxury-lounge coaches 4401-4440 (built 1934), drawing p. 143 (IMG_5177): body 79 ft 6 in, truck centres 11 ft 6 in from each end, 10 ft 1 in wide;
// VESTIBULE AT BOTH ENDS (3 ft 6 in each); men's lounge end 15 ft 8 in, passenger compartment 44 ft 5 5/8 in seating 48, women's lounge 12 ft 3 7/16 in.
// Windows are arched-top on the real car (drawn as plain 26 x 25 in openings); 13 in piers, 2 ft 4 1/2 in sash centres in pairs per the drawing.

include <../../../common/mr_common.scad>
