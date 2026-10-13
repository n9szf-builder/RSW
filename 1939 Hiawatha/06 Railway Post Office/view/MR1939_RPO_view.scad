// =====================================================================
//  MR1939_RPO_view.scad  -  PARTS VIEWER
//  Milwaukee Road 1939 Hiawatha  -  Railway Post Office
//  Shows every printed part assembled together, painted in the fleet
//  scheme (common/mr_config.scad). Set EXPLODE > 0 to lift the roof and
//  drop the floor + interior for a look inside.
// =====================================================================
include <../lib/MR1939_RPO_lib.scad>

/* [View] */
EXPLODE       = 0;     // [0:5:80] 0 = assembled (parts together); raise to pull them apart
ROOF_LIFT     = 40;    // [0:5:120]
FLOOR_DROP    = 30;    // [0:5:120]
SHOW_BODY     = true;
SHOW_ROOF     = true;
SHOW_FLOOR    = true;
SHOW_INTERIOR = true;
SHOW_LEDS     = true;
SHOW_TRUCKS   = true;
SHOW_TRACK    = true;  // 45 mm gauge rails

mr_view(explode = EXPLODE, roof_lift = ROOF_LIFT, floor_drop = FLOOR_DROP,
        show_body = SHOW_BODY, show_roof = SHOW_ROOF, show_floor = SHOW_FLOOR,
        show_interior = SHOW_INTERIOR, show_leds = SHOW_LEDS,
        show_trucks = SHOW_TRUCKS, show_track = SHOW_TRACK);
