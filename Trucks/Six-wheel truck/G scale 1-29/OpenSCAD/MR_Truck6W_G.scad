// =====================================================================
//  MR_Truck6W_G.scad  -  STAND-ALONE TRUCK FILE   1:29 (G scale)
//  Milwaukee Road passenger truck - Six-wheel truck
//  Created by Tom Fleming, n9szf@mac.com
//
//  Everything is in this one file.  Pick PART in the Customizer, F6, File > Export > STL or 3MF.
//    assembly        the whole truck (to look at)
//    sideframe       print 2 per truck, inner face on the bed
//    bolster         print 1 per truck; its tongues glue into the sideframes
//    end_beam        print 2 per truck; glue into the sideframe slots (frame ends on the 4-wheel truck,
//                    between the axles on the 6-wheel truck)
//    wheel           print 2 per axle, flange face down; paint light silver
//    bearing_coupon  test piece for the F683ZZ bearing pocket fit - print this first
//  Per truck you also need: 3 mm brass axle rod (length is echoed in the console), F683ZZ bearings
//  (2 per axle), an M3 pivot screw.
//  Stand-alone file: everything it needs is inside it - no other files are required.
// =====================================================================

/* [Export] */
PART = "assembly"; // [assembly, sideframe, bolster, end_beam, wheel, bearing_coupon, drawing_side, drawing_top, drawing_end, info]

/* [Show in the assembly view] */
SHOW_WHEELS = true;
SHOW_TRACK  = true;

/* [Paint] */
PAINT_SCHEME = "MILW";   // [UP, MILW, none]

/* [Hidden] */

// =====================================================================
//  mr_config.scad  —  fleet-wide settings (Milwaukee Road passenger fleet)
//  Change these once and every car and truck picks them up.
// =====================================================================

SCALE   = 29;      // 1:29 (G scale, US standard gauge). Use 32 for 1:32.
GAUGE   = 45;      // track gauge, mm

// ---- printer: Bambu Lab P1S (256 x 256 x 256 mm), PETG ----
// Every car is cut into the fewest sections that fit this bed.  Body/roof joints land on a
// window pier (never through a window, door, magnet, skytop glass or rounded tail); floor
// joints are staggered between them, clear of the trucks, battery box and underframe.
// For the 800 mm printer set BED_X/Y/Z = 800 and DIAGONAL_PRINT = true - cars then print whole.
BED_X   = 256;     // mm
BED_Y   = 256;
BED_Z   = 256;
PRINT_MARGIN   = 3;     // kept clear at each end of the bed, mm
DIAGONAL_PRINT = false; // lay long parts across the bed diagonal (only worth it on a big bed)
FILAMENT       = "PETG";
JOINT_CLEAR    = 1;     // body joint at least this far outside a window socket, mm
FLOOR_STAGGER  = 40;    // floor joints at least this far from a body joint, mm

// ---- section ID labels: engraved on every printed section ----
//   body  : inside face of the -Y side wall, just above the floor screw bosses   "1948 Coach  B2/4  A>"
//   roof  : inside face of the -Y roof lip                                        "1948 Coach  R2/4  A>"
//   floor : floor top (the face on the print bed)                                 "<A  1948 Coach  F2/5"
//   B/R/F = body/roof/floor, 2/4 = section 2 of 4 counted from the A end; the arrow points to the A end.
LABELS      = true;
LABEL_D     = 0.6;      // engraving depth, mm (3 layers at 0.2)
LABEL_SIZE  = 5;        // text height, mm (roof lip 3.5; shrinks to fit short sections)
LABEL_FONT  = "Liberation Sans:style=Bold";

