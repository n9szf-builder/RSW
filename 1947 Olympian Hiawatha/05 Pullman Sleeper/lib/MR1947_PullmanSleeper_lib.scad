// =====================================================================
//  MR1947_PullmanSleeper_lib.scad  -  prototype data: Pullman Sleeper  (1947 Olympian Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Pullman Sleeper";
CAR_TRAIN = "1947 Olympian Hiawatha";

// ---- body ----
LEN_FT       = 85;    // over body (end sheet to end sheet)
WIDTH_FT     = 10;    // over side sheets
SIDE_FT      = 7.75;   // bottom of side sill to eave
ROOF_RISE_FT = 1.85;   // eave to roof peak

// ---- ends ----
END_B        = "flat";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
SKY_START_FT = 0;      // skytop glazing start (0 = start of tail)
SKY_PITCH_IN = 30;     // skytop mullion spacing
SKY_DROP_FT  = 0;      // skytop: how far the roof crown comes down at the tail
SKY_SILL_IN  = 0;      // skytop: bottom of the solarium glass (0 = auto)
SKY_SPINE_IN = 0;      // skytop: solid strip along the roof centre (0 = none)
SKY_MULLION  = 0.18;   // skytop: mullion width, fraction of the pitch
// skytop nose + glass from a side elevation (empty = simple tail with evenly spaced bays)
SKY_TOP_PTS  = [];   // [x_ft, roof-top height ft] down the nose
SKY_PANES    = [];   // side-elevation window polygons [[x_ft, z_in], ...]
SKY_WINS     = [];   // rounded solarium windows ["x", x0_ft, x1_ft, z0_in, z1_in] / ["a", a0_deg, a1_deg, z0_in, z1_in]
SKY_REAR_PANES  = [];   // [y0_in, y1_in, z0_in, z1_in, from_x_ft]
SKY_CROWN_PANES = [];   // [x0_ft, x1_ft, y0_in, y1_in, z0_in]
SKY_BAND        = [];   // stainless flank band, side-elevation polygon [[x_ft, z_in], ...] (preview paint)
SKY_BAND_COLOR  = "#C9CED3";
SKY_FLUTES      = [];   // fluted stainless band [x0_ft, z0_in, ribs, pitch_in, rib_in, depth_mm] (Creek cars)
SKY_MARKER      = [];   // rear marker light [centre z_in, diameter_in] (boss printed on the nose)
END_DOORS    = true;

// ---- end doors + diaphragms ----
END_DOOR_STYLE   = "closed";   // "closed" (recessed door) | "open" (doorway cut through)
END_DOOR_W_IN    = 30;
END_DOOR_H_IN    = 78;
END_DOOR_SILL_IN = 6;
END_DOOR_RECESS  = 0.8;    // how deep the closed door sits, model mm
END_DOOR_WINDOW  = true;    // window in the upper door
END_DOOR_WINDOW_SHAPE = "rect";   // "rect" | "porthole"
END_DOOR_PORT_IN   = 20;     // porthole diameter
END_DOOR_PORT_Z_IN = 57;     // porthole centre above the side-sill bottom
END_DIAPHRAGM    = true;    // raised diaphragm frame around the door
DIAPHRAGM_W_IN   = 5;      // frame width
DIAPHRAGM_D      = 2.5;    // how far it stands out, model mm
DIAPHRAGM_TOP_IN = 88;     // top of the frame above the side-sill bottom

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in, side, shape]  (x from A end, sill above side-sill bottom)
//   side: 0 both, -1 only -Y side, 1 only +Y side;  shape: 0 rectangle, 1 round porthole (w = diameter), 2 oval
WINDOWS = [
        [8.49, 47, 30, 37, -1, 2],
        [13.8, 46, 30, 37, -1, 2],
        [21.71, 47, 27, 35, -1, 0],
        [27.02, 47, 27, 35, -1, 0],
        [34.79, 38, 26, 66, 0, 0],
        [41.22, 38, 28, 40, 0, 0],
        [46.35, 37, 26, 66, 0, 0],
        [52.69, 37, 27, 39, 0, 0],
        [57.9, 44, 27, 39, 0, 0],
        [64.4, 44, 27, 39, 0, 0],
        [70.85, 44, 27, 39, 0, 0],
        [8.49, 22, 24, 44, 1, 0],
        [13.8, 22, 24, 44, 1, 0],
        [21.71, 22, 24, 44, 1, 0],
        [27.02, 22, 24, 44, 1, 0],
        [79.41, 27, 27, 41, 0, 1],
        [82.87, 21, 34, 55, 0, 0]];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [];
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [[82.9, 30, 80, 4, 0]];
// vestibule step boxes: "auto" (under every vestibule side door) | [] | [[x_ft, door_w_in, side], ...]
STEPWELLS = "auto";
// roof housing (A/C, ice activator): [x0_ft, x1_ft, w_in, h_in]
ROOF_HOUSINGS = [];

