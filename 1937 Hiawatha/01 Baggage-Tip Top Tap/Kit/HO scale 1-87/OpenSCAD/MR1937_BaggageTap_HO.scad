// =====================================================================
//  MR1937_BaggageTap_HO.scad  -  STAND-ALONE KIT FILE   1:87 (HO scale)
//  Milwaukee Road 1937 Hiawatha  -  Baggage-Tip Top Tap
//  Created by Tom Fleming, n9szf@mac.com
//
//  Everything is in this one file - open it in OpenSCAD (2025 or newer, Manifold) on its own.
//  Pick PART / SECTION / PRINTER / COLOR_PART in the Customizer, F6, then File > Export > STL or 3MF.
//    assembly / exploded   whole car, or every printed section pulled apart (to look at, not for printing)
//    body N         sides + ends up to the eave (prints upright)
//    roof N         removable roof (prints upright on its lip)
//    floor N        floor with truck bolster pads (prints upside down)
//    windows / window_rims / window_glass   window inserts (one colour, or split for two colours)
//    interior N, steps, battery_box   G scale only
//  PRINTER   P1S  = Bambu P1S 256 mm bed: the car is cut into pinned sections that fit
//            GIGA = Elegoo OrangeStorm Giga 800 mm bed: body, roof and floor each in one piece
//  COLOR_PART (body sections only) all = one piece to paint;  body / skirt / stripe = the three
//            paint colours as separate solids for an AMS print (load them as one object with 3 parts)
//  No exterior lettering is modelled (decals / vinyl).  Trucks are a separate project.
//  Stand-alone file: everything it needs is inside it - no other files are required.
// =====================================================================

/* [Export] */
PART       = "assembly"; // [assembly, exploded, shape, body, body_colours, roof, floor, interior, battery_box, equipment, steps, brake_wheel, windows, window_rims, window_glass, drawing_side, drawing_top, drawing_end, drawing_plan, info]
SECTION    = 1;          // [1:1:8]
PRINTER    = "P1S";      // [P1S]
COLOR_PART = "all";      // [all, body, skirt, stripe]

/* [Show in the assembly view] */
SHOW_BODY      = true;
SHOW_ROOF      = true;
SHOW_FLOOR     = true;
SHOW_INTERIOR  = true;
SHOW_WINDOWS   = true;
SHOW_STEPS     = true;
SHOW_TRUCKS    = true;
SHOW_COUPLERS  = true;
SHOW_LIGHT_BOX = true;
SHOW_EQUIPMENT = true;

/* [Car frame] */
// print the floor / frame as ONE part (needs a big bed, e.g. the OrangeStorm Giga)
FRAME_ONE_PIECE = false;
// underbody boxes and tanks as separate parts fixed by holes in the frame
EQUIP_SEPARATE  = true;
EQUIP_FIX       = "pin";   // [pin, screw]

/* [Paint] */
// UP = Armour Yellow + Harbor Mist Gray; MILW = orange + maroon; none = plain, as printed in one colour
PAINT_SCHEME   = "MILW";   // [UP, MILW, none]
SHOW_LETTERING = false;

/* [Hidden] */

// =====================================================================
//  mr_config.scad  —  fleet-wide settings (Milwaukee Road passenger fleet)
//  Change these once and every car and truck picks them up.
// =====================================================================

SCALE   = 87.1;      // 1:29 (G scale, US standard gauge). Use 32 for 1:32.
GAUGE   = 16.5;      // track gauge, mm

// ---- printer: Bambu Lab P1S (256 x 256 x 256 mm), PETG ----
// Every car is cut into the fewest sections that fit this bed.  Body/roof joints land on a
// window pier (never through a window, door, magnet, skytop glass or rounded tail); floor
// joints are staggered between them, clear of the trucks, battery box and underframe.
// For the 800 mm printer set BED_X/Y/Z = 800 and DIAGONAL_PRINT = true - cars then print whole.
BED_X   = PRINTER == "GIGA" ? 800 : 256;     // mm
BED_Y   = PRINTER == "GIGA" ? 800 : 256;
BED_Z   = PRINTER == "GIGA" ? 1000 : 256;
PRINT_MARGIN   = 3;     // kept clear at each end of the bed, mm
DIAGONAL_PRINT = PRINTER == "GIGA" || true; // lay long parts across the bed diagonal (only worth it on a big bed)
FILAMENT       = "PETG";
JOINT_CLEAR    = 1;     // body joint at least this far outside a window socket, mm
FLOOR_STAGGER  = 20;    // floor joints at least this far from a body joint, mm

// ---- section ID labels: engraved on every printed section ----
//   body  : inside face of the -Y side wall, just above the floor screw bosses   "1948 Coach  B2/4  A>"
//   roof  : inside face of the -Y roof lip                                        "1948 Coach  R2/4  A>"
//   floor : floor top (the face on the print bed)                                 "<A  1948 Coach  F2/5"
//   B/R/F = body/roof/floor, 2/4 = section 2 of 4 counted from the A end; the arrow points to the A end.
LABELS      = true;
LABEL_D     = 0.4;      // engraving depth, mm (3 layers at 0.2)
LABEL_SIZE  = 3;        // text height, mm (roof lip 3.5; shrinks to fit short sections)
LABEL_FONT  = "Liberation Sans:style=Bold";

// ---- print / fit ----
WALL    = 1.6;     // shell thickness, mm
FLOOR_T = 2.0;     // floor plate thickness, mm
// floor fixing: a ledge round the inside of the body sits on the floor, and screws come up
// through the floor into bosses on the side walls
FLOOR_LEDGE_W = 1.2;     // ledge width in from the wall, mm
FLOOR_LEDGE_H = 1.5;     // ledge height, mm
FLOOR_SCREW_PITCH = 90; // mm between screws along each side (at most)
FLOOR_SCREW_END   = 20;  // first / last screw from the car ends, mm
FLOOR_BOSS    = 5.0;     // boss width along the wall, mm
FLOOR_BOSS_H  = 6.0;    // boss height above the floor, mm
FLOOR_PILOT   = 1.7;     // pilot hole in the boss (M2.5 self-tapping)
FLOOR_CLEAR_D = 2.3;     // clearance hole in the floor
FLOOR_HEAD_D  = 4.0;     // counterbore for the screw head, from underneath
CLEAR   = 0.25;    // sliding fit clearance, mm
JOINT_T = 4;       // internal collar at section joints (thickens the wall round the pins)
JOINT_W = 12;
PIN_D   = 2.1;     // alignment pins: 1.75 mm filament (2.1 hole - PETG prints holes a little small)
PIN_L   = 10;      // 7 mm into each section

// ---- removable roof ----
ROOF_LIP_H = 3;    // locating lip that drops inside the body walls, mm
ROOF_LIP_T = 1.2;
MAGNETS    = true; // magnets hold the roof down
MAG_D      = 3.2;  // pocket for 6 x 3 mm neodymium disc magnets
MAG_H      = 1.2;

// ---- LED roof lighting ----
LED        = false;
LED_STYLE  = "strip";  // "strip" (clip channel for LED tape) | "spots" (holes for 3 mm LEDs)
LED_W      = 10.4;     // LED tape width + clearance (8 mm tape -> 8.4)
LED_DEPTH  = 2.5;      // channel depth below the ceiling
LED_SPOT_D = 3.1;
LED_SPOT_PITCH_FT = 6;
WIRE_D     = 4;        // wire notch through the roof lip

// ---- lighting pack: battery + electronics tray INSIDE the car ----
// One tray per car (fleet standard): 2 x 18650 cells, USB-C charger, wireless-charging receiver board,
// XIAO ESP32-C6, 5 V boost for the LED strip.  It sits on the floor inside the car - in the restroom when
// one is long enough, otherwise the kitchen, baggage / mail room, a bedroom, the bar or a lounge (first
// that fits; ELEC_BOX_X_FT in the car lib overrides).  Nothing hangs under the floor.  Lift the roof to
// reach the USB-C port and the switch.  See "Electronics - Lighting Pack" for wiring, parts and firmware.
ELEC_BOX   = false;
EBOX_L     = 72;       // mm, along the car (18650 cell = 65 mm)
EBOX_W     = 64;       // mm, across (two cells side by side + a 21 mm bay for the boards)
EBOX_H     = 24;       // mm, wall height above the floor
EBOX_T     = 1.6;      // wall
EBOX_SCREW = 2.2;      // (not used now the tray is inside - it is glued or taped to the floor)
// ---- wireless charging: receiver coil under the roof ----
// A flat receiver coil sticks to the ceiling on the car centre line, above the tray; a charging pad laid
// on the roof charges the car with the roof on.  The LED channel is left open for the coil (the LED tape
// runs straight across underneath it).  Kept clear of the roof magnets.
COIL       = true;
COIL_D     = 50;       // mm, coil + ferrite diameter (the locating rim is this size inside)
COIL_RIM_H = 4;        // mm, how far the rim hangs below the ceiling at the centre line
MARKER_LED_D = 5.2;    // hole for a 5 mm LED behind the marker lens (observation cars)

// ---- interior ----
COACH_PITCH_IN = 42;   // coach seat pitch (prototype inches)

// ---- paint (preview colours) ----
// "UP"   = Union Pacific Armour Yellow + Harbor Mist Gray with red pinstripes.
//          UP required it on cars in the joint "City" pool from 1955; the Milwaukee Road
//          then used it on all non-commuter passenger cars until Amtrak (1971).
// "MILW" = Milwaukee Road orange + maroon (1935-1955).
ARMOUR_YELLOW    = "#FFCE24";   // UP Armor Yellow 255/206/36 (De Karske colour chart); paint: Tru-Color TCP-026
HARBOR_MIST_GRAY = "#777777";   // UP Gray 119/119/119 (De Karske colour chart); paint: Tru-Color TCP-025
UP_RED           = "#C0282D";
MILW_ORANGE      = "#FF870F";   // Milw Rd Orange 255/135/15 (De Karske colour chart)
MILW_MAROON      = "#741C1F";   // letterboard and window band (was #5A1A1A; matched by eye to the orange/maroon photos)
// Milwaukee Road orange + maroon as worn 1947-55: maroon letterboard with gold lettering, a thin orange
// stripe under it, a maroon band round the windows, orange below. The bands sit at the same height on every car,
// so they line up along the train (heights from the 1948 coach, where the two thin ribs mark the band edges).
MILW_BAND_Z0_IN = 38.4;     // bottom of the maroon window band, above the side-sill bottom
MILW_BAND_Z1_IN = 71.4;     // top of the maroon window band
STAR_ROWS    = [];           // rows of painted stars along the sides (see mr_view.scad)
MILW_UPPER_COLOR = "";        // a third body colour for the letterboard + lower band (set in a car lib; "" = none)
MILW_LOWER_BAND_IN = 0;       // height of that lower band along the bottom of the sides
PAINT_LETTER_LOW = "#741C1F";  // lettering below the windows in the MILW scheme (maroon; white on the 1938 branch cars)
FLUTE_ROUND     = false;    // true: side ribs (FLUTES = "rib") are half-round instead of square-edged
PLAT_STEPS      = true;     // side steps under an open platform (basic style)
PLATFORM_A_FT   = 0;        // open platform at the A end too (branch-line combines): depth in ft, set in the car lib
MILW_BAND_FIT   = false;    // true: fit the band to this car's own windows instead (set in a car's lib for an odd car)
MILW_BAND_BELOW_IN = 2.5;   // MILW_BAND_FIT: band starts this far below the lowest window sill
MILW_BAND_ABOVE_IN = 3.2;   // MILW_BAND_FIT: ... and ends this far above the highest window top
UNDER_SHROUD_IN = [];   // [width_in, depth_in]: a shroud round the under-floor equipment from truck to truck (1938 Hiawatha cars); [] = none
PLAT_BOW_IN  = 0;    // business-car platform: > 0 = the canopy / deck end is a full bow (half ellipse) this deep, instead of rounded corners
PLAT_DOME_IN = 0;    // business-car platform: > 0 = the canopy roof rounds down to the fascia over this length at the end
MILW_STRIPE_IN     = 3.0;   // orange stripe between the window band and the maroon letterboard
PAINT_NONE   = "#D2D4D6";
PAINT_BODY   = PAINT_SCHEME == "UP" ? ARMOUR_YELLOW    : PAINT_SCHEME == "MILW" ? MILW_ORANGE : PAINT_NONE;
PAINT_ROOF   = PAINT_SCHEME == "UP" ? HARBOR_MIST_GRAY : PAINT_SCHEME == "MILW" ? "#6E6E6E" : PAINT_NONE;
PAINT_SKIRT  = PAINT_SCHEME == "UP" ? HARBOR_MIST_GRAY : MILW_MAROON;  // band along the bottom of the sides
PAINT_STRIPE = PAINT_SCHEME == "UP" ? UP_RED           : "#1A1A1A";
PAINT_TRUCK  = PAINT_SCHEME == "MILW" ? "#1C1C1C" : "#C8CACC";   // orange + maroon cars: black trucks (Milwaukee Magazine July 1947: "black truck enamel"); otherwise light gray
PAINT_WHEEL  = "#D9DCDF";   // printed wheels, painted light silver
PAINT_AXLE   = "#B5A642";   // brass axle rod
PAINT_BEARING = "#D01C1F";  // ball bearings shown red in the views, so they are easy to spot
PAINT_LETTER = PAINT_SCHEME == "UP" ? UP_RED           : "#E8C06A";   // letterboard lettering
PAINT_END    = PAINT_SCHEME == "UP" ? HARBOR_MIST_GRAY : PAINT_BODY;  // car ends: gray 1955-71, body colour 1946-55 (De Karske)
PAINT_END_DOOR = "#EBD381";     // end door: sand 235/211/129 in UP paint; in Milwaukee paint the door is drawn orange (Tom 10/6)
PAINT_END_GLASS = "#0F8C8C";    // porthole glass in the end door (teal, as drawn)
PAINT_SKIRT_IN = 7;             // height of the gray band at the bottom (from the Walthers HO 1948 coach)
SHOW_PAINT_BANDS = true;        // draw the lower band + pinstripes in previews
// ---- what the assembly view shows (Customizer switches in every car file) ----
// ---- multi-colour printing (AMS) ----
// COLOR_PART splits each BODY section into the three paint colours as separate solids that fit
// together exactly; load the three files as one object with three parts and give each a filament.
// The sides print upright, so the lower band and the pinstripes are plain layer changes; only the
// gray car ends change colour inside a layer.  "all" = the whole part in one piece (paint it).
LAYER_H         = 0.2;     // colour boundaries are rounded to whole layers of this height, mm
PAINT_STRIPE_MM = 0.4;     // pinstripe height, mm (3 layers)
PAINT_END_SKIN  = 0.4;     // the side colour wraps this far round onto the end sheet edge, mm

// ---- vestibule steps: closed side doors with a separate printed step box under each ----
CLOSED_VESTIBULES = true;  // vestibule side doors (in DOORS) are drawn closed instead of cut open
STEP_BOTTOM_IN = 22;       // rail top to the top of the bottom step (prototype inches)
STEP_N         = 3;        // treads below the vestibule floor
STEP_TREAD_IN  = 10;       // tread depth (prototype inches)
STEP_T         = 1.2;      // tread / riser / cheek plate thickness, mm
STEP_FLANGE    = 7.0;      // mounting flange behind the stepwell, mm (2 x M2.5 screws down through the floor)
STEP_PILOT     = 2.2;      // pilot hole in the flange (M2.5 self-tapping, 8 mm)
STEP_COLOR     = "#2A2A2A";
GRAB_HOLES     = false;     // holes beside each vestibule door for bent brass-wire grab irons
GRAB_HOLE_D    = 1.1;      // for 0.8 - 1.0 mm brass wire
GRAB_OFFSET_IN = 4;        // grab iron centre line beyond the door edge (prototype inches)
GRAB_Z_IN      = [14, 56]; // bottom and top leg of each grab iron above the side sill (prototype inches)
END_GRABS      = false;     // brass-wire grab-iron holes on the end corners
END_GRAB_Y_IN  = 5;        // in from the car side (prototype inches)
END_GRAB_Z_IN  = [8, 40];  // bottom and top leg above the side sill (prototype inches)
BRAKE_WHEEL    = false;     // hand-brake wheel on the car end, left side as you face it (De Karske end views)
BRAKE_WHEEL_D_IN = 20;     // wheel diameter
BRAKE_WHEEL_Z_IN = 40;     // centre above the side sill
BRAKE_WHEEL_Y_FT = 3.4;    // centre out from the car centre line
BRAKE_WHEEL_SEPARATE = true; // TDQ-291 (Tom 13 Oct 2026): the wheel broke off a print - the end gets a hole and the
                             // wheel prints on its own (PART = "brake_wheel") with a peg that glues into the hole
BW_PEG_D  = 1.6;             // peg on the separate wheel, mm
BW_HOLE_D = 1.9;             // hole in the end sheet for the peg, mm
STEP_SHIELDS   = true;     // step boxes at a car end get a skirt shield in the end plane, bottom edge angled in

// ---- window inserts: separate printed glazing (tinted pane + silver rim) pressed in from inside ----
WINDOW_INSERTS = true;   // false = plain open windows, no sockets
WIN_FLANGE  = 0.8;       // insert flange beyond the opening, mm (sits in the socket inside the wall)
WIN_FLANGE_T = 0.6;      // flange thickness, mm
WIN_FIT     = 0.1;      // press-fit clearance, mm (raise if too tight, lower if they fall out)
WIN_SOCKET_W = 0.8;      // wall of the socket rim on the inside of the car side, mm
WIN_RIM_W   = 0.5;       // silver rim seen from outside, mm
WIN_INSET   = 0.3;       // glass face sits this far in from the car side, mm
GLASS_TINT  = [0.30, 0.40, 0.46, 0.55];
RIM_SILVER  = "#C9CED3";

// ---- running gear ----
RAIL_TO_SILL_FT = 3.2; // rail top to bottom of body side sill. Prototype photos show about 2.9 ft;
                       // 3.2 ft keeps the 36 in wheels clear of the floor, which sits at the sill line
BOLSTER_H     = 2.5;     // pad under the car floor that sits on the truck bolster
WHEEL_WELL_D  = 0;   // wheel wells: recess in the floor underside over each wheel, mm deep (0 = none).
                       //   The sprung trucks (Trucks/library, TDQ-268) let the car drop 1 mm onto its
                       //   springs; the floor is only ~0.1 mm above the flanges, so it needs the wells (TDQ-276).
TRUCK_SCREW_D = 1.8;   // truck pivot screw (M3)

// ---- printed wheelsets (printed wheels, painted light silver, pressed on a brass axle rod) ----
WHEEL_D_IN   = 36;     // prototype wheel diameter at the tread, inches (31.5 mm at 1:29)
WHEEL_B2B    = 40.5;   // back-to-back between the wheels, mm (G-scale standard)
WHEEL_W      = 6.5;    // wheel width incl. flange, mm
// No track power pickup: the wheels are plain printed wheels, there is no insulating bushing.
WHEEL_REAM   = 0.0;     // leave the wheel bore this much undersize, then drill / ream to size (e.g. 0.2)
FLANGE_T     = 1.5;    // flange thickness, mm
FLANGE_H     = 2.0;    // flange depth, mm
AXLE_D       = 3.0;    // brass axle rod diameter, mm (wheels press on; ends run in the bearings)
AXLE_BEARING = "F683";  // ball bearing in each journal box: "F683" (F683ZZ flanged 3x7x3, flange 8.1 x 0.8),
                        // "MR63" (3x6x2.5), "683" (3x7x3 plain) or "none" (axle runs in a plain hole)
BEARING_FIT  = 0.10;    // pocket oversize on the bearing OD, mm (print the fit coupon in Test Prints/04 first)
AXLE_HOLE_D  = 3.25;    // plain hole in the sideframe (AXLE_BEARING = "none")
// [bore, OD, width, flange OD, flange thickness]
BRG = AXLE_BEARING == "F683" ? [3, 7, 3, 8.1, 0.8] : AXLE_BEARING == "MR63" ? [3, 6, 2.5, 0, 0]
    : AXLE_BEARING == "683" ? [3, 7, 3, 0, 0] : [];
AXLE_HOLE_DEPTH = len(BRG) > 0 ? BRG[4] + BRG[2] + 0.5 : 2.5;   // how far the axle end goes into each sideframe: right through the bearing, tip in the relief behind it
SF_T         = 4.5;    // sideframe thickness, mm
TRUCK4_STYLE = "A-4778"; // 4-wheel trucks: "1938" = the 1938 Hiawatha truck (RME 3/1939 photo; set in the libs of the 1935-1942 cars),
                         //   "A-4778" = Milwaukee Road 1947 equalizer truck (MPL drawing A-4778,
                         //   7'-0" wheelbase on the shop-built cars), "nystrom" = the earlier best-guess cast frame
SF_CLEAR     = 0.8;    // gap between wheel hub and sideframe
AXLE_TIP_LEN = 2 * (WHEEL_B2B / 2 + WHEEL_W + 1 + SF_CLEAR + AXLE_HOLE_DEPTH) - 0.4;   // cut the axle rod to this
AXLE_TIP_D   = AXLE_D;

// ---- couplers (body-mounted, e.g. Kadee #1906 with its gearbox - MEASURE YOURS) ----
COUPLER_Z_IN   = 34.5;          // coupler centre above the rail (AAR standard 34.5 in)
COUPLER_BOX    = [15, 9.5, 4];   // gearbox length (along car), width, height, mm
COUPLER_SCREW_D = 1.8;          // tap hole for the gearbox screw (2-56 / M2)
// ---- car frame (floor + underframe) options ----
                                //        separate part located by holes in the frame;  false = moulded on as before
EQUIP_PIN_DEPTH = 6;            // how far a pin / screw goes into the equipment part, mm
COUPLER_POCKET  = true;         // printed draft-gear pocket under each end: two cheeks + a back stop the gearbox slides into
COUPLER_POCKET_T = 1.6;         // cheek thickness, mm
COUPLER_FIT     = 0.3;          // clearance round the gearbox in the pocket, mm
SHOW_TRUCKS_ON_CAR = false;      // show trucks + couplers under the car in the assembly view
MIN_CURVE_D_FT  = 4;           // smallest curve on the layout, diameter in REAL feet (10 ft = 3.05 m)
COUPLER_REACH_MIN = 3.5;         // knuckle face at least this far beyond the body end sheet, mm
// Kadee #1906 (#1 scale Type E, centreset shank) stand-in, view only - MEASURE YOURS
KD_HEAD  = [3, 4, 3];          // knuckle head: length, width, height, mm
KD_SHANK = [1.8, 1.4];            // shank width, height, mm
KD_PIVOT = 3;                   // pivot, mm back from the gearbox front

$fn = 48;

// =====================================================================
//  mr_units.scad  —  prototype-to-model conversion helpers
// =====================================================================

function ft(f)        = f * 304.8 / SCALE;        // prototype feet   -> model mm
function inch(i)      = i * 25.4  / SCALE;        // prototype inches -> model mm
function ftin(f, i=0) = ft(f) + inch(i);

// A row of evenly spaced windows. Each window is [x_ft, w_in, h_in, sill_in]
//   start_ft : centre of first window from the A (front) end
//   pitch_ft : centre-to-centre spacing
//   sill_in  : sill height above the bottom of the side sill
function mr_window_row(start_ft, pitch_ft, n, w_in, h_in, sill_in) =
    [ for (k = [0:1:n-1]) [start_ft + k * pitch_ft, w_in, h_in, sill_in] ];


// ===================== CAR DATA =====================

// =====================================================================
//  MR1937_BaggageTap_lib.scad  -  prototype data: Baggage-Tip Top Tap  (1937 Hiawatha)
//
//  Every dimension here is an ESTIMATE until checked against the
//  diagrams / photos you put in ../drawings/.  Units: prototype feet or
//  inches (converted with ft() / inch() at the fleet SCALE).
//  Shared code: ../../../common/   Fleet settings: common/mr_config.scad
// =====================================================================

CAR_NAME  = "Baggage-Tip Top Tap";
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
END_DOOR_RECESS  = 0.4;    // how deep the closed door sits, model mm
END_DOOR_WINDOW  = true;    // window in the upper door
END_DOOR_WINDOW_SHAPE = "rect";   // "rect" | "porthole"
END_DOOR_PORT_IN   = 20;     // porthole diameter
END_DOOR_PORT_Z_IN = 57;     // porthole centre above the side-sill bottom
END_DIAPHRAGM    = true;    // raised diaphragm frame around the door
DIAPHRAGM_W_IN   = 5;      // frame width
DIAPHRAGM_D      = 1.25;    // how far it stands out, model mm
DIAPHRAGM_TOP_IN = 88;     // top of the frame above the side-sill bottom

// ---- openings ----  window: [x_ft, w_in, h_in, sill_in, side, shape]  (x from A end, sill above side-sill bottom)
//   side: 0 both, -1 only -Y side, 1 only +Y side;  shape: 0 rectangle, 1 round porthole (w = diameter), 2 oval
WINDOWS = [
    [40.7, 10, 10, 56, -1, 1],
    [39.2, 10, 10, 56, 1, 1]
];
DOME_WINDOWS = [];
// door (cut open): [x_ft, w_in, h_in, sill_in]
DOORS = [];   // TDQ-285 (Tom 13 Oct 2026): doors closed - now DOOR_PANELS below
// closed side door: [x_ft, w_in, h_in, sill_in, side, recess_in]  (recess_in 0 = engraved outline)
DOOR_PANELS = [[13.5, 86, 84, 6, 0, 1], [34.2, 26, 80, 6, 0, 1]];   // TDQ-285: closed doors (were open doorways)
// vestibule step boxes: "auto" (under every vestibule side door) | [] | [[x_ft, door_w_in, side], ...]
STEPWELLS = [];
// roof housing (A/C, ice activator): [x0_ft, x1_ft, w_in, h_in]
ROOF_HOUSINGS = [];

// ---- end sheet ribs ----  horizontal ribs across the flat ends (0 = none)
END_RIBS          = 0;
END_RIB_Z0_IN     = 3;      // lowest rib above the side-sill bottom
END_RIB_PITCH_IN  = 10.7;   // rib spacing
END_RIB_H_IN      = 1.5;    // rib height
END_RIB_D         = 0.3;    // how far the ribs stand out, model mm
END_RIB_MARGIN_IN = 3;      // ribs stop this far in from the end edges
END_RIB_STYLE     = "bead";   // "band" (flat bands, rounded edges) | "bead" (half-round)
END_POSTS         = false;    // collision posts either side of the door, full height
END_POST_W_IN     = 6.6;
END_POST_GAP_IN   = 42;     // clear space between the posts
END_POST_D        = 0.5;    // model mm
END_FRAME         = false;    // raised door-frame plate between the posts
END_FRAME_HEADER_IN = 7;    // plate top above the door opening
END_FRAME_D       = 0.4;    // model mm
END_SILL_H_IN     = 0;      // raised strip across the bottom of the end (0 = none)
END_SILL_D        = 0.4;

// ---- roof detail ----
ROOF_RIBS       = 0;      // raised ribs running along the roof (0 = none)
ROOF_RIB_R      = 0.3;    // rib radius, model mm
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
LETTER_X0_FT = 22.1;   // centre of first letter
LETTER_X1_FT = 55.3;   // centre of last letter
LETTER_Z_IN  = 73;     // baseline above the side-sill bottom
LETTER_H_IN  = 7.5;
// more lettering: [text, x_ft (centre), baseline_in, height_in]
EXTRA_TEXT   = [];

// ---- side treatment ----
FLUTES         = "rib";   // "none" | "groove" (1937 fluting) | "rib" (1938 Kuhler)
FLUTE_COUNT    = 2;   // RME March 1939: the 1936 cars had corrugations above and below the windows only (Tom 10/5)
FLUTE_Z0_IN    = 31.6;
FLUTE_PITCH_IN = 33.9;
FLUTE_H_IN     = 2;
FLUTE_D        = 0.3;   // model mm
REAR_FINS      = false;

// ---- dome ----
DOME          = false;
DOME_START_FT = 0;
DOME_END_FT   = 0;
DOME_RISE_FT  = 0;
DOME_SLOPE_FT = 6;

// ---- removable roof ----  (lip, magnet size and LED options: common/mr_config.scad)
MAGNET_X_FT = [17.7, 38.15, 63.6];   // magnet pairs, placed on window piers

// ---- interior ----  zone types: see common/mr_interior.scad
INTERIOR = false;
INTERIOR_ZONES = [
    ["baggage", 0, 30.9],
    ["bulkhead", 31],
    ["bar", 31.2, 38.5],
    ["diner", 39, 71.3],
    ["bulkhead", 71.67],
    ["toilet", 72, 79]
];

