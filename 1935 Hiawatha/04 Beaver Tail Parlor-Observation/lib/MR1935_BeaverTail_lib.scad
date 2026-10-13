// =====================================================================
//  MR1935_BeaverTail_lib.scad  -  prototype data: Beaver Tail Parlor-Observation  (1935 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Beaver Tail Parlor-Observation";
CAR_TRAIN = "1935 Hiawatha";

// ---- body ----
LEN_FT = 78.36;    // over body (end sheet to end sheet)
WIDTH_FT = 10.08;    // over side sheets
SIDE_FT      = 7.75;   // bottom of side sill to eave
ROOF_RISE_FT = 1.85;   // eave to roof peak

// ---- ends ----
END_B        = "round";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 0;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
END_DOORS    = true;

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in]  (x from A end, sill above side-sill bottom)
WINDOWS = [
    [5.4, 26, 25, 38, -1, 3],
    [12, 26, 25, 38, -1, 3],
    [15.5, 26, 25, 38, -1, 3],
    [20.5, 26, 25, 38, -1, 3],
    [26, 26, 25, 38, -1, 3],
    [8.8, 26, 25, 38, 1, 3],
    [15.4, 26, 25, 38, 1, 3],
    [22.5, 26, 25, 38, 1, 3],
    [32.9, 26, 25, 38, 0, 3],
    [36.29, 26, 25, 38, 0, 3],
    [39.68, 26, 25, 38, 0, 3],
    [43.07, 26, 25, 38, 0, 3],
    [46.46, 26, 25, 38, 0, 3],
    [49.85, 26, 25, 38, 0, 3],
    [53.24, 26, 25, 38, 0, 3],
    [56.63, 26, 25, 38, 0, 3],
    [60.02, 26, 25, 38, 0, 3],
    [66.7, 26, 25, 38, 0, 3],
    [70.1, 26, 25, 38, 0, 3]
];
DOME_WINDOWS = [];
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [
    [1.75, 30, 80, 6]
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
MAGNET_X_FT = [16.97, 38.23, 62.69];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.5],
    ["lounge", 7.3, 19],
    ["bulkhead", 19.1],
    ["toilet", 19.3, 29.3],
    ["bulkhead", 29.5],
    ["parlor", 29.8, 70],
    ["lounge", 70.3, 77]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.5, 66.86];

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
// Beaver-Tail parlor-observations Nokomis, Wenonah (built 1934), drawing p. 130 (IMG_5164): 78 ft 4 3/8 in, truck centres 11 ft 6 in from each end;
// vestibule 3 ft 6 in, men's lounge 11 ft 9 1/4 in, women's lounge 7 ft 5 13/16 in, passenger compartment 46 ft 5 15/16 in seating 24 running into the tail.
// The page was photographed at an angle, so window positions here are read off by eye (+/- 1 ft) - re-photograph flat to tighten. Arched-top windows drawn plain.

include <../../../common/mr_common.scad>
