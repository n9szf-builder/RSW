// =====================================================================
//  MR1947_SkytopSleeper_lib.scad  -  prototype data: Skytop Sleeper-Lounge  (1947 Olympian Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Skytop Sleeper-Lounge";
CAR_TRAIN = "1947 Olympian Hiawatha";

// ---- body ----
LEN_FT       = 83.8;    // over body (end sheet to end sheet)
WIDTH_FT     = 10;    // over side sheets
SIDE_FT      = 7.77;   // bottom of side sill to eave
ROOF_RISE_FT = 1.89;   // eave to roof peak

// ---- ends ----
END_B        = "skytop";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 6;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 59.5;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
SKY_DROP_FT  = 0;      // skytop: how far the roof crown comes down at the tail
SKY_SILL_IN  = 0;      // skytop: bottom of the solarium glass (0 = auto)
SKY_SPINE_IN = 0;      // skytop: solid strip along the roof centre (0 = none)
SKY_MULLION  = 0.18;   // skytop: mullion width, fraction of the pitch
// skytop nose + glass from a side elevation (empty = simple tail with evenly spaced bays)
SKY_TOP_PTS  = [[70.61, 9.65], [72.24, 9.43], [74.97, 8.99], [77.69, 8.01], [80.42, 6.54], [82.05, 5.07], [83.14, 3.05], [83.8, 2.62]];   // [x_ft, roof-top height ft] down the nose
SKY_PANES    = [];   // side-elevation window polygons [[x_ft, z_in], ...]
SKY_WINS     = [["x", 59.9, 64, 38, 66], ["x", 64.7, 68.8, 38, 66], ["x", 69.5, 73.6, 38, 66], ["x", 74.3, 77.6, 38, 66], ["a", 6, 31, 38, 66], ["a", 38, 61, 38, 66], ["a", 68, 112, 38, 66], ["x", 59.9, 62.2, 76, 112], ["x", 62.7, 65, 76, 112], ["x", 65.5, 68.6, 76, 112], ["x", 69.1, 72.4, 76, 112], ["x", 72.9, 75.6, 76, 104], ["x", 76.1, 77.5, 76, 96], ["p", 7, 29, 72, 26], ["p", 36, 58, 72, 26], ["p", 65, 112, 72, 26]];   // rounded solarium windows ["x", x0_ft, x1_ft, z0_in, z1_in] / ["a", a0_deg, a1_deg, z0_in, z1_in]
SKY_REAR_PANES  = [];   // [y0_in, y1_in, z0_in, z1_in, from_x_ft]
SKY_CROWN_PANES = [[59.9, 62.2, -18, 18, 97], [62.7, 65, -18, 18, 97], [65.5, 68.6, -18, 18, 97], [69.1, 72.4, -18, 18, 97], [72.9, 75.6, -18, 18, 97], [76.1, 77.4, -18, 18, 90]];   // [x0_ft, x1_ft, y0_in, y1_in, z0_in]
SKY_BAND        = [[59, 19], [90, 19], [90, 34.5], [59, 34.5]];   // stainless flank band, side-elevation polygon [[x_ft, z_in], ...] (preview paint)
SKY_BAND_COLOR  = "#C9CED3";
SKY_FLUTES      = [59.2, 19.5, 5, 3, 1.5, 0.6];   // fluted stainless band [x0_ft, z0_in, ribs, pitch_in, rib_in, depth_mm] (Creek cars)
SKY_MARKER      = [27, 13];   // rear marker light [centre z_in, diameter_in] (boss printed on the nose)
END_DOORS    = true;

// ---- end doors + diaphragms ----
END_DOOR_STYLE   = "closed";   // "closed" (recessed door) | "open" (doorway cut through)
END_DOOR_W_IN    = 26;
END_DOOR_H_IN    = 75;
END_DOOR_SILL_IN = 8;
END_DOOR_RECESS  = 0.8;    // how deep the closed door sits, model mm
END_DOOR_WINDOW  = true;    // window in the upper door
END_DOOR_WINDOW_SHAPE = "porthole";   // "rect" | "porthole"
END_DOOR_PORT_IN   = 20;     // porthole diameter
END_DOOR_PORT_Z_IN = 57;     // porthole centre above the side-sill bottom
END_DIAPHRAGM    = true;    // raised diaphragm frame around the door
DIAPHRAGM_W_IN   = 5;      // frame width
DIAPHRAGM_D      = 2.5;    // how far it stands out, model mm
DIAPHRAGM_TOP_IN = 88;     // top of the frame above the side-sill bottom

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in, side, shape]  (x from A end, sill above side-sill bottom)
//   side: 0 both, -1 only -Y side, 1 only +Y side;  shape: 0 rectangle, 1 round porthole (w = diameter), 2 oval
WINDOWS = [
        [2.15, 24, 24, 42.6, 0, 1],
        [5.78, 26, 26, 40, -1, 1],
        [7.68, 26, 26, 40, 1, 1],
        [15.67, 44, 27, 37, 1, 0],
        [20.82, 44, 27, 37, 1, 0],
        [28.58, 44, 27, 37, 1, 0],
        [33.68, 44, 27, 37, 1, 0],
        [39.51, 44, 27, 37, 1, 0],
        [44.6, 44, 27, 37, 1, 0],
        [52.32, 44, 27, 37, 1, 0],
        [57.49, 44, 27, 37, 1, 0],
        [15.56, 44, 27, 37, -1, 0],
        [26.05, 44, 27, 37, -1, 0],
        [36.51, 44, 27, 37, -1, 0],
        [47.03, 44, 27, 37, -1, 0],
        [57.38, 44, 27, 37, -1, 0]];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [];
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [[2.15, 30, 80, 4, 0]];
// roof housing (A/C, ice activator): [x0_ft, x1_ft, w_in, h_in]
ROOF_HOUSINGS = [[2.34, 6.43, 40, 5]];