// ---- underframe ----  hangs under the floor and prints with it (clears the truck swing zones)
UNDERFRAME       = false;
CENTER_SILL_W_IN = 24;
CENTER_SILL_D_IN = 10;
CROSSBEARERS_FT  = [29.6, 34.06, 49.4, 51.87];
CROSSBEARER_W_IN = 6;
CROSSBEARER_D_IN = 8;
UNDER_MAX_IN     = 30;     // nothing hangs lower than this below the floor
// equipment: ["box", x_ft, y_in, l_in, w_in, h_in] | ["tank", x_ft, y_in, l_in, dia_in] | ["tankx", x_ft, y_in, dia_in, len_in]
UNDER_EQUIP = [
    ["box", 21.58, 0, 36, 22, 22],
    ["box", 39.45, 0, 100, 50, 27],
    ["tankx", 45.89, 0, 16, 44],
    ["tankx", 47.17, 0, 16, 44],
    ["box", 49.94, 0, 32, 30, 10],
    ["box", 53.51, 0, 28, 20, 16],
    ["box", 57.27, 0, 59, 70, 30]
];

// ---- running gear ----  (truck designs: ../../../Trucks/)
TRUCK_AXLES        = 2;
TRUCK_WHEELBASE_FT = 8;   // Milwaukee Magazine May 1947: the 1947 truck cut the wheelbase "from 8 feet to 7 feet"
TRUCK_CENTERS_FT = [11.28, 68.22];
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

TRUCK4_STYLE = "1938";   // 1938 Hiawatha truck (RME March 1939) - used for all pre-1947 cars until earlier truck drawings turn up

// ---- Shops book (Hiawatha - Nothing Faster on Rails, Milwaukee Shops Inc. 2014) - applied 10/6 ----
// Express-Tip Top Tap 151-152 (1936-37), drawing p. 13 (IMG_5050): body 79 ft 6 in; baggage room 30 ft 11 in, bar + tap room 40 ft 9 in seating 40,
// toilets 7 ft 10 in. The tap room has NO side windows - only one small porthole each side by the bar. Baggage door has five barred lights.
// The narrow service door (about 34 ft) is on one side only on the real car; the model cuts DOORS on both sides.



// ===================== SHARED CODE =====================

// =====================================================================
//  mr_carbody.scad  —  parametric streamlined passenger-car body
//
//  Parts: BODY (sides + ends up to the eave), removable ROOF (with
//  locating lip, magnet bosses, LED mounts), FLOOR.
//  Coordinates: X along the car (0 = A/front end), Y across, Z up
//  (0 = bottom of the side sill). Model units: mm.
//
//  Every car lib must set, BEFORE including mr_common.scad:
//    CAR_NAME CAR_TRAIN LEN_FT WIDTH_FT SIDE_FT ROOF_RISE_FT
//    END_B TAIL_FT PLATFORM_FT SKY_START_FT SKY_PITCH_IN SKY_DROP_FT SKY_SILL_IN SKY_SPINE_IN SKY_MULLION
//    SKY_TOP_PTS SKY_PANES SKY_WINS SKY_REAR_PANES SKY_CROWN_PANES SKY_BAND SKY_BAND_COLOR SKY_FLUTES SKY_MARKER END_DOORS
//    WINDOWS DOME_WINDOWS DOORS DOOR_PANELS ROOF_HOUSINGS
//    LETTERING LETTER_X0_FT LETTER_X1_FT LETTER_Z_IN LETTER_H_IN EXTRA_TEXT
//    ROOF_RIBS ROOF_RIB_R ROOF_RIB_SPAN ROOF_RIB_END_FT ROOF_VENTS VENT_L_IN VENT_W_IN VENT_H_IN VENT_MESH
//    UNDERFRAME CENTER_SILL_W_IN CENTER_SILL_D_IN CROSSBEARERS_FT CROSSBEARER_W_IN CROSSBEARER_D_IN UNDER_EQUIP UNDER_MAX_IN
//    END_RIBS END_RIB_STYLE END_RIB_Z0_IN END_RIB_PITCH_IN END_RIB_H_IN END_RIB_D END_RIB_MARGIN_IN
//    END_POSTS END_POST_W_IN END_POST_GAP_IN END_POST_D END_FRAME END_FRAME_HEADER_IN END_FRAME_D
//    END_SILL_H_IN END_SILL_D
//    END_DOOR_STYLE END_DOOR_W_IN END_DOOR_H_IN END_DOOR_SILL_IN END_DOOR_RECESS END_DOOR_WINDOW
//    END_DOOR_WINDOW_SHAPE END_DOOR_PORT_IN END_DOOR_PORT_Z_IN
//    END_DIAPHRAGM DIAPHRAGM_W_IN DIAPHRAGM_D DIAPHRAGM_TOP_IN
//    FLUTES FLUTE_COUNT FLUTE_Z0_IN FLUTE_PITCH_IN FLUTE_H_IN FLUTE_D REAR_FINS
//    DOME DOME_START_FT DOME_END_FT DOME_RISE_FT DOME_SLOPE_FT
//    MAGNET_X_FT INTERIOR INTERIOR_ZONES
//    TRUCK_AXLES TRUCK_WHEELBASE_FT TRUCK_CENTERS_FT BODY_JOINTS_FT ELEC_BOX_X_FT
//    BODY_COLOR BODY_COLOR_ALT ROOF_COLOR FLOOR_COLOR INTERIOR_COLOR
//  (OpenSCAD evaluates assignments in order, so values must exist first.)
// =====================================================================

// ---------- derived sizes ----------
L    = ft(LEN_FT);
W    = ft(WIDTH_FT);
HS   = ft(SIDE_FT);
RR   = ft(ROOF_RISE_FT);
HT   = HS + RR;
TAIL = (END_B == "round" || END_B == "skytop") ? ft(TAIL_FT) : 0;
PLATA = ft(PLATFORM_A_FT);                            // open platform at the A end (x < 0)
PLAT = (END_B == "platform") ? ft(PLATFORM_FT) : 0;   // open observation platform beyond the body
DR   = DOME ? ft(DOME_RISE_FT) : 0;
DS   = ft(DOME_START_FT);
DE   = ft(DOME_END_FT);
DSL  = ft(DOME_SLOPE_FT);
TOP  = HT + DR;
ROOF_Z   = HS;                      // body / roof split at the eave
CEIL_Z   = HT - WALL;               // ceiling height on the centre line
RAIL_TOP = -ft(RAIL_TO_SILL_FT);    // rail top in car coordinates

// ---------- print sections: see "PRINT SECTIONS" at the end of this file ----------

// ---------- cross-section and plan ----------
module mr_profile(w, hs, rr, bot = 0) {
    hull() {
        translate([-w/2, bot]) square([w, hs - bot]);
        translate([0, hs]) scale([w/2, rr]) circle(r = 1, $fn = 96);
    }
}

module mr_plan(o, z0, z1) {
    if (TAIL <= 0) {
        translate([o, -W, z0]) cube([L - 2*o, 2*W, z1 - z0]);
    } else {
        translate([o, -W, z0]) cube([L - TAIL - o + 0.01, 2*W, z1 - z0]);
        translate([L - TAIL, 0, z0])
            scale([TAIL - o, W/2 - o, 1]) cylinder(r = 1, h = z1 - z0, $fn = 120);
    }
}

// Skytop roof drop: over the solarium the crown of the roof comes down by SKY_DROP_FT at the tail
// (eave height stays at HS so the body / roof split is unchanged)
SKY_DROP = (END_B == "skytop") ? min(ft(SKY_DROP_FT), RR * 0.8) : 0;
SKY_XD   = (END_B == "skytop") ? (SKY_START_FT > 0 ? ft(SKY_START_FT) : L - TAIL) : L;
function mr_sky_rr(x, o) = max(RR - o - SKY_DROP * pow(max(0, min(1, (x - SKY_XD) / (L - SKY_XD))), 2), 1);

// Skytop nose (SKY_TOP_PTS = [[x_ft, top_ft], ...] read off a side elevation).
// The tail is built in horizontal slices: at each height the end is a half-ellipse of TAIL_FT
// (the plan rounding) whose tip sits on the side-elevation outline at that height, so the side
// view follows the drawing, the plan is round at every level and the roof keeps its section.
// Beaver tail side outline (END_B = "round"), TDQ-272: same slices as the Skytop nose.
// The settings below are optional in a car's lib - a car without them keeps the plain half-round tail.
TAIL_PTS_L   = is_undef(TAIL_PTS)       ? [] : TAIL_PTS;         // [[x_ft, height_ft], ...] roof -> side sill
REAR_WINS_L  = is_undef(REAR_WINS)      ? [] : REAR_WINS;        // [[y_centre_ft, w_in, z0_ft, z1_ft], ...]
TFIN_Z_L     = is_undef(TAIL_FIN_Z_IN)  ? [] : TAIL_FIN_Z_IN;    // bottom of each tail fin above the side sill
TFIN_H_L     = is_undef(TAIL_FIN_H_IN)  ? 1.5 : TAIL_FIN_H_IN;   // fin thickness
TFIN_D_L     = is_undef(TAIL_FIN_D_IN)  ? 3 : TAIL_FIN_D_IN;     // how far a fin stands off the skin
TFIN_X0_L    = is_undef(TAIL_FIN_X0_FT) ? 0 : TAIL_FIN_X0_FT;    // fins start here
NOSE_SRC = END_B == "skytop" ? SKY_TOP_PTS : (END_B == "round" ? TAIL_PTS_L : []);
NOSE_ON = len(NOSE_SRC) > 1;
NOSE_X0 = NOSE_ON ? ft(NOSE_SRC[0][0]) - TAIL - ft(1) : L;
NOSE_ZX = NOSE_ON ? [for (i = [len(NOSE_SRC) - 1:-1:0]) [NOSE_SRC[i][1], NOSE_SRC[i][0]]] : [[0, 0]];
function mr_nose_xmax(z) = min(L, ft(lookup(z / ft(1), NOSE_ZX)));      // outline tip at height z (mm)
module mr_nose_slice(z, o) {
    xt = min(mr_nose_xmax(z + o), L) - o;                                 // inner skins drop by o as well
    r  = TAIL - o;
    translate([0, 0, z]) linear_extrude(0.01) hull() {
        translate([-2, -(W/2 - o)]) square([xt - r + 2, W - 2*o]);
        translate([xt - r, 0]) scale([r, W/2 - o]) circle(r = 1, $fn = 96);
    }
}
module mr_nose_plan(o, zb) {
    z0 = zb - 1; z1 = TOP + 2; n = 32;
    for (i = [0:1:n-1]) hull() {
        mr_nose_slice(z0 + (z1 - z0) * i / n, o);
        mr_nose_slice(z0 + (z1 - z0) * (i + 1) / n, o);
    }
}

module mr_body_solid(o = 0, zb = 0) {
    if (NOSE_ON) intersection() {
        translate([-1, 0, 0]) rotate([90, 0, 90])
            linear_extrude(L + 2) mr_profile(W - 2*o, HS, RR - o, zb);
        mr_nose_plan(o, zb);
        // A-end sheet for a beaver tail with an outline: start at x = o, as mr_plan does (TDQ-272).
        // (Skytop cars keep x = -1 here, unchanged - see TDQ in Research_Notes about their A end.)
        translate([END_B == "round" ? o : -5, -W, zb - 2]) cube([L + 10, 2*W, TOP + 10]);
    }
    else intersection() {
        if (SKY_DROP <= 0)
            translate([-1, 0, 0]) rotate([90, 0, 90])
                linear_extrude(L + 2) mr_profile(W - 2*o, HS, RR - o, zb);
        else union() {
            translate([-1, 0, 0]) rotate([90, 0, 90])
                linear_extrude(SKY_XD + 1.01) mr_profile(W - 2*o, HS, RR - o, zb);
            n = 12;
            for (i = [0:1:n-1]) hull()
                for (x = [SKY_XD + i * (L + 1 - SKY_XD) / n, SKY_XD + (i + 1) * (L + 1 - SKY_XD) / n])
                    translate([x, 0, 0]) rotate([90, 0, 90])
                        linear_extrude(0.01) mr_profile(W - 2*o, HS, mr_sky_rr(x, o), zb);
        }
        mr_plan(o, zb - 1, TOP + 2);
    }
}

module mr_dome_solid(o = 0) {
    if (DOME) {
        dw = W * 0.88;
        rt = RR * 0.7;
        hull() {
            translate([DS + o, 0, 0]) rotate([90, 0, 90])
                linear_extrude(DE - DS - 2*o) mr_profile(dw - 2*o, HS, RR - o, HS * 0.5);
            translate([DS + DSL, 0, 0]) rotate([90, 0, 90])
                linear_extrude(DE - DS - 2*DSL) mr_profile(dw - 2*o, TOP - rt, rt - o, HS * 0.5);
        }
    }
}

module mr_outer() { mr_body_solid(0, 0);     mr_dome_solid(0); }
module mr_inner() { mr_body_solid(WALL, -5); mr_dome_solid(WALL); }

// ---------- section joints (only used if a car is split) ----------
function mr_top_at(x) = (DOME && x > DS + DSL && x < DE - DSL) ? TOP : HT;

// Each side wall has its own joints (BJS[0] = -Y side, BJS[1] = +Y side); the roof has RJ.
// The collar stops short of the window sockets so the glazing inserts still seat.
module mr_collar_band() { difference() { mr_outer(); union() { mr_body_solid(JOINT_T, -5); mr_dome_solid(JOINT_T); } } }
module mr_collars() {
    for (k = [0, 1]) for (j = BJS[k]) intersection() {
        mr_collar_band();
        difference() {   // clear of the floor, the roof lip and the magnet blocks
            translate([j - JOINT_W/2, k == 0 ? -W : 0, FLOOR_T + 0.5]) cube([JOINT_W, W, ROOF_Z - ROOF_LIP_H - 12 - FLOOR_T]);
            for (w = WINDOWS) translate([ft(w[0]) - inch(w[1])/2 - WIN_FLANGE - WIN_SOCKET_W - 0.5, -W, inch(w[3]) - WIN_FLANGE - WIN_SOCKET_W - 0.5])
                cube([inch(w[1]) + 2 * (WIN_FLANGE + WIN_SOCKET_W + 0.5), 2*W, inch(w[2]) + 2 * (WIN_FLANGE + WIN_SOCKET_W + 0.5)]);
        }
    }
    for (j = RJ) intersection() {
        mr_collar_band();
        translate([j - JOINT_W/2, -W, ROOF_Z + 3.5]) cube([JOINT_W, 2*W, TOP]);
    }
}

// two pins in each side wall (low, and just under the window sills) + one in the roof crown
function mr_pin_zs(j) = let(z1 = FLOOR_T + FLOOR_LEDGE_H + 5,
        sills = [for (w = WINDOWS) if (abs(ft(w[0]) - j) < inch(w[1]) / 2 + PIN_L / 2 + 4)
                     inch(w[3]) - WIN_FLANGE - WIN_SOCKET_W],
        z2 = min(concat([HS * 0.45, ROOF_Z - ROOF_LIP_H - 14], [for (z = sills) z - PIN_D / 2 - 1.5])))
    z2 - z1 >= 8 ? [z1, z2] : [z1];
module mr_joint_pins() {
    for (k = [0, 1]) for (j = BJS[k]) for (z = mr_pin_zs(j))
        translate([j, (k == 0 ? -1 : 1) * (W/2 - JOINT_T/2), z])
            rotate([0, 90, 0]) cylinder(d = PIN_D, h = PIN_L, center = true, $fn = 16);
    for (j = RJ)
        translate([j, 0, mr_top_at(j) - JOINT_T/2])
            rotate([0, 90, 0]) cylinder(d = PIN_D, h = PIN_L, center = true, $fn = 16);
}

// ---------- openings and detail ----------
// window: [x_ft, w_in, h_in, sill_in, side, shape]
//   side : 0 both sides, -1 only the -Y side, 1 only the +Y side
//   shape: 0 rectangle (rounded corners), 1 round porthole (diameter w), 2 oval (rounded ends),
//          3 arched top (1934 cars), 4 / 5 Kuhler fin window rounded toward the B / A end (1938 Beaver Tail)
module mr_opening2d(w, h, shape) {
    if (shape == 1) translate([0, w/2]) circle(d = w, $fn = 40);
    else if (shape == 2) hull() for (e = [-1, 1]) translate([e * (w - h)/2, h/2]) circle(d = h, $fn = 32);
    else if (shape == 3) hull() {   // arched top (1934 cars): square at the bottom, oval at the top
        translate([0, (h - w * 0.2) / 2]) offset(r = w * 0.05) offset(delta = -w * 0.05) square([w, h - w * 0.2], center = true);
        translate([0, h - w * 0.2]) scale([1, 0.4]) circle(d = w, $fn = 48);
    }
    else if (shape == 4 || shape == 5) mirror([shape == 5 ? 1 : 0, 0]) intersection() {
        // Kuhler fin window (1938 finned Beaver Tail, Shops book p. 61): square at one end; the other end
        // a small radius at the head and a long sweep down to the sill
        translate([-w/2, 0]) square([w, h]);
        hull() {
            rs = min(w, h) * 0.12; rt = h * 0.28; rb = h * 0.85;
            translate([-w/2 + rs, rs]) circle(r = rs, $fn = 16);
            translate([-w/2 + rs, h - rs]) circle(r = rs, $fn = 16);
            translate([w/2 - rt, h - rt]) circle(r = rt, $fn = 32);
            translate([w/2 - rb * 1.15, rb]) scale([1.15, 1]) circle(r = rb, $fn = 64);
        }
    }
    else translate([0, h/2]) offset(r = min(w, h) * 0.12) offset(delta = -min(w, h) * 0.12) square([w, h], center = true);
}

module mr_window_cuts() {
    for (w = concat(WINDOWS, DOME_WINDOWS)) {
        side  = len(w) > 4 ? w[4] : 0;
        shape = len(w) > 5 ? w[5] : 0;
        y0 = side > 0 ? 0 : -W;
        yl = side == 0 ? 2*W : W;
        translate([ft(w[0]), y0 + yl, inch(w[3])]) rotate([90, 0, 0])
            linear_extrude(yl) mr_opening2d(inch(w[1]), inch(w[2]), shape);
    }
    if (NOSE_ON && END_B == "round")                 // windows in the sloped beaver tail (REAR_WINS)
        for (r = REAR_WINS_L) {
            ww = inch(r[1]); z0 = ft(r[2]); z1 = ft(r[3]);
            translate([mr_nose_xmax(z1) - ft(2), ft(r[0]), z0]) rotate([0, 90, 0]) rotate([0, 0, 90])
                linear_extrude(L) translate([-ww/2, 0])
                    offset(r = ww * 0.1) offset(delta = -ww * 0.1) square([ww, z1 - z0]);
        }
}

// ---------- WINDOW INSERTS ----------
// Each side window gets a socket rim on the inside of the wall; a separately printed insert
// (tinted pane with a flange, silver rim round the edge) presses into it from inside the car.
// Windows on curved walls (tails, domes, skytop glass) and in recessed sliding doors are skipped.
function mr_win_side(w)  = len(w) > 4 ? w[4] : 0;
function mr_win_shape(w) = len(w) > 5 ? w[5] : 0;
function mr_win_in_rdoor(w) = len([for (d = DOOR_PANELS)
    if (mr_dp_recess(d) > 0 && abs(ft(d[0]) - ft(w[0])) < inch(d[1]) / 2 + inch(w[1]) / 2
        && (mr_dp_side(d) == 0 || mr_win_side(w) == 0 || mr_dp_side(d) == mr_win_side(w))) 1]) > 0;
function mr_win_ok(w) = ft(w[0]) + inch(w[1]) / 2 < L - TAIL - 2 && ft(w[0]) - inch(w[1]) / 2 > 2
                        && !(END_B == "skytop" && SKY_START_FT > 0 && ft(w[0]) + inch(w[1]) / 2 > ft(SKY_START_FT))
                        && !mr_win_in_rdoor(w);
INSERT_WINDOWS = WINDOW_INSERTS ? [for (w = WINDOWS) if (mr_win_ok(w)) w] : [];
// one entry per physical insert: [window, side]
INSERT_LIST = [for (w = INSERT_WINDOWS) for (s = mr_win_side(w) == 0 ? [1, -1] : [mr_win_side(w)]) [w, s]];

module mr_win2d(w, grow) { offset(delta = grow) mr_opening2d(inch(w[1]), inch(w[2]), mr_win_shape(w)); }

// place local insert space (x along the car, y up, z outward, z = 0 on the inside face of the wall)
module mr_at_window(w, s) {
    scale([1, s, 1]) translate([ft(w[0]), W/2 - WALL, inch(w[3])]) rotate([90, 0, 0]) mirror([0, 0, 1]) children();
}

module mr_win_sockets() {
    for (e = INSERT_LIST) mr_at_window(e[0], e[1])
        translate([0, 0, -(WIN_FLANGE_T + 0.2)]) linear_extrude(WIN_FLANGE_T + 0.25)
            difference() {
                mr_win2d(e[0], WIN_FLANGE + WIN_FIT + WIN_SOCKET_W);
                mr_win2d(e[0], WIN_FLANGE + WIN_FIT);
            }
}

// insert in local space; which = "all" | "rim" | "glass"
module mr_win_insert(w, which = "all") {
    ph = WALL - WIN_INSET;                                   // plug height through the wall
    if (which != "glass")                                     // silver rim round the plug
        linear_extrude(ph) difference() { mr_win2d(w, -WIN_FIT); mr_win2d(w, -WIN_FIT - WIN_RIM_W); }
    if (which != "rim") {
        translate([0, 0, -WIN_FLANGE_T]) linear_extrude(WIN_FLANGE_T) mr_win2d(w, WIN_FLANGE);
        linear_extrude(ph) mr_win2d(w, which == "glass" ? -WIN_FIT - WIN_RIM_W : -WIN_FIT);
    }
}

module mr_win_inserts_preview() {
    color(RIM_SILVER) for (e = INSERT_LIST) mr_at_window(e[0], e[1]) mr_win_insert(e[0], "rim");
}
module mr_win_glass_preview() {
    color(GLASS_TINT) for (e = INSERT_LIST) mr_at_window(e[0], e[1]) mr_win_insert(e[0], "glass");
}

// print layout: flange down, laid out in rows
WIN_CELL = inch(max(concat([30], [for (e = INSERT_LIST) max(e[0][1], e[0][2])]))) + 2 * WIN_FLANGE + 6;
WIN_COLS = max(1, floor((BED_X - 40) / WIN_CELL));
module mr_win_print(which = "all") {
    for (i = [0:1:len(INSERT_LIST) - 1]) {
        w = INSERT_LIST[i][0];
        translate([20 + (i % WIN_COLS) * WIN_CELL, 20 + floor(i / WIN_COLS) * WIN_CELL, WIN_FLANGE_T])
            translate([0, -inch(mr_win_shape(w) == 1 ? w[1] : w[2]) / 2, 0]) mr_win_insert(w, which);
    }
}

// door panel: [x_ft, w_in, h_in, sill_in, side, recess_in]
//   recess_in = 0 : engraved outline of a closed side door
//   recess_in > 0 : the door sits that far in from the side, with a jamb around the opening
//                   (sliding baggage doors); the roof lip is cleared above it
DP_JAMB = 1.2;                                     // jamb wall thickness, mm
function mr_dp_side(d)   = len(d) > 4 ? d[4] : 0;
function mr_dp_recess(d) = len(d) > 5 ? inch(d[5]) : 0;

// ---------- vestibule doors: closed, stepwell under the sill ----------
// A vestibule side door is one up to 36 in wide and at least 72 in high within 6 ft of a car end
// (not at an open platform or a Skytop / beaver tail).  With CLOSED_VESTIBULES such doors in DOORS
// are engraved (closed) instead of cut open.  STEPWELLS = "auto" puts a step box under every
// vestibule door; or list them by hand: [[x_ft, door_w_in, side], ...] (side 0 = both), [] = none.
function mr_is_vest(xf, w_in, h_in) = let(x = ft(xf))
    w_in <= 36 && h_in >= 72 && (x < ft(6) || x > L - ft(6)) && !(PLAT > 0 && x > L - ft(6)) && !(TAIL > 0 && x > L - TAIL - ft(1));
CUT_DOORS   = CLOSED_VESTIBULES ? [for (d = DOORS) if (!mr_is_vest(d[0], d[1], d[2])) d] : DOORS;
VEST_PANELS = CLOSED_VESTIBULES ? [for (d = DOORS) if (mr_is_vest(d[0], d[1], d[2])) [d[0], d[1], d[2], d[3], 0]] : [];
ALL_PANELS  = concat(DOOR_PANELS, VEST_PANELS);
STEP_LIST   = is_list(STEPWELLS) ? STEPWELLS
            : [for (d = ALL_PANELS) if (mr_dp_recess(d) == 0 && mr_is_vest(d[0], d[1], d[2])) [d[0], d[1], mr_dp_side(d)]];
STEP_ITEMS  = [for (e = STEP_LIST) for (sd = (len(e) > 2 && e[2] != 0) ? [e[2]] : [1, -1]) [ft(e[0]), inch(e[1]), sd]];

module mr_door_panels() {             // engraved outlines (non-recessed doors only)
    for (d = ALL_PANELS) if (mr_dp_recess(d) == 0) {
        side = mr_dp_side(d);
        for (s = side == 0 ? [1, -1] : [side]) scale([1, s, 1])
            translate([ft(d[0]), W/2 + 1, inch(d[3])]) rotate([90, 0, 0]) linear_extrude(1.4)
                difference() {
                    translate([-inch(d[1])/2, 0]) square([inch(d[1]), inch(d[2])]);
                    translate([-inch(d[1])/2 + 0.5, 0.5]) square([inch(d[1]) - 1, inch(d[2]) - 1]);
                }
    }
}

module mr_door_recess_openings() {    // cut the doorway through the side
    for (d = DOOR_PANELS) if (mr_dp_recess(d) > 0) {
        side = mr_dp_side(d);
        for (s = side == 0 ? [1, -1] : [side]) scale([1, s, 1])
            translate([ft(d[0]) - inch(d[1])/2, W/2 - WALL - 1, inch(d[3])]) cube([inch(d[1]), WALL + 2, inch(d[2])]);
    }
}

module mr_door_recess_parts(grow = 0) {   // recessed door leaf + jamb box
    for (d = DOOR_PANELS) if (mr_dp_recess(d) > 0) {
        side = mr_dp_side(d);
        rec = mr_dp_recess(d);
        w = inch(d[1]); h = inch(d[2]); z0 = inch(d[3]); x0 = ft(d[0]) - w/2;
        for (s = side == 0 ? [1, -1] : [side]) scale([1, s, 1]) {
            translate([x0 - 0.01, W/2 - rec - WALL, z0 - 0.01]) cube([w + 0.02, WALL, h + 0.02]);          // door leaf
            difference() {                                                                              // jamb
                translate([x0 - DP_JAMB, W/2 - rec - WALL, z0 - DP_JAMB]) cube([w + 2*DP_JAMB, rec + WALL - 0.01, h + 2*DP_JAMB]);
                translate([x0, W/2 - rec - WALL - 1, z0]) cube([w, rec + WALL + 2, h]);
            }
        }
    }
}

module mr_door_recess_lip_clear() {   // keep the roof lip out of the jamb
    for (d = DOOR_PANELS) if (mr_dp_recess(d) > 0) {
        side = mr_dp_side(d);
        rec = mr_dp_recess(d);
        for (s = side == 0 ? [1, -1] : [side]) scale([1, s, 1])
            translate([ft(d[0]) - inch(d[1])/2 - DP_JAMB - 1, W/2 - rec - WALL - 1, ROOF_Z - ROOF_LIP_H - 2])
                cube([inch(d[1]) + 2*DP_JAMB + 2, rec + 1 - 0.01, ROOF_LIP_H + 2]);
    }
}

// ---------- end sheet detail (from the Walthers O scale 1948 end casting) ----------
//  ribs   : horizontal ribs across the end. END_RIB_STYLE "band" = wide flat bands with
//           rounded edges and narrow grooves between (1948 cars); "bead" = half-round beads
//  posts  : two collision posts running the full height either side of the door
//  frame  : raised door-frame plate between the posts, up to a header above the door
//  sill   : raised strip across the bottom of the end
module mr_end_clip(margin_in) {
    translate([-5, 0, 0]) rotate([90, 0, 90]) linear_extrude(L + 10)
        offset(delta = -inch(margin_in)) mr_profile(W, HS, RR, 0);
}

module mr_band2d(d, h) {          // rib cross-section, outward = -X, height along +Y
    r = min(d, h / 2) * 0.9;
    hull() {
        translate([-d + r, r])     circle(r = r, $fn = 16);
        translate([-d + r, h - r]) circle(r = r, $fn = 16);
        square([0.01, h]);
    }
}

