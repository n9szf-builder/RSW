// =====================================================================
//  MR1937_PassExpress_lib.scad  -  prototype data: Passenger-Express  (1937 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================
include <../../../common/mr_base.scad>

CAR_NAME  = "Passenger-Express";
CAR_TRAIN = "1937 Hiawatha";

// ---- body ----
LEN_FT = 79.5;    // over body (end sheet to end sheet)
WIDTH_FT = 10.06;    // over side sheets
SIDE_FT      = 7.75;   // bottom of side sill to eave
ROOF_RISE_FT = 1.85;   // eave to roof peak

// ---- ends ----
END_B        = "flat";   // rear end: "flat" | "round" (beaver tail) | "skytop" | "platform" (open observation platform)
TAIL_FT      = 12;      // length of rounded tail
PLATFORM_FT  = 0;      // open platform depth beyond the body (END_B = "platform")
PLAT_STYLE   = "basic";   // platform: "basic" (branch cars) | "business" (rounded canopy + deck, barred railing)
PLAT_CORNER_IN = 30;   // business: plan radius of the canopy / deck corners
PLAT_END_WINS  = [];   // windows in the platform end wall: [y_in (+Y positive), w_in, h_in, sill_in]
PLAT_RAIL_BARS = 7;   // business: horizontal railing bars
PLAT_DRUMHEAD  = [];   // business: drumhead disc on the end rail [y_in, dia_in, centre_in above the deck]
PLAT_MARKER_IN = 0;   // business: marker drum on the canopy roof, diameter (0 = none)
PLAT_SKIRT_IN  = 0;   // business: end skirt depth below the deck (0 = none)
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
    [8, 26, 27, 36, 1],
    [7.6, 26, 27, 36, -1],
    [13.6, 26, 27, 36],
    [17.05, 26, 27, 36],
    [20.5, 26, 27, 36],
    [23.95, 26, 27, 36],
    [27.4, 26, 27, 36],
    [30.85, 26, 27, 36]
];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [
    [1.9, 30, 80, 6],
    [61, 84, 84, 6]
];
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [];
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
LETTER_POS_FT = [];   // optional: one x (ft) per letter, -Y side (letterboard broken by windows)
LETTER_X0_FT = 22.3;   // centre of first letter
LETTER_X1_FT = 55.6;   // centre of last letter
LETTER_Z_IN  = 73;     // baseline above the side-sill bottom
LETTER_H_IN  = 7.5;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT   = [];

// ---- side treatment ----
FLUTES         = "rib";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 2;
FLUTE_Z0_IN    = 31.6;
FLUTE_PITCH_IN = 33.9;
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
MAGNET_X_FT = [15.6, 39.75, 64.85];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = true;
INTERIOR_ZONES = [
    ["bulkhead", 3.5],
    ["toilet", 4, 10.2],
    ["bulkhead", 10.33],
    ["coach", 10.6, 34],
    ["bulkhead", 34.3],
    ["baggage", 34.6, 79.5]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = true;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT  = [29.77, 34.26, 49.73, 52.23];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 21.68, 0, 36, 22, 22],
    ["box", 39.7, 0, 100, 50, 27],
    ["tankx", 46.19, 0, 16, 44],
    ["tankx", 47.49, 0, 16, 44],
    ["box", 50.28, 0, 32, 30, 10],
    ["box", 53.88, 0, 28, 20, 16],
    ["box", 57.67, 0, 59, 70, 30]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;
TRUCK_CENTERS_FT = [11.5, 68.21];
ELEC_BOX_X_FT      = 0;   // lighting-pack box centre (0 = midway between the trucks)

// ---- printing ----
BODY_JOINTS_FT = [];   // [] = automatic from bed size; or e.g. [26.5, 52.5] to land on window piers

// ---- colours (preview only) ----  fleet paint scheme: PAINT_SCHEME in common/mr_config.scad
BODY_COLOR     = PAINT_BODY;
BODY_COLOR_ALT = PAINT_BODY;
ROOF_COLOR     = PAINT_ROOF;
FLOOR_COLOR    = "#4A4A4A";
INTERIOR_COLOR = "#7A3B2E";

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Passenger and express cars 201-204 (1937), drawing p. 39 (IMG_5076): 79 ft 6 in; vestibule 3 ft 6 in, toilets 6 ft 10 in, passenger compartment 23 ft 11 1/2 in seating 28,
// baggage room 23 ft 2 1/2 in + 7 ft door + 15 ft. The A end here is the vestibule end. Baggage door cut open (five barred lights on the real door).
TRUCK4_STYLE = "1938";

include <../../../common/mr_common.scad>
