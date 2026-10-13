// =====================================================================
//  TRUCK  -  printed Bettendorf-style freight / caboose truck
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad.
//
//  Built the same way as the passenger car trucks, so the bought parts
//  are the same: printed wheels pressed on a 3 mm brass rod axle, the
//  axle ends running in F683ZZ flanged ball bearings (3 x 7 x 3) pressed
//  into the journal boxes. No brake rigging, no track power pickup.
//
//  Per truck:  2 sideframes + 1 bolster (glued together), 4 wheels,
//              2 axles (brass rod), 4 bearings, 1 pivot screw (~3 mm).
//  Per car:    two trucks.
//
//  The SHAPE IS A BEST GUESS: a typical cast Bettendorf freight sideframe
//  of the 1930s (5'-6" wheelbase, 33" wheels), drawn by eye. No drawing
//  or photo of this caboose's own trucks is in the project yet.
//
//  Truck origin: truck centre, z = 0 at the rail top, x along the track.
//  The top of the bolster is truck_bolster_h above the rail, where the
//  car's bolster pad rests (see "underframe / trucks" in the params).
// =====================================================================

// ---------------- truck settings ----------------
truck_axle_d    = 3.0;    // mm, brass axle rod
truck_brg       = [3, 7, 3, 8.1, 0.8];  // F683ZZ: bore, OD, width, flange OD, flange thickness
truck_brg_fit   = 0.10;   // mm, pocket oversize on the bearing OD        CHECK with a test print
wheel_b2b       = 40.5;   // mm, back-to-back between the wheels (G standard)
wheel_w         = 6.5;    // mm, wheel width including the flange
wheel_flange_t  = 1.5;    // mm
wheel_flange_h  = 2.0;    // mm
truck_sf_t      = 4.5;    // mm, sideframe thickness
truck_sf_clear  = 0.8;    // mm, gap between wheel hub and sideframe
truck_screw_d   = 3.4;    // mm, clearance for the pivot screw through the bolster
truck_bolster_d = 8;      // mm, bolster depth (top to underside)
truck_bolster_l = p(12);  // bolster size along the track
truck_tongue    = 2.4;    // mm, how far each bolster end goes into a sideframe
truck_top_in    = 27.5;   // inches above rail: top of the sideframe         ESTIMATE
truck_end_in    = 7.5;    // inches the frame runs past each axle            ESTIMATE
paint_wheel     = "#D9DCDF";  // printed wheels, painted light silver
paint_axle      = "#B5A642";  // brass
paint_bearing   = "#D01C1F";  // bearings shown red so they are easy to spot

// ---------------- derived ----------------
t_zc   = wheel_dia / 2;                                           // axle centre above the rail
t_yi   = wheel_b2b / 2 + wheel_w + 1 + truck_sf_clear;             // sideframe inner face
t_win  = p(8);                                                    // bolster tongue half-width
t_brg_depth = truck_brg[4] + truck_brg[2] + 0.5;                  // axle end goes this far into a sideframe
truck_axle_len = 2 * (t_yi + t_brg_depth) - 0.4;                  // cut the brass rod to this

// ---------------- wheel ----------------
// flange (back) face at z = 0, tread outward along +z. Print flange face down.
module truck_wheel() {
    R   = wheel_dia / 2;
    rb  = truck_axle_d * 0.97 / 2;                                // press fit on the axle
    hub = truck_axle_d / 2 + 3.5;
    rotate_extrude($fn = 96) polygon([
        [rb, 0], [R + wheel_flange_h, 0], [R + wheel_flange_h, wheel_flange_t * 0.5], [R + 0.3, wheel_flange_t + 0.3],
        [R, wheel_flange_t + 0.8], [R - (wheel_w - wheel_flange_t) * 0.05, wheel_w], [R - 2.2, wheel_w],
        [R - 2.2, wheel_w * 0.55], [hub, wheel_w * 0.55], [hub, wheel_w + 1.0], [rb, wheel_w + 1.0]]);
}

module truck_bearing() {                                          // bought part, for the views only
    difference() {
        union() {
            cylinder(d = truck_brg[3], h = truck_brg[4], $fn = 48);
            cylinder(d = truck_brg[1], h = truck_brg[4] + truck_brg[2], $fn = 48);
        }
        translate([0, 0, -1]) cylinder(d = truck_brg[0], h = truck_brg[4] + truck_brg[2] + 2, $fn = 24);
    }
}

module truck_wheelset() {                                         // centred on the axle
    color(paint_axle) rotate([90, 0, 0]) cylinder(d = truck_axle_d, h = truck_axle_len, center = true, $fn = 20);
    for (s = [1, -1]) scale([1, s, 1]) {
        translate([0, wheel_b2b / 2, 0]) rotate([-90, 0, 0]) color(paint_wheel) truck_wheel();
        translate([0, t_yi, 0]) rotate([-90, 0, 0]) color(paint_bearing) truck_bearing();
    }
}