module mr_bead2d(d, h) {
    translate([0, h / 2]) intersection() {
        scale([d, h / 2]) circle(r = 1, $fn = 32);
        translate([-d - 1, -h]) square([d + 1.01, 2 * h]);
    }
}

module mr_end_details(grow = 0) {
    pw = inch(END_POST_W_IN);
    pg = inch(END_POST_GAP_IN);
    for (e = mr_end_list()) if (!mr_plat_end(e)) mr_at_end(e) {
        if (END_RIBS > 0) intersection() {
            for (k = [0:1:END_RIBS-1])
                translate([0, 0, inch(END_RIB_Z0_IN + k * END_RIB_PITCH_IN) - grow])
                    rotate([90, 0, 0]) linear_extrude(2*W, center = true)
                        if (END_RIB_STYLE == "bead") mr_bead2d(END_RIB_D + grow, inch(END_RIB_H_IN) + 2*grow);
                        else mr_band2d(END_RIB_D + grow, inch(END_RIB_H_IN) + 2*grow);
            mr_end_clip(END_RIB_MARGIN_IN);
        }
        if (END_POSTS) intersection() {
            for (s = [1, -1])
                translate([-END_POST_D - grow, s * (pg/2 + pw/2) - pw/2 - grow, -grow])
                    cube([END_POST_D + 0.01 + grow, pw + 2*grow, TOP + 5]);
            mr_end_clip(0.3);
        }
        if (END_FRAME)
            translate([-END_FRAME_D - grow, -pg/2 - grow, -grow])
                cube([END_FRAME_D + 0.01 + grow, pg + 2*grow, ED_Z + ED_H + inch(END_FRAME_HEADER_IN) + 2*grow]);
        if (END_SILL_H_IN > 0) intersection() {
            translate([-END_SILL_D - grow, -W, -grow]) cube([END_SILL_D + 0.01 + grow, 2*W, inch(END_SILL_H_IN) + 2*grow]);
            mr_end_clip(0.3);
        }
    }
}

// ---------- roof ribs and vents (from the Walthers HO 1948 cars) ----------
function mr_roof_z(y) = HS + RR * sqrt(max(0, 1 - pow(y / (W/2), 2)));    // outer roof height at offset y

RIB_X0 = ft(0.5);
RIB_X1 = min(L - (TAIL > 0 ? TAIL : ft(0.5)), END_B == "skytop" ? SKY_XD - ft(0.5) : L);

module mr_roof_ribs() {             // raised half-round ribs running along the roof + a seam near each end
    if (ROOF_RIBS > 0) {
        ym = W/2 * ROOF_RIB_SPAN;
        for (k = [0:1:ROOF_RIBS-1]) {
            y = ROOF_RIBS == 1 ? 0 : -ym + k * 2 * ym / (ROOF_RIBS - 1);
            difference() {
                translate([RIB_X0, y, mr_roof_z(y)]) rotate([0, 90, 0]) cylinder(r = ROOF_RIB_R, h = RIB_X1 - RIB_X0, $fn = 12);
                if (DOME) translate([DS, -W, 0]) cube([DE - DS, 2*W, TOP + 5]);
            }
        }
        if (ROOF_RIB_END_FT > 0)
            for (xs = TAIL > 0 ? [ft(ROOF_RIB_END_FT)] : [ft(ROOF_RIB_END_FT), L - ft(ROOF_RIB_END_FT)])
                intersection() {
                    difference() { mr_body_solid(-ROOF_RIB_R, 0); mr_body_solid(0.01, 0); }
                    translate([xs - ROOF_RIB_R, -ym - ROOF_RIB_R, ROOF_Z + 1]) cube([2 * ROOF_RIB_R, 2 * (ym + ROOF_RIB_R), TOP]);
                }
    }
}

// roof vent with a screened (mesh) face: [x_ft, y_in, face]  face = +1 mesh toward +Y, -1 toward -Y
module mr_vent_shape(vl, vw, vh, face) {        // origin: centre of the vent at its lowest roof point
    r = min(vw * 0.45, vh * 0.6);
    hull() {
        translate([-vl/2, -vw/2, -3]) cube([vl, vw, 3]);                                      // base, sunk into the roof
        translate([-vl/2, face > 0 ? vw/2 - 0.01 : -vw/2, 0]) cube([vl, 0.01, vh]);          // flat mesh face
        translate([-vl/2, -face * (vw/2 - r), vh - r]) rotate([0, 90, 0]) cylinder(r = r, h = vl, $fn = 24);
    }
}

module mr_vent_mesh2d(pw, ph) {                 // crosshatch screen, 2D (x along the car, y up)
    p = 0.7; t = 0.22;
    intersection() {
        square([pw, ph]);
        for (a = [45, -45]) rotate(a)
            for (i = [-60:1:60]) translate([-50, i * p]) square([100, t]);
    }
}

module mr_roof_vents() {
    vl = inch(VENT_L_IN); vw = inch(VENT_W_IN); vh = inch(VENT_H_IN);
    m = 0.45; dep = 0.35;
    for (v = ROOF_VENTS) {
        y = inch(v[1]); face = v[2];
        difference() {
            translate([ft(v[0]), y, mr_roof_z(abs(y) + vw/2)]) {
                difference() {
                    mr_vent_shape(vl, vw, vh, face);
                    if (VENT_MESH) scale([1, face, 1])            // recessed screen panel
                        translate([-vl/2 + m, vw/2 - dep, m]) cube([vl - 2*m, dep + 1, vh - 2*m]);
                }
                if (VENT_MESH) scale([1, face, 1])                // the screen itself
                    translate([-vl/2 + m, vw/2 - 0.01, m]) rotate([90, 0, 0])
                        linear_extrude(dep) mr_vent_mesh2d(vl - 2*m, vh - 2*m);
            }
            mr_body_solid(WALL, -5);                                  // keep the ceiling clear
        }
    }
}

// roof housing / vent: [x0_ft, x1_ft, w_in, h_in, y_in]  (y_in = offset from the centre line, optional)
module mr_roof_housings() {
    for (h = ROOF_HOUSINGS) {
        hw = inch(h[2]);
        yo = len(h) > 4 ? inch(h[4]) : 0;
        difference() {
            translate([ft(h[0]), yo - hw/2, HT - RR * 0.5]) cube([ft(h[1]) - ft(h[0]), hw, RR * 0.5 + inch(h[3])]);
            mr_body_solid(WALL, -5);
        }
    }
}

module mr_door_cuts() {
    for (d = CUT_DOORS)
        translate([ft(d[0]) - inch(d[1])/2, -W, inch(d[3])])
            cube([inch(d[1]), 2*W, inch(d[2])]);
    if (END_DOORS) mr_end_door_cuts();
    mr_plat_end_windows();
}

// ---------- end doors + diaphragms ----------
// END_DOOR_STYLE "closed": the door sits recessed END_DOOR_RECESS mm in the end sheet
// (optional window); "open": a doorway cut right through.
ED_W = inch(END_DOOR_W_IN);
ED_H = inch(END_DOOR_H_IN);
ED_Z = inch(END_DOOR_SILL_IN);
function mr_end_list() = TAIL == 0 ? [0, 1] : [0];      // 0 = A end, 1 = B end
function mr_plat_end(e) = (e == 1 && PLAT > 0) || (e == 0 && PLATA > 0);           // the end wall behind an open platform: plain (no ribs / posts), door with a square window

module mr_at_end(e) {             // children built for the A end (x <= 0, pointing -X); mirrored for B
    if (e == 0) children();
    else translate([L, 0, 0]) mirror([1, 0, 0]) children();
}

module mr_end_door_cuts() {
    depth = END_DOOR_STYLE == "open" ? WALL + 1 : END_DOOR_RECESS;
    for (e = mr_end_list()) mr_at_end(e)
        translate([-3, -ED_W/2, ED_Z]) cube([3 + depth, ED_W, ED_H]);
    mr_end_door_windows();
}

module mr_end_door_windows() {   // "rect" window in the upper door, or a round "porthole"
    if (END_DOOR_STYLE != "open" && END_DOOR_WINDOW)
        for (e = mr_end_list()) mr_at_end(e)
            if (END_DOOR_WINDOW_SHAPE == "porthole" && !mr_plat_end(e))
                translate([-3, 0, inch(END_DOOR_PORT_Z_IN)]) rotate([0, 90, 0])
                    cylinder(d = inch(END_DOOR_PORT_IN), h = WALL + 4, $fn = 40);
            else
                translate([-3, -ED_W * 0.3, ED_Z + inch(44)]) cube([WALL + 4, ED_W * 0.6, inch(24)]);
}

module mr_diaphragms(grow = 0) {  // raised frame around each end door
    if (END_DOORS && END_DIAPHRAGM) {
        fw = inch(DIAPHRAGM_W_IN);
        top = min(inch(DIAPHRAGM_TOP_IN), ROOF_Z - 0.5);
        for (e = mr_end_list()) if (!mr_plat_end(e)) mr_at_end(e)   // no diaphragm on an open platform
            difference() {
                translate([-DIAPHRAGM_D - grow, -ED_W/2 - fw - grow, ED_Z - grow])
                    cube([DIAPHRAGM_D + 0.01 + grow, ED_W + 2*fw + 2*grow, top - ED_Z + 2*grow]);
                translate([-DIAPHRAGM_D - 2, -ED_W/2 + grow, ED_Z - 1]) cube([DIAPHRAGM_D + 4, ED_W - 2*grow, ED_H + 1 - grow]);
            }
    }
}

FL_X0 = ft(1.5);
FL_X1 = (NOSE_ON && END_B == "round") ? ft(NOSE_SRC[0][0]) - ft(1) : L - (TAIL > 0 ? TAIL : ft(1.5));   // round tail with an outline: mr_fins carries the ribs on

FLUTE_DOOR_GAP_IN = 2;     // ribs / flutes stop this far short of a side door (door frame)
module mr_flutes(add) {
    if (FLUTE_COUNT > 0 && ((FLUTES == "rib" && add) || (FLUTES == "groove" && !add)))
        difference() {
            for (k = [0:1:FLUTE_COUNT-1]) for (s = [1, -1]) scale([1, s, 1])
                if (add && FLUTE_ROUND)          // rounded rib: half an ellipse standing FLUTE_D proud of the side
                    translate([FL_X0, W/2 - 0.01, inch(FLUTE_Z0_IN + k * FLUTE_PITCH_IN) + inch(FLUTE_H_IN) / 2])
                        scale([1, FLUTE_D / (inch(FLUTE_H_IN) / 2), 1]) rotate([0, 90, 0]) cylinder(r = inch(FLUTE_H_IN) / 2, h = FL_X1 - FL_X0, $fn = 24);
                else
                translate([FL_X0, add ? W/2 - 0.01 : W/2 - FLUTE_D, inch(FLUTE_Z0_IN + k * FLUTE_PITCH_IN)])
                    cube([FL_X1 - FL_X0, add ? FLUTE_D + 0.01 : FLUTE_D + 1, inch(FLUTE_H_IN)]);
            for (d = concat(ALL_PANELS, CUT_DOORS)) {                 // not across the doors
                side = len(d) > 4 ? d[4] : 0;
                g = inch(FLUTE_DOOR_GAP_IN);
                for (sd = side == 0 ? [1, -1] : [side]) scale([1, sd, 1])
                    translate([ft(d[0]) - inch(d[1])/2 - g, 0, inch(d[3]) - g]) cube([inch(d[1]) + 2*g, W, inch(d[2]) + 2*g]);
            }
        }
}

// 1938 Kuhler finned Beaver Tail (TDQ-272): the side ribs carry on round the tail, bending down to
// follow its outline, and deep fins wrap the tail over the rear windows (Mitchell builder photo, 1938).
// Ribs: bands parallel to the side outline, FLUTE_D proud. Fins: level bands, TAIL_FIN_D_IN proud.
// Only for END_B = "round" with a TAIL_PTS outline; the straight ribs (mr_flutes) stop where these begin.
function mr_tail_sil() = concat(
    [[-ft(200), -ft(20)], [-ft(200), HT]],
    [for (p = NOSE_SRC) [ft(p[0]), ft(p[1])]],
    [[ft(NOSE_SRC[len(NOSE_SRC) - 1][0]) + 1, -ft(20)]]);
module mr_tail_bands(zs, h, d, x0) {
    intersection() {
        difference() { mr_body_solid(-d, 0); mr_body_solid(WALL / 2, -5); }   // reaches half into the wall: always fused to it
        translate([x0, -W, -1]) cube([L + 5 - x0, 2*W, TOP + 5]);
        rotate([90, 0, 0]) linear_extrude(2*W, center = true)
            for (zb = zs) difference() {
                offset(delta = -(HT - zb - h)) polygon(mr_tail_sil());
                offset(delta = -(HT - zb)) polygon(mr_tail_sil());
            }
    }
}
module mr_fins() {
    if (REAR_FINS && NOSE_ON && END_B == "round") {
        if (FLUTES == "rib" && FLUTE_COUNT > 0)          // side ribs carried round the tail
            mr_tail_bands([for (k = [0:1:FLUTE_COUNT-1]) inch(FLUTE_Z0_IN + k * FLUTE_PITCH_IN)],
                          inch(FLUTE_H_IN), FLUTE_D, ft(NOSE_SRC[0][0]) - ft(2));
        if (len(TFIN_Z_L) > 0)                            // the Kuhler fins, level, wrapped round the tail
            intersection() {
                d = inch(TFIN_D_L);
                difference() { mr_body_solid(-d, 0); mr_body_solid(WALL / 2, -5); }
                translate([ft(TFIN_X0_L), -W, 0]) cube([L + 5 - ft(TFIN_X0_L), 2*W, TOP + 5]);
                for (z = TFIN_Z_L) translate([-5, -W, inch(z)]) cube([L + 10, 2*W, inch(TFIN_H_L)]);
            }
    }
}

SKY_X0 = (END_B == "skytop") ? (SKY_START_FT > 0 ? ft(SKY_START_FT) : L - TAIL) : L;

SKY_WIN_R = inch(4);                       // corner radius of the solarium windows
module mr_sky_win(w) {
    r  = SKY_WIN_R;
    z0 = inch(w[3]) + r; z1 = inch(w[4]) - r;
    if (w[0] == "p") {                                // plan sector on the sloping top of the tail
        xc = L - TAIL;
        R  = 2 * W;
        translate([0, 0, inch(w[3])]) linear_extrude(TOP + 10)
            offset(r = r) offset(delta = -r) intersection() {
                translate([xc, 0]) polygon(concat([[0, 0]],
                    [for (i = [0:8]) let(a = w[1] + (w[2] - w[1]) * i / 8) [R * sin(a), R * cos(a)]]));
                difference() { translate([xc - R, -R]) square(2 * R); translate([xc, 0]) circle(r = inch(w[4]), $fn = 64); }
            }
    }
    else if (w[0] == "x")
        hull() for (x = [ft(w[1]) + r, ft(w[2]) - r], z = [z0, z1])
            translate([x, W * 0.2, z]) rotate([-90, 0, 0]) cylinder(r = r, h = W, $fn = 16);
    else {
        xc = L - TAIL;
        b  = W / 2;
        d  = r / b * 180 / PI;                           // corner radius as an angle at the side
        hull() for (a = [w[1] + d, w[2] - d], z = [z0, z1])
            translate([xc, 0, z]) rotate([0, 0, 90 - a]) translate([b * 0.3, 0, 0])
                rotate([0, 90, 0]) cylinder(r = r, h = W, $fn = 16);
    }
}

module mr_skytop_cuts() {
    // Skytop solarium: glazing between curved mullions that run up the sides and over the roof.
    //   SKY_SILL_IN  : bottom of the glass (0 = 45% of the side height)
    //   SKY_SPINE_IN : solid strip left along the roof centre line (0 = none)
    //   SKY_MULLION  : mullion width as a fraction of SKY_PITCH_IN
    // With SKY_PANES the glass is laid out pane by pane instead:
    //   SKY_PANES       : side-elevation polygons [[x_ft, z_in], ...], cut through both sides
    //   SKY_REAR_PANES  : [y0_in, y1_in, z0_in, z1_in, from_x_ft]  cut rearward through the nose
    //   SKY_CROWN_PANES : [x0_ft, x1_ft, y0_in, y1_in, z0_in]      cut down through the roof crown
    //   SKY_WINS : rounded windows laid out round the tail, mirrored to both sides:
    //     ["x", x0_ft, x1_ft, z0_in, z1_in]      on the straight side, cut square through the side
    //     ["a", a0_deg, a1_deg, z0_in, z1_in]    round the tail: angle from the side (0) to the rear
    //                                            centre line (90) about the start of the tail rounding,
    //                                            so the mullions run radially like the real car
    //     ["p", a0_deg, a1_deg, z0_in, rin_in]   on the sloping top of the tail: a sector seen from above,
    //                                            same angles, from rin out, cut down to z0 (frames follow
    //                                            the slope up to a ring round the roof centre panes)
    if (END_B == "skytop" && (len(SKY_PANES) > 0 || len(SKY_WINS) > 0)) {
        for (s = [1, -1]) scale([1, s, 1]) for (w = SKY_WINS) mr_sky_win(w);
        for (pn = SKY_PANES) rotate([90, 0, 0]) linear_extrude(2*W + 2, center = true)
            polygon([for (q = pn) [ft(q[0]), inch(q[1])]]);
        for (r = SKY_REAR_PANES)
            translate([ft(r[4]), inch(r[0]), inch(r[2])]) cube([L + 20 - ft(r[4]), inch(r[1] - r[0]), inch(r[3] - r[2])]);
        for (c = SKY_CROWN_PANES)
            translate([ft(c[0]), inch(c[2]), inch(c[4])]) cube([ft(c[1] - c[0]), inch(c[3] - c[2]), TOP]);
    }
    else if (END_B == "skytop") {
        p  = inch(SKY_PITCH_IN);
        n  = floor((L - SKY_X0) / p);
        z0 = SKY_SILL_IN > 0 ? inch(SKY_SILL_IN) : HS * 0.45;
        if (n > 0)
            for (k = [0:1:n-1])
                difference() {      // the last bay runs out through the tip of the tail
                    translate([SKY_X0 + k*p + p*SKY_MULLION, -W, z0])
                        cube([(k == n-1 ? L + 5 - (SKY_X0 + k*p + p*SKY_MULLION) : p * (1 - SKY_MULLION)), 2*W, TOP]);
                    if (SKY_SPINE_IN > 0) translate([SKY_X0 - 1, -inch(SKY_SPINE_IN)/2, HS]) cube([L, inch(SKY_SPINE_IN), TOP]);
                }
    }
}

// preview only: tinted glass over the skytop solarium (the print leaves these open for clear sheet)
module mr_skytop_glass() {
    if (END_B == "skytop") {
        z0 = SKY_SILL_IN > 0 ? inch(SKY_SILL_IN) : HS * 0.45;
        render() intersection() {
            difference() { mr_body_solid(0.5, 0); mr_body_solid(1.1, -5); }
            if (len(SKY_PANES) > 0) mr_skytop_cuts();
            else translate([SKY_X0, -W, z0]) cube([L + 5 - SKY_X0, 2*W, TOP]);
        }
    }
}

// ---------- STEP BOXES (printed separately, screwed up under the floor) ----------
// Local frame of one box: x along the car (centred on the door), u = in from the car side, z as the car.
// Treads step inwards as they rise: bottom tread at the side line, top tread deepest in, closed risers.
STEP_TREAD = inch(STEP_TREAD_IN);
STEP_Z0    = RAIL_TOP + inch(STEP_BOTTOM_IN);                   // top of the bottom tread
STEP_RISE  = (FLOOR_T - STEP_Z0) / STEP_N;                      // vestibule floor top -> bottom tread
function mr_step_z(k) = FLOOR_T - k * STEP_RISE;                // top of tread k (1 = top ... STEP_N = bottom)
STEP_UB    = STEP_N * STEP_TREAD;                               // back plate, in from the side
STEP_ZB    = mr_step_z(STEP_N) - STEP_T;                        // underside of the bottom tread
STEP_FL_T  = 3.0;                                               // flange thickness
function mr_step_w(e) = e[1] + inch(2);                         // box width: door + cheeks
function mr_step_holes(e) = [for (i = [-1, 1]) [i * (mr_step_w(e)/2 - 4.5), STEP_UB + STEP_T + STEP_FLANGE/2 + 0.3]];
// a door within 5 ft of a car end: the box runs out to the end sheet and closes with a shield plate there
function mr_step_shield(e) = !STEP_SHIELDS || e[0] > L ? 0 : e[0] < ft(5) ? -1 : (e[0] > L - ft(5) ? 1 : 0);   // platform steps (x > L): cheeks both sides
function mr_step_xa(e) = mr_step_shield(e) == -1 ? -e[0] + 0.4 : -mr_step_w(e)/2;        // local x range of the box
function mr_step_xb(e) = mr_step_shield(e) == 1 ? L - e[0] - 0.4 : mr_step_w(e)/2;
module mr_step_shield2d() {                                     // X = u (in from the side), Y = z
    polygon([[0, 0], [0, STEP_ZB], [STEP_UB * 0.3, STEP_ZB], [STEP_UB + STEP_T, STEP_ZB * 0.45], [STEP_UB + STEP_T, 0]]);
}

module mr_step_profile() {                                      // 2D: X = u (in from the side), Y = z
    for (k = [1:1:STEP_N]) {
        uo = (STEP_N - k) * STEP_TREAD;
        translate([uo, mr_step_z(k) - STEP_T]) square([STEP_TREAD + STEP_T, STEP_T]);               // tread
        if (k < STEP_N) translate([uo, mr_step_z(k + 1) - 0.01]) square([STEP_T, mr_step_z(k) - mr_step_z(k + 1)]);  // riser
    }
    translate([STEP_UB, mr_step_z(1) - STEP_T]) square([STEP_T, STEP_T - mr_step_z(1)]);            // back plate
    translate([STEP_UB, -STEP_FL_T]) square([STEP_T + STEP_FLANGE, STEP_FL_T]);                     // mounting flange
}
module mr_step_box(e) {                                         // one box in its local frame
    xa = mr_step_xa(e); xb = mr_step_xb(e); sh = mr_step_shield(e);
    difference() {
        union() {
            translate([xa, 0, 0]) rotate([90, 0, 90]) linear_extrude(xb - xa) mr_step_profile();
            for (i = [-1, 1]) let(xc = i < 0 ? xa : xb - STEP_T)
                if (sh == i) translate([xc, 0, 0]) rotate([90, 0, 90]) linear_extrude(STEP_T) mr_step_shield2d();   // end shield
                else translate([xc, 0, STEP_ZB]) cube([STEP_T, STEP_UB + STEP_T, -STEP_ZB]);                          // cheek
        }
        for (h = mr_step_holes(e)) translate([h[0], h[1], -STEP_FL_T - 1]) cylinder(d = STEP_PILOT, h = STEP_FL_T + 2, $fn = 16);
    }
}
module mr_at_step(e) { translate([e[0], e[2] * W/2, 0]) scale([1, -e[2], 1]) children(); }
module mr_step_boxes(grow = 0) {                                // all boxes where they sit on the car
    for (e = STEP_ITEMS) mr_at_step(e)
        if (grow == 0) mr_step_box(e);
        else translate([mr_step_xa(e) - grow, -1, STEP_ZB - grow]) cube([mr_step_xb(e) - mr_step_xa(e) + 2*grow, STEP_UB + STEP_T + STEP_FLANGE + 1 + grow, -STEP_ZB + grow]);
}
module mr_step_floor_holes() {                                  // screws go down through the floor into the flange
    for (e = STEP_ITEMS) mr_at_step(e) for (h = mr_step_holes(e)) translate([h[0], h[1], 0]) {
        translate([0, 0, -1]) cylinder(d = FLOOR_CLEAR_D, h = FLOOR_T + 2, $fn = 16);
        translate([0, 0, FLOOR_T - 1.8]) cylinder(d = FLOOR_HEAD_D, h = 2, $fn = 20);             // head sits flush
    }
}
module mr_grab_holes() {                                        // through the side, beside each vestibule door
    if (GRAB_HOLES) for (e = STEP_ITEMS) mr_at_step(e)
        for (i = [-1, 1], z = GRAB_Z_IN) translate([i * (e[1]/2 + inch(GRAB_OFFSET_IN)), -1, inch(z)])
            rotate([-90, 0, 0]) cylinder(d = GRAB_HOLE_D, h = WALL + 2, $fn = 12);
}
module mr_steps_print() {                                       // every box on its cheek, treads in plane - no supports
    if (len(STEP_ITEMS) > 0) for (i = [0:1:len(STEP_ITEMS) - 1]) let(e = STEP_ITEMS[i])
        translate([10 - STEP_ZB, 10 + i * (STEP_UB + STEP_FLANGE + 12), mr_step_xb(e)]) rotate([0, 90, 0]) mr_step_box(e);
}
// warn if a truck could swing into a box on a curve
STEP_TRUCK_R = sqrt(pow(max(ft(TRUCK_WHEELBASE_FT)/2 + inch(WHEEL_D_IN)/2 + 5, mr_truck_half(TRUCK_AXLES, ft(TRUCK_WHEELBASE_FT)) + 2), 2) + pow(GAUGE/2 + 14, 2));
for (e = STEP_ITEMS, tc = TRUCK_CENTERS_FT)
    if (abs(ft(tc) - e[0]) - mr_step_w(e)/2 < STEP_TRUCK_R)
        echo(str("WARNING: step box at ", e[0] / ft(1), " ft is inside the truck swing circle - check on curves"));

// ---------- END DETAILS: corner grab-iron holes, hand-brake wheel (De Karske end views) ----------
module mr_end_grab_holes() {                                    // through the end sheet at both corners
    if (END_GRABS) for (e = mr_end_list()) mr_at_end(e)
        for (s = [-1, 1], z = END_GRAB_Z_IN) translate([-1, s * (W/2 - inch(END_GRAB_Y_IN)), inch(z)])
            rotate([0, 90, 0]) cylinder(d = GRAB_HOLE_D, h = WALL + 2, $fn = 12);
}
// brake wheel on the B end when it is a plain end, otherwise on the A end; left side as you face that end
BW_END = (TAIL == 0 && END_B != "platform") ? 1 : 0;
module mr_brake_wheel(grow = 0) {
    if (BRAKE_WHEEL && END_DOORS) mr_at_end(BW_END) {
        y = (BW_END == 0 ? 1 : -1) * ft(BRAKE_WHEEL_Y_FT);
        r = inch(BRAKE_WHEEL_D_IN) / 2; z = inch(BRAKE_WHEEL_Z_IN); xo = -inch(5);
        if (!BRAKE_WHEEL_SEPARATE) translate([xo, y, z]) rotate([0, 90, 0]) mr_bw_wheel(r, grow);   // printed on the body
        if (!BRAKE_WHEEL_SEPARATE) translate([xo, y, z]) rotate([0, 90, 0]) cylinder(r = 0.6 + grow, h = -xo + 0.5, $fn = 12);          // shaft into the end
        translate([xo + 1.6, y, 0.2]) cylinder(r = 0.5 + grow, h = z - 0.2, $fn = 12);                        // brake staff down the end
        translate([xo + 1.6, y, z * 0.35]) rotate([0, -90, 0]) cylinder(r = 0.5 + grow, h = -xo - 1.1, $fn = 10);  // staff bracket
    }
}
module mr_bw_wheel(r, grow = 0) {                         // rim, three spokes and hub, centred on the axis (along z)
    difference() { cylinder(r = r + grow, h = 0.9 + 2*grow, center = true, $fn = 48); cylinder(r = r - 1.3 - grow, h = 3, center = true, $fn = 48); }   // rim
    for (a = [0, 60, 120]) rotate([0, 0, a]) cube([2 * r - 1, 0.9 + 2*grow, 0.9 + 2*grow], center = true);                                     // spokes
    cylinder(r = 1.4 + grow, h = 1.6 + 2*grow, center = true, $fn = 20);                                                                        // hub
}
module mr_brake_wheel_hole() {                            // TDQ-291: hole in the end sheet for the separate wheel's peg
    if (BRAKE_WHEEL && END_DOORS && BRAKE_WHEEL_SEPARATE) mr_at_end(BW_END) {
        y = (BW_END == 0 ? 1 : -1) * ft(BRAKE_WHEEL_Y_FT);
        translate([-1, y, inch(BRAKE_WHEEL_Z_IN)]) rotate([0, 90, 0]) cylinder(d = BW_HOLE_D, h = WALL + 1.01, $fn = 16);
    }
}
module mr_brake_wheel_part() {                            // the separate wheel: face down on the bed, peg straight up
    r = inch(BRAKE_WHEEL_D_IN) / 2;
    translate([0, 0, 0.8]) mr_bw_wheel(r);
    cylinder(d = BW_PEG_D, h = inch(5) + WALL - 0.3, $fn = 16);          // peg: reaches through the hub into the hole
}
module mr_brake_wheel_placed() {                          // the separate wheel shown in place (assembly picture)
    if (BRAKE_WHEEL && END_DOORS && BRAKE_WHEEL_SEPARATE) mr_at_end(BW_END) {
        y = (BW_END == 0 ? 1 : -1) * ft(BRAKE_WHEEL_Y_FT);
        translate([-inch(5), y, inch(BRAKE_WHEEL_Z_IN)]) rotate([0, 90, 0]) { mr_bw_wheel(inch(BRAKE_WHEEL_D_IN) / 2); cylinder(d = BW_PEG_D, h = inch(5) + WALL - 0.3, $fn = 16); }
    }
}

