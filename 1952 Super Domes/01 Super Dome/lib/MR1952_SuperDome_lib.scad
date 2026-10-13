// =====================================================================
//  MR1952_SuperDome_lib.scad  -  prototype data: Super Dome  (1952 Super Domes)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Super Dome";
CAR_TRAIN = "1952 Super Domes";
// Super Dome layout from the Railway Classics HO diagram (drawings/Super Dome diagram - Railway Classics HO.jpg), 30 Sep 2026


// ---- body ----
LEN_FT       = 82.7;    // over body (end sheet to end sheet)
WIDTH_FT     = 10;    // over side sheets
SIDE_FT      = 8.2;   // bottom of side sill to eave
ROOF_RISE_FT = 2.0;   // eave to roof peak

// ---- ends ----
END_B        = "flat";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 0;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
END_DOORS    = true;

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in]  (x from A end, sill above side-sill bottom)
WINDOWS = [[26.73, 43.6, 27, 26.3], [31.2, 33.5, 27, 26.3], [35.73, 43, 27, 26.3], [40.63, 44, 27, 26.3], [45.61, 43.6, 27, 26.3]];
DOME_WINDOWS = mr_window_row(7.38, 3.406, 21, 36.5, 44, 101.8);
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [];

// ---- side treatment ----
FLUTES         = "none";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 0;
FLUTE_Z0_IN    = 8;
FLUTE_PITCH_IN = 3;
FLUTE_H_IN     = 1.5;
FLUTE_D        = 0.6;   // model mm
REAR_FINS      = false;

// ---- dome ----
DOME          = true;
DOME_START_FT = 0.8;
DOME_END_FT   = 81.9;
DOME_RISE_FT  = 2.1;
DOME_SLOPE_FT = 4.2;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [5, 42.25, 80];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 4.5],
    ["lounge", 6, 79],
    ["domedeck", 10, 75],
    ["bulkhead", 80.5]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 3;
TRUCK_WHEELBASE_FT = 11;
TRUCK_CENTERS_FT   = [12.1, 70.7];

// ---- printing ----
BODY_JOINTS_FT = [];   // [] = automatic from bed size; or e.g. [26.5, 52.5] to land on window piers

// ---- colours (preview only) ----  fleet paint scheme: PAINT_SCHEME in common/mr_config.scad
BODY_COLOR     = PAINT_BODY;
BODY_COLOR_ALT = PAINT_BODY;
ROOF_COLOR     = PAINT_ROOF;
FLOOR_COLOR    = "#4A4A4A";
INTERIOR_COLOR = "#7A3B2E";


// ---- added by build_tree.py (new options; edit as needed) ----
DOOR_PANELS = [[52.7, 23.5, 49, 8.6, 0], [65.0, 78.9, 51, 8.6, 0], [70.4, 41, 51, 8.6, 0]];
ROOF_HOUSINGS = [];
LETTERING = "THE MILWAUKEE ROAD";
LETTER_X0_FT = 23.8;
LETTER_X1_FT = 59.5;
LETTER_Z_IN = 78;
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
EXTRA_TEXT = [["SUPER DOME", 41.2, 16, 4, 0], ["55", 2.2, 78, 3, 0], ["55", 80.4, 78, 3, 0]];


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
CROSSBEARERS_FT = [31.59, 36.5, 53.41, 56.13];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN = 30;
UNDER_EQUIP = [
    ["box", 22.76, 0, 36, 22, 22],
    ["box", 42.45, 0, 100, 50, 27],
    ["tankx", 49.53, 0, 16, 44],
    ["tankx", 50.95, 0, 16, 44],
    ["box", 54.01, 0, 32, 30, 10],
    ["box", 57.93, 0, 28, 20, 16],
    ["box", 62.08, 0, 59, 70, 30]
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

include <../../../common/mr_common.scad>
