// =====================================================================
//  MR1939_Coach_lib.scad  -  prototype data: Coach  (1939 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Coach";
CAR_TRAIN = "1939 Hiawatha";

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
    [1.9, 20, 20, 40, 0, 1],   // porthole in each vestibule side door - shops book p. 55 drawing and p. 54 photo of coach 451 (added 7 Oct 2026)
    [5.5, 24, 28, 36, -1],
    [9.95, 24, 28, 36, -1],
    [6.77, 24, 16, 48, 1],
    [13.47, 24, 16, 48, 1],
    [19.77, 24, 28, 36],
    [23.2, 24, 28, 36],
    [26.63, 24, 28, 36],
    [30.06, 24, 28, 36],
    [33.49, 24, 28, 36],
    [36.92, 24, 28, 36],
    [40.35, 24, 28, 36],
    [43.78, 24, 28, 36],
    [47.21, 24, 28, 36],
    [50.64, 24, 28, 36],
    [54.07, 24, 28, 36],
    [57.5, 24, 28, 36],
    [60.93, 24, 28, 36],
    [66.83, 24, 16, 48, -1],
    [73.55, 24, 16, 48, -1],
    [78.1, 20, 20, 40, -1, 1],
    [65.19, 24, 28, 36, 1],
    [68.79, 24, 28, 36, 1],
    [72.41, 24, 28, 36, 1],
    [77.44, 20, 20, 40, 1, 1]
];
DOME_WINDOWS = [];
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [
    [1.9, 30, 80, 6]
];

// ---- side treatment ----
FLUTES         = "rib";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 7;
FLUTE_Z0_IN    = 9;
FLUTE_PITCH_IN = 11.3;
FLUTE_H_IN     = 2;
FLUTE_D        = 0.6;   // model mm
FLUTE_ROUND    = true;  // Tom 7 Oct 2026: the 1938 ribs are rounded (half-round), not square-edged
REAR_FINS      = false;

// ---- dome ----
DOME          = false;
DOME_START_FT = 0;
DOME_END_FT   = 0;
DOME_RISE_FT  = 0;
DOME_SLOPE_FT = 6;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [15.9, 38.75, 63.55];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.5],
    ["toilet", 4, 15.2],
    ["bulkhead", 15.58],
    ["coach", 15.8, 64],
    ["bulkhead", 64.25],
    ["lounge", 64.5, 74],
    ["toilet", 74.5, 79]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.28, 68.22];

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


// ---- RME March 1939 'Milwaukee Builds More Welded Passenger Cars' (added 10/5) ----
// Sides: seven corrugations (FLUTE_*: 9 in + k x 11.3 in) - five full length, two in the window band cut by the windows.
// Paint (MILW): maroon window band between the ribs below the sills and above the window heads, yellow stripe, maroon letterboard.
MILW_BAND_Z0_IN = 31.6;
MILW_BAND_Z1_IN = 67.5;
MILW_STRIPE_IN  = 9.3;
UNDER_SHROUD_IN = [76, 26];   // equipment shrouded from bolster to bolster

TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Luxury-lounge coaches 437-452, drawing p. 55 (IMG_5092): body 79 ft 6 in, truck centres 11 ft 3 3/8 in from each end,
// vestibule 3 ft 6 in, women's lounge 12 ft 1 in, passenger compartment 48 ft 8 in seating 56, men's lounge 15 ft 3 in.
// Window positions measured off the photographed drawing (+/- 6 in); 24 x 28 in sash, lounge windows differ side to side.

include <../../../common/mr_common.scad>