// ---------- FLOOR FIXING: ledge + screw bosses ----------
FS_Y  = W/2 - WALL - FLOOR_BOSS/2 - 0.5;                    // screw line, 4.5 mm in from the side walls
FS_X1 = L - (TAIL > 0 ? TAIL + 10 : FLOOR_SCREW_END);
FS_N  = max(2, ceil((FS_X1 - FLOOR_SCREW_END) / FLOOR_SCREW_PITCH) + 1);
function mr_fs_blocked(x) = len([for (d = CUT_DOORS) if (abs(x - ft(d[0])) < inch(d[1])/2 + FLOOR_BOSS) 1])
                          + len([for (d = DOOR_PANELS) if (mr_dp_recess(d) > 0 && abs(x - ft(d[0])) < inch(d[1])/2 + mr_dp_recess(d) + FLOOR_BOSS) 1]) > 0;
FS_X  = [for (i = [0:1:FS_N - 1]) let(x = FLOOR_SCREW_END + i * (FS_X1 - FLOOR_SCREW_END) / (FS_N - 1)) if (!mr_fs_blocked(x)) x];
FLOOR_SCREWS = [for (x = FS_X, s = [-1, 1]) [x, s * FS_Y]];

module mr_floor_ledge() {
    difference() {
        intersection() {
            difference() { mr_body_solid(WALL - 0.3, 0); mr_body_solid(WALL + FLOOR_LEDGE_W, -5); }
            translate([-10, -W, FLOOR_T]) cube([L + 20, 2*W, FLOOR_LEDGE_H]);
        }
        for (d = DOOR_PANELS) if (mr_dp_recess(d) > 0)            // clear of recessed sliding doors
            translate([ft(d[0]) - inch(d[1])/2 - 1, -W, 0]) cube([inch(d[1]) + 2, 2*W, FLOOR_T + FLOOR_LEDGE_H + 1]);
        for (d = CUT_DOORS) translate([ft(d[0]) - inch(d[1])/2, -W, 0]) cube([inch(d[1]), 2*W, 20]);
    }
    for (p = FLOOR_SCREWS) {                                     // bosses on the wall, 45 deg top so they print
        s = sign(p[1]);
        translate([p[0], 0, FLOOR_T]) scale([1, s, 1]) difference() {
            hull() {
                translate([-FLOOR_BOSS/2, W/2 - WALL - FLOOR_BOSS - 1, 0]) cube([FLOOR_BOSS, FLOOR_BOSS + 1.5, FLOOR_BOSS_H - FLOOR_BOSS - 1]);
                translate([-FLOOR_BOSS/2, W/2 - WALL - 0.1, FLOOR_BOSS_H - 0.1]) cube([FLOOR_BOSS, 0.4, 0.1]);
            }
            translate([0, FS_Y, -1]) cylinder(d = FLOOR_PILOT, h = FLOOR_BOSS_H - 2, $fn = 16);
        }
    }
}
module mr_floor_screw_holes() {                                  // through the floor and anything under it
    for (p = FLOOR_SCREWS) translate([p[0], p[1], 0]) {
        translate([0, 0, -1]) cylinder(d = FLOOR_CLEAR_D, h = FLOOR_T + 2, $fn = 16);
        translate([0, 0, -60]) cylinder(d = FLOOR_HEAD_D, h = 60 + 1.6, $fn = 20);
    }
}
module mr_floor_boss_clear() {                                   // keeps the interior off the bosses and ledge
    for (p = FLOOR_SCREWS) translate([p[0] - FLOOR_BOSS/2 - 0.6, p[1] > 0 ? W/2 - WALL - FLOOR_BOSS - 1.6 : -W/2, FLOOR_T - 0.1])
        cube([FLOOR_BOSS + 1.2, FLOOR_BOSS + WALL + 2.2, FLOOR_BOSS_H + 0.8]);
}

// ---------- the complete shell (before splitting) ----------
module mr_shell_full() {
    difference() {
        union() {
            difference() {
                union() {
                    difference() { mr_outer(); mr_inner(); }
                    mr_collars();
                    mr_flutes(true);
                    mr_fins();
                    mr_end_details();
                    mr_diaphragms();
                    mr_marker_boss();
                    mr_sky_flutes();
                    mr_win_sockets();
                    mr_floor_ledge();
                    mr_brake_wheel();
                }
                mr_door_recess_openings();
            }
            mr_door_recess_parts();
        }
        mr_window_cuts();
        mr_marker_led_hole();
        mr_door_cuts();
        mr_flutes(false);
        mr_skytop_cuts();
        mr_joint_pins();
        mr_door_panels();
        mr_grab_holes();
        mr_end_grab_holes();
        mr_brake_wheel_hole();
        mr_coupler_clear();
    }
}

// ---------- roof fixing: lip + magnets ----------
MAG_R  = MAG_D / 2 + 1.2;                         // boss radius
MAG_Y  = W/2 - WALL - CLEAR - MAG_R;              // magnet centre line
MAG_ZB = ROOF_Z - ROOF_LIP_H - CLEAR;             // top of the body's magnet block
MAG_BD = W/2 - WALL - (MAG_Y - MAG_R) + 0.01;     // block depth from the wall

module mr_roof_lip() {
    // lip that drops inside the body walls
    intersection() {
        difference() { mr_body_solid(WALL + CLEAR, -5); mr_body_solid(WALL + CLEAR + ROOF_LIP_T, -5); }
        translate([-10, -W, ROOF_Z - ROOF_LIP_H]) cube([L + 20, 2*W, ROOF_LIP_H + 0.01]);
    }
    // band tying the lip to the roof shell
    intersection() {
        difference() { mr_body_solid(WALL - 0.01, -5); mr_body_solid(WALL + CLEAR + ROOF_LIP_T, -5); }
        translate([-10, -W, ROOF_Z]) cube([L + 20, 2*W, 3]);
    }
}

module mr_magnet_blocks() {       // on the body, under the roof lip (45 deg gusset, prints without support)
    if (MAGNETS) for (x = MAGNET_X_FT) for (s = [1, -1]) scale([1, s, 1])
        hull() {
            translate([ft(x) - MAG_R, W/2 - WALL - MAG_BD + 0.01, MAG_ZB - MAG_H - 1.5])
                cube([2 * MAG_R, MAG_BD, MAG_H + 1.5]);
            translate([ft(x) - MAG_R, W/2 - WALL - 0.01, MAG_ZB - MAG_H - 1.5 - MAG_BD])
                cube([2 * MAG_R, 0.02, 0.1]);
        }
}

module mr_magnet_bosses() {       // on the roof, above the blocks
    if (MAGNETS) for (x = MAGNET_X_FT) for (s = [1, -1]) scale([1, s, 1])
        translate([ft(x), MAG_Y, ROOF_Z - ROOF_LIP_H]) cylinder(r = MAG_R, h = ROOF_LIP_H + 3);
}

module mr_magnet_pockets() {
    if (MAGNETS) for (x = MAGNET_X_FT) for (s = [1, -1]) scale([1, s, 1]) {
        translate([ft(x), MAG_Y, MAG_ZB - MAG_H]) cylinder(d = MAG_D, h = MAG_H + 0.01);   // body
        translate([ft(x), MAG_Y, ROOF_Z - ROOF_LIP_H - 0.01]) cylinder(d = MAG_D, h = MAG_H); // roof
    }
}

// ---------- LED lighting ----------
LED_X0 = ft(2.5);
LED_X1 = (END_B == "skytop") ? SKY_X0 - ft(1) : (TAIL > 0 ? L - TAIL : L - ft(2.5));
LED_RANGES0 = DOME ? [[LED_X0, DS - 2], [DE + 2, LED_X1]] : [[LED_X0, LED_X1]];
// ---- lighting pack position (tray inside the car) ----
function mr_pz(t, minl) = [for (z = INTERIOR_ZONES) if (z[0] == t && len(z) > 2 && ft(z[2] - z[1]) >= minl) z];
PACK_ORDER = [["toilet", EBOX_L - 12], ["kitchen", EBOX_L], ["baggage", EBOX_L], ["rpo", EBOX_L], ["rooms", EBOX_L], ["bar", EBOX_L], ["lounge", EBOX_L]];
PACK_HITS  = [for (o = PACK_ORDER) for (z = mr_pz(o[0], o[1])) z];
PACK_SAME  = len(PACK_HITS) > 0 ? [for (z = PACK_HITS) if (z[0] == PACK_HITS[0][0]) z] : [];
PACK_LMAX  = len(PACK_SAME) > 0 ? max([for (z = PACK_SAME) z[2] - z[1]]) : 0;
PACK_ZONE  = len(PACK_SAME) > 0 ? [for (z = PACK_SAME) if (z[2] - z[1] == PACK_LMAX) z][0] : [];   // the longest room of the first kind that fits
PACK_AUTO  = ELEC_BOX_X_FT <= 0 && len(PACK_ZONE) > 0;
EBOX_X = ELEC_BOX_X_FT > 0 ? ft(ELEC_BOX_X_FT) : PACK_AUTO ? ft(PACK_ZONE[1] + PACK_ZONE[2]) / 2 : L / 2;
EBOX_Y = PACK_AUTO && (PACK_ZONE[0] == "toilet" || PACK_ZONE[0] == "kitchen" || PACK_ZONE[0] == "rooms") ? inch(14) : 0;   // those rooms sit on +Y, corridor on -Y
// ---- charging coil position: above the tray, moved along the car if a roof magnet is too close ----
COIL_ON = COIL && ELEC_BOX && LED;
COIL_OK = [for (k = [0:1:60]) for (s = [1, -1]) let (x = EBOX_X + s * k * 5)
           if (x > LED_X0 + COIL_D && x < LED_X1 - COIL_D && len([for (m = MAGNET_X_FT) if (abs(ft(m) - x) < COIL_D / 2 + 12) 1]) == 0) x];
COIL_X  = len(COIL_OK) > 0 ? COIL_OK[0] : L / 2;
LED_RANGES = COIL_ON ? [for (r = LED_RANGES0) for (q = (COIL_X > r[0] && COIL_X < r[1]) ? [[r[0], COIL_X - COIL_D / 2 - 2], [COIL_X + COIL_D / 2 + 2, r[1]]] : [r]) q] : LED_RANGES0;
WIRE_X = ft(3);

module mr_led_mounts() {
    if (LED) intersection() {
        mr_body_solid(0, 0);                    // never pokes through the roof skin
        for (r = LED_RANGES) if (r[1] - r[0] > 10) {
            if (LED_STYLE == "strip") {
                for (s = [1, -1]) scale([1, s, 1]) {
                    translate([r[0], LED_W/2, CEIL_Z - LED_DEPTH - 1]) cube([r[1] - r[0], 1.2, LED_DEPTH + 1 + RR]);
                    translate([r[0], LED_W/2 - 0.5, CEIL_Z - LED_DEPTH - 1]) cube([r[1] - r[0], 0.51, 0.8]);
                }
            } else {
                p = ft(LED_SPOT_PITCH_FT);
                n = floor((r[1] - r[0]) / p);
                if (n > 0) for (k = [0:1:n-1])
                    translate([r[0] + p * (k + 0.5), 0, CEIL_Z - 4]) cylinder(d = LED_SPOT_D + 3, h = RR + 4);
            }
        }
    }
    if (COIL_ON) intersection() {                                                     // locating rim for the charging coil
        mr_body_solid(0, 0);
        translate([COIL_X, 0, CEIL_Z - COIL_RIM_H]) difference() {
            cylinder(d = COIL_D + 2.4, h = COIL_RIM_H + RR, $fn = 72);
            translate([0, 0, -1]) cylinder(d = COIL_D, h = COIL_RIM_H + RR + 2, $fn = 72);
            for (a = [0, 90]) rotate(a) translate([-COIL_D, -6, -1]) cube([2 * COIL_D, 12, COIL_RIM_H + RR + 2]);   // gaps for the LED tape and the leads
        }
    }
}

module mr_led_holes() {
    if (LED && LED_STYLE == "spots")
        for (r = LED_RANGES) if (r[1] - r[0] > 10) {
            p = ft(LED_SPOT_PITCH_FT);
            n = floor((r[1] - r[0]) / p);
            if (n > 0) for (k = [0:1:n-1])
                translate([r[0] + p * (k + 0.5), 0, CEIL_Z - 5]) cylinder(d = LED_SPOT_D, h = 5, $fn = 20);
        }
}

module mr_wire_notch() {          // lets the LED wires drop past the lip down the +Y wall
    if (LED)
        translate([WIRE_X - WIRE_D/2, W/2 - WALL - CLEAR - ROOF_LIP_T - 1, ROOF_Z - ROOF_LIP_H - 1])
            cube([WIRE_D, ROOF_LIP_T + CLEAR + 2, ROOF_LIP_H + 4.5]);
}

module mr_led_strip_visual() {    // view only
    if (LED) for (r = LED_RANGES) if (r[1] - r[0] > 10) {
        if (LED_STYLE == "strip")
            translate([r[0], -LED_W/2 + 0.6, CEIL_Z - LED_DEPTH]) cube([r[1] - r[0], LED_W - 1.2, 0.8]);
        else {
            p = ft(LED_SPOT_PITCH_FT);
            n = floor((r[1] - r[0]) / p);
            if (n > 0) for (k = [0:1:n-1])
                translate([r[0] + p * (k + 0.5), 0, CEIL_Z - 4]) sphere(d = 3);
        }
    }
}

// ---------- open observation platform (business cars) ----------
// PLAT_STYLE "basic": straight roof overhang, plain railing (branch-line cars).
// PLAT_STYLE "business": canopy and deck rounded in plan (PLAT_CORNER_IN), fascia round the canopy,
// roof marker drum (PLAT_MARKER_IN), windows in the end wall (PLAT_END_WINS), railing of horizontal
// bars (PLAT_RAIL_BARS) with a drumhead (PLAT_DRUMHEAD), end skirt below the deck (PLAT_SKIRT_IN).
PBIZ   = PLAT > 0 && PLAT_STYLE == "business";
P_RC   = PBIZ ? max(0.5, min(inch(PLAT_CORNER_IN), PLAT - 0.5, W/2 - 0.5)) : 0;
P_STEP = L + ft(2.5);                    // side openings for the platform steps run from the body to here
P_BOW  = PBIZ ? min(inch(PLAT_BOW_IN), PLAT - 0.5) : 0;      // bowed end: straight sides, then a half ellipse this deep
P_DOME = PBIZ ? min(inch(PLAT_DOME_IN), PLAT - 0.5) : 0;     // canopy roof rounds down over this length
module mr_plat_dome() {                  // side-view limit of the canopy: full height, then an elliptical drop to the fascia at the end
    zl = ROOF_Z - ROOF_LIP_H; hh = TOP - zl + 0.5; xc = L + PLAT - P_DOME;
    if (P_DOME > 0) {
        translate([L - 5, -W, zl - 1]) cube([xc - L + 5, 2 * W, hh + 50]);
        translate([xc, 0, zl]) rotate([90, 0, 0]) linear_extrude(2 * W, center = true)
            union() { scale([1.04 * P_DOME / hh, 1]) circle(r = hh, $fn = 96); translate([-1, -1]) square([1.01, hh + 50]); }
        translate([xc - 1, -W, zl - 1]) cube([P_DOME + 2, 2 * W, 1.01]);
    }
    else translate([L - 5, -W, zl - 1]) cube([PLAT + 10, 2 * W, hh + 50]);
}
module mr_plat_plan(grow = 0, x0 = L - 1) {     // 2D plan of the platform / canopy (x, y)
    r = max(0.2, P_RC + grow);
    if (P_BOW > 0) hull() {
        translate([x0, -W/2 - grow]) square([0.01, W + 2*grow]);
        translate([L + PLAT - P_BOW, 0]) scale([max(0.2, P_BOW + grow) / (W/2 + grow), 1]) circle(r = W/2 + grow, $fn = 120);
    }
    else hull() {
        translate([x0, -W/2 - grow]) square([0.01, W + 2*grow]);
        for (sy = [-1, 1]) translate([L + PLAT - P_RC, sy * (W/2 - P_RC)]) circle(r = r, $fn = 48);
    }
}
module mr_plat_ring(t, grow = 0, xa = P_STEP) {   // band of width t just inside the plan outline, from xa back
    intersection() {
        difference() { mr_plat_plan(grow); mr_plat_plan(grow - t); }
        translate([xa, -W]) square([PLAT + 10, 2*W]);
    }
}
module mr_platform_canopy() {     // roof overhang above the platform (part of the roof)
    if (PLATA > 0)
        intersection() {
            translate([-PLATA, 0, 0]) rotate([90, 0, 90]) linear_extrude(PLATA + 0.01)
                difference() { mr_profile(W, HS, RR, 0); mr_profile(W - 2*WALL, HS, RR - WALL, -5); }
            translate([-PLATA - 1, -W, ROOF_Z]) cube([PLATA + 2, 2*W, TOP]);
        }
    if (PLAT > 0 && !PBIZ)
        intersection() {
            translate([L - 0.01, 0, 0]) rotate([90, 0, 90]) linear_extrude(PLAT + 0.01)
                difference() { mr_profile(W, HS, RR, 0); mr_profile(W - 2*WALL, HS, RR - WALL, -5); }
            translate([L - 1, -W, ROOF_Z]) cube([PLAT + 2, 2*W, TOP]);
        }
    if (PBIZ) {
        intersection() {                                  // solid canopy, rounded in plan, fascia down to the lip
            translate([L - 0.01, 0, 0]) rotate([90, 0, 90]) linear_extrude(PLAT + 0.01) mr_profile(W, HS, RR, 0);
            translate([0, 0, ROOF_Z - ROOF_LIP_H]) linear_extrude(TOP) mr_plat_plan(0, L - 0.01);
            mr_plat_dome();
        }
        if (PLAT_MARKER_IN > 0) {                         // marker drum on the roof, lens to the rear
            d = inch(PLAT_MARKER_IN); xm = L + PLAT - d * 0.45; zc = HT + d/2 - inch(4);
            difference() {
                union() {
                    translate([xm, 0, zc]) rotate([0, 90, 0]) cylinder(d = d, h = d * 0.9, center = true, $fn = 48);
                    translate([xm - d * 0.35, -d * 0.3, HT - inch(P_DOME > 0 ? 18 : 6)]) cube([d * 0.7, d * 0.6, zc - HT + inch(P_DOME > 0 ? 18 : 6)]);   // saddle (deeper where the roof rounds down)
                }
                translate([xm + d * 0.45 - 0.6, 0, zc]) rotate([0, 90, 0]) cylinder(d = d * 0.72, h = 2, $fn = 40);     // lens recess
                translate([xm - d, 0, zc]) rotate([0, 90, 0]) cylinder(d = 3.2, h = 2 * d, $fn = 16);                // LED bore
            }
        }
    }
}
// glass in the platform end wall: [y_in (+Y side positive), w_in, h_in, sill_in]; corners rounded 5 in
module mr_plat_end_windows() {
    if (PLAT > 0) for (w = PLAT_END_WINS) let(ww = inch(w[1]), hh = inch(w[2]), r = min(inch(5), ww/2 - 0.1, hh/2 - 0.1))
        translate([L - WALL - 1, inch(w[0]), inch(w[3]) + hh/2]) rotate([0, 90, 0]) linear_extrude(WALL + 2)
            hull() for (a = [-1, 1], b = [-1, 1]) translate([a * (hh/2 - r), b * (ww/2 - r)]) circle(r = r, $fn = 20);
}
// steps down from each side of an open platform (basic style), printed with the floor: three treads between two stringers
module mr_plat_step_pair(pl) {
    sl = min(ft(2.3), pl - 3); x0 = 1.5; t = 1.2; n = 3; rise = inch(9); run = inch(8); yo = W/2 - 1;
    for (s = [1, -1]) scale([1, s, 1]) {
        for (k = [1:1:n]) translate([x0, yo - (n - k + 1) * run, -k * rise]) cube([sl, run, t]);
        for (xx = [x0, x0 + sl - t]) translate([xx, 0, 0]) rotate([90, 0, 90]) linear_extrude(t)
            polygon([[yo - n * run, FLOOR_T], [yo, FLOOR_T], [yo, -n * rise], [yo - run, -n * rise], [yo - n * run, -rise]]);
    }
}
module mr_plat_step_notch(pl) {     // stepwell: the deck is cut away above the treads so you walk up onto the platform
    sl = min(ft(2.3), pl - 3); x0 = 1.5; t = 1.2; n = 3; run = inch(8); yo = W/2 - 1;
    for (s = [1, -1]) scale([1, s, 1]) translate([x0 + t, yo - n * run, -1]) cube([sl - 2 * t, n * run + 5, FLOOR_T + 2]);
}
module mr_plat_wells() {
    if (PLAT_STEPS && PLAT > 0 && !PBIZ) translate([L, 0, 0]) mr_plat_step_notch(PLAT);
    if (PLAT_STEPS && PLATA > 0) mirror([1, 0, 0]) mr_plat_step_notch(PLATA);
}
module mr_plat_steps() {
    if (PLAT_STEPS && PLAT > 0 && !PBIZ) translate([L, 0, 0]) mr_plat_step_pair(PLAT);
    if (PLAT_STEPS && PLATA > 0) mirror([1, 0, 0]) mr_plat_step_pair(PLATA);
}
module mr_plat_deck() {           // platform deck (part of the floor)
    mr_plat_steps();
    difference() {
        union() {
            if (PLATA > 0) translate([-PLATA, -(W/2 - 1), 0]) cube([PLATA + WALL + CLEAR + 1, W - 2, FLOOR_T]);
            if (PLAT > 0 && !PBIZ)
                translate([L - WALL - CLEAR - 1, -(W/2 - 1), 0]) cube([PLAT + WALL + CLEAR + 1, W - 2, FLOOR_T]);
        }
        mr_plat_wells();
    }
    if (PBIZ) {
        linear_extrude(FLOOR_T) mr_plat_plan(-1, L - WALL - CLEAR - 1);
        if (PLAT_SKIRT_IN > 0)                            // end sill / skirt round the rear, notched for the coupler
            difference() {
                translate([0, 0, -inch(PLAT_SKIRT_IN)]) linear_extrude(inch(PLAT_SKIRT_IN) + 0.01) mr_plat_ring(1.6, -1);
                translate([L + PLAT - 20, -W * 0.18, -inch(PLAT_SKIRT_IN) - 1]) cube([30, W * 0.36, inch(PLAT_SKIRT_IN) + 1]);
            }
    }
}

module mr_railing_a(pl = PLATA) {   // A-end railing (basic style), drawn at the B end form and mirrored
    rh = inch(42); p = 1.2; y = W/2 - 1.6; x_end = pl - 1.2; x_step = min(ft(2.5), pl - 6);
    if (pl > 0) mirror([1, 0, 0]) translate([0, 0, FLOOR_T]) {
        translate([x_end, -y, rh - p]) cube([p, 2*y, p]);
        translate([x_end, -y, rh * 0.5]) cube([p, 2*y, p * 0.7]);
        for (yy = [-y : (2*y) / 8 : y + 0.01]) translate([x_end, yy - p/2, 0]) cube([p, p, rh]);
        for (s = [1, -1]) scale([1, s, 1]) {
            translate([x_step, y - p, rh - p]) cube([x_end - x_step, p, p]);
            translate([x_step, y - p, 0]) cube([p, p, rh]);
        }
    }
}
module mr_railing(a = true) {     // end + side railings, printed separately and glued to the deck
    if (a) mr_railing_a();
    if (PBIZ) {
        rh = inch(42); p = 1.2; n = max(2, PLAT_RAIL_BARS);
        translate([0, 0, FLOOR_T]) {
            for (k = [0:1:n]) translate([0, 0, k == 0 ? 0 : rh * k / n - p]) linear_extrude(p) mr_plat_ring(p, -1.6);   // bars
            intersection() {                                                                   // posts, ~22 mm apart
                linear_extrude(rh) mr_plat_ring(p, -1.6);
                union() {
                    for (sy = [-1, 1]) translate([P_STEP, sy * W/2 - 4, 0]) cube([p, 8, rh]);            // gate posts
                    for (yy = [-0.3, -0.1, 0.1, 0.3]) translate([L + PLAT - 5, yy * W - p/2, 0]) cube([6, p, rh]);
                    for (sy = [-1, 1]) translate([L + PLAT - P_RC, sy * (W/2 - P_RC), 0])            // corner posts at 45 deg
                        rotate([0, 0, sy * 45]) translate([0, -p/2, 0]) cube([P_RC + 2, p, rh]);
                }
            }
            if (len(PLAT_DRUMHEAD) > 2)                                                        // drumhead on the end rail
                translate([L + PLAT - 1.6 + 0.2, inch(PLAT_DRUMHEAD[0]), inch(PLAT_DRUMHEAD[2])]) rotate([0, 90, 0])
                    cylinder(d = inch(PLAT_DRUMHEAD[1]), h = 1.2, $fn = 48);
        }
    }
    else if (PLAT > 0) {
        rh = inch(42); p = 1.2; y = W/2 - 1.6;
        x_end = L + PLAT - 1.2;
        x_step = L + ft(2.5);     // steps at the sides next to the body
        translate([0, 0, FLOOR_T]) {
            translate([x_end, -y, rh - p]) cube([p, 2*y, p]);                          // end top rail
            translate([x_end, -y, rh * 0.5]) cube([p, 2*y, p * 0.7]);                  // end mid rail
            for (yy = [-y : (2*y) / 8 : y + 0.01]) translate([x_end, yy - p/2, 0]) cube([p, p, rh]);   // posts
            for (s = [1, -1]) scale([1, s, 1]) {
                translate([x_step, y - p, rh - p]) cube([x_end - x_step, p, p]);       // side top rail
                translate([x_step, y - p, 0]) cube([p, p, rh]);                        // side post
            }
        }
    }
}

// ---------- BODY, ROOF ----------
// render() makes F5 preview evaluate the real solid (fast with Manifold) instead of
// OpenCSG's z-buffer trick, which draws these deep CSG trees with the wrong colours.
module mr_body_full() {
    render() difference() {
        union() {
            intersection() {
                mr_shell_full();
                translate([-10, -W, -1]) cube([L + 20, 2*W, ROOF_Z + 1]);
            }
            mr_magnet_blocks();
        }
        mr_magnet_pockets();
    }
}

module mr_roof_full() {
    render() difference() {
        union() {
            intersection() {
                mr_shell_full();
                translate([-10, -W, ROOF_Z]) cube([L + 20, 2*W, TOP + 10]);
            }
            mr_roof_lip();
            mr_magnet_bosses();
            mr_led_mounts();
            mr_platform_canopy();
            mr_roof_housings();
            mr_roof_ribs();
            mr_roof_vents();
        }
        mr_magnet_pockets();
        mr_led_holes();
        mr_wire_notch();
        mr_door_recess_lip_clear();
        mr_skytop_cuts();
    }
}

// ---------- placing a part on the bed ----------
module mr_place(len) {
    if (DIAGONAL_PRINT && len > BED_X - PRINT_MARGIN)
        translate([BED_X / 2, BED_Y / 2, 0]) rotate(45) translate([-len / 2, 0, 0]) children();
    else children();
}

module mr_xslice(x0, x1, z0, z1, first, last) {
    translate([x0 - (first ? 10 + PLATA : 0), -W, z0])
        cube([x1 - x0 + (first ? 10 + PLATA : 0) + (last ? 10 + PLAT : 0), 2*W, z1 - z0]);
}

