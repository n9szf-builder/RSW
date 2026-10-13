// =====================================================================
//  MIL_Rib_1939_caboose_Main.scad
//  Milwaukee Road Rib Side Bay Window Caboose - 1939 as-built
//  G scale (1:29 default), parametric OpenSCAD
//
//  FOLDER LAYOUT
//    MIL_Rib_1939_caboose_Main.scad  - this file: the whole painted car,
//                                      and the part selector for export
//    library/   - the model, one .scad per part (+ caboose_params.scad
//                 for every setting, caboose_all.scad pulls them in)
//    View/      - one file per part: open it to see just that part,
//                 laid out for printing or in place on the car
//    Notes/     - project notes log and to-do list (PDF)
//    stl/       - exported STLs (export_all_stls.sh)
//
//  CHANGE SETTINGS in library/caboose_params.scad (dimensions, rib style,
//  road number, preview options, fits).
//
//  v28: split into library/ part files, View/ files and this Main file.
//       Geometry unchanged from v27.
//  v27: A/B labels and ghost wheels turned off in the preview.
//  v26: roof ends are just the steel roof sheet - the deep fascia band
//       across each end is removed; inner roof posts reach the sheet.
//  v25: glazing rabbets (notches) inside every window; separately printed
//       window glazing shown blue at 10% transparency; restroom on Side A,
//       right-hand end, with toilet.
//  v24: from photos of both sides of the HO model: the far side is the
//       MIRROR of the near side (not turned end-for-end); the toolbox
//       ("access door") and its grab are on Side A only; A/B labels now
//       match the photos; side windows resized.
//  v23: door panels removed; door knob added on each end door.
//  v22: inset panels on the end doors; "A"/"B" side labels in the
//       preview; battleship gray interior in the preview.
//  v21: white brass-wire grab irons and end handrails shown in the
//       preview (not printed); holes for the end handrails; short
//       crosswise running board at each roof end by the ladder.
//  v20: Milwaukee Road paint scheme in the preview; road number 01876
//       as raised lettering on the bay number board and the ends.
//  v19: ladder fix (second stile was missing); end walls now rise into
//       the roof so the platform ceiling meets the end sheet cleanly.
//  v18: ladders now reach the crowned roof surface; UNDERSIDE detail:
//       channel center sill, fish-belly crossbearers, bolster stubs,
//       K-brake (KC) cylinder/reservoir, levers, rods, train line and
//       scribed floor boards.
//  v17a: preview fix - parts are pre-rendered in the preview and the deck
//        tread-plate texture is skipped there (it is still in the STL),
//        so OpenSCAD's preview no longer gives up and shows only wheels.
//  v17: open STAIRWELLS at the platform corners: deck narrowed to the
//       area in front of the door plus a full-width end beam; floor
//       plate opened over the steps; steps mount on a rim.
//  v16: from HO #01876 close-ups: side grab positions, shallow toolbox
//       with its own grab, smaller end door window, grab holes on the
//       body ends, belt lines on the bay, tee cap on the smokestack.
//  v15: roof narrowed to the body width (bays stand clear of it); roof
//       now sits flat on the wall tops, located by corner tabs.
//  v14: bay top slopes 5% down toward the front; bay bottom square.
//  v13: from the HO reference model (#01876): end railing rebuilt with
//       corner/roof posts, one top rail and flat stanchions; ladder moved
//       inboard; brake staff moved; bigger bay end windows; wire holes
//       for the long curved grabs at each end of the sides.
//  v12: bay windows with 45-degree canted ends (end windows on the
//       angled faces); sloped underside kept as an option, off.
//  v11: 45-degree sloped underside on the bay windows.
//  v10: END LADDERS and printed SMOKESTACK + LANTERN JACK.
//  v9: end RAILINGS (printed frames) and BRAKE WHEELS on brass staffs.
//  v8: steps lean outboard (each lower tread steps out) on sloped
//      stringers; checker-plate deck option.
//  v7: deck lowered to near the body bottom; 3-tread steps with closed
//      stringers and risers, printed on their side.
//  v6: platform DECKS, corner STEPS, coupler pockets for Kadee #906.
//  v5: UNDERFRAME for USA Trains trucks + wheel/truck clearance preview.
//  v4: set up for the 1939 as-built cars; adds ROOF and wood ROOFWALK.
//  v3: build-year rib styles (1939 / 1944 / 1946), bay window presets,
//      end door as a scribed panel with a window.
//  v2: dimensions taken from a side elevation drawing (car #063),
//      calibrated at ~0.335 in/pixel (33" wheels, 38'-2" over couplers,
//      cross-checked against ~11'-9" height). Ribs are HORIZONTAL.
//
//  PROTOTYPE dimensions are in inches and scaled to mm by p().
//  MODEL construction values (walls, fits, bosses) are real mm.
//  Values marked ESTIMATE could not be read from the drawing.
//
//  Export one part at a time: set `part`, render (F6), export STL -
//  or open that part's file in View/, or run export_all_stls.sh.
// =====================================================================

part       = "preview";  // "preview" | "body" | "bay" | "toolbox" | "roof" | "roofwalk" | "underframe" | "deck" | "step" | "railing" | "brakewheel" | "ladder" | "smokestack" | "lanternjack" | "glazing" | "restroom" | "truck_sideframe" | "truck_bolster" | "truck_wheel" | "truck"

include <library/caboose_all.scad>

if (part == "preview") caboose_preview();
else caboose_print(part);

caboose_report();
