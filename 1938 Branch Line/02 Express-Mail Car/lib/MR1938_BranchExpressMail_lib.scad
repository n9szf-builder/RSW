// =====================================================================
//  MR1938_BranchExpressMail_lib.scad  -  prototype data: Branchline Express-Mail Car  (1938 Branch Line)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Branchline Express-Mail Car";
CAR_TRAIN = "1938 Branch Line";

// ---- body ----
LEN_FT = 66.23;    // over body (end sheet to end sheet)
WIDTH_FT = 10.08;    // over side sheets
SIDE_FT      = 7.75;   // bottom of side sill to eave
ROOF_RISE_FT = 1.85;   // eave to roof peak

// ---- ends ----
END_B        = "platform";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT = 3.74;      // open platform depth beyond the body (END_B = "platform")
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
        [43.90, 24, 27, 39, 0, 0],
        [47.40, 24, 27, 39, 0, 0],
        [50.90, 24, 27, 39, 0, 0],
        [54.40, 24, 27, 39, 0, 0],
        [57.80, 24, 27, 39, 0, 0],
        [61.20, 24, 27, 39, 0, 0],
        [23.16, 9, 27, 48, 0, 0],
        [24.12, 9, 27, 48, 0, 0],
        [25.08, 9, 27, 48, 0, 0],
        [26.04, 9, 27, 48, 0, 0],
        [64.3, 18, 22, 44, 1, 0],
        [9.0, 30, 24, 44, 0, 0],
        [3.0, 16, 22, 50, 0, 0]];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [];
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [[3.0, 30, 78, 4, 0], [24.6, 69, 82, 3, 0]];
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
LETTER_X0_FT = 19;   // centre of first letter
LETTER_X1_FT = 50;   // centre of last letter
LETTER_Z_IN = 78;     // baseline above the side-sill bottom
LETTER_H_IN = 7;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT = [["U.S. MAIL", 10.5, 30, 4, 2], ["RAILWAY POST OFFICE", 10.5, 23, 3.5, 2], ["RAILWAY EXPRESS", 34.5, 21, 5, 2], ["AGENCY", 34.5, 9.5, 5, 2], ["2756", 47.4, 12, 6, 2]];

// ---- side treatment ----
FLUTES = "rib";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT = 7;
FLUTE_Z0_IN = 5.5;
FLUTE_PITCH_IN = 10.8;
FLUTE_H_IN = 2;
FLUTE_D        = 0.7;   // model mm
REAR_FINS      = false;

// ---- dome ----
DOME          = false;
DOME_START_FT = 0;
DOME_END_FT   = 0;
DOME_RISE_FT  = 0;
DOME_SLOPE_FT = 6;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [5.5, 33, 62.9];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["rpo", 0.5, 15.4],
    ["bulkhead", 15.7],
    ["baggage", 16.2, 41.9],
    ["bulkhead", 42.26],
    ["coach", 42.7, 62.4],
    ["toilet", 62.6, 65.8]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT = [17, 25, 42, 50];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 22.0, 0, 36, 22, 22],
    ["box", 31.0, 0, 60, 40, 20],
    ["tankx", 38.0, 0, 16, 44],
    ["box", 45.0, 0, 32, 30, 10]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;
TRUCK_CENTERS_FT = [8.07, 61.28];
ELEC_BOX_X_FT = 37.5;   // lighting-pack box centre (0 = midway between the trucks)

// ---- printing ----
BODY_JOINTS_FT = [];   // [] = automatic from bed size; or e.g. [26.5, 52.5] to land on window piers

// ---- colours (preview only) ----  fleet paint scheme: PAINT_SCHEME in common/mr_config.scad
BODY_COLOR     = PAINT_BODY;
BODY_COLOR_ALT = PAINT_BODY;
ROOF_COLOR     = PAINT_SCHEME == "MILW" ? "#44494B" : PAINT_ROOF;    // dark gray-black roof as 2713 today (as built 1938: oxide brown, about #6B4334)
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

// ---- Shops book (Hiawatha - Nothing Faster on Rails, 2014) p. 71 (IMG_5108): mail 15 ft 6 in, baggage 26 ft 7 in with 5 ft 9 in door, passenger 23 ft 9 1/2 in (24 seats), platform 3 ft 8 7/8 in at the passenger end only, truck centres 53 ft 2 1/2 in, built 1938, ribbed as built; Mendota photos of 2713 for colour ----
// 1938 branch-line paint: orange body, maroon letterboard only (NO maroon window band), 1/2 in aluminium stripe
// under the letterboard, gold-leaf lettering, roof and trucks oxide brown, underbody / handrails / grabs black,
// window sashes, platforms and steps maroon (paint these by hand).
// paint scheme default for this car is MILW: set in the main file / kit file header (build_tree.py paint="MILW")
MILW_BAND_Z0_IN = 74.5;       // band of zero height = no window band
MILW_BAND_Z1_IN = 74.5;
MILW_STRIPE_IN  = 0.5;        // letterboard starts at 75 in
MILW_ORANGE     = "#D8642F";  // body colour matched to Tom's photos of 2713 at Mendota (a redder, burnt orange than the Hiawatha orange #FF870F)
PAINT_TRUCK     = PAINT_SCHEME == "MILW" ? "#1C1C1C" : "#C8CACC";     // black trucks as 2713 today (as built: oxide brown)

FLUTE_ROUND     = true;       // rounded ribs (Tom 10/7)
PAINT_LETTER_LOW = "#F4F4F4";  // RAILWAY EXPRESS AGENCY and the car number in white, as 2713 at Mendota (Tom 10/7)
TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

include <../../../common/mr_common.scad>