// place = true -> on the bed, ready to print;  false -> where it sits on the car
// one side (k = 0: -Y, 1: +Y) of body section i
module mr_xslice_side(k, i, z0, z1) {
    c = BCUTS[k]; first = i == 1; last = i == len(c) - 1;
    x0 = c[i-1] - (first ? 10 : 0); x1 = c[i] + (last ? 10 + PLAT : 0);
    translate([x0, k == 0 ? -W : 0, z0]) cube([x1 - x0, W, z1 - z0]);
}
// ---------- colour regions for multi-colour (AMS) body prints ----------
function mr_lay(z) = round(z / LAYER_H) * LAYER_H;
CP_ZB = mr_lay(inch(PAINT_SKIRT_IN));                 // top of the lower band
CP_S  = max(LAYER_H, mr_lay(PAINT_STRIPE_MM));        // pinstripe height
CP_ZT = mr_lay(ROOF_Z - 0.8);                         // bottom of the upper pinstripe
module mr_cp_ends() {                                 // the end sheets (gray in the UP scheme)
    for (e = mr_end_list()) if (!mr_plat_end(e)) mr_at_end(e)
        translate([-30, -(W/2 - PAINT_END_SKIN), -60]) cube([30 + WALL, W - 2 * PAINT_END_SKIN, TOP + 120]);
}
module mr_cp_slab(z0, z1) { if (z1 - z0 > 0.001) translate([-60 - PLATA, -W, z0]) cube([L + PLAT + PLATA + 120, 2 * W, z1 - z0]); }   // a band of no height draws nothing
// ---- Milwaukee Road orange + maroon (1947-55) painted onto the body by height ----
function mr_wshape(w) = len(w) > 5 ? w[5] : 0;
MW_RECT = [for (w = WINDOWS) if (mr_wshape(w) == 0) w];          // the band follows the ordinary (rectangular) windows
MW_SRC  = len(MW_RECT) > 0 ? MW_RECT : WINDOWS;
MW_FIT  = MILW_BAND_FIT && len(MW_SRC) > 0;
MILW_Z0 = MW_FIT ? inch(min([for (w = MW_SRC) w[3]]) - MILW_BAND_BELOW_IN) : inch(MILW_BAND_Z0_IN);          // bottom of the window band
MILW_Z1 = MW_FIT ? inch(max([for (w = MW_SRC) w[3] + w[2]]) + MILW_BAND_ABOVE_IN) : inch(MILW_BAND_Z1_IN);   // top of the window band
// letterboard lettering: in the MILW scheme it must sit on the maroon letterboard, above the orange stripe
function mr_letter_z() = (PAINT_SCHEME == "MILW" && inch(LETTER_Z_IN) < MILW_Z1 + inch(MILW_STRIPE_IN) + inch(1.2))
    ? MILW_Z1 + inch(MILW_STRIPE_IN) + inch(1.5) : inch(LETTER_Z_IN);
MILW_Z2 = MILW_Z1 + inch(MILW_STRIPE_IN);                                                                // bottom of the letterboard
module mr_body_milw() {
    color(MILW_ORANGE) render() intersection() { mr_body_full(); union() { mr_cp_slab(MILW_3 ? MILW_ZS : -60, MILW_Z0); mr_cp_slab(MILW_Z1, MILW_Z2); mr_cp_ends(); } }
    color(MILW_MAROON) render() intersection() { mr_body_full(); difference() { union() { mr_cp_slab(MILW_Z0, MILW_Z1); if (!MILW_3) mr_cp_slab(MILW_Z2, TOP + 60); } mr_cp_ends(); } }
    if (MILW_3) color(MILW_UPPER_COLOR) render() intersection() { mr_body_full(); difference() { union() { mr_cp_slab(MILW_Z2, TOP + 60); mr_cp_slab(-60, MILW_ZS); } mr_cp_ends(); } }
}
// A third body colour (MILW_UPPER_COLOR set in a car lib): the letterboard, and a band MILW_LOWER_BAND_IN high along the
// bottom of the sides, take that colour instead of the maroon / orange - e.g. the 1942 "Buy War Bonds" coach 477.
MILW_3  = MILW_UPPER_COLOR != "";
MILW_ZS = MILW_3 && MILW_LOWER_BAND_IN > 0 ? inch(MILW_LOWER_BAND_IN) : -60;
module mr_color_region(c) {
    if (c == "skirt") { mr_cp_slab(-60, CP_ZB); mr_cp_ends(); }
    else if (c == "stripe") difference() {
        union() { mr_cp_slab(CP_ZB, CP_ZB + CP_S); mr_cp_slab(CP_ZT, CP_ZT + CP_S); }
        mr_cp_ends();
    }
    else if (c == "body") difference() {
        mr_cp_slab(CP_ZB + CP_S, TOP + 60);
        mr_cp_slab(CP_ZT, CP_ZT + CP_S);
        mr_cp_ends();
    }
    // Milwaukee Road orange + maroon as two print colours (lettering and the gold are paint / decals)
    else if (c == "milw_orange") { mr_cp_slab(MILW_ZS > 0 ? mr_lay(MILW_ZS) : -60, mr_lay(MILW_Z0)); mr_cp_slab(mr_lay(MILW_Z1), mr_lay(MILW_Z2)); mr_cp_ends(); }
    else if (c == "milw_maroon") difference() {
        union() { mr_cp_slab(mr_lay(MILW_Z0), mr_lay(MILW_Z1)); if (!MILW_3) mr_cp_slab(mr_lay(MILW_Z2), TOP + 60); }
        mr_cp_ends();
    }
    else if (c == "milw_upper") { if (MILW_3) difference() {
        union() { mr_cp_slab(mr_lay(MILW_Z2), TOP + 60); if (MILW_ZS > 0) mr_cp_slab(-60, mr_lay(MILW_ZS)); }
        mr_cp_ends();
    } }
    else mr_cp_slab(-60, TOP + 60);                   // "all"
}

module mr_body_half(i, k, cp = COLOR_PART) intersection() {
    difference() { mr_body_full(); mr_body_label(i, k); }
    mr_xslice_side(k, i, -1, ROOF_Z + 1);
    mr_color_region(cp);
}
// End sections print as one piece (the end sheet ties the sides together).  A middle section is
// two separate side walls - on the bed each starts at x = 0, side by side.
module mr_body_section(i, place = true, cp = COLOR_PART) {
    if (!place) { mr_body_half(i, 0, cp); mr_body_half(i, 1, cp); }
    else if (i == 1 || i == N_BODY)
        mr_place(BODY_LENS[i-1]) translate([-min(BCUTS[0][i-1], BCUTS[1][i-1]), 0, 0]) { mr_body_half(i, 0, cp); mr_body_half(i, 1, cp); }
    else for (k = [0, 1]) translate([-BCUTS[k][i-1], 0, 0]) mr_body_half(i, k, cp);
}
module mr_body_section_colours(i, place = true) {       // the section as an AMS print (MILW: orange + maroon; UP: three colours)
    if (PAINT_SCHEME == "MILW") {
        color(MILW_ORANGE) render() mr_body_section(i, place, "milw_orange");
        color(MILW_MAROON) render() mr_body_section(i, place, "milw_maroon");
        if (MILW_3) color(MILW_UPPER_COLOR) render() mr_body_section(i, place, "milw_upper");
    } else {
        color(PAINT_BODY)   render() mr_body_section(i, place, "body");
        color(PAINT_SKIRT)  render() mr_body_section(i, place, "skirt");
        color(PAINT_STRIPE) render() mr_body_section(i, place, "stripe");
    }
}

module mr_roof_section(i, place = true) {
    x0 = RCUT[i-1]; x1 = RCUT[i];
    if (place)       // prints upright, standing on the lip
        mr_place(x1 - x0 + (i == 1 ? PLATA : 0)) translate([-x0 + (i == 1 ? PLATA : 0), 0, -(ROOF_Z - ROOF_LIP_H)]) mr_roof_section(i, false);
    else intersection() { difference() { mr_roof_full(); mr_roof_label(i); } mr_xslice(x0, x1, ROOF_Z - ROOF_LIP_H - 1, TOP + 10 + (PBIZ ? inch(PLAT_MARKER_IN) : 0), i == 1, i == N_BODY); }
}

// ---------- FLOOR ----------
// ---------- COUPLER MOUNTS (both ends) ----------
// The gearbox sits under the floor at each end with the coupler at COUPLER_Z_IN above the rail.
// If that puts the gearbox top above the floor underside, a pocket is cut into the floor and the
// bottom of the end sheet.
CPL_CZ  = inch(COUPLER_Z_IN) - ft(RAIL_TO_SILL_FT);          // coupler centre in car coordinates
CPL_TOP = CPL_CZ + COUPLER_BOX[2] / 2;                      // gearbox top
module mr_at_both_ends() { translate([-PLATA, 0, 0]) children(); translate([L + PLAT, 0, 0]) mirror([1, 0, 0]) children(); }   // B coupler at the platform end sill

module mr_coupler_clear() {        // space the gearbox needs (subtract from body end, floor, underframe)
    mr_at_both_ends()
        translate([-1, -COUPLER_BOX[1]/2 - 0.3, CPL_TOP - COUPLER_BOX[2] - 0.3])
            cube([COUPLER_BOX[0] + 1.3, COUPLER_BOX[1] + 0.6, COUPLER_BOX[2] + 0.6]);
}

module mr_coupler_pads() {         // mounting pad under the floor when the gearbox hangs below it
    if (CPL_TOP < 0) mr_at_both_ends()
        translate([0.2, -COUPLER_BOX[1]/2 - 2, CPL_TOP]) cube([COUPLER_BOX[0] + 2, COUPLER_BOX[1] + 4, -CPL_TOP + 0.01]);
    if (COUPLER_POCKET) mr_coupler_pocket();
}
// Draft-gear pocket (part of the floor): a cheek each side of the gearbox and a stop behind it, from the
// floor underside down to the bottom of the gearbox.  The gearbox drops in from below and is held by its
// own screw; the mouth is open to the car end so the coupler can swing.
CPL_BOT = CPL_TOP - COUPLER_BOX[2];                        // gearbox underside (car coordinates)
module mr_coupler_pocket() {
    t = COUPLER_POCKET_T; w = COUPLER_BOX[1] / 2 + COUPLER_FIT; h = -CPL_BOT;
    if (h > 0.6) mr_at_both_ends() {
        for (s = [1, -1]) translate([0.2, s > 0 ? w : -w - t, CPL_BOT]) cube([COUPLER_BOX[0] + 2 + t, t, h + 0.01]);          // cheeks
        translate([2 + COUPLER_BOX[0] + COUPLER_FIT, -w - t, CPL_BOT]) cube([t, 2 * (w + t), h + 0.01]);                       // back stop
        for (s = [1, -1]) translate([0.2, s > 0 ? w + t - 0.01 : -w - t - 3, -1.2]) cube([COUPLER_BOX[0] + 2 + t, 3.01, 1.21]);  // foot fillets
    }
}

module mr_coupler_screws() {
    mr_at_both_ends() translate([COUPLER_BOX[0] / 2, 0, CPL_TOP - 1]) cylinder(d = COUPLER_SCREW_D, h = FLOOR_T + 2 - min(CPL_TOP, 0), $fn = 16);
}

// ---- how far each coupler must stick out for MIN_CURVE_D_FT ----
// On a curve two coupled cars meet at an angle; each coupler swings half of it and the inside
// corners of the bodies (and diaphragms) close up.  The knuckle face sits far enough out that
// they don't touch: CPL_REACH (mm beyond the end sheet).  Coupled cars then sit 2 x CPL_REACH apart.
CPL_RC    = MIN_CURVE_D_FT * 304.8 / 2;                              // real layout radius, mm (not scaled)
CPL_TC    = len(TRUCK_CENTERS_FT) > 1 ? ft(TRUCK_CENTERS_FT[len(TRUCK_CENTERS_FT) - 1] - TRUCK_CENTERS_FT[0]) : L * 0.72;
CPL_SWING = atan((L / 2 + COUPLER_REACH_MIN) / (CPL_RC * cos(asin(min(0.99, CPL_TC / 2 / CPL_RC)))));
CPL_DIA_HW = END_DOORS && END_DIAPHRAGM ? ED_W / 2 + inch(6) : 0;          // diaphragm half width
CPL_REACH = max(COUPLER_REACH_MIN,
                (W / 2) * sin(CPL_SWING) + 1.5,                                 // body corners
                (END_DOORS && END_DIAPHRAGM ? DIAPHRAGM_D + CPL_DIA_HW * sin(CPL_SWING) + 1 : 0));   // diaphragms
echo(str("COUPLERS: on a ", MIN_CURVE_D_FT, " ft diameter curve each coupler swings +/- ", round(CPL_SWING * 10) / 10,
         " deg; knuckle face ", round(CPL_REACH * 10) / 10, " mm beyond the end sheet (",
         round((CPL_REACH + 2 + KD_PIVOT) * 10) / 10, " mm from the gearbox pivot)"));

module mr_kadee_head() {           // Type E knuckle head, knuckle face at x = 0, pointing -x
    h = KD_HEAD; w2 = h[1] / 2;
    translate([0, 0, -h[2] / 2]) {
        hull() { translate([2, -w2, 0]) cube([h[0] - 2, w2 + 1.5, h[2]]); translate([2.2, -w2 + 2.2, 0]) cylinder(r = 2.2, h = h[2], $fn = 20); }   // head body
        difference() {                                                                                       // knuckle
            hull() { translate([0, 0.5, 0]) cube([h[0] - 2, w2 - 0.5, h[2]]); translate([2.5, w2 - 2.5, 0]) cylinder(r = 2.5, h = h[2], $fn = 24); }
            translate([-1, 1.2, -1]) cube([2.2, 2.2, h[2] + 2]);                                              // knuckle pocket
        }
        translate([h[0] - 1, -1.2, -0.8]) cube([1.2, 2.4, h[2] + 1.6]);                                      // pin boss
    }
}
module mr_coupler_visual() {       // Kadee stand-in (view only): gearbox, shank, Type E head, trip pin
    color("#1C1C1C") mr_at_both_ends() {
        translate([2, -COUPLER_BOX[1]/2, CPL_TOP - COUPLER_BOX[2]]) cube(COUPLER_BOX);                 // gearbox
        translate([2 - 0.01, -COUPLER_BOX[1]/2 - 3, CPL_TOP - 1.2]) cube([6, COUPLER_BOX[1] + 6, 1.2]); // mounting ears
        translate([-CPL_REACH + KD_HEAD[0] - 1, -KD_SHANK[0]/2, CPL_CZ - KD_SHANK[1]/2])
            cube([CPL_REACH - KD_HEAD[0] + 3 + KD_PIVOT, KD_SHANK[0], KD_SHANK[1]]);                  // shank
        translate([-CPL_REACH, 0, CPL_CZ]) mr_kadee_head();
    }
    color("#8A8A8A") mr_at_both_ends()                                                                 // trip pin
        translate([-CPL_REACH + KD_HEAD[0] - 2, 0, 0]) {
            translate([0, 0, RAIL_TOP + 1.8]) cylinder(d = 0.8, h = CPL_CZ - KD_HEAD[2]/2 - RAIL_TOP - 1.8, $fn = 8);
            translate([-2.5, -0.4, RAIL_TOP + 1.8]) cube([2.5, 0.8, 0.8]);
        }
}

// ---------- LIGHTING PACK TRAY (inside the car) ----------
// position: EBOX_X / EBOX_Y, worked out with the LED ranges above
module mr_ebox_footprint(grow = 0, h = 120) {                   // the space the tray takes (cut from the interior)
    translate([EBOX_X - EBOX_L/2 - grow, EBOX_Y - EBOX_W/2 - grow, FLOOR_T - 0.01]) cube([EBOX_L + 2*grow, EBOX_W + 2*grow, h]);
}
module mr_ebox_floor_holes() { }                                // nothing through the floor any more
// the tray where it sits in the car: open top, cells on the wall side, boards on the aisle side
module mr_ebox() {
    T = EBOX_T; H = EBOX_H; cb = 38.3;                          // cb = bay for two 18650 cells side by side
    translate([EBOX_X - EBOX_L/2, EBOX_Y - EBOX_W/2, FLOOR_T]) difference() {
        union() {
            difference() { cube([EBOX_L, EBOX_W, H]); translate([T, T, T]) cube([EBOX_L - 2*T, EBOX_W - 2*T, H]); }
            translate([T - 0.01, EBOX_W - T - cb - 1.2, T - 0.01]) cube([EBOX_L - 2*T + 0.02, 1.2, 9]);      // divider: cells | boards
            translate([EBOX_L/2 - 0.6, EBOX_W - T - cb, T - 0.01]) cube([1.2, cb + 0.01, 3]);                 // low rib under the cells
        }
        // aisle-side wall (-Y): USB-C charger port and slide switch (roof off to reach them)
        translate([10, -1, T + 3]) cube([11, T + 2, 5]);
        translate([30, -1, T + 5]) cube([10, T + 2, 4.5]);
        // lead notches in the top edge: LED strip + charging coil, marker light / spare
        for (x = [EBOX_L/2 - 4, EBOX_L - 16]) translate([x, -1, H - 4]) cube([8, T + 2, 5]);
        translate([EBOX_L/2 - 3, EBOX_W - T - cb - 1.5, T + 5]) cube([6, 2, 5]);                               // cell leads through the divider
    }
}
module mr_ebox_print() { translate([-(EBOX_X - EBOX_L/2), -(EBOX_Y - EBOX_W/2), -FLOOR_T]) mr_ebox(); }

// ---------- UNDERFRAME (hangs under the floor, prints with it) ----------
//  centre sill + body bolsters + crossbearers + equipment.  Nothing is placed inside the
//  truck swing zones, and nothing hangs lower than UNDER_MAX_IN.
//  equipment: ["box", x_ft, y_in, l_in, w_in, h_in]   box, l along the car, w across, h down
//             ["tank", x_ft, y_in, l_in, dia_in]       cylinder along the car
//             ["tankx", x_ft, y_in, dia_in, len_in]    cylinder across the car (air reservoir)
UF_ZONE = max(ft(TRUCK_WHEELBASE_FT) / 2 + inch(WHEEL_D_IN) / 2 + inch(10), mr_truck_half(TRUCK_AXLES, ft(TRUCK_WHEELBASE_FT)) + inch(4));   // truck clearance, each side of centre
UF_MAX  = inch(UNDER_MAX_IN);

module mr_uf_item(e, sep = false) {
    t = e[0]; x = ft(e[1]); y = inch(e[2]);
    if (t == "box")
        translate([x - inch(e[3])/2, y - inch(e[4])/2, -inch(e[5])]) cube([inch(e[3]), inch(e[4]), inch(e[5]) + 0.01]);
    else if (t == "tank") {
        d = inch(e[4]);
        translate([x - inch(e[3])/2, y, -d/2 - inch(3)]) rotate([0, 90, 0]) cylinder(d = d, h = inch(e[3]), $fn = 32);
        for (k = [-1, 1]) let(w = sep ? PIN_D + 3.2 : 1.2)                                     // hangers (saddles when separate)
            translate([x + k * inch(e[3]) * 0.3 - w/2, y - d/2, -inch(3) - d/2]) cube([w, d, inch(3) + d/2 + 0.01]);
    } else if (t == "tankx") {
        d = inch(e[3]);
        translate([x, y - inch(e[4])/2, -d/2 - inch(2)]) rotate([-90, 0, 0]) cylinder(d = d, h = inch(e[4]), $fn = 32);
        translate([x - d * 0.3, y - inch(e[4])/2, -inch(2) - d/2]) cube([d * 0.6, inch(e[4]), inch(2) + d/2 + 0.01]);        // saddle
    }
}
// ---- separate underbody equipment: fixing points, holes, print layout ----
EQ_SEP = UNDERFRAME && EQUIP_SEPARATE && len(UNDER_EQUIP) > 0;
function mr_eq_len(e) = e[0] == "tankx" ? inch(e[3]) : inch(e[3]);               // size along the car
function mr_eq_wid(e) = e[0] == "box" ? inch(e[4]) : e[0] == "tank" ? inch(e[4]) : inch(e[4]);
function mr_eq_h(e)   = e[0] == "box" ? inch(e[5]) : e[0] == "tank" ? inch(e[4]) + inch(3) : inch(e[3]) + inch(2);
function mr_eq_pts(e) = let(x = ft(e[1]), y = inch(e[2]))                         // two fixing points per item
    e[0] == "tankx" ? [[x, y - inch(e[4]) * 0.3], [x, y + inch(e[4]) * 0.3]]
  : e[0] == "tank"  ? [[x - inch(e[3]) * 0.3, y], [x + inch(e[3]) * 0.3, y]]
  : (inch(e[3]) >= inch(e[4]) ? [[x - inch(e[3]) * 0.3, y], [x + inch(e[3]) * 0.3, y]]
                              : [[x, y - inch(e[4]) * 0.3], [x, y + inch(e[4]) * 0.3]]);
function mr_eq_sill(p) = abs(p[1]) < inch(CENTER_SILL_W_IN) / 2 ? inch(CENTER_SILL_D_IN) : 0;   // sill depth above this point
module mr_eq_keep() {                         // the space an item may occupy (clear of trucks, light box, steps, depth limit)
    difference() {
        translate([-10, -W, -UF_MAX]) cube([L + 20, 2*W, UF_MAX + 0.02]);
        for (tc = TRUCK_CENTERS_FT) translate([ft(tc) - UF_ZONE, -W, -50]) cube([2 * UF_ZONE, 2*W, 50]);
        mr_step_boxes(1.0);
    }
}
module mr_eq_frame_solid() {                  // centre sill + crossbearers, grown by a fit clearance (cut out of the items)
    ex0 = ft(1.5); ex1 = L - (TAIL > 0 ? TAIL : ft(1.5)); c = 0.2;
    translate([ex0, -inch(CENTER_SILL_W_IN)/2 - c, -inch(CENTER_SILL_D_IN) - c]) cube([ex1 - ex0, inch(CENTER_SILL_W_IN) + 2*c, inch(CENTER_SILL_D_IN) + c + 1]);
    for (x = CROSSBEARERS_FT) translate([ft(x) - inch(CROSSBEARER_W_IN)/2 - c, -W/2, -inch(CROSSBEARER_D_IN) - c])
        cube([inch(CROSSBEARER_W_IN) + 2*c, W, inch(CROSSBEARER_D_IN) + c + 1]);
}
module mr_eq_holes(in_item) {                 // fixing holes: through sill / floor, and into the item
    if (EQ_SEP) for (e = UNDER_EQUIP) for (p = mr_eq_pts(e)) let(zs = mr_eq_sill(p)) {
        if (in_item)
            translate([p[0], p[1], -zs - EQUIP_PIN_DEPTH]) cylinder(d = EQUIP_FIX == "screw" ? FLOOR_PILOT : PIN_D, h = zs + EQUIP_PIN_DEPTH + 1, $fn = 16);
        else if (EQUIP_FIX == "screw") {
            translate([p[0], p[1], -zs - 1]) cylinder(d = FLOOR_CLEAR_D, h = zs + FLOOR_T + 2, $fn = 16);
            translate([p[0], p[1], FLOOR_T - 1.8]) cylinder(d = FLOOR_HEAD_D, h = 2, $fn = 20);
        }
        else translate([p[0], p[1], -zs - 1]) cylinder(d = PIN_D, h = zs + 1 + FLOOR_T - 1.0, $fn = 16);
    }
}
module mr_eq_part(e) {                        // one item as a separate part, in its place on the car
    difference() {
        intersection() { mr_uf_item(e, true); mr_eq_keep(); }
        mr_eq_frame_solid();
        mr_eq_holes(true);
    }
}
module mr_equipment() { if (EQ_SEP) for (e = UNDER_EQUIP) mr_eq_part(e); }       // all items in place (assembly view)
function mr_eq_off(i) = i == 0 ? 10 : mr_eq_off(i - 1) + mr_eq_len(UNDER_EQUIP[i - 1]) + 6;
module mr_equipment_print() {                 // every item top face down on the bed, in a row along X
    if (EQ_SEP) for (i = [0:1:len(UNDER_EQUIP) - 1]) let(e = UNDER_EQUIP[i])
        translate([mr_eq_off(i) + mr_eq_len(e) / 2, 10 + mr_eq_wid(e) / 2, 0])
            rotate([180, 0, 0]) translate([-ft(e[1]), -inch(e[2]), 0]) mr_eq_part(e);
}

module mr_underframe() {
    if (UNDERFRAME) {
        tcs = [for (tc = TRUCK_CENTERS_FT) ft(tc)];
        ex0 = ft(1.5); ex1 = L - (TAIL > 0 ? TAIL : ft(1.5));
        difference() {
            union() {
                translate([ex0, -inch(CENTER_SILL_W_IN)/2, -inch(CENTER_SILL_D_IN)])           // centre sill
                    cube([ex1 - ex0, inch(CENTER_SILL_W_IN), inch(CENTER_SILL_D_IN) + 0.01]);
                for (x = CROSSBEARERS_FT)                                                           // crossbearers
                    translate([ft(x) - inch(CROSSBEARER_W_IN)/2, -(W/2 - WALL - CLEAR - 1), -inch(CROSSBEARER_D_IN)])
                        cube([inch(CROSSBEARER_W_IN), W - 2*(WALL + CLEAR + 1), inch(CROSSBEARER_D_IN) + 0.01]);
                if (!EQ_SEP) for (e = UNDER_EQUIP) mr_uf_item(e);
                if (len(UNDER_SHROUD_IN) > 1) {                                                     // shroud: two side walls + ends, open underneath (prints with the floor)
                    sw = inch(UNDER_SHROUD_IN[0]); sd = min(inch(UNDER_SHROUD_IN[1]), UF_MAX);
                    xa = tcs[0] + UF_ZONE; xb = tcs[len(tcs) - 1] - UF_ZONE; st = 1.6;
                    difference() {
                        translate([xa, -sw/2, -sd]) cube([xb - xa, sw, sd + 0.01]);
                        translate([xa + st, -sw/2 + st, -sd - 1]) cube([xb - xa - 2*st, sw - 2*st, sd + 2]);
                    }
                }
            }
            for (x = tcs) translate([x - UF_ZONE, -W, -50]) cube([2 * UF_ZONE, 2*W, 50 - 0.01]);   // truck swing zones
            mr_step_boxes(1.0);                                                                        // step boxes
            translate([-10, -W, -50]) cube([L + 20, 2*W, 50 - UF_MAX]);                              // depth limit
        }
        for (x = tcs)                                                                               // body bolsters (inside the truck sideframes)
            translate([x - inch(9), -(T_YI - 1.5), -BOLSTER_H + 0.5])
                cube([inch(18), 2 * (T_YI - 1.5), BOLSTER_H - 0.49]);
    }
}

// ---------- WHEEL WELLS (TDQ-276) ----------
// A recess WHEEL_WELL_D deep in the floor underside over every wheel, wide enough for the wheel
// to swing with its truck on the MIN_CURVE_D_FT curve (+2 degrees). Each well covers the part of
// the wheel (flange included) that comes within WHEEL_WELL_D + 0.3 mm of the floor.
WW_SWING = asin(min(0.95, (CPL_TC / 2) / CPL_RC)) + 2;                       // truck turn on the tightest curve, degrees
WW_RF    = inch(WHEEL_D_IN) / 2 + FLANGE_H;                                  // flange radius
WW_HC    = sqrt(max(0, 2 * WW_RF * (WHEEL_WELL_D + 0.3) - pow(WHEEL_WELL_D + 0.3, 2))) + 1;   // half length along the car
WW_Y0    = WHEEL_B2B / 2 - 0.5;                                              // inner edge (flange side)
WW_Y1    = WHEEL_B2B / 2 + WHEEL_W + 1.5;                                    // outer edge (hub)
module mr_wheel_wells() {
    if (WHEEL_WELL_D > 0) for (tc = TRUCK_CENTERS_FT, a = mr_axles(TRUCK_AXLES, ft(TRUCK_WHEELBASE_FT)), sy = [-1, 1])
        translate([ft(tc), 0, -0.01]) hull() for (r = [-WW_SWING, 0, WW_SWING]) rotate([0, 0, r])
            translate([a - WW_HC, sy > 0 ? WW_Y0 : -WW_Y1, 0]) cube([2 * WW_HC, WW_Y1 - WW_Y0, WHEEL_WELL_D + 0.01]);
}

module mr_floor_full() {
    render() difference() {
        union() {
            intersection() {
                mr_body_solid(WALL + CLEAR, -5);
                translate([-1, -W, 0]) cube([L + 2, 2*W, FLOOR_T]);
            }
            for (tc = TRUCK_CENTERS_FT)
                translate([ft(tc), 0, -BOLSTER_H]) cylinder(d = 14, h = BOLSTER_H + 0.01);
            mr_plat_deck();     // open platform deck
            mr_underframe();
            mr_coupler_pads();
        }
        mr_coupler_clear();
        mr_coupler_screws();
        mr_ebox_floor_holes();
        mr_floor_screw_holes();
        mr_step_floor_holes();
        mr_eq_holes(false);
        mr_wheel_wells();
        for (tc = TRUCK_CENTERS_FT)
            translate([ft(tc), 0, -BOLSTER_H - 1])
                cylinder(d = TRUCK_SCREW_D, h = BOLSTER_H + FLOOR_T + 2, $fn = 20);
        for (j = FJ) for (s = [-1, 1])
            translate([j, s * W * 0.3, FLOOR_T / 2])
                rotate([0, 90, 0]) cylinder(d = PIN_D, h = PIN_L, center = true, $fn = 16);
    }
}