// ---- print / fit ----
WALL    = 2.4;     // shell thickness, mm
FLOOR_T = 4.0;     // floor plate thickness, mm
// floor fixing: a ledge round the inside of the body sits on the floor, and screws come up
// through the floor into bosses on the side walls
FLOOR_LEDGE_W = 2.5;     // ledge width in from the wall, mm
FLOOR_LEDGE_H = 3.0;     // ledge height, mm
FLOOR_SCREW_PITCH = 150; // mm between screws along each side (at most)
FLOOR_SCREW_END   = 40;  // first / last screw from the car ends, mm
FLOOR_BOSS    = 8.0;     // boss width along the wall, mm
FLOOR_BOSS_H  = 12.0;    // boss height above the floor, mm
FLOOR_PILOT   = 2.2;     // pilot hole in the boss (M2.5 self-tapping)
FLOOR_CLEAR_D = 2.9;     // clearance hole in the floor
FLOOR_HEAD_D  = 5.2;     // counterbore for the screw head, from underneath
CLEAR   = 0.25;    // sliding fit clearance, mm
JOINT_T = 6;       // internal collar at section joints (thickens the wall round the pins)
JOINT_W = 18;
PIN_D   = 2.1;     // alignment pins: 1.75 mm filament (2.1 hole - PETG prints holes a little small)
PIN_L   = 14;      // 7 mm into each section

// ---- removable roof ----
ROOF_LIP_H = 6;    // locating lip that drops inside the body walls, mm
ROOF_LIP_T = 2.0;
MAGNETS    = true; // magnets hold the roof down
MAG_D      = 6.2;  // pocket for 6 x 3 mm neodymium disc magnets
MAG_H      = 3.2;

// ---- LED roof lighting ----
LED        = true;
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
ELEC_BOX   = true;
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
SHOW_LETTERING   = true;        // draw the letterboard lettering in previews (never part of a print)
// ---- what the assembly view shows (Customizer switches in every car file) ----
SHOW_BODY = true;  SHOW_ROOF = true;  SHOW_FLOOR = true;  SHOW_INTERIOR = true;  SHOW_WINDOWS = true;
SHOW_STEPS = true; SHOW_TRUCKS = true; SHOW_COUPLERS = true; SHOW_LIGHT_BOX = true; SHOW_EQUIPMENT = true;
// ---- multi-colour printing (AMS) ----
// COLOR_PART splits each BODY section into the three paint colours as separate solids that fit
// together exactly; load the three files as one object with three parts and give each a filament.
// The sides print upright, so the lower band and the pinstripes are plain layer changes; only the
// gray car ends change colour inside a layer.  "all" = the whole part in one piece (paint it).
COLOR_PART      = "all";   // "all" | "body" (yellow / orange) | "skirt" (gray band + car ends) | "stripe" (red pinstripes)
LAYER_H         = 0.2;     // colour boundaries are rounded to whole layers of this height, mm
PAINT_STRIPE_MM = 0.6;     // pinstripe height, mm (3 layers)
PAINT_END_SKIN  = 0.8;     // the side colour wraps this far round onto the end sheet edge, mm

// ---- vestibule steps: closed side doors with a separate printed step box under each ----
CLOSED_VESTIBULES = true;  // vestibule side doors (in DOORS) are drawn closed instead of cut open
STEP_BOTTOM_IN = 22;       // rail top to the top of the bottom step (prototype inches)
STEP_N         = 3;        // treads below the vestibule floor
STEP_TREAD_IN  = 10;       // tread depth (prototype inches)
STEP_T         = 1.2;      // tread / riser / cheek plate thickness, mm
STEP_FLANGE    = 7.0;      // mounting flange behind the stepwell, mm (2 x M2.5 screws down through the floor)
STEP_PILOT     = 2.2;      // pilot hole in the flange (M2.5 self-tapping, 8 mm)
STEP_COLOR     = "#2A2A2A";
GRAB_HOLES     = true;     // holes beside each vestibule door for bent brass-wire grab irons
GRAB_HOLE_D    = 1.1;      // for 0.8 - 1.0 mm brass wire
GRAB_OFFSET_IN = 4;        // grab iron centre line beyond the door edge (prototype inches)
GRAB_Z_IN      = [14, 56]; // bottom and top leg of each grab iron above the side sill (prototype inches)
END_GRABS      = true;     // brass-wire grab-iron holes on the end corners
END_GRAB_Y_IN  = 5;        // in from the car side (prototype inches)
END_GRAB_Z_IN  = [8, 40];  // bottom and top leg above the side sill (prototype inches)
BRAKE_WHEEL    = true;     // hand-brake wheel on the car end, left side as you face it (De Karske end views)
BRAKE_WHEEL_D_IN = 20;     // wheel diameter
BRAKE_WHEEL_Z_IN = 40;     // centre above the side sill
BRAKE_WHEEL_Y_FT = 3.4;    // centre out from the car centre line
STEP_SHIELDS   = true;     // step boxes at a car end get a skirt shield in the end plane, bottom edge angled in