// ---------------- sideframe ----------------
// side view outline (x along the track, y up from the rail), one piece
module truck_sideframe2d() {
    h  = truck_wb / 2;                 // axle position
    zt = p(truck_top_in);              // top of the frame over the bolster
    e  = p(truck_end_in);
    difference() {
        polygon([
            [-h - e, p(10.5)], [-h - e, p(22.5)], [-h + p(4), p(23.5)], [-p(15), zt],
            [ p(15), zt], [ h - p(4), p(23.5)], [ h + e, p(22.5)], [ h + e, p(10.5)],
            [ h - p(6), p(10.5)], [ p(14), p(6)], [-p(14), p(6)], [-h + p(6), p(10.5)]]);
        // the open triangle between the column and the pedestal, each side
        for (s = [1, -1]) scale([s, 1])
            polygon([[p(12.5), p(10.6)], [p(12.5), p(23.8)], [h - p(8), p(20.3)], [h - p(8), p(14.4)]]);
    }
}

module truck_bearing_pocket() {       // opens on the inner face; axis along +z from the face
    cylinder(d = truck_brg[3] + truck_brg_fit + 0.2, h = truck_brg[4] + 0.01, $fn = 48);              // flange counterbore
    cylinder(d = truck_brg[1] + truck_brg_fit, h = truck_brg[4] + truck_brg[2] + 0.01, $fn = 48);      // bearing, press fit
    cylinder(d = truck_brg[0] + 1.0, h = truck_brg[4] + truck_brg[2] + 1.2, $fn = 20);                // relief for the axle tip
}

// the +Y sideframe in place: inner face at y = t_yi, detail on the outside
module truck_sideframe() {
    h  = truck_wb / 2;
    yo = t_yi + truck_sf_t;            // outer face of the frame
    yf = yo - 1.0;                     // floor of the recessed bolster window
    zb = truck_bolster_h;              // bolster top
    difference() {
        union() {
            translate([0, yo, 0]) rotate([90, 0, 0]) linear_extrude(truck_sf_t) truck_sideframe2d();
            for (a = [-h, h]) {
                // journal box: a square box with a sloping lid
                translate([a - p(4.5), yo - 0.01, t_zc - p(5)]) cube([p(9), p(3.2), p(10.5)]);
                translate([a - p(4), yo + p(3.2) - 0.02, t_zc - p(4.5)]) hull() {
                    cube([p(8), 0.01, p(9.5)]);
                    translate([p(0.5), p(1.3), p(0.3)]) cube([p(7), 0.01, p(7.5)]);
                }
            }
            translate([-p(8.5), yo - 0.01, p(8.3)]) cube([p(17), p(2.4), p(1.7)]);        // spring seat lip
        }
        // bolster window, recessed (not through - the bolster tongue slot is behind it)
        translate([-p(8.5), yf, p(10)]) cube([p(17), 1.01, p(14)]);
        // bearing pockets
        for (a = [-h, h]) translate([a, t_yi - 0.01, t_zc]) rotate([-90, 0, 0]) truck_bearing_pocket();
        // slot for the bolster tongue
        translate([-t_win, t_yi - 1, zb - truck_bolster_d - 0.15]) cube([2 * t_win, truck_tongue + 1.2, truck_bolster_d + 0.3]);
    }
    // in the window: the bolster end, and two coil springs standing on the spring seat
    translate([-p(7), yf - 0.01, zb - p(6.5)]) cube([p(14), 1.0 + p(1.0), p(6)]);
    for (sx = [-1, 1]) translate([sx * p(3.7), yf + 0.3, p(10)])
        for (k = [0 : 4]) translate([0, 0, p(0.9) + k * p(1.5)])
            rotate_extrude($fn = 24) translate([p(2.0), 0]) circle(r = p(0.9), $fn = 10);
}

// ---------------- bolster ----------------
// beam between the two sideframes; its ends glue into the sideframe slots.
// The car's bolster pad sits on the round centre plate; the pivot screw
// goes up through the hole into the pilot hole in the underframe.
module truck_bolster() {
    zb = truck_bolster_h;
    difference() {
        union() {
            translate([-truck_bolster_l / 2, -t_yi, zb - truck_bolster_d]) cube([truck_bolster_l, 2 * t_yi, truck_bolster_d]);
            for (s = [1, -1]) scale([1, s, 1])
                translate([-t_win + 0.2, t_yi - 0.01, zb - truck_bolster_d]) cube([2 * t_win - 0.4, truck_tongue - 0.2, truck_bolster_d]);
            translate([0, 0, zb - truck_bolster_d]) cylinder(d = 16, h = truck_bolster_d, $fn = 48);   // centre plate
        }
        translate([0, 0, zb - truck_bolster_d - 1]) cylinder(d = truck_screw_d, h = truck_bolster_d + 2, $fn = 24);
    }
}

// ---------------- whole truck ----------------
module truck_frame() {                                            // the printed, glued frame
    for (s = [1, -1]) scale([1, s, 1]) truck_sideframe();
    truck_bolster();
}
module truck_assembly(wheels = true) {
    color(paint_black) truck_frame();
    if (wheels) for (a = [-truck_wb / 2, truck_wb / 2]) translate([a, 0, t_zc]) truck_wheelset();
}
// both trucks in place under the car (car z = 0 is the bottom of the body)
module placed_trucks(wheels = true) {
    for (x = [-p(truck_centers) / 2, p(truck_centers) / 2])
        translate([x, 0, -floor_above_rail]) truck_assembly(wheels);
}

// print layouts
module truck_sideframe_print() { translate([0, 0, -t_yi]) rotate([90, 0, 0]) truck_sideframe(); }   // inner face down
module truck_bolster_print()   { translate([0, 0, -(truck_bolster_h - truck_bolster_d)]) truck_bolster(); }