module mr_floor_section(i, place = true) {
    x0 = FCUT[i-1]; x1 = FCUT[i];
    if (place)       // printed upside down: floor top on the bed, bolster pads up
        mr_place(x1 - x0 + (i == 1 ? PLATA : 0)) translate([-x0 + (i == 1 ? PLATA : 0), 0, FLOOR_T]) rotate([180, 0, 0]) mr_floor_section(i, false);
    else intersection() { difference() { mr_floor_full(); mr_floor_label(i); } mr_xslice(x0, x1, -max(BOLSTER_H, inch(UNDER_MAX_IN)) - 2, FLOOR_T + 2, i == 1, i == N_FLOOR); }
}

// =====================================================================
//  PRINT SECTIONS  (at the end so every opening, magnet and underframe list exists)
//  The car is cut into the fewest sections that fit BED_X.  Each side wall gets its own joints,
//  on a window pier of THAT side (the sides are separate pieces except in the end sections), so
//  cars with staggered windows (sleepers) still split cleanly.  The roof gets its own joints, clear
//  of magnets, housings, dome and skytop glass.  Floor (and interior) joints are staggered between
//  the body joints, off the trucks, battery box, crossbearers, equipment and floor screws.
//  Where no joint has full clearance, the centre of a narrow pier is used (echoed as "tight").
//  BODY_JOINTS_FT = [..] in a car's lib overrides all of this (same joints both sides and roof).
// =====================================================================
BED_LEN = (DIAGONAL_PRINT ? sqrt(BED_X * BED_X + BED_Y * BED_Y) - W : BED_X) - 2 * PRINT_MARGIN;
SEC_END = 4;                   // end details that stand proud of the end sheet (diaphragm, grabs), mm
TIGHT   = 60;                  // penalty (mm) for a joint on a narrow pier instead of a clear one

function mr_qsort(v) = len(v) <= 1 ? v :
    let(p = v[floor(len(v) / 2)][0])
    concat(mr_qsort([for (e = v) if (e[0] < p) e]), [for (e = v) if (e[0] == p) e], mr_qsort([for (e = v) if (e[0] > p) e]));
function mr_prefmax(sv) = [for (i = [0:1:len(sv) - 1]) max([for (k = [0:1:i]) sv[k][1]])];
// free stretches of [lo, hi] between blocked intervals [[a, b], ...]
function mr_gaps(iv, lo, hi) =
    let(sv = mr_qsort([for (e = iv) if (e[1] > lo && e[0] < hi) e]), n = len(sv), me = mr_prefmax(sv),
        raw = n == 0 ? [[lo, hi]]
            : concat([[lo, sv[0][0]]], n > 1 ? [for (i = [0:1:n - 2]) [me[i], sv[i + 1][0]]] : [], [[me[n - 1], hi]]))
    [for (g = raw) let(a = max(g[0], lo), b = min(g[1], hi)) if (b > a) [a, b]];
// centres of the piers between openings that touch or nearly touch (fallback joints)
function mr_piers(iv, lo, hi) =
    let(sv = mr_qsort(iv), n = len(sv), me = mr_prefmax(sv))
    n < 2 ? [] : [for (i = [0:1:n - 2]) if (sv[i + 1][0] > me[i]) let(p = (me[i] + sv[i + 1][0]) / 2) if (p > lo && p < hi) p];
// possible joint positions: the centre of a narrow gap, every 5 mm along a wide one
function mr_cands(G) = [for (g = G) each ((g[1] - g[0]) < 12 ? [(g[0] + g[1]) / 2] : [for (x = [g[0] + 6 : 5 : g[1] - 6]) x])];
function mr_nearest(c, x) = let(d = [for (p = c) abs(p - x)], m = min(d)) [for (i = [0:1:len(c) - 1]) if (d[i] == m) c[i]][0];
function mr_cuts(j) = concat([0], j, [L]);
function mr_good(j) = len([for (x = j) if (x < 0) 1]) == 0;
// choose joints one after another: nearest the target T[k] (plus penalty), keeping this section on
// the bed and leaving the rest of the car able to fit.  C = [[x, penalty], ...].  -1 = no fit.
function mr_seq(C, T, ext, prev = 0, k = 0) =
    k >= len(T) ? [] :
    let(rem = len(T) - k, lim = BED_LEN - (k == 0 ? SEC_END : 0),
        ok = [for (c = C) if (c[0] > prev + 20 && c[0] - prev <= lim && L + ext + SEC_END - c[0] <= rem * BED_LEN) c])
    len(ok) == 0 ? [-1] :
    let(cost = [for (c = ok) abs(c[0] - T[k]) + c[1]], m = min(cost),
        j = [for (i = [0:1:len(ok) - 1]) if (cost[i] == m) ok[i][0]][0])
    concat([j], mr_seq(C, T, ext, j, k + 1));

// ---- openings and fixed no-go zones ----
function mr_wside(w) = len(w) > 4 ? w[4] : 0;
function mr_open_iv(s, g, dg) = concat(          // s = -1 / +1 side; g = window clearance; dg = door clearance
    [for (w = WINDOWS) if (mr_wside(w) == 0 || mr_wside(w) == s) [ft(w[0]) - inch(w[1]) / 2 - g, ft(w[0]) + inch(w[1]) / 2 + g]],
    [for (d = DOORS) [ft(d[0]) - inch(d[1]) / 2 - 3 - dg, ft(d[0]) + inch(d[1]) / 2 + 3 + dg]],
    [for (d = DOOR_PANELS) if (len(d) < 5 || d[4] == 0 || d[4] == s) [ft(d[0]) - inch(d[1]) / 2 - 3 - dg, ft(d[0]) + inch(d[1]) / 2 + 3 + dg]]);
SKY_SIMPLE = END_B == "skytop" && len(SKY_WINS) == 0 && len(SKY_PANES) == 0;
TAIL_BLOCK = SKY_SIMPLE ? [[SKY_X0 - 10, L + 50]] : (TAIL > 0 ? [[L - TAIL - 10, L + 50]] : []);
SKY_OPEN = concat([for (e = SKY_WINS) if (e[0] == "x") [ft(e[1]), ft(e[2])]],
                  [for (p = SKY_PANES) [ft(min([for (q = p) q[0]])), ft(max([for (q = p) q[0]]))]]);
MAG_BLOCK = [for (m = MAGNET_X_FT) [ft(m) - MAG_R - JOINT_W / 2, ft(m) + MAG_R + JOINT_W / 2]];
WIN_G = WIN_FLANGE + WIN_SOCKET_W + JOINT_CLEAR;
function mr_side_cands(s) = concat(
    [for (c = mr_cands(mr_gaps(concat(mr_open_iv(s, WIN_G, PIN_L / 2 + 2), MAG_BLOCK, TAIL_BLOCK,
                                      [for (o = SKY_OPEN) [o[0] - 8, o[1] + 8]]), 40, L - 40))) [c, 0]],
    [for (p = mr_piers(concat(mr_open_iv(s, 0, 0), MAG_BLOCK, TAIL_BLOCK, SKY_OPEN), 40, L - 40)) [p, TIGHT]]);
ROOF_FIXED = concat(MAG_BLOCK, TAIL_BLOCK,
    [for (h = ROOF_HOUSINGS) [ft(h[0]) - 4, ft(h[1]) + 4]],
    [[WIRE_X - WIRE_D - 4, WIRE_X + WIRE_D + 4]],
    DOME ? [[DS - 8, DS + DSL + 8], [DE - DSL - 8, DE + 8]] : []);
ROOF_OPEN = concat([for (w = DOME_WINDOWS) [ft(w[0]) - inch(w[1]) / 2, ft(w[0]) + inch(w[1]) / 2]], SKY_OPEN,
                   [for (c = SKY_CROWN_PANES) [ft(c[0]), ft(c[1])]]);
ROOF_CANDS = concat(
    [for (c = mr_cands(mr_gaps(concat(ROOF_FIXED, [for (o = ROOF_OPEN) [o[0] - WIN_G - 3, o[1] + WIN_G + 3]]), 40, L - 40))) [c, 0]],
    [for (p = mr_piers(concat(ROOF_FIXED, ROOF_OPEN), 40, L - 40)) [p, TIGHT]]);
SIDE_CANDS = [mr_side_cands(-1), mr_side_cands(1)];

// ---- floor ----
FLOOR_BLOCK_MIN = concat(
    [for (tc = TRUCK_CENTERS_FT) [ft(tc) - inch(9) - 4, ft(tc) + inch(9) + 4]],
    []);
FLOOR_BLOCK = concat(FLOOR_BLOCK_MIN,
    [for (x = FS_X) [x - FLOOR_BOSS / 2 - 3, x + FLOOR_BOSS / 2 + 3]],
    [for (e = STEP_ITEMS) [e[0] - e[1] / 2 - 8, e[0] + e[1] / 2 + 8]],
    UNDERFRAME ? [for (x = CROSSBEARERS_FT) [ft(x) - inch(CROSSBEARER_W_IN) / 2 - 2, ft(x) + inch(CROSSBEARER_W_IN) / 2 + 2]] : [],
    UNDERFRAME ? [for (e = UNDER_EQUIP) [ft(e[1]) - inch(e[3]) / 2 - 2, ft(e[1]) + inch(e[3]) / 2 + 2]] : []);
function mr_fj(bjs) = len(bjs[0]) == 0 ? [] :
    let(J = concat(bjs[0], bjs[1]),
        C = concat([for (c = mr_cands(mr_gaps(concat(FLOOR_BLOCK, [for (j = J) [j - FLOOR_STAGGER, j + FLOOR_STAGGER]]), 30, L - 30))) [c, 0]],
                   [for (c = mr_cands(mr_gaps(concat(FLOOR_BLOCK_MIN, [for (j = J) [j - 25, j + 25]]), 30, L - 30))) [c, TIGHT]]),
        bc = mr_cuts([for (i = [0:1:len(bjs[0]) - 1]) (bjs[0][i] + bjs[1][i]) / 2]))
    mr_seq(C, [for (i = [1:1:len(bc) - 1]) (bc[i - 1] + bc[i]) / 2], PLAT);

// ---- pick the number of sections ----
function mr_even(n) = [for (i = [1:1:n - 1]) i * L / n];
function mr_try(n) = let(T = mr_even(n), a = mr_seq(SIDE_CANDS[0], T, PLAT), b = mr_seq(SIDE_CANDS[1], T, PLAT),
                         r = mr_seq(ROOF_CANDS, T, PLAT), f = (mr_good(a) && mr_good(b)) ? mr_fj([a, b]) : [-1])
    [a, b, r, f];
function mr_fit(n) = let(t = mr_try(n)) mr_good(t[0]) && mr_good(t[1]) && mr_good(t[2]) && mr_good(t[3]);
N_MIN   = max(1, ceil((L + PLAT + PLATA + 2 * SEC_END) / BED_LEN));
N_FITS  = [for (n = [N_MIN:1:N_MIN + 4]) if (mr_fit(n)) n];
SEC_OK  = len(N_FITS) > 0;
N_PICK  = SEC_OK ? N_FITS[0] : N_MIN + 1;
SEC_T   = SEC_OK ? mr_try(N_PICK)
        : let(e = mr_even(N_PICK)) [e, e, e, [for (i = [1:1:N_PICK]) (i - 0.5) * L / N_PICK]];
MANUAL  = len(BODY_JOINTS_FT) > 0;
BJS     = MANUAL ? [[for (j = BODY_JOINTS_FT) ft(j)], [for (j = BODY_JOINTS_FT) ft(j)]] : [SEC_T[0], SEC_T[1]];
RJ      = MANUAL ? BJS[0] : SEC_T[2];
FJ      = FRAME_ONE_PIECE ? [] : MANUAL ? mr_fj(BJS) : SEC_T[3];
BJ      = RJ;                       // (older name)
N_BODY  = len(RJ) + 1;
BCUTS   = [mr_cuts(BJS[0]), mr_cuts(BJS[1])];
RCUT    = mr_cuts(RJ);
BCUT    = RCUT;                     // (older name)
N_FLOOR = len(FJ) + 1;              // floor + interior joints are staggered
FCUT    = mr_cuts(FJ);
TIGHT_J = [for (k = [0, 1]) for (j = BJS[k]) if (len([for (c = SIDE_CANDS[k]) if (c[0] == j && c[1] > 0) 1]) > 0) j];
function mr_end_x(i, e) = (i == 1 ? SEC_END : 0) + (i == N_BODY ? SEC_END + e : 0);
BODY_LENS = [for (i = [1:1:N_BODY])
    (i == 1 || i == N_BODY) ? max(BCUTS[0][i], BCUTS[1][i]) - min(BCUTS[0][i-1], BCUTS[1][i-1]) + mr_end_x(i, PLAT)
                            : max(BCUTS[0][i] - BCUTS[0][i-1], BCUTS[1][i] - BCUTS[1][i-1])];
ROOF_LENS  = [for (i = [1:1:N_BODY]) RCUT[i] - RCUT[i-1] + mr_end_x(i, PLAT) + (i == 1 ? PLATA : 0)];
FLOOR_LENS = [for (i = [1:1:N_FLOOR]) FCUT[i] - FCUT[i-1] + (i == 1 ? SEC_END + PLATA : 0) + (i == N_FLOOR ? SEC_END + PLAT : 0)];

// ---------- SECTION ID LABELS (engraved) ----------
function mr_join(v, i = 0) = i >= len(v) ? "" : str(v[i], mr_join(v, i + 1));
CAR_YEAR = mr_join([for (i = [0:1:min(3, len(CAR_TRAIN) - 1)]) CAR_TRAIN[i]]);
function mr_label(k, i, n) = str(CAR_YEAR, " ", CAR_NAME, "  ", k, i, "/", n);
function mr_lab_size(s, avail, h) = min(h, avail / (len(s) * 0.68));
// centre of a label ln long inside [x0, x1], as near the middle as the blocked intervals allow
function mr_lab_x(x0, x1, blocks, ln) =
    let(c = (x0 + x1) / 2, g = [for (q = mr_gaps(blocks, x0 + JOINT_W / 2 + 3, x1 - JOINT_W / 2 - 3)) if (q[1] - q[0] >= ln) q])
    len(g) == 0 ? c : mr_nearest([for (q = g) min(max(c, q[0] + ln / 2), q[1] - ln / 2)], c);
