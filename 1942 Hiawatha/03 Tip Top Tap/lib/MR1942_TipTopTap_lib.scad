// =====================================================================
//  MR1942_TipTopTap_lib.scad  -  prototype data: Tip Top Tap  (1942 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Tip Top Tap";
CAR_TRAIN = "1942 Hiawatha";

// ---- body ----
LEN_FT = 79.5;    // over body (end sheet to end sheet)
WIDTH_FT = 10.06;    // over side sheets
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
    [9.27, 38, 24, 38, -1],
    [15.63, 38, 24, 38, -1],
    [21.93, 38, 24, 38, -1],
    [28.13, 38, 24, 38, -1],
    [34.26, 38, 24, 38, -1],
    [49.01, 38, 24, 38, -1],
    [55.17, 38, 24, 38, -1],
    [61.36, 38, 24, 38, -1],
    [67.58, 38, 24, 38, -1],
    [73.79, 38, 24, 38, -1],
    [1.5, 20, 20, 40, 1, 1],
    [5.33, 26, 24, 38, 1],
    [14.52, 38, 24, 38, 1],
    [33.2, 38, 24, 38, 1],
    [48.12, 38, 24, 38, 1],
    [67.04, 38, 24, 38, 1],
    [77, 20, 20, 40, 1, 1]
];
DOME_WINDOWS = [];
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [
    [41.65, 30, 80, 6]
];

// ---- side treatment ----
FLUTES         = "rib";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 3;
FLUTE_Z0_IN    = 10;
FLUTE_PITCH_IN = 6;
FLUTE_H_IN     = 2;
FLUTE_D        = 0.6;   // model mm
REAR_FINS      = false;

// ---- dome ----
DOME          = false;
DOME_START_FT = 0;
DOME_END_FT   = 0;
DOME_RISE_FT  = 0;
DOME_SLOPE_FT = 6;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [17.6, 39.75, 63.6];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["toilet", 0.5, 7.6],
    ["bulkhead", 7.83],
    ["lounge", 8.1, 36.6],
    ["bar", 36.8, 46.1],
    ["lounge", 46.3, 74.9],
    ["bulkhead", 75.1],
    ["toilet", 75.4, 79]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.29, 68.21];

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
LETTER_X0_FT = 22.1;
LETTER_X1_FT = 55.3;
LETTER_Z_IN = 73;
LETTER_H_IN = 7.5;


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
CROSSBEARERS_FT = [29.6, 34.06, 49.4, 51.87];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN = 30;
UNDER_EQUIP = [
    ["box", 21.58, 0, 36, 22, 22],
    ["box", 39.45, 0, 100, 50, 27],
    ["tankx", 45.89, 0, 16, 44],
    ["tankx", 47.17, 0, 16, 44],
    ["box", 49.94, 0, 32, 30, 10],
    ["box", 53.51, 0, 28, 20, 16],
    ["box", 57.27, 0, 59, 70, 30]
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

TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Buffet-Tip Top Tap 160-161 (1942), drawing p. 89 (IMG_5128): body 79 ft 6 in, no vestibule; women / lockers 7 ft 10 in, passenger compartment 28 ft 11 7/8 in seating 26,
// buffet section 9 ft 4 in, second compartment 28 ft 11 7/8 in seating 26, men 4 ft 4 1/4 in. Ten 38 in windows on one side, only five on the other.
// Service door with porthole at the buffet (one side only on the real car).

include <../../../common/mr_common.scad>
