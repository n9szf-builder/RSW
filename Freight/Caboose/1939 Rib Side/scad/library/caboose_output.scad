// =====================================================================
//  OUTPUT MODULES
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad, which MIL_Rib_1939_caboose_Main.scad and
//  every file in View/ include.
//  Contains: caboose_print(name), caboose_installed(name),
//  caboose_preview(), caboose_report(). Main and View files call these.
// =====================================================================

// part in its PRINT orientation (what the STL export produces)
module caboose_print(name) {
    if (name == "body") {
        body();
    } else if (name == "bay") {
        // tilt so the sloped top lies flat on the bed, then flip it down
        a = atan(bay_top_slope/100);
        translate([0, 0, p(bay_h) * cos(a)]) rotate([180, 0, 0]) rotate([a, 0, 0]) bay();
    } else if (name == "toolbox") {
        rotate([90, 0, 0]) toolbox();
    } else if (name == "underframe") {
        rotate([180, 0, 0]) underframe();
    } else if (name == "deck") {
        translate([-L/2, 0, 0]) deck();
    } else if (name == "glazing") {
        glazing_sheet();
    } else if (name == "restroom") {
        translate([-(L/2 - wall), 0, 0]) restroom();
    } else if (name == "ladder") {
        ladder_flat();
    } else if (name == "smokestack") {
        translate([0, 0, 6]) smokestack();
    } else if (name == "lanternjack") {
        translate([0, 0, 5]) lanternjack();
    } else if (name == "railing") {
        railing_frame_flat(-staff_y);
    } else if (name == "brakewheel") {
        brake_wheel();
    } else if (name == "step") {
        translate([0, 0, -step_x0]) rotate([0, -90, 0]) step();
    } else if (name == "roof") {
        roof();
    } else if (name == "roofwalk") {
        translate([0, 0, walk_top]) rotate([180, 0, 0]) roofwalk();
    } else if (name == "truck_sideframe") {
        truck_sideframe_print();
    } else if (name == "truck_bolster") {
        truck_bolster_print();
    } else if (name == "truck_wheel") {
        truck_wheel();
    } else if (name == "truck") {
        // the whole truck standing on the rail, to look at - not a print part
        truck_assembly();
    } else {
        echo(str("Unknown part: ", name));
    }
}

// full painted car - the original "preview"
module caboose_preview() {
    // each part is render()ed so the preview doesn't exceed OpenSCAD's
    // CSG element limit (first preview is slower, then it's cached)
    color(paint_body) render() body();
    color(paint_black) { end_number(number_relief + 0.05); rotate([0, 0, 180]) end_number(number_relief + 0.05); }
    placed_parts(1, tb_plus);
    placed_parts(-1, tb_minus);
    color(paint_roof) translate([0, 0, H]) render() roof();
    color(paint_black) translate([0, 0, H]) render() roofwalk();
    color(paint_black) translate([p(smokejack_x), p(smokejack_y), H + roof_z(p(smokejack_y))]) render() smokestack();
    color(paint_black) translate([p(lanternjack_x), p(lanternjack_y), H + roof_z(p(lanternjack_y))]) render() lanternjack();
    color(paint_black) render() underframe();
    color(paint_black) { render() deck(); rotate([0, 0, 180]) render() deck(); }
    end_details();
    rotate([0, 0, 180]) end_details();
    color(paint_black) render() four_steps();
    if (show_wire_grabs) color(paint_white) all_wires();
    color(paint_interior) render() interior_liner();
    color(paint_interior) render() restroom();
    if (show_side_labels) color("red") side_labels();
    // glazing last so the transparency shows what's behind it
    color(paint_glass) {
        side_glazing();
        other() side_glazing();
        door_glazing();
        rotate([0, 0, 180]) door_glazing();
        translate([p(bay_x), W/2, p(bay_bottom)]) bay_glazing();
        translate([(other_side == "rotated" ? -1 : 1) * p(bay_x), -W/2, p(bay_bottom)])
            rotate([0, 0, 180]) bay_glazing();
    }
    if (show_trucks) placed_trucks();
    if (show_wheel_ghosts) %wheel_ghosts();
}

// glazing in place on the car (preview)
module placed_glazing() {
    side_glazing();
    other() side_glazing();
    door_glazing();
    rotate([0, 0, 180]) door_glazing();
    translate([p(bay_x), W/2, p(bay_bottom)]) bay_glazing();
    translate([(other_side == "rotated" ? -1 : 1) * p(bay_x), -W/2, p(bay_bottom)])
        rotate([0, 0, 180]) bay_glazing();
}

// one part (all copies of it) where it sits on the finished car, painted
module caboose_installed(name) {
    far = (other_side == "rotated") ? -1 : 1;
    if (name == "body") color(paint_body) body();
    else if (name == "bay") color(paint_body) {
        translate([p(bay_x), W/2, p(bay_bottom)]) bay();
        translate([far * p(bay_x), -W/2, p(bay_bottom)]) rotate([0, 0, 180]) bay();
    }
    else if (name == "toolbox") color(paint_body) {
        if (tb_plus) translate([p(toolbox_x), W/2, p(toolbox_bottom)]) toolbox();
        if (tb_minus) translate([far * p(toolbox_x), -W/2, p(toolbox_bottom)]) rotate([0, 0, 180]) toolbox();
    }
    else if (name == "roof") color(paint_roof) translate([0, 0, H]) roof();
    else if (name == "roofwalk") color(paint_black) translate([0, 0, H]) roofwalk();
    else if (name == "underframe") color(paint_black) underframe();
    else if (name == "deck") color(paint_black) { deck(); rotate([0, 0, 180]) deck(); }
    else if (name == "step") color(paint_black) four_steps();
    else if (name == "railing") color(paint_black) { railing(); rotate([0, 0, 180]) railing(); }
    else if (name == "brakewheel") color(paint_black)
        for (r = [0, 180]) rotate([0, 0, r]) translate([staff_x, staff_y, deck_h + p(brake_wheel_h)]) brake_wheel();
    else if (name == "ladder") color(paint_black) { ladder(); rotate([0, 0, 180]) ladder(); }
    else if (name == "smokestack") color(paint_black)
        translate([p(smokejack_x), p(smokejack_y), H + roof_z(p(smokejack_y))]) smokestack();
    else if (name == "lanternjack") color(paint_black)
        translate([p(lanternjack_x), p(lanternjack_y), H + roof_z(p(lanternjack_y))]) lanternjack();
    else if (name == "glazing") color(paint_glass) placed_glazing();
    else if (name == "restroom") color(paint_interior) restroom();
    else if (name == "truck" || name == "truck_sideframe" || name == "truck_bolster" || name == "truck_wheel") placed_trucks();
    else echo(str("Unknown part: ", name));
}

// faint see-through outline of the whole car, for context in the Views
module car_ghost() {
    %body();
    %translate([0, 0, H]) roof();
    %underframe();
}

module caboose_report() {
    echo(str("Body: ", L, " x ", W, " x ", H, " mm  |  Roof: ", RL, " x ", RW, " mm"));
    echo(str("Ladder: ", ladder_len, " mm tall, ", ladder_rungs, " rungs"));
    echo(str("Brake staff wire: cut 2 pieces ", staff_len, " mm long (1/16 in brass)"));
    echo(str("Trucks: wheelbase ", truck_wb, " mm; cut 4 brass axles (", truck_axle_d, " mm rod) ", truck_axle_len, " mm long; 8 F683ZZ bearings; 2 pivot screws"));
    echo(str("Expected coupler centerline above rail: ", floor_above_rail - kadee_box_h/2, " mm (Kadee G target 28.6)"));
}
