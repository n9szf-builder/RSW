// =====================================================================
//  MR1948_SkytopParlor_lib.scad  -  prototype data: Skytop Parlor-Lounge  (1948 Twin Cities Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Skytop Parlor-Lounge";
CAR_TRAIN = "1948 Twin Cities Hiawatha";

// ---- body ----
LEN_FT       = 83.6;    // over body (end sheet to end sheet)
WIDTH_FT     = 10;    // over side sheets
SIDE_FT      = 7.77;   // bottom of side sill to eave
ROOF_RISE_FT = 1.89;   // eave to roof peak

// ---- ends ----
END_B        = "skytop";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 6;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 68.23;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
SKY_DROP_FT  = 0;      // skytop: how far the roof crown comes down at the tail
SKY_SILL_IN  = 0;      // skytop: bottom of the solarium glass (0 = auto)
SKY_SPINE_IN = 0;      // skytop: solid strip along the roof centre (0 = none)
SKY_MULLION  = 0.18;   // skytop: mullion width, fraction of the pitch
// skytop nose + glass from a side elevation (empty = simple tail with evenly spaced bays)
SKY_TOP_PTS  = [[70.41, 9.65], [72.04, 9.43], [74.77, 8.99], [77.49, 8.01], [80.22, 6.54], [81.85, 5.07], [82.94, 3.05], [83.6, 2.62]];   // [x_ft, roof-top height ft] down the nose
SKY_PANES    = [];   // side-elevation window polygons [[x_ft, z_in], ...]
SKY_WINS     = [["x", 68.35, 72.9, 38.6, 63.4], ["x", 73.4, 77.45, 38.6, 63.4], ["a", 6, 31, 38.6, 63.4], ["a", 38, 61, 38.6, 63.4], ["a", 68, 112, 38.6, 63.4], ["x", 68.35, 70.6, 75.2, 112], ["x", 71, 73.6, 75.2, 112], ["x", 74, 77.3, 75.2, 100], ["p", 7, 29, 71, 26], ["p", 36, 58, 71, 26], ["p", 65, 112, 71, 26]];   // rounded solarium windows ["x", x0_ft, x1_ft, z0_in, z1_in] / ["a", a0_deg, a1_deg, z0_in, z1_in]
SKY_REAR_PANES  = [];   // [y0_in, y1_in, z0_in, z1_in, from_x_ft]
SKY_CROWN_PANES = [[68.6, 70.6, -18, 18, 97], [71, 73.6, -18, 18, 97], [74, 77.3, -18, 18, 97], [77.8, 79.1, -18, 18, 88]];   // [x0_ft, x1_ft, y0_in, y1_in, z0_in]
SKY_BAND        = [[67.3, 30.1], [90, 30.1], [90, 17], [67.79, 17]];   // stainless flank band, side-elevation polygon [[x_ft, z_in], ...] (preview paint)
SKY_BAND_COLOR  = "#C9CED3";
SKY_FLUTES      = [];   // fluted stainless band [x0_ft, z0_in, ribs, pitch_in, rib_in, depth_mm] (Creek cars)
SKY_MARKER      = [23.5, 13];   // rear marker light [centre z_in, diameter_in] (boss printed on the nose)
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
        [2.21, 26, 26, 38.6, 0, 1],
        [9.88, 27, 27, 38.6, 0, 1],
        [14.68, 45, 26, 38.6, 0, 2],
        [19.65, 31, 26, 38.6, 0, 0],
        [24.12, 31, 26, 38.6, 0, 0],
        [27.58, 31, 26, 38.6, 0, 0],
        [31.04, 31, 26, 38.6, 0, 0],
        [34.5, 31, 26, 38.6, 0, 0],
        [37.96, 31, 26, 38.6, 0, 0],
        [41.42, 31, 26, 38.6, 0, 0],
        [44.88, 31, 26, 38.6, 0, 0],
        [48.33, 31, 26, 38.6, 0, 0],
        [51.79, 31, 26, 38.6, 0, 0],
        [55.25, 31, 26, 38.6, 0, 0],
        [58.71, 31, 26, 38.6, 0, 0],
        [62.75, 45, 26, 38.6, 0, 2]];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [];
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [[2.21, 30, 80, 4, 0]];
// vestibule step boxes: "auto" (under every vestibule side door) | [] | [[x_ft, door_w_in, side], ...]
STEPWELLS = "auto";
// roof housing (A/C, ice activator): [x0_ft, x1_ft, w_in, h_in]
ROOF_HOUSINGS = [[4.47, 8.39, 40, 5]];

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
LETTER_X0_FT = 15.37;   // centre of first letter
LETTER_X1_FT = 48.88;   // centre of last letter
LETTER_Z_IN  = 74;     // baseline above the side-sill bottom
LETTER_H_IN  = 8;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT   = [["CEDAR RAPIDS", 34.99, 16.4, 5, 0], ["186", 6.1, 74, 3, 0], ["Hiawatha", 79.73, 19, 9, 0, 1, "Brush Script MT:style=Italic", true]];

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
MAGNET_X_FT = [5, 39.69, 66.23];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 4.5],
    ["toilet", 4.7, 12],
    ["bulkhead", 12.2],
    ["lounge", 12.4, 17.4],
    ["bulkhead", 17.6],
    ["parlor", 17.8, 61],
    ["bulkhead", 61.2],
    ["toilet", 61.4, 66.8],
    ["bulkhead", 67],
    ["lounge", 67.6, 77]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT  = [31.44, 35.93, 51.4, 53.9];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 23.35, 0, 36, 22, 22],
    ["box", 41.37, 0, 100, 50, 27],
    ["tankx", 47.86, 0, 16, 44],
    ["tankx", 49.16, 0, 16, 44],
    ["box", 51.95, 0, 32, 30, 10],
    ["box", 55.55, 0, 28, 20, 16],
    ["box", 59.34, 0, 59, 70, 30]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 7;
TRUCK_CENTERS_FT   = [11.67, 71.17];
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