// ---- window inserts: separate printed glazing (tinted pane + silver rim) pressed in from inside ----
WINDOW_INSERTS = true;   // false = plain open windows, no sockets
WIN_FLANGE  = 1.2;       // insert flange beyond the opening, mm (sits in the socket inside the wall)
WIN_FLANGE_T = 0.8;      // flange thickness, mm
WIN_FIT     = 0.12;      // press-fit clearance, mm (raise if too tight, lower if they fall out)
WIN_SOCKET_W = 1.0;      // wall of the socket rim on the inside of the car side, mm
WIN_RIM_W   = 0.9;       // silver rim seen from outside, mm
WIN_INSET   = 0.4;       // glass face sits this far in from the car side, mm
GLASS_TINT  = [0.30, 0.40, 0.46, 0.55];
RIM_SILVER  = "#C9CED3";

// ---- running gear ----
RAIL_TO_SILL_FT = 3.2; // rail top to bottom of body side sill. Prototype photos show about 2.9 ft;
                       // 3.2 ft keeps the 36 in wheels clear of the floor, which sits at the sill line
BOLSTER_H     = 6;     // pad under the car floor that sits on the truck bolster
TRUCK_SCREW_D = 3.4;   // truck pivot screw (M3)

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
COUPLER_BOX    = [30, 15, 8];   // gearbox length (along car), width, height, mm
COUPLER_SCREW_D = 1.8;          // tap hole for the gearbox screw (2-56 / M2)
// ---- car frame (floor + underframe) options ----
FRAME_ONE_PIECE = false;        // true = the floor / frame prints as ONE part whatever the bed size (needs a big bed)
EQUIP_SEPARATE  = true;         // true = underbody equipment (boxes, tanks) is NOT printed on the frame: each item is a
                                //        separate part located by holes in the frame;  false = moulded on as before
EQUIP_FIX       = "pin";        // "pin" = blind holes for 1.75 mm filament pins (glue) | "screw" = M2.5 screws down through the floor
EQUIP_PIN_DEPTH = 6;            // how far a pin / screw goes into the equipment part, mm
COUPLER_POCKET  = true;         // printed draft-gear pocket under each end: two cheeks + a back stop the gearbox slides into
COUPLER_POCKET_T = 1.6;         // cheek thickness, mm
COUPLER_FIT     = 0.3;          // clearance round the gearbox in the pocket, mm
SHOW_TRUCKS_ON_CAR = true;      // show trucks + couplers under the car in the assembly view
MIN_CURVE_D_FT  = 10;           // smallest curve on the layout, diameter in REAL feet (10 ft = 3.05 m)
COUPLER_REACH_MIN = 10;         // knuckle face at least this far beyond the body end sheet, mm
// Kadee #1906 (#1 scale Type E, centreset shank) stand-in, view only - MEASURE YOURS
KD_HEAD  = [8, 11, 8];          // knuckle head: length, width, height, mm
KD_SHANK = [5, 3.5];            // shank width, height, mm
KD_PIVOT = 8;                   // pivot, mm back from the gearbox front

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


// ===================== TRUCK DATA =====================

// =====================================================================
//  MR_Truck6W_lib.scad  -  Six-wheel passenger truck
//  Prototype values are ESTIMATES. Wheelset sizes, ride height and the
//  pivot screw are fleet-wide in common/mr_config.scad.
// =====================================================================

TRUCK_NAME     = "Six-wheel passenger truck";
T_AXLES        = 3;
T_WHEELBASE_FT = 11;     // axle to axle (prototype ft)
T_FRAME_H_IN   = 22;      // sideframe depth (prototype in)
T_EQUALIZER    = true;



// ===================== SHARED CODE =====================

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


if (PART == "assembly") {
    mr_truck_painted(PAINT_SCHEME == "none" ? PAINT_NONE : PAINT_TRUCK, T_AXLES, T_WHEELBASE_FT, 22, SHOW_WHEELS);
    if (SHOW_TRACK) mr_track(ft(T_WHEELBASE_FT) + 80);
}
else mr_truck_part(PART);
