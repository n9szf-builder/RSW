// =====================================================================
//  MR1942_WarBondCoach_lib.scad  -  prototype data: War Bond Coach 477  (1942 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "War Bond Coach 477";
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
    [5.7, 20, 20, 40, -1, 1],
    [10.74, 28, 24, 38, -1],
    [8.1, 20, 20, 40, 1, 1],
    [17.94, 28, 24, 38],
    [21.37, 28, 24, 38],
    [24.8, 28, 24, 38],
    [28.23, 28, 24, 38],
    [31.66, 28, 24, 38],
    [35.09, 28, 24, 38],
    [38.52, 28, 24, 38],
    [41.95, 28, 24, 38],
    [45.38, 28, 24, 38],
    [48.81, 28, 24, 38],
    [52.24, 28, 24, 38],
    [55.67, 28, 24, 38],
    [59.1, 28, 24, 38],
    [66.25, 28, 24, 38, -1],
    [71.07, 28, 24, 38, -1],
    [75.86, 28, 24, 38, -1],
    [65.41, 39, 24, 38, 1],
    [75.63, 39, 24, 38, 1]
];
DOME_WINDOWS = [];
// door: [x_ft, w_in, h_in, sill_in]
DOORS = [
    [1.9, 30, 80, 6]
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
MAGNET_X_FT = [15.9, 40.05, 63.4];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.5],
    ["toilet", 4, 13.7],
    ["bulkhead", 14],
    ["coach", 14.3, 62.6],
    ["bulkhead", 62.83],
    ["lounge", 63.1, 79]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.5, 68.21];

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
LETTERING = "";
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
EXTRA_TEXT = [["Buy War Bonds", 40, 16.5, 15, 2, 1.35, "Brush Script MT:style=Italic", true], ["C M St P & P", 73, 85, 3, 2], ["477", 2.6, 88, 2.5, 2]];


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

// Colours, star rows and lettering positions now follow the colour side elevation in the Shops book p. 118 (IMG_5152):
// deep blue letterboard and skirting, orange-red window band, white sides, gold script; 24 stars centred in each blue band;
// 477 above the vestibule door, C M St P & P at the other end.  At each end the colours fade into orange and maroon (not modelled).
// ---- "Buy War Bonds" coach 477 (Shops book pp. 86-87): repainted 29 Sept 1942 ----
// gray roof, white sides, red window band, blue letterboard and skirting, gold-leaf "Buy War Bonds" on the lower side,
// 48 white stars a side (24 on the letterboard, 24 on the skirting - decals), no road name on the letterboard,
// orange and maroon blended in at each end (paint by hand).  Colours are a best guess from black-and-white photos.
// paint scheme default for this car is MILW: set in the main file / kit file header (build_tree.py paint="MILW")
MILW_ORANGE = "#F7F7F5";   // main colour: white
MILW_MAROON = "#C4362B";   // window band: orange-red
MILW_UPPER_COLOR = "#2E2F7A";   // letterboard + lower band: deep blue
MILW_LOWER_BAND_IN = 12;           // blue skirting along the bottom of the sides, with 24 stars
PAINT_LETTER_LOW = "#E2B100";   // gold lettering
PAINT_END_DOOR = "#F7F7F5";   // end door white on this car (fleet default is sand yellow) - Tom 10/7
MILW_BAND_Z0_IN    = 34;          // red band only just wraps the windows (sill 38, head 62)
MILW_BAND_Z1_IN    = 66;
MILW_STRIPE_IN     = 16;          // white stripe between the red band and the blue letterboard (letterboard from 82 in)
STAR_ROWS = [[87.5, 23, 53, 24, 3.2], [6, 23, 52.5, 24, 3.2]];   // 24 stars on the letterboard, 24 on the skirting
TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Luxury-lounge coaches 454-478 (1942), drawing p. 85 (IMG_5124): body 79 ft 6 in, truck centres 11 ft 6 in and 11 ft 3 1/2 in from the ends;
// vestibule 3 ft 6 in, men / women 10 ft 6 in, passenger compartment 48 ft 10 in, smoking lounge 16 ft 8 in.
// Wide low sash with rounded corners, about 28 x 24 in; porthole in the vestibule door.

include <../../../common/mr_common.scad>