// ---- end sheet ribs ----  horizontal ribs across the flat ends (0 = none)
END_RIBS          = 0;
END_RIB_Z0_IN     = 3;      // lowest rib above the side-sill bottom
END_RIB_PITCH_IN  = 10.7;   // rib spacing
END_RIB_H_IN      = 1.5;    // rib height
END_RIB_D         = 0.6;    // how far the ribs stand out, model mm
END_RIB_MARGIN_IN = 3;      // ribs stop this far in from the end edges
END_RIB_STYLE     = "bead";   // "band" (flat bands, rounded edges) | "bead" (half-round)
END_POSTS         = false;    // collision posts either side of the door, full height
END_POST_W_IN     = 6.6;
END_POST_GAP_IN   = 42;     // clear space between the posts
END_POST_D        = 1;    // model mm
END_FRAME         = false;    // raised door-frame plate between the posts
END_FRAME_HEADER_IN = 7;    // plate top above the door opening
END_FRAME_D       = 0.8;    // model mm
END_SILL_H_IN     = 0;      // raised strip across the bottom of the end (0 = none)
END_SILL_D        = 0.8;

// ---- roof detail ----
ROOF_RIBS       = 0;      // raised ribs running along the roof (0 = none)
ROOF_RIB_R      = 0.5;    // rib radius, model mm
ROOF_RIB_SPAN   = 0.85;   // ribs spread over this fraction of the half-width
ROOF_RIB_END_FT = 0;    // cross seam this far from each end (0 = none)
// roof vents with a screened face: [x_ft, y_in (offset from centre line), face (+1 / -1 = side the screen faces)]
ROOF_VENTS = [];
VENT_L_IN = 16;
VENT_W_IN = 12;
VENT_H_IN = 6;
VENT_MESH = true;    // crosshatch screen on the vent face (fine detail - resin prints it best)

// ---- lettering (preview) ----
LETTERING    = "THE MILWAUKEE ROAD";
LETTER_POS_FT = [15.43, 18.55, 21.46, 26.15, 28.9, 31.81, 38.07, 40.56, 43.41, 49.16, 52.1, 54.87, 59.39, 61.51, 63.59, 65.6];   // optional: one x (ft) per letter, -Y side (letterboard broken by windows)
LETTER_X0_FT = 15.43;   // centre of first letter
LETTER_X1_FT = 65.6;   // centre of last letter
LETTER_Z_IN  = 73;     // baseline above the side-sill bottom
LETTER_H_IN  = 7.5;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT   = [["JEFFERSON RIVER", 41.2, 23, 5, 0], ["24 PULLMAN", 2.9, 84, 2.5, -1], ["PULLMAN 24", 78.9, 84, 3, -1], ["24 PULLMAN", 79.2, 84, 3, 1], ["PULLMAN 24", 3.2, 84, 2.5, 1]];

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
MAGNET_X_FT = [5, 43.5, 81.25];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.5],
    ["rooms", 4, 30.5, 6.5],
    ["bulkhead", 31],
    ["rooms", 31.5, 49.5, 4.5],
    ["rooms", 50, 76.5, 6.5],
    ["toilet", 77, 80.8],
    ["bulkhead", 81.2]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT  = [32.52, 37.01, 52.48, 54.98];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 24.43, 0, 36, 22, 22],
    ["box", 42.45, 0, 100, 50, 27],
    ["tankx", 48.94, 0, 16, 44],
    ["tankx", 50.24, 0, 16, 44],
    ["box", 53.03, 0, 32, 30, 10],
    ["box", 56.63, 0, 28, 20, 16],
    ["box", 60.42, 0, 59, 70, 30]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8.5;
TRUCK_CENTERS_FT   = [12.75, 72.25];
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
PLAT_STYLE = "basic";
PLAT_CORNER_IN = 30;
PLAT_END_WINS = [];
PLAT_RAIL_BARS = 7;
PLAT_DRUMHEAD = [];
PLAT_MARKER_IN = 0;
PLAT_SKIRT_IN = 0;

include <../../../common/mr_common.scad>