module mr_label_text(s, sz) text(s, size = sz, font = LABEL_FONT, halign = "center", valign = "center");
// text on a side wall, read from inside the car: k = 0 the -Y wall (A end to the right), 1 the +Y wall (A end to the left)
module mr_on_wall(k) {
    if (k == 0) multmatrix([[-1, 0, 0, 0], [0, 0, -1, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) children();
    else        multmatrix([[ 1, 0, 0, 0], [0, 0,  1, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) children();
}

LAB_BODY_Z = FLOOR_T + FLOOR_BOSS_H + 2 + LABEL_SIZE / 2;
function mr_lab_body_block(s) = concat(
    [for (w = WINDOWS) if ((mr_wside(w) == 0 || mr_wside(w) == s) && inch(w[3]) - WIN_FLANGE - WIN_SOCKET_W - 1 < LAB_BODY_Z + LABEL_SIZE / 2)
        let(h = inch(w[1]) / 2 + WIN_FLANGE + WIN_SOCKET_W + 2) [ft(w[0]) - h, ft(w[0]) + h]],
    mr_open_iv(s, 0, 6), TAIL_BLOCK);
module mr_body_label(i, k) if (LABELS) {
    c  = BCUTS[k]; x0 = c[i-1]; x1 = c[i]; sg = k == 0 ? -1 : 1;
    s  = k == 0 ? str(mr_label("B", i, N_BODY), " -Y  A>") : str("<A  ", mr_label("B", i, N_BODY), " +Y");
    sz = mr_lab_size(s, x1 - x0 - JOINT_W - 10, LABEL_SIZE);
    cx = mr_lab_x(x0, x1, mr_lab_body_block(sg), len(s) * sz * 0.68 + 6);
    intersection() {
        difference() { mr_body_solid(WALL - LABEL_D, -5); mr_body_solid(WALL + 1, -10); }
        translate([cx, sg * (W/2 - WALL - 10), LAB_BODY_Z]) mr_on_wall(k) linear_extrude(WALL + 14) mr_label_text(s, sz);
    }
}

LIP_IN   = WALL + CLEAR + ROOF_LIP_T;      // inset of the roof lip's inner face
LAB_ROOF_SIZE = min(3.5, ROOF_LIP_H - 2);
LAB_ROOF_BLOCK = concat(
    [for (m = MAGNET_X_FT) [ft(m) - MAG_R - 3, ft(m) + MAG_R + 3]],
    mr_open_iv(-1, 0, 6), TAIL_BLOCK, [for (o = SKY_OPEN) [o[0] - 10, L + 50]]);
module mr_roof_label(i) if (LABELS) {
    x0 = RCUT[i-1]; x1 = RCUT[i];
    s  = str(mr_label("R", i, N_BODY), "  A>");
    sz = mr_lab_size(s, x1 - x0 - JOINT_W - 10, LAB_ROOF_SIZE);
    cx = mr_lab_x(x0, x1, LAB_ROOF_BLOCK, len(s) * sz * 0.68 + 6);
    intersection() {
        difference() { mr_body_solid(LIP_IN - 0.5, -5); mr_body_solid(LIP_IN + 1, -10); }
        translate([-10, -W, ROOF_Z - ROOF_LIP_H]) cube([L + 20, W, ROOF_LIP_H]);
        translate([cx, -W/2 + LIP_IN + 10, ROOF_Z - ROOF_LIP_H / 2]) mr_on_wall(0) linear_extrude(LIP_IN + 14) mr_label_text(s, sz);
    }
}

LAB_FLOOR_Y = 12;                         // clear of the truck screw, battery-box holes and floor pins
module mr_floor_label(i) if (LABELS) {
    x0 = FCUT[i-1]; x1 = FCUT[i];
    s  = str("<A  ", mr_label("F", i, N_FLOOR));
    sz = mr_lab_size(s, x1 - x0 - JOINT_W - 6, LABEL_SIZE);
    cx = mr_lab_x(x0, x1, [], len(s) * sz * 0.68 + 4);
    translate([cx, LAB_FLOOR_Y, FLOOR_T - LABEL_D]) linear_extrude(LABEL_D + 1) mr_label_text(s, sz);
}

// =====================================================================
//  mr_interior.scad  —  optional interior, printed separately and
//  glued onto the floor. Built from INTERIOR_ZONES in the car lib:
//
//    ["bulkhead", x]           partition with door
//    ["coach",    x0, x1, p]   2+2 coach seats (optional pitch p in inches)
//    ["sections", x0, x1]      open berth sections (facing seat pairs)
//    ["parlor",   x0, x1]      single parlor chairs angled to the windows
//    ["diner",    x0, x1]      tables with facing seats both sides
//    ["lounge",   x0, x1]      sofas along both walls, small tables
//    ["bar",      x0, x1]      counter + stools on the +Y side
//    ["kitchen",  x0, x1]      kitchen block, corridor on -Y
//    ["toilet",   x0, x1]      enclosed room, corridor on -Y
//    ["rooms",    x0, x1, len] bedrooms / drawing rooms, corridor on -Y
//    ["domedeck", x0, x1]      Super Dome upper deck with 2+2 seats
//    ["rpo",      x0, x1]      Railway Post Office: letter cases on +Y, sorting table on -Y
//    ["baggage",  x0, x1]      empty (baggage / mail space)
//  x values are prototype feet from the A end.
// =====================================================================

IW     = W - 2 * (WALL + CLEAR) - 1;   // usable interior width
PART_H = inch(64);                     // partition height (stays clear of roof lip + magnets)

module mr_seat(w, facing = 1) {        // w = width across the car (mm); faces +x or -x
    d  = inch(20); sh = inch(17); bh = inch(38); bt = inch(4);
    translate([-d/2, -w/2, 0]) cube([d, w, sh]);
    translate([facing > 0 ? -d/2 - bt * 0.2 : d/2 - bt * 0.8, -w/2, 0]) cube([bt, w, bh]);
}

module mr_wall_x(x, y0, y1, h = PART_H, t = 1.2) { translate([x - t/2, min(y0, y1), 0]) cube([t, abs(y1 - y0), h]); }
module mr_wall_y(y, x0, x1, h = PART_H, t = 1.2) { translate([min(x0, x1), y - t/2, 0]) cube([abs(x1 - x0), t, h]); }

module mr_zone_bulkhead(x) {
    difference() {
        mr_wall_x(x, -IW/2, IW/2);
        translate([x - 2, -inch(13), 0.01]) cube([4, inch(26), inch(60)]);
    }
}

module mr_seat_rows(x0, x1, width, aisle, pitch) {
    sw = (width - aisle) / 2;
    n  = floor((x1 - x0) / pitch);
    if (n > 0) for (k = [0:1:n-1]) for (s = [-1, 1])
        translate([x0 + pitch/2 + k * pitch, s * (aisle/2 + sw/2), 0]) mr_seat(sw - 0.6, 1);
}

module mr_zone_coach(x0, x1) { mr_seat_rows(x0, x1, IW, inch(24), inch(COACH_PITCH_IN)); }

module mr_zone_sections(x0, x1) {
    p = ft(6.5); a = inch(24); sw = (IW - a) / 2;
    n = floor((x1 - x0) / p);
    if (n > 0) for (k = [0:1:n-1]) for (s = [-1, 1])
        translate([x0 + k * p, s * (a/2 + sw/2), 0]) {
            translate([inch(14), 0, 0])     mr_seat(sw - 0.6, 1);
            translate([p - inch(14), 0, 0]) mr_seat(sw - 0.6, -1);
        }
}

module mr_zone_parlor(x0, x1) {
    p = inch(44);
    n = floor((x1 - x0) / p);
    if (n > 0) for (k = [0:1:n-1]) for (s = [-1, 1])
        translate([x0 + p/2 + k * p, s * (IW/2 - inch(20)), 0]) {
            cylinder(d = inch(10), h = inch(6));
            rotate(s * 45) mr_seat(inch(24), 1);
        }
}

// dining room: 4-seat tables both sides at pitch_in, centred in the zone (line them up with the windows).
//   diag = angle (deg) for the Milwaukee Road 'diagonal' seating - each table and its chairs are
//   turned, alternating direction, as on the 1947 Olympian Hiawatha diners (plan A-4224 rev N)
module mr_zone_diner(x0, x1, pitch_in = 84, diag = 0) {
    p = inch(pitch_in); a = inch(28);
    sw = (IW - a) / 2 * (diag != 0 ? 0.85 : 1);
    tl = inch(min(36, pitch_in / 2 - 8));
    so = tl/2 + inch(10);                              // seat centre from table centre
    n = max(0, floor((x1 - x0 - 2 * (so + inch(8))) / p) + 1);
    xm = (x0 + x1) / 2 - (n - 1) * p / 2;
    if (n > 0) for (k = [0:1:n-1]) for (s = [-1, 1])
        translate([xm + k * p, s * (IW / 2 - (IW - a) / 4), 0])
            rotate([0, 0, diag * s * (k % 2 == 0 ? 1 : -1)]) {
                translate([-tl/2, -sw/2 + 0.3, 0]) cube([tl, sw - 0.6, inch(29)]);   // table
                translate([-so, 0, 0]) mr_seat(sw - 0.6, 1);
                translate([ so, 0, 0]) mr_seat(sw - 0.6, -1);
            }
}

module mr_zone_lounge(x0, x1) {
    d = inch(24);
    for (s = [1, -1]) scale([1, s, 1]) {
        translate([x0 + inch(6), IW/2 - d, 0])        cube([x1 - x0 - inch(12), d, inch(16)]);
        translate([x0 + inch(6), IW/2 - inch(5), 0])  cube([x1 - x0 - inch(12), inch(5), inch(32)]);
    }
    n = floor((x1 - x0) / ft(8));
    if (n > 0) for (k = [0:1:n-1]) translate([x0 + ft(4) + k * ft(8), 0, 0]) cylinder(d = inch(20), h = inch(20));
}

module mr_zone_bar(x0, x1) {
    translate([x0, IW/2 - inch(30), 0]) cube([x1 - x0, inch(30), inch(42)]);
    n = floor((x1 - x0) / inch(30));
    if (n > 0) for (k = [0:1:n-1])
        translate([x0 + inch(15) + k * inch(30), IW/2 - inch(48), 0]) cylinder(d = inch(14), h = inch(28));
}

module mr_zone_kitchen(x0, x1) {
    translate([x0, -IW/2 + inch(28), 0]) cube([x1 - x0, IW - inch(28), PART_H]);
}

module mr_zone_toilet(x0, x1) {
    cw = inch(28);
    difference() {
        translate([x0, -IW/2 + cw, 0]) cube([x1 - x0, IW - cw, PART_H]);
        translate([x0 + 1.2, -IW/2 + cw + 1.2, 1.2]) cube([x1 - x0 - 2.4, IW - cw - 2.4, PART_H]);
        translate([(x0 + x1)/2 - inch(12), -IW/2 + cw - 1, 1.2]) cube([inch(24), 4, inch(60)]);
    }
}

module mr_zone_rooms(x0, x1, room_ft = 7) {
    cw = inch(30); yc = -IW/2 + cw;
    n  = max(1, floor((x1 - x0) / ft(room_ft)));
    rl = (x1 - x0) / n;
    for (k = [0:1:n-1]) {
        xa = x0 + k * rl;
        mr_wall_x(xa, yc, IW/2);                                  // room divider
        mr_wall_y(yc, xa, xa + inch(6));                          // corridor wall ...
        mr_wall_y(yc, xa + inch(30), xa + rl);                    // ... with door gap
        translate([xa + 1, IW/2 - inch(30), 0]) cube([rl - 2, inch(30) - 0.5, inch(18)]);   // bed / sofa
    }
    mr_wall_x(x1, yc, IW/2);
}

module mr_zone_domedeck(x0, x1) {
    dz = HS * 0.55 - FLOOR_T;                    // deck height above the floor top
    dw = W * 0.88 - 2 * (WALL + CLEAR) - 2;
    translate([x0, -dw/2, dz]) cube([x1 - x0, dw, 1.6]);
    n = floor((x1 - x0 - 10) / ft(8));
    for (k = [0:1:n]) for (s = [-1, 1])
        translate([x0 + 5 + k * (x1 - x0 - 10) / max(n, 1), s * (dw/2 - 3), 0]) cylinder(d = 3, h = dz);
    translate([0, 0, dz + 1.6]) mr_seat_rows(x0, x1, dw, inch(20), inch(40));
}

module mr_zone_rpo(x0, x1) {
    cd = inch(16);                                   // letter-case depth
    difference() {
        translate([x0, IW/2 - cd, 0]) cube([x1 - x0, cd, PART_H]);
        for (k = [1:1:4])                            // shelf grooves on the working face
            translate([x0 + inch(6), IW/2 - cd - 1, inch(30) + k * inch(7)]) cube([x1 - x0 - inch(12), 1.4, 0.6]);
    }
    translate([x0, -IW/2, 0]) cube([x1 - x0, inch(24), inch(36)]);          // sorting table / pouch racks
}

module mr_zone(z) {
    t = z[0];
    a = ft(z[1]);
    b = len(z) > 2 ? ft(z[2]) : a;
    if      (t == "bulkhead") mr_zone_bulkhead(a);
    else if (t == "coach")    mr_seat_rows(a, b, IW, inch(24), inch(len(z) > 3 ? z[3] : COACH_PITCH_IN));
    else if (t == "sections") mr_zone_sections(a, b);
    else if (t == "parlor")   mr_zone_parlor(a, b);
    else if (t == "diner")    mr_zone_diner(a, b, len(z) > 3 ? z[3] : 84, len(z) > 4 ? z[4] : 0);
    else if (t == "lounge")   mr_zone_lounge(a, b);
    else if (t == "bar")      mr_zone_bar(a, b);
    else if (t == "kitchen")  mr_zone_kitchen(a, b);
    else if (t == "toilet")   mr_zone_toilet(a, b);
    else if (t == "rooms")    mr_zone_rooms(a, b, len(z) > 3 ? z[3] : 7);
    else if (t == "domedeck") mr_zone_domedeck(a, b);
    else if (t == "rpo")      mr_zone_rpo(a, b);
}

module mr_interior_full() {
    if (INTERIOR)
        render() intersection() {
            difference() {
                translate([0, 0, FLOOR_T]) union() { for (z = INTERIOR_ZONES) mr_zone(z); }
                if (ELEC_BOX) mr_ebox_footprint(0.6);          // pocket for the lighting-pack tray
            }
            difference() {
                union() { mr_body_solid(WALL + FLOOR_LEDGE_W + CLEAR + 0.3, -5); mr_dome_solid(WALL + CLEAR + 0.5); }
                mr_floor_boss_clear();
            }
        }
}

module mr_interior_section(i, place = true) {
    x0 = FCUT[i-1]; x1 = FCUT[i];
    if (place) mr_place(x1 - x0) translate([-x0, 0, -FLOOR_T]) mr_interior_section(i, false);
    else intersection() { mr_interior_full(); mr_xslice(x0, x1, FLOOR_T - 0.01, TOP, i == 1, i == N_FLOOR); }
}

// =====================================================================
//  mr_truck.scad  -  Milwaukee Road Nystrom-style passenger truck (BEST GUESS)
//
//  Shape proportioned from the prototype photos in Trucks/.../drawings/
//  (cast sideframe with a curved lower chord, coil spring nests either side
//  of the bolster, roller-bearing journal boxes in the pedestals).
//  Parts: 2 sideframes + 1 bolster + 2 end beams (glued), 4 printed wheels
//  (painted light silver) on 2 brass axles (AXLE_D rod cut to AXLE_TIP_LEN).
//  No brake rigging and no track power pickup on any truck.  Origin: truck centre,
//  Z = 0 at rail top.  Sizes in prototype inches via inch().
// =====================================================================

T_ZC   = inch(WHEEL_D_IN) / 2;                                   // axle centre height
T_ZTOP = ft(RAIL_TO_SILL_FT) - BOLSTER_H;                        // bolster top = under the car's pad
T_YI   = WHEEL_B2B / 2 + WHEEL_W + 1 + SF_CLEAR;                  // sideframe inner face
T_TOP  = T_ZC + inch(17);                                        // sideframe top
T_WIN  = inch(11.5);                                             // bolster window half-width

// ---- printed wheel: flange (back) face at z = 0, tread outward along +z ----
// plain printed wheel: the bore presses straight onto the brass axle (no insulating bushing)
module mr_wheel() {
    R  = inch(WHEEL_D_IN) / 2;
    rb = AXLE_D * 0.97 / 2 - WHEEL_REAM / 2;                      // press fit
    hub = AXLE_D / 2 + 3.5;
    rotate_extrude($fn = 96) polygon([
        [rb, 0], [R + FLANGE_H, 0], [R + FLANGE_H, FLANGE_T * 0.5], [R + 0.3, FLANGE_T + 0.3],
        [R, FLANGE_T + 0.8], [R - (WHEEL_W - FLANGE_T) * 0.05, WHEEL_W], [R - 2.2, WHEEL_W],
        [R - 2.2, WHEEL_W * 0.55], [hub, WHEEL_W * 0.55], [hub, WHEEL_W + 1.0], [rb, WHEEL_W + 1.0]]);
}

module mr_wheelset() {                                            // centred on the axle: brass rod + 2 printed wheels
    color(PAINT_AXLE) rotate([90, 0, 0]) cylinder(d = AXLE_D, h = AXLE_TIP_LEN, center = true, $fn = 20);
    for (s = [1, -1]) scale([1, s, 1])
        translate([0, WHEEL_B2B / 2, 0]) rotate([-90, 0, 0]) color(PAINT_WHEEL) mr_wheel();
    if (len(BRG) > 0) for (s = [1, -1]) scale([1, s, 1])            // a bearing on each axle end, in the journal box pocket
        translate([0, T_YI, 0]) rotate([-90, 0, 0]) color(PAINT_BEARING) mr_bearing();
}
module mr_bearing() {                                             // bought ball bearing (shown red): flange at z = 0, the axle runs through the bore
    difference() {
        union() {
            if (BRG[3] > 0) cylinder(d = BRG[3], h = BRG[4], $fn = 48);
            cylinder(d = BRG[1], h = BRG[4] + BRG[2], $fn = 48);
        }
        translate([0, 0, -1]) cylinder(d = BRG[0], h = BRG[4] + BRG[2] + 2, $fn = 24);
    }
}

function mr_axles(axles, wb) = axles == 3 ? [-wb/2, 0, wb/2] : [-wb/2, wb/2];

// ---- Milwaukee Road 1947 equalizer truck, MPL drawing A-4778 (Trucks/01.../drawings) ----
// Straight top member (top 3'-1" above the rail), pedestals round roller-bearing journal boxes,
// a deep box equalizer between the pedestals (5" off the rail, two lightening holes) carrying a
// coil spring nest either side of the bolster, brake cylinder on the long (3'-9") end of the frame,
// 2'-7 1/2" at the other end: 13'-4 1/2" over the frame on the 7'-0" wheelbase.
EQ = TRUCK4_STYLE == "A-4778";
function mr_truck_half(axles, wb) = (axles == 2 && TRUCK4_STYLE == "A-4778") ? wb/2 + inch(45) : wb/2 + inch(20);   // frame half length (long end); reads the config, not EQ, as the car body asks before this file has run
T_TOP_EQ = min(inch(37), ft(RAIL_TO_SILL_FT) - 1.2);            // frame top, clear of the car floor
// end beams: a cross bar at each end of the frame ties the two sideframes together (strength);
// its ends glue into slots in the sideframes' inner faces, clear of the wheels.
EB_L = inch(5);                                                  // bar size along the truck
EB_H = inch(4);                                                  // bar height
EB_Z = T_TOP_EQ - inch(5);                                       // underside of the bar (inside the top member)
EB_IN = SF_T * 0.7;                                              // how far each end goes into a sideframe
function mr_end_beam_xs(wb) = [-wb/2 - inch(29.5), wb/2 + inch(28)];
// 6-wheel truck: the frame ends stop at the outer wheels, so the same bars go across between the axles instead
function mr_cross_beam_xs(wb) = [-wb/4, wb/4];
EB_Z3 = T_TOP - inch(4.9);                                       // underside of the bar, inside the top chord
module mr_end_beam() {                                           // print flat; 2 per truck
    translate([-EB_L / 2, -T_YI - EB_IN + 0.2, 0]) cube([EB_L, 2 * (T_YI + EB_IN - 0.2), EB_H]);
}
module mr_sideframe2d_eq(wb) {
    a = wb / 2; t = T_TOP_EQ; r = inch(2);
    // top member, 6" deep; long end (brake cylinder) at -x
    hull() { translate([-a - inch(33) + r, t - r]) circle(r); translate([a + inch(31.5) - r, t - r]) circle(r);
             translate([-a - inch(33) + r, t - inch(6) + r]) circle(r); translate([a + inch(31.5) - r, t - inch(6) + r]) circle(r); }
    // ends drop to the brake gear brackets
    for (e = [[-a - inch(33), -a - inch(14)], [a + inch(14), a + inch(31.5)]])
        hull() { translate([e[0] + r, t - inch(6)]) circle(r); translate([e[1] - r, t - inch(6)]) circle(r);
                 translate([(e[0] + e[1]) / 2, t - inch(12)]) circle(inch(3)); }
    for (sx = [-1, 1]) let(x = sx * a) {
        for (k = [-1, 1]) translate([x + k * inch(7.1) + (k > 0 ? 0 : -inch(3)), inch(9)]) square([inch(3), t - inch(9) - 0.01]);   // pedestal legs
        translate([x - inch(10.1), inch(9)]) square([inch(20.2), inch(2)]);                  // pedestal tie bar
        translate([x - inch(7.1), T_ZC - inch(6)]) square([inch(14.2), inch(12)]);           // journal box in the jaw
    }
    for (sx = [-1, 1]) translate([sx * (T_WIN + inch(1.5)) - inch(1.5), inch(18)]) square([inch(3), t - inch(18) - 0.01]);   // bolster columns
    for (sx = [-1, 1]) translate([sx > 0 ? T_WIN + inch(1.5) : -a + inch(7), t - inch(9)]) square([a - inch(7) - T_WIN - inch(1.5), inch(3.5)]);   // lower rail
    difference() {                                                  // equalizer, 8 1/2" box section, 5" off the rail
        offset(r = inch(4)) offset(delta = -inch(4)) translate([-a + inch(7), inch(5)]) square([2 * (a - inch(7)), inch(13.5)]);
        for (sx = [-1, 1]) translate([sx * inch(16), inch(10)]) hull() { translate([-inch(2.5), 0]) circle(inch(1.8)); translate([inch(2.5), 0]) circle(inch(1.8)); }
    }
    for (sx = [-1, 1]) translate([sx * inch(21) - inch(4), inch(18.5) - 0.01]) square([inch(8), t - inch(6) - inch(18.5) + 0.02]);   // spring nest backing
}

// ---- 1938 Hiawatha truck (Railway Mechanical Engineer, March 1939, p. 99) - TRUCK4_STYLE = "1938" ----
// Cast frame with a straight top member, pedestals round the roller-bearing boxes, a drop equalizer
// between the journals carrying one big coil spring each side of the bolster (no elliptic springs),
// a hydraulic shock absorber at the centre and the brake cylinder on top of the frame.
// BEST GUESS from the one photo; the article gives no dimensions for the frame.
S38 = TRUCK4_STYLE == "1938";
function mr_xbeam38_xs() = [-inch(21), inch(21)];           // cross beams between the bolster and the wheels (the frame ends stop at the wheels)
EB_Z38 = T_TOP_EQ - inch(5.5);
module mr_sideframe2d_38(wb) {
    a = wb / 2; t = T_TOP_EQ; r = inch(2); re = inch(2.75);
    difference() {
        union() {
            hull() for (sx = [-1, 1], dz = [r, inch(7) - r]) translate([sx * (a + inch(10.1) - r), t - dz]) circle(r);      // top member, 7 in deep
            for (sx = [-1, 1]) {
                x = sx * a;
                for (k = [-1, 1]) translate([x + k * inch(8.6) - inch(1.5), inch(9)]) square([inch(3), t - inch(9) - 0.01]);   // pedestal legs
                translate([x - inch(10.1), inch(9)]) square([inch(20.2), inch(2)]);                                          // pedestal tie bar
                translate([x - inch(7.1), T_ZC - inch(6)]) square([inch(14.2), inch(12)]);                                   // journal box seat
            }
            // deep lower beam (drop equalizer + spring plank), 3.5 to 15.5 in above the rail, ends curling up to the pedestals
            hull() for (sx = [-1, 1]) { translate([sx * (a - inch(18)), inch(6.25)]) circle(re); translate([sx * (a - inch(19)), inch(12.75)]) circle(re); }
            pts = [[a - inch(18), inch(6.25)], [a - inch(13.5), inch(8.5)], [a - inch(11.3), inch(14)], [a - inch(10.5), inch(21)], [a - inch(10.2), inch(28)]];
            for (sx = [-1, 1]) for (k = [0:1:len(pts) - 2]) hull() {
                translate([sx * pts[k][0], pts[k][1]]) circle(re); translate([sx * pts[k + 1][0], pts[k + 1][1]]) circle(re); }
            for (sx = [-1, 1]) translate([sx * (a - inch(23)) - inch(5.5), inch(15) - 0.01]) square([inch(11), t - inch(7) - inch(15) + 0.02]);      // backing behind each spring
            for (sx = [-1, 1]) translate([sx * (T_WIN + inch(1.25)) - inch(1.25), inch(13) - 0.01]) square([inch(2.5), t - inch(7) - inch(13) + 0.02]);   // swing hangers either side of the bolster
        }
        for (sx = [-1, 1]) translate([sx * (a - inch(17)), t - inch(3.5)]) circle(d = inch(3), $fn = 20);                    // lightening holes in the top member
    }
}

// ---- sideframe outline in the X-Z plane (Z measured from the rail) ----
module mr_sideframe2d(axles, wb) {
    xs = mr_axles(axles, wb);
    hl = wb/2 + inch(20);                                        // half length
    zc = T_ZC;
    r  = inch(1.8);
    // top chord, ends sloping down to the pedestals
    hull() {
        translate([-hl + inch(8), T_TOP - r]) circle(r = r);
        translate([ hl - inch(8), T_TOP - r]) circle(r = r);
        translate([-hl + r, zc + inch(4)]) circle(r = r);
        translate([ hl - r, zc + inch(4)]) circle(r = r);
        translate([-hl + inch(10), T_TOP - inch(4)]) circle(r = r);
        translate([ hl - inch(10), T_TOP - inch(4)]) circle(r = r);
    }
    // pedestals around the journal boxes
    for (a = xs) translate([a - inch(10), zc - inch(8)]) square([inch(20), T_TOP - (zc - inch(8)) - 0.01]);
    // curved lower chord (fish belly) between pedestals
    for (i = [0:1:len(xs) - 2]) {
        x0 = xs[i] + inch(9); x1 = xs[i + 1] - inch(9); xm = (x0 + x1) / 2;
        pts = [[x0, zc - inch(5)], [x0 + (xm - x0) * 0.45, zc - inch(10)], [xm, zc - inch(11)],
               [x1 - (x1 - xm) * 0.45, zc - inch(10)], [x1, zc - inch(5)]];
        for (k = [0:1:len(pts) - 2]) hull() { translate(pts[k]) circle(r = inch(2)); translate(pts[k + 1]) circle(r = inch(2)); }
    }
    // columns either side of the bolster window
    if (axles == 2)
        for (sx = [-1, 1]) translate([sx * (T_WIN + inch(1.5)) - inch(1.5), zc - inch(10)]) square([inch(3), T_TOP - zc + inch(10) - 0.01]);
}

module mr_spring(h) {                                            // coil spring, vertical, base at z = 0
    n = 5; p = h / n; rr = inch(1.0);
    for (k = [0:1:n - 1]) translate([0, 0, rr + k * p * (h - 2 * rr) / (h - p)])
        rotate_extrude($fn = 24) translate([inch(3.5), 0]) circle(r = rr, $fn = 12);
    cylinder(r = inch(2.8), h = h);
}

// clasp brake beam: a shoe on each wheel tread joined by a beam across the truck.
// 2 per axle (fore and aft of the wheels). Printed separately (beam face on the bed), glued
// between the sideframes. Local origin: axle centre; the beam sits on the +X side.
BB_R = inch(WHEEL_D_IN) / 2;
module mr_brake_beam() {
    y0 = WHEEL_B2B / 2 + FLANGE_T + 0.6;                      // tread, clear of the flange
    y1 = T_YI - 0.3;
    translate([BB_R + 2.0, -y1, -1.0]) cube([1.8, 2 * y1, 2.0]);                                   // beam
    for (s = [1, -1]) scale([1, s, 1])
        translate([0, y0, 0]) rotate([-90, 0, 0]) linear_extrude(y1 - y0)
            intersection() {                                                                         // shoe
                difference() { circle(r = BB_R + 0.5 + 1.6, $fn = 64); circle(r = BB_R + 0.5, $fn = 64); }
                polygon([[0, 0], [30 * cos(-14), 30 * sin(-14)], [30 * cos(14), 30 * sin(14)]]);
            }
}

module mr_sideframe(axles, wb) {                                 // the +Y sideframe, inner face at y = T_YI
    xs = mr_axles(axles, wb);
    zc = T_ZC;
    eq = axles == 2 && EQ;
    s38 = axles == 2 && S38;
    difference() {
        intersection() {                                            // nothing below the inner face - it prints face down
        translate([-500, T_YI, -50]) cube([1000, 100, 200]);
        union() {
            translate([0, T_YI + SF_T, 0]) rotate([90, 0, 0]) linear_extrude(SF_T)
                if (eq) mr_sideframe2d_eq(wb); else if (s38) mr_sideframe2d_38(wb); else mr_sideframe2d(axles, wb);
            for (a = xs) {                                         // journal box + roller-bearing cap
                translate([a, T_YI + SF_T - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = inch(12), h = inch(2.5), $fn = 64);   // round journal box
                translate([a, T_YI + SF_T + inch(2.5) - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = inch(9), h = inch(2.2), $fn = 48);
                translate([a, T_YI + SF_T + inch(4.7) - 0.02, zc]) rotate([-90, 0, 0]) cylinder(d1 = inch(9), d2 = inch(7.4), h = inch(0.8), $fn = 48);   // rounded cap edge
            }
            if (eq) {
                for (sx = [-1, 1])                                    // equalizer springs, a nest either side of the bolster
                    translate([sx * inch(21), T_YI + SF_T / 2 + 0.6, inch(18.5)]) mr_spring(T_TOP_EQ - inch(6) - inch(18.5));
                translate([-wb/2 - inch(45), T_YI + SF_T / 2, T_TOP_EQ - inch(3.5)]) rotate([0, 90, 0])
                    cylinder(d = inch(11), h = inch(12), $fn = 32);    // 11" x 8" brake cylinder on the long end
                translate([-wb/2 - inch(33) - 0.01, T_YI, T_TOP_EQ - inch(8)]) cube([inch(3), SF_T + inch(2), inch(8)]);   // cylinder bracket
                for (sx = [-1, 1]) translate([sx * inch(10.5), T_YI + SF_T - 0.01, inch(19)])                              // vertical shock absorbers
                    cylinder(d = inch(3), h = T_TOP_EQ - inch(6) - inch(19), $fn = 16);
            }
            if (s38) {
                yo = T_YI + SF_T;                                     // outer face of the frame plate
                zs = inch(17); hs = T_TOP_EQ - inch(7) - zs;          // spring seat height, spring height
                for (sx = [-1, 1]) translate([sx * (wb/2 - inch(23)), T_YI + SF_T / 2 + 0.6, 0]) {      // one big coil spring each side
                    translate([0, 0, zs]) scale([1.8, 1.8, 1]) mr_spring(hs);
                    translate([0, 0, zs - inch(2.2)]) cylinder(d = inch(15), h = inch(2.2) + 0.01, $fn = 40);   // spring seat cup on the lower beam
                    translate([0, 0, zs + hs - inch(1.2)]) cylinder(d = inch(14), h = inch(1.2), $fn = 40);     // spring cap under the frame
                }
                for (zr = [inch(3.6), inch(11.4)])                    // the lower beam's two rails
                    translate([-(wb/2 - inch(19)), yo - 0.01, zr]) cube([2 * (wb/2 - inch(19)), inch(1.2), inch(3.2)]);
                translate([-inch(8.5), yo - 0.01, inch(4.5)]) cube([inch(17), inch(3), inch(6.5)]);                     // spring plank end
                translate([0, yo + inch(2), inch(10.5)]) cylinder(d = inch(6), h = T_TOP_EQ - inch(5) - inch(10.5), $fn = 24);   // hydraulic shock absorber
                for (sx = [-1, 1]) {
                    translate([sx * (T_WIN + inch(1.25)), yo - 0.01, inch(14.5)]) rotate([-90, 0, 0]) cylinder(d = inch(5), h = inch(2), $fn = 20);   // hanger pins
                    translate([sx > 0 ? T_WIN : -(wb/2 - inch(28.5)), yo - 0.01, inch(25.5)])                                   // levelizing bar arms
                        cube([wb/2 - inch(28.5) - T_WIN, inch(1.8), inch(2)]);
                }
                translate([-inch(17), yo + inch(2.2), T_TOP_EQ - inch(3.6)]) rotate([0, 90, 0]) cylinder(d = inch(7), h = inch(22), $fn = 32);   // brake cylinder
                translate([inch(5) - 0.01, yo + inch(2.2), T_TOP_EQ - inch(3.6)]) rotate([0, 90, 0]) cylinder(d = inch(2), h = inch(14), $fn = 12);   // piston rod
            }
            if (axles == 2 && !eq && !s38) {                         // spring nests
                for (sx = [-1, 1]) translate([sx * inch(22), T_YI + SF_T / 2, zc - inch(8)]) mr_spring(T_TOP - inch(4) - (zc - inch(8)));
                translate([-inch(34), T_YI + SF_T + inch(3.5), zc + inch(9)]) rotate([0, 90, 0]) cylinder(d = inch(8), h = inch(10), $fn = 24);
                translate([-inch(34), T_YI + SF_T - 0.01, zc + inch(9) - inch(2)]) cube([inch(10), inch(3.5), inch(4)]);   // bracket
                translate([-wb/2 + inch(10), T_YI + SF_T + inch(3.5), zc + inch(9)]) rotate([0, 90, 0])
                    cylinder(d = inch(1.5), h = wb/2 - inch(10) - inch(34), $fn = 10);                      // push rod
            }
        }
        }
        for (a = xs) translate([a, T_YI - 0.01, zc]) rotate([-90, 0, 0]) mr_bearing_pocket();   // bearing pocket / axle hole
        if (axles == 2) translate([-T_WIN + 0.2, T_YI - 1, T_ZTOP - inch(9) - 0.3])  // bolster tongue slot
            cube([2 * T_WIN - 0.4, SF_T * 0.7 + 1, inch(9) + 0.6]);
        if (eq) for (x = mr_end_beam_xs(wb)) translate([x - EB_L / 2 - 0.15, T_YI - 1, EB_Z - 0.15])   // end beam slots
            cube([EB_L + 0.3, EB_IN + 1, EB_H + 0.3]);
        if (s38) for (x = mr_xbeam38_xs()) translate([x - EB_L / 2 - 0.15, T_YI - 1, EB_Z38 - 0.15])              // 1938 truck: cross beam slots
            cube([EB_L + 0.3, EB_IN + 1, EB_H + 0.3]);
        if (axles == 3) for (x = mr_cross_beam_xs(wb)) translate([x - EB_L / 2 - 0.15, T_YI - 1, EB_Z3 - 0.15])   // cross beam slots
            cube([EB_L + 0.3, EB_IN + 1, EB_H + 0.3]);
    }
}

// ball-bearing pocket in the journal box, opening on the inner face (local: axis along +z from the face)
module mr_bearing_pocket(fit = BEARING_FIT) {
    if (len(BRG) == 0) cylinder(d = AXLE_HOLE_D, h = AXLE_HOLE_DEPTH + 0.01, $fn = 20);
    else {
        if (BRG[3] > 0) cylinder(d = BRG[3] + fit + 0.2, h = BRG[4] + 0.01, $fn = 48);        // flange counterbore
        cylinder(d = BRG[1] + fit, h = BRG[4] + BRG[2] + 0.01, $fn = 48);                      // bearing (press fit)
        cylinder(d = BRG[0] + 1.0, h = BRG[4] + BRG[2] + 1.2, $fn = 20);                       // relief behind the inner race; the axle tip runs through the bearing into it
    }
}
module mr_bearing_coupon() {        // fit test: three pockets at FIT - 0.05, FIT, FIT + 0.05 (engraved -, 0, +)
    difference() {
        translate([0, -6, 0]) cube([36, 12, BRG[4] + BRG[2] + 1.5]);
        for (i = [0:2]) translate([6 + i * 12, 0, -0.01]) mr_bearing_pocket(BEARING_FIT - 0.05 + i * 0.05);
        for (i = [0:2]) translate([6 + i * 12, -5.5, BRG[4] + BRG[2] + 1.1]) linear_extrude(1)
            text(i == 0 ? "-" : i == 1 ? "0" : "+", size = 3, halign = "center");
    }
}

// 6-wheel truck: the wheels stand taller than the bolster and almost reach the car floor, so nothing can cross
// above the centre axle's wheels. The bolster is a span bolster: a slab between the wheels, over the centre axle,
// with a cross arm at each end that glues into the sideframe slots (the arms are the cross beams - one part).
// The car's bolster pad sits in the round seat in the middle. Prints upside down (top face on the bed).
function mr_bolster6_top() = EB_Z3 + EB_H;
module mr_truck_bolster6(wb) {
    zt = mr_bolster6_top(); zb = T_ZC + AXLE_D / 2 + 2.5; ys = WHEEL_B2B / 2 - 2; xl = wb / 4 + EB_L / 2;
    difference() {
        union() {
            translate([-xl, -ys, zb]) cube([2 * xl, 2 * ys, zt - zb]);                              // slab between the wheels
            for (x = mr_cross_beam_xs(wb)) translate([x - EB_L / 2, -T_YI - EB_IN + 0.2, EB_Z3])   // cross arms into the sideframes
                cube([EB_L, 2 * (T_YI + EB_IN - 0.2), EB_H]);
        }
        translate([0, 0, T_ZTOP]) cylinder(d = 18, h = zt - T_ZTOP + 1, $fn = 48);                  // seat for the car's bolster pad
        translate([0, 0, zb - 1]) cylinder(d = TRUCK_SCREW_D, h = zt - zb + 2, $fn = 20);           // pivot screw
    }
}
module mr_truck_bolster(axles, wb = 0) {
    if (axles == 3) mr_truck_bolster6(wb); else mr_truck_bolster4(axles);
}
module mr_truck_bolster4(axles) {
    bt = inch(9);
    difference() {
        union() {
            translate([-inch(8), -T_YI, T_ZTOP - bt]) cube([inch(16), 2 * T_YI, bt]);             // bolster
            if (axles == 2) for (s = [1, -1]) scale([1, s, 1])                                  // tongues into the sideframes
                translate([-T_WIN + 0.4, T_YI - 0.01, T_ZTOP - inch(9)]) cube([2 * T_WIN - 0.8, SF_T * 0.7, inch(9)]);
            translate([0, 0, T_ZTOP - 0.01]) cylinder(d = 14, h = 0.01);                        // centre plate
        }
        translate([0, 0, T_ZTOP - bt - 1]) cylinder(d = TRUCK_SCREW_D, h = bt + 2, $fn = 20);   // pivot screw
    }
}

module mr_truck_model(axles = 2, wheelbase_ft = 8, frame_h_in = 22, show_wheels = true, equalizer = true) {
    wb = ft(wheelbase_ft);
    for (s = [1, -1]) scale([1, s, 1]) mr_sideframe(axles, wb);
    mr_truck_bolster(axles, wb);
    if (axles == 2 && EQ) for (x = mr_end_beam_xs(wb)) translate([x, 0, EB_Z]) mr_end_beam();   // end beams
    if (axles == 2 && S38) for (x = mr_xbeam38_xs()) translate([x, 0, EB_Z38]) mr_end_beam();    // 1938 truck: the same bars, between the bolster and the wheels
    if (show_wheels) for (a = mr_axles(axles, wb)) translate([a, 0, T_ZC]) mr_wheelset();
}

// painted truck: frame in the truck colour, wheels light silver, axles brass
module mr_truck_painted(col, axles = 2, wheelbase_ft = 8, frame_h_in = 22, show_wheels = true) {
    color(col) mr_truck_model(axles, wheelbase_ft, frame_h_in, false);
    if (show_wheels) for (a = mr_axles(axles, ft(wheelbase_ft))) translate([a, 0, T_ZC]) mr_wheelset();
}

module mr_track(len) {
    color("#8C8C8C") for (s = [-1, 1]) translate([-len/2, s * GAUGE/2 - 1.5, -8]) cube([len, 3, 8]);
}

// ---- used by the truck folders (T_* values come from the truck lib) ----
module mr_truck_part(part = "assembly") {
    wb = ft(T_WHEELBASE_FT);
    echo(str(TRUCK_NAME, ": ", T_AXLES, "-axle, wheelbase ", T_WHEELBASE_FT, " ft = ", round(wb), " mm; ",
             "cut the ", AXLE_D, " mm brass axle rod to ", AXLE_TIP_LEN, " mm; bearings: ", AXLE_BEARING, " x ", 2 * T_AXLES, " per truck"));
    if (part == "assembly") mr_truck_model(T_AXLES, T_WHEELBASE_FT);
    else if (part == "sideframe")                        // print 2 per truck, inner face down
        translate([0, 0, -T_YI]) rotate([90, 0, 0]) mr_sideframe(T_AXLES, wb);
    else if (part == "bolster") {                        // print flat (the 6-wheel span bolster prints upside down)
        if (T_AXLES == 3) translate([0, 0, mr_bolster6_top()]) rotate([180, 0, 0]) mr_truck_bolster(T_AXLES, wb);
        else translate([0, 0, -(T_ZTOP - inch(9))]) mr_truck_bolster(T_AXLES, wb);
    }
    else if (part == "wheel") mr_wheel();                // print 4 per truck, flange face down; paint light silver
    else if (part == "end_beam" && T_AXLES == 2) mr_end_beam();          // print 2 per truck, flat; glue into the sideframe slots (frame ends on the 4-wheel truck, between the axles on the 6-wheel truck)
    else if (part == "bearing_coupon") mr_bearing_coupon();   // bearing pocket fit test
    else if (part == "brake_beam")                       // print 2 per axle, beam face down
        translate([0, 0, BB_R + 3.8]) rotate([0, 90, 0]) mr_brake_beam();
    else if (part == "drawing_side") {
        projection() rotate([-90, 0, 0]) mr_truck_model(T_AXLES, T_WHEELBASE_FT);
        translate([-wb/2 - 20, -14]) text(str(TRUCK_NAME, "  1:", SCALE, "  wheelbase ", round(wb), " mm"), size = 3);
    }
    else if (part == "drawing_top")  projection() mr_truck_model(T_AXLES, T_WHEELBASE_FT);
    else if (part == "drawing_end")  projection() rotate([-90, 0, 0]) rotate([0, 0, -90]) mr_truck_model(T_AXLES, T_WHEELBASE_FT);
    else if (part == "info") echo("MRTRUCK");
}

module mr_truck_view(show_wheels = true, show_track = true, show_pad = true) {
    mr_truck_painted(PAINT_TRUCK, T_AXLES, T_WHEELBASE_FT, 22, show_wheels);
    if (show_track) mr_track(ft(T_WHEELBASE_FT) + 80);
    if (show_pad) color(PAINT_BODY, 0.5)            // car floor pad + floor, for ride height
        translate([0, 0, ft(RAIL_TO_SILL_FT) - BOLSTER_H]) {
            cylinder(d = 14, h = BOLSTER_H);
            translate([-40, -50, BOLSTER_H]) cube([80, 100, FLOOR_T]);
        }
}

// =====================================================================
//  mr_drawing.scad  —  2D technical views (export as SVG / DXF / PDF)
// =====================================================================

module mr_title(y) {
    translate([0, y])
        text(str("Milwaukee Road  ", CAR_TRAIN, "  -  ", CAR_NAME,
                 "      1:", SCALE,
                 "      body ", round(L), " x ", round(W), " x ", round(TOP), " mm",
                 "      ", N_BODY, " body/roof, ", N_FLOOR, " floor sections"),
             size = 5);
}

module mr_dim(len, y, label) {
    translate([0, y]) {
        square([len, 0.4]);
        translate([0, -2]) square([0.4, 4.4]);
        translate([len - 0.4, -2]) square([0.4, 4.4]);
    }
    translate([len/2, y + 2]) text(label, size = 4, halign = "center");
}

module mr_joint_marks(y0, h) {
    for (j = concat(BJS[0], BJS[1], RJ)) translate([j - 0.15, y0]) square([0.3, h]);   // side-wall and roof joints
    for (j = FJ) translate([j - 0.15, y0 - 6]) square([0.3, 4]);        // floor joints
}

module mr_drawing(view) {
    if (view == "side") {
        projection() rotate([-90, 0, 0]) { mr_body_full(); mr_roof_full(); mr_floor_full(); mr_railing(); }
        for (x = [-8, L + PLAT + 2]) translate([x, ROOF_Z - 0.2]) square([6, 0.4]);   // roof split line
        for (tc = TRUCK_CENTERS_FT) translate([ft(tc) - 0.2, -BOLSTER_H - 8]) square([0.4, 6]);
        mr_joint_marks(TOP + 3, 6);
        mr_dim(L, -BOLSTER_H - 16, str(round(L), " mm  (", LEN_FT, " ft prototype)"));
        mr_title(-BOLSTER_H - 32);
    } else if (view == "top") {
        projection() mr_roof_full();
        for (tc = TRUCK_CENTERS_FT) translate([ft(tc), 0]) difference() { circle(d = 6); circle(d = 5); }
        mr_joint_marks(W/2 + 3, 6);
        mr_dim(L, -W/2 - 12, str(round(L), " mm"));
        mr_title(-W/2 - 28);
    } else if (view == "end") {
        projection() rotate([-90, 0, 0]) rotate([0, 0, -90]) { mr_body_full(); mr_roof_full(); mr_floor_full(); }
        translate([-W/2, 0]) mr_dim(W, -BOLSTER_H - 12, str(round(W), " mm (", WIDTH_FT, " ft)"));
        translate([W/2 + 8, 0]) rotate(90) mr_dim(TOP, 0, str(round(TOP), " mm"));
        translate([-W/2, -BOLSTER_H - 28]) text(str(CAR_NAME, "  end view  1:", SCALE), size = 5);
    } else if (view == "plan") {       // interior plan: floor + interior seen from above
        projection() { mr_floor_full(); mr_interior_full(); }
        mr_dim(L, -W/2 - 12, str(round(L), " mm"));
        translate([0, -W/2 - 28]) text(str(CAR_NAME, "  interior plan  1:", SCALE), size = 5);
    }
}

// =====================================================================
//  mr_view.scad  —  assembled / exploded preview of all printed parts
// =====================================================================

// Paint preview: lower band and pinstripes drawn as thin skins on the straight sides
module mr_paint_bands() {
    x0 = ft(0.5);
    x1 = L - (TAIL > 0 ? TAIL : ft(0.5));
    xs = END_B == "skytop" ? min(x1, SKY_X0) : x1;          // upper pinstripe stops at the solarium glass
    zb = inch(PAINT_SKIRT_IN);
    if (PAINT_SCHEME != "MILW") for (s = [1, -1]) scale([1, s, 1]) {      // MILW: the bands are painted on the body itself (mr_body_milw)
        color(PAINT_SKIRT)  translate([x0, W/2 + 0.03, 0])            cube([x1 - x0, 0.15, zb]);
        color(PAINT_STRIPE) translate([x0, W/2 + 0.03, zb])           cube([x1 - x0, 0.2, 0.6]);
        color(PAINT_STRIPE) translate([x0, W/2 + 0.03, ROOF_Z - 0.8]) cube([xs - x0, 0.2, 0.6]);
    }
    if (TAIL > 0 && PAINT_SCHEME != "MILW") {                // carry the skirt + stripe round the tail on the skin
        color(PAINT_SKIRT)  render() intersection() { mr_paint_skin(); translate([x1, -W, -1]) cube([L - x1 + 5, 2*W, zb + 1]); }
        color(PAINT_STRIPE) render() intersection() { mr_paint_skin(); translate([x1, -W, zb]) cube([L - x1 + 5, 2*W, 0.6]); }
    }
    if (END_B == "skytop" && len(SKY_BAND) > 2)               // stainless sweep along the flanks and across the tail
        color(SKY_BAND_COLOR) render() intersection() {
            mr_paint_skin();
            rotate([90, 0, 0]) linear_extrude(2*W + 2, center = true) polygon([for (q = SKY_BAND) [ft(q[0]), inch(q[1])]]);
        }
    if (END_B == "skytop" && len(SKY_MARKER) > 1)            // red marker light lens
        color("#D01818") translate([L + 0.9, 0, inch(SKY_MARKER[0])]) rotate([0, 90, 0])
            cylinder(d = inch(SKY_MARKER[1]) * 0.78, h = 0.5, $fn = 40);
}

// thin skin standing just proud of the body, used to lay paint and lettering over curved surfaces
module mr_paint_skin(out = 0.15) {
    difference() { mr_body_solid(-out, 0); mr_body_solid(0.05, -5); }
}

// fluted stainless band (Pullman Creek Skytops): SKY_FLUTES = [x0_ft, z0_in, n, pitch_in, rib_in, depth_mm]
// raised ribs that follow the body round the tail; printed with the body, silver in the preview
module mr_sky_flutes(extra = 0) {
    if (END_B == "skytop" && len(SKY_FLUTES) > 5) {
        f = SKY_FLUTES;
        intersection() {
            difference() { mr_body_solid(-f[5] - extra, 0); mr_body_solid(0.02, -5); }
            for (k = [0:1:f[2] - 1]) translate([ft(f[0]) - extra, -W, inch(f[1] + k * f[3]) - extra])
                cube([L + 20, 2 * W, inch(f[4]) + 2 * extra]);
        }
    }
}

// marker-light boss on the skytop nose (printed with the body)
module mr_marker_led_hole() {          // 5 mm LED lights the marker lens from inside
    if (END_B == "skytop" && len(SKY_MARKER) > 1)
        translate([L - 25, 0, inch(SKY_MARKER[0])]) rotate([0, 90, 0]) cylinder(d = MARKER_LED_D, h = 30, $fn = 24);
}
module mr_marker_boss() {
    if (END_B == "skytop" && len(SKY_MARKER) > 1)
        translate([L - 3, 0, inch(SKY_MARKER[0])]) rotate([0, 90, 0]) cylinder(d = inch(SKY_MARKER[1]), h = 3.9, $fn = 40);
}

// Letterboard lettering, spread evenly between LETTER_X0_FT and LETTER_X1_FT (preview only)
// Extra side lettering: [text, x_ft (centre), baseline_in, size_in, side, spacing, font, wrap]  (preview only)
//   side: 0 = both sides at the same car position; 2 = both sides, laid out the same way as the
//   viewer sees it (x mirrored on the +Y side); -1 / 1 = one side only.  spacing: letter spacing (1 = normal)
//   font: any installed font ("" = Liberation Sans Bold); wrap: true = lay the text onto a curved body
function mr_tx_font(t) = (len(t) > 6 && t[6] != "") ? t[6] : "Liberation Sans:style=Bold";
module mr_tx(t) { text(t[0], size = inch(t[3]), halign = "center", spacing = len(t) > 5 ? t[5] : 1, font = mr_tx_font(t)); }
// which: 0 all, 1 only the items on the orange lower side, 2 only the items on the maroon (MILW scheme)
function mr_xt_z(z) = (PAINT_SCHEME == "MILW" && inch(z) > MILW_Z1 - inch(3) && inch(z) < MILW_Z2 + inch(1.2)) ? MILW_Z2 + inch(1.5) : inch(z);   // keep text off the orange stripe
// Rows of painted stars along the sides (preview only): STAR_ROWS = [[z_in (centre), x0_ft, x1_ft, count, size_in], ...]
module mr_star2d(r) { polygon([for (i = [0:9]) let(a = 90 + i * 36, q = i % 2 == 0 ? r : r * 0.4) [q * cos(a), q * sin(a)]]); }
module mr_stars() {
    if (len(STAR_ROWS) > 0) render()
        for (s = STAR_ROWS) for (k = [0:1:s[3] - 1]) {
            x = ft(s[1]) + (s[3] > 1 ? k * (ft(s[2]) - ft(s[1])) / (s[3] - 1) : 0);
            translate([x, -W/2 - 0.05, inch(s[0])]) rotate([90, 0, 0]) linear_extrude(0.2) mr_star2d(inch(s[4]) / 2);
            translate([L - x, W/2 + 0.05, inch(s[0])]) rotate([90, 0, 180]) linear_extrude(0.2) mr_star2d(inch(s[4]) / 2);
        }
}
module mr_extra_text(which = 0) {
    if (len(EXTRA_TEXT) > 0) render()
        for (t = EXTRA_TEXT) if (which == 0 || (which == 2) == (inch(t[2]) >= MILW_Z0 - 2)) {
            side = len(t) > 4 ? t[4] : 0;
            wrap = len(t) > 7 && t[7];
            if (side != 1) {
                if (wrap) intersection() {
                    mr_paint_skin(max(0.3, FLUTES == "rib" ? FLUTE_D + 0.1 : 0.3));       // stands above the stainless band / side ribs
                    translate([ft(t[1]), -W/2 + 30, mr_xt_z(t[2])]) rotate([90, 0, 0]) linear_extrude(40) mr_tx(t);
                }
                else translate([ft(t[1]), -W/2 - 0.05, mr_xt_z(t[2])]) rotate([90, 0, 0]) linear_extrude(0.2) mr_tx(t);
            }
            if (side != -1) {
                xx = side == 2 ? L - ft(t[1]) : ft(t[1]);
                if (wrap) intersection() {
                    mr_paint_skin(max(0.3, FLUTES == "rib" ? FLUTE_D + 0.1 : 0.3));       // stands above the stainless band / side ribs
                    translate([xx, W/2 - 30, mr_xt_z(t[2])]) rotate([90, 0, 180]) linear_extrude(40) mr_tx(t);
                }
                else translate([xx, W/2 + 0.05, mr_xt_z(t[2])]) rotate([90, 0, 180]) linear_extrude(0.2) mr_tx(t);
            }
        }
}

// LETTER_POS_FT (optional): one position (ft) per non-space letter on the -Y side, for letterboards
// broken up round windows; the +Y side is mirrored within LETTER_X0_FT..LETTER_X1_FT
function mr_letter_k(i) = i - len([for (j = [0:1:i]) if (LETTERING[j] == " ") 1]);
module mr_lettering() {
    n = len(LETTERING);
    lp = is_list(LETTER_POS_FT) && len(LETTER_POS_FT) > 0;
    if (n > 0) render() {
        st = (ft(LETTER_X1_FT) - ft(LETTER_X0_FT)) / max(n - 1, 1);
        for (i = [0:1:n-1]) if (LETTERING[i] != " ") {
            xa = lp ? ft(LETTER_POS_FT[mr_letter_k(i)]) : ft(LETTER_X0_FT) + i * st;
            xb = lp ? ft(LETTER_X0_FT + LETTER_X1_FT - LETTER_POS_FT[mr_letter_k(i)]) : ft(LETTER_X1_FT) - i * st;
            translate([xa, -W/2 - 0.05, mr_letter_z()]) rotate([90, 0, 0])
                linear_extrude(0.2) text(LETTERING[i], size = inch(LETTER_H_IN), halign = "center",
                                         font = "Liberation Sans:style=Bold");
            translate([xb, W/2 + 0.05, mr_letter_z()]) rotate([90, 0, 180])
                linear_extrude(0.2) text(LETTERING[i], size = inch(LETTER_H_IN), halign = "center",
                                         font = "Liberation Sans:style=Bold");
        }
    }
}

module mr_end_paint() {           // ends are gray in the UP scheme; render() avoids F5 z-fighting
    render() difference() {
        union() {
            mr_end_details(0.05);                                // ribs, posts, frame painted with the end
            mr_brake_wheel(0.05);
            for (e = mr_end_list()) mr_at_end(e)
                translate([-0.15, 0, 0]) intersection() {
                    mr_body_solid(0.05, 0); translate([-1, -W, -1]) cube([1.15, 2*W, TOP + 2]);
                }
        }
        mr_door_cuts();
        mr_diaphragms(0.02);
    }
}
module mr_end_door_paint() {      // recessed end door face (sand) and its porthole glass (teal)
    if (END_DOORS && END_DOOR_STYLE != "open") {
        color(PAINT_SCHEME == "MILW" && PAINT_END_DOOR == "#EBD381" ? MILW_ORANGE : PAINT_END_DOOR) render() difference() {   // Tom 10/6: end doors are orange in Milwaukee paint (sand in UP); a car that sets its own door colour keeps it
            for (e = mr_end_list()) mr_at_end(e)
                translate([END_DOOR_RECESS - 0.15, -ED_W/2 + 0.05, ED_Z + 0.05]) cube([0.12, ED_W - 0.1, ED_H - 0.1]);
            mr_end_door_windows();                               // keeps the door window open
        }
        if (END_DOOR_WINDOW && END_DOOR_WINDOW_SHAPE == "porthole")
            color(PAINT_END_GLASS) for (e = mr_end_list()) if (!mr_plat_end(e)) mr_at_end(e)
                translate([END_DOOR_RECESS + 0.4, 0, inch(END_DOOR_PORT_Z_IN)]) rotate([0, 90, 0])
                    cylinder(d = inch(END_DOOR_PORT_IN) + 0.4, h = 0.3, $fn = 40);
    }
}

module mr_diaphragm_paint() { color("#1C1C1C") render() mr_diaphragms(0.05); }

module mr_view(explode = 0, roof_lift = 40, floor_drop = 30,
               show_body = true, show_roof = true, show_floor = true, show_interior = true,
               show_leds = true, show_trucks = true, show_track = true) {
    lift = explode > 0 ? roof_lift : 0;
    drop = explode > 0 ? floor_drop : 0;
    for (i = [1:1:N_BODY]) translate([(i - 1) * explode, 0, 0]) {
        if (show_body) color(i % 2 == 1 ? BODY_COLOR : BODY_COLOR_ALT) mr_body_section(i, false);
        if (show_roof) translate([0, 0, lift]) color(ROOF_COLOR) mr_roof_section(i, false);
    }
    if (show_leds) translate([0, 0, lift]) color("#FFE14D") mr_led_strip_visual();
    if (show_floor) translate([(N_FLOOR - 1) * explode, 0, -drop]) color("#2A2A2A") mr_railing();
    if (show_body && SHOW_PAINT_BANDS) {
        mr_paint_bands();
        if (SHOW_LETTERING) { color("#FFFFFF") mr_stars(); color(PAINT_LETTER) mr_lettering(); if (PAINT_SCHEME == "MILW") { color(PAINT_LETTER_LOW) mr_extra_text(1); color(PAINT_LETTER) mr_extra_text(2); } else color(PAINT_LETTER) mr_extra_text(); }   // MILW: maroon on the orange, gold on the maroon
        color(PAINT_END) mr_end_paint();
        mr_end_door_paint();
        mr_diaphragm_paint();
    }
    for (i = [1:1:N_FLOOR]) translate([(i - 1) * explode, 0, -drop]) {
        if (show_floor) color(FLOOR_COLOR) mr_floor_section(i, false);
        if (show_interior && INTERIOR) color(INTERIOR_COLOR) mr_interior_section(i, false);
    }
    translate([0, 0, -drop]) {
        if (show_trucks) mr_coupler_visual();
        if (show_trucks) for (tc = TRUCK_CENTERS_FT)
            translate([ft(tc), 0, RAIL_TOP]) mr_truck_painted(PAINT_TRUCK, TRUCK_AXLES, TRUCK_WHEELBASE_FT);
        if (show_track) translate([L/2, 0, RAIL_TOP]) mr_track(L + 100 + explode * N_BODY);
    }
}

// =====================================================================
//  mr_common.scad  —  included at the BOTTOM of every car lib
//  (the car lib includes mr_base.scad at its top, then sets its values)
// =====================================================================

// ---------- TEST PRINTS: short slices that fit a small printer (e.g. Bambu P1S, 256 mm) ----------
// mr_test_part(part, x0_ft, len_mm)   part = "assembly" | "body" | "roof" | "floor" | "windows"
// The slice runs from x0_ft for len_mm; a slice that reaches either end of the car takes the whole end.
function mr_tx0(x0_ft) = x0_ft <= 0.3 ? -40 : ft(x0_ft);
function mr_tx1(x0_ft, len_mm) = ft(x0_ft) + len_mm >= L - 3 ? L + PLAT + 40 : ft(x0_ft) + len_mm;
module mr_tslice(x0, x1, z0, z1) { translate([x0, -W - 10, z0]) cube([x1 - x0, 2 * W + 20, z1 - z0]); }

module mr_test_part(part, x0_ft, len_mm) {
    x0 = mr_tx0(x0_ft); x1 = mr_tx1(x0_ft, len_mm);
    xs = max(x0, 0);                                                   // bed origin at the slice start
    if (part == "body")            // prints upright, as the full body
        translate([-xs, 0, 0]) intersection() { mr_body_full(); mr_tslice(x0, x1, -1, ROOF_Z + 1); }
    else if (part == "roof")       // prints upright on its lip
        translate([-xs, 0, -(ROOF_Z - ROOF_LIP_H)])
            intersection() { mr_roof_full(); mr_tslice(x0, x1, ROOF_Z - ROOF_LIP_H - 1, TOP + 10); }
    else if (part == "floor")      // prints upside down, floor top on the bed
        translate([-xs, 0, FLOOR_T]) rotate([180, 0, 0])
            intersection() { mr_floor_full(); mr_tslice(x0, x1, -80, FLOOR_T + 2); }
    else if (part == "windows") {  // the inserts for the windows in this slice (both sides)
        tl = [for (e = INSERT_LIST) if (ft(e[0][0]) > x0 && ft(e[0][0]) < x1) e];
        cols = max(1, floor(230 / WIN_CELL));
        if (len(tl) > 0) for (i = [0:1:len(tl) - 1]) {
            w = tl[i][0];
            translate([10 + (i % cols) * WIN_CELL, 10 + floor(i / cols) * WIN_CELL, WIN_FLANGE_T])
                translate([0, -inch(mr_win_shape(w) == 1 ? w[1] : w[2]) / 2, 0]) mr_win_insert(w, "all");
        }
    }
    else {                         // assembly preview of the slice
        translate([-xs, 0, 0]) intersection() {
            union() {
                color(BODY_COLOR) mr_body_full();
                color(ROOF_COLOR) mr_roof_full();
                color(FLOOR_COLOR) mr_floor_full();
                color(STEP_COLOR) mr_step_boxes();
                if (ELEC_BOX) color("#2B2B2B") mr_ebox();
            }
            mr_tslice(x0, x1, -80, TOP + 20);
        }
        translate([-xs, 0, 0]) for (e = INSERT_LIST) if (ft(e[0][0]) > x0 && ft(e[0][0]) < x1)
            mr_at_window(e[0], e[1]) { color(RIM_SILVER) mr_win_insert(e[0], "rim"); color(GLASS_TINT) mr_win_insert(e[0], "glass"); }
        echo(str("TEST SLICE ", x0 / ft(1), " - ", x1 / ft(1), " ft, ", x1 - x0, " mm long"));
    }
}

module mr_part(part = "assembly", section = 1) {
    echo(str(CAR_NAME, ": ", N_BODY, " body/roof sections, ", N_FLOOR, " floor sections, body ",
             round(L), " x ", round(W), " x ", round(TOP), " mm at 1:", SCALE));
    if (TOP > BED_Z || W > BED_Y)
        echo("WARNING: part taller or wider than the bed settings in mr_config.scad");
    function f1(v) = [for (j = v) round(j / ft(1) * 10) / 10];
    echo(str("SECTIONS for a ", BED_X, " mm bed (", round(BED_LEN), " mm usable), ", N_BODY, " body/roof + ", N_FLOOR, " floor.",
             "  Joints (ft from the A end): -Y wall ", f1(BJS[0]), ", +Y wall ", f1(BJS[1]), ", roof ", f1(RJ), ", floor ", f1(FJ),
             ".  Longest: body ", round(max(BODY_LENS)), ", roof ", round(max(ROOF_LENS)), ", floor ", round(max(FLOOR_LENS)), " mm"));
    if (len(TIGHT_J) > 0) echo(str("NOTE: joints on a narrow pier (no full clearance) at ", f1(TIGHT_J), " ft - check the window sockets there"));
    if (!SEC_OK || max(concat(BODY_LENS, ROOF_LENS, FLOOR_LENS)) > BED_LEN)
        echo("WARNING: a section is longer than the bed - set BODY_JOINTS_FT in the lib by hand");

    if (part == "assembly") {
        painted = SHOW_PAINT_BANDS && PAINT_SCHEME != "none";
        if (SHOW_BODY) { if (painted && PAINT_SCHEME == "MILW") mr_body_milw(); else color(BODY_COLOR) mr_body_full(); }
        if (SHOW_BODY) color("#1C1C1C") mr_brake_wheel_placed();   // separate brake wheel (TDQ-291)
        if (SHOW_ROOF) {
            if (END_B == "skytop") {           // the solarium framing is body colour, the roof gray stops at the glass
                color(ROOF_COLOR) render() intersection() { mr_roof_full(); translate([-20, -W, -10]) cube([SKY_X0 + 20, 2*W, TOP + 50]); }
                color(BODY_COLOR) render() intersection() { mr_roof_full(); translate([SKY_X0, -W, -10]) cube([L, 2*W, TOP + 50]); }
            }
            else color(ROOF_COLOR) mr_roof_full();
        }
        if (SHOW_FLOOR) { color(FLOOR_COLOR) mr_floor_full(); color("#2A2A2A") mr_railing(); }
        if (SHOW_EQUIPMENT) color("#3A3A3A") mr_equipment();
        if (SHOW_STEPS) color(STEP_COLOR)  mr_step_boxes();
        if (SHOW_INTERIOR && INTERIOR) color(INTERIOR_COLOR) mr_interior_full();
        if (SHOW_TRUCKS && SHOW_TRUCKS_ON_CAR)
            for (tc = TRUCK_CENTERS_FT)
                translate([ft(tc), 0, RAIL_TOP]) mr_truck_painted(PAINT_TRUCK, TRUCK_AXLES, TRUCK_WHEELBASE_FT);
        if (SHOW_COUPLERS && SHOW_TRUCKS_ON_CAR) mr_coupler_visual();
        if (SHOW_BODY && painted) {         // paint preview: bands, lettering, gray ends
            mr_paint_bands();
            if (SHOW_LETTERING) { color("#FFFFFF") mr_stars(); color(PAINT_LETTER) mr_lettering(); if (PAINT_SCHEME == "MILW") { color(PAINT_LETTER_LOW) mr_extra_text(1); color(PAINT_LETTER) mr_extra_text(2); } else color(PAINT_LETTER) mr_extra_text(); }   // MILW: maroon on the orange, gold on the maroon
            color(PAINT_END)    mr_end_paint();
            mr_end_door_paint();
            mr_diaphragm_paint();
        }
        if (SHOW_BODY) color(painted ? SKY_BAND_COLOR : BODY_COLOR) render() mr_sky_flutes(0.04);
        if (SHOW_LIGHT_BOX && ELEC_BOX) color("#2B2B2B") mr_ebox();
        if (SHOW_WINDOWS && SHOW_BODY && len(INSERT_LIST) > 0) { mr_win_inserts_preview(); mr_win_glass_preview(); }
        if (SHOW_BODY) color([0.55, 0.75, 0.85, 0.35]) mr_skytop_glass();   // transparent - drawn last
    }
    else if (part == "shape") {           // plain form check: body + roof in light gray, trucks for scale
        color("#D2D4D6") { mr_body_full(); mr_roof_full(); mr_step_boxes(); }
        for (tc = TRUCK_CENTERS_FT)
            translate([ft(tc), 0, RAIL_TOP]) color("#6A6A6A") mr_truck_model(TRUCK_AXLES, TRUCK_WHEELBASE_FT);
    }
    else if (part == "exploded") {       // every printed section pulled apart, in its print colours (pictures only)
        gap = max(12, L * 0.04); lift = TOP * 0.55; drop = TOP * 0.45;
        for (i = [1:1:N_BODY]) translate([(i - 1) * gap, 0, 0]) {
            mr_body_section_colours(i, false);
            translate([0, 0, lift]) color(PAINT_ROOF) mr_roof_section(i, false);
        }
        for (i = [1:1:N_FLOOR]) translate([(i - 1) * gap * (N_BODY - 1) / max(1, N_FLOOR - 1), 0, -drop]) {
            color(FLOOR_COLOR) mr_floor_section(i, false);
            if (INTERIOR) color(INTERIOR_COLOR) mr_interior_section(i, false);
        }
    }
    else if (part == "body_colours") mr_body_section_colours(min(max(section, 1), N_BODY));   // picture of the AMS print
    else if (part == "body")         mr_body_section(min(max(section, 1), N_BODY));
    else if (part == "roof")         mr_roof_section(min(max(section, 1), N_BODY));
    else if (part == "floor")        mr_floor_section(min(max(section, 1), N_FLOOR));
    else if (part == "interior")     mr_interior_section(min(max(section, 1), N_FLOOR));
    else if (part == "railing")      translate([-L, 0, -FLOOR_T]) { mr_railing(false); translate([L + PLAT + 2 * PLATA + 10, 0, 0]) mr_railing_a(); }   // prints upright
    else if (part == "drawing_side") mr_drawing("side");
    else if (part == "drawing_top")  mr_drawing("top");
    else if (part == "drawing_end")  mr_drawing("end");
    else if (part == "drawing_plan") mr_drawing("plan");
    else if (part == "battery_box")  mr_ebox_print();
    else if (part == "equipment")    mr_equipment_print();      // separate underbody equipment, top faces on the bed
    else if (part == "brake_wheel")  mr_brake_wheel_part();    // TDQ-291: print one, glue its peg into the hole in the car end
    else if (part == "steps")        mr_steps_print();          // vestibule step boxes, print on their sides         // lighting pack box, prints bottom down
    else if (part == "windows")      mr_win_print("all");     // one-colour inserts (paint the rim silver)
    else if (part == "window_rims")  color(RIM_SILVER) mr_win_print("rim");     // two-colour print: silver ...
    else if (part == "window_glass") color(GLASS_TINT) mr_win_print("glass");   // ... and tinted clear
    else if (part == "info")         echo(str("MRINFO;", N_BODY, ";", N_FLOOR, ";", INTERIOR ? 1 : 0, ";", PLAT > 0 ? 1 : 0, ";", EQ_SEP ? 1 : 0));
}


mr_part(PART, SECTION);