// ---- end sheet ribs ----  horizontal ribs across the flat ends (0 = none)
END_RIBS          = 10;
END_RIB_Z0_IN     = 4.3;      // lowest rib above the side-sill bottom
END_RIB_PITCH_IN  = 10.6;   // rib spacing
END_RIB_H_IN      = 2;    // rib height
END_RIB_D         = 0.9;    // how far the ribs stand out, model mm
END_RIB_MARGIN_IN = 2.5;      // ribs stop this far in from the end edges
END_RIB_STYLE     = "bead";   // "band" (flat bands, rounded edges) | "bead" (half-round)
END_POSTS         = true;    // collision posts either side of the door, full height
END_POST_W_IN     = 6.6;
END_POST_GAP_IN   = 42;     // clear space between the posts
END_POST_D        = 1;    // model mm
END_FRAME         = true;    // raised door-frame plate between the posts
END_FRAME_HEADER_IN = 7;    // plate top above the door opening
END_FRAME_D       = 0.8;    // model mm
END_SILL_H_IN     = 4;      // raised strip across the bottom of the end (0 = none)
END_SILL_D        = 0.8;

// ---- roof detail ----
ROOF_RIBS       = 13;      // raised ribs running along the roof (0 = none)
ROOF_RIB_R      = 0.5;    // rib radius, model mm
ROOF_RIB_SPAN   = 0.85;   // ribs spread over this fraction of the half-width
ROOF_RIB_END_FT = 3.3;    // cross seam this far from each end (0 = none)
// roof vents with a screened face: [x_ft, y_in (offset from centre line), face (+1 / -1 = side the screen faces)]
ROOF_VENTS = [];
VENT_L_IN = 16;
VENT_W_IN = 12;
VENT_H_IN = 6;
VENT_MESH = true;    // crosshatch screen on the vent face (fine detail - resin prints it best)

// ---- lettering (preview) ----
LETTERING    = "THE MILWAUKEE ROAD";
LETTER_X0_FT = 16;   // centre of first letter
LETTER_X1_FT = 56;   // centre of last letter
LETTER_Z_IN  = 74;     // baseline above the side-sill bottom
LETTER_H_IN  = 8;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT   = [["ALDER CREEK", 36, 16.4, 5, 0], ["12", 5.07, 74, 3, 0], ["Olympian Hiawatha", 68.5, 9, 7, 0, 1, "Brush Script MT:style=Italic", true]];

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
MAGNET_X_FT = [10, 42, 54.9];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.9],
    ["toilet", 4.1, 10.4],
    ["kitchen", 10.6, 12.7],
    ["rooms", 12.9, 58.9, 5.75],
    ["bulkhead", 59.2],
    ["lounge", 59.5, 75]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT  = [31.65, 36.14, 51.62, 54.12];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 23.56, 0, 36, 22, 22],
    ["box", 41.59, 0, 100, 50, 27],
    ["tankx", 48.08, 0, 16, 44],
    ["tankx", 49.37, 0, 16, 44],
    ["box", 52.17, 0, 32, 30, 10],
    ["box", 55.76, 0, 28, 20, 16],
    ["box", 59.56, 0, 59, 70, 30]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;
TRUCK_CENTERS_FT   = [11.88, 71.39];
ELEC_BOX_X_FT      = 0;   // lighting-pack box centre (0 = midway between the trucks)

// ---- printing ----
BODY_JOINTS_FT = [];   // [] = automatic from bed size; or e.g. [26.5, 52.5] to land on window piers

// ---- colours (preview only) ----  fleet paint scheme: PAINT_SCHEME in common/mr_config.scad
BODY_COLOR     = PAINT_BODY;
BODY_COLOR_ALT = PAINT_BODY;
ROOF_COLOR     = PAINT_ROOF;
FLOOR_COLOR    = "#4A4A4A";
INTERIOR_COLOR = "#7A3B2E";


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
