/*
Customizable Hex Coaster
by Mike Kasberg

The defaults below are reasonable, but you can customize them
for a different size or different look.

13 rows works very well. Other numbers may lose symmetry, but feel
free to experiment.

LICENSE: Creative Commons - Attribution (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/
*/

// Width of the coaster at its widest point
width = 110;

// Thickness of the coaster
thickness = 5;

// How many rows of hexagons?
rows = 13;

// Thickness of the hex pattern walls
hex_wall_thickness = 0.6;

// Thickness of the outer walls
outer_wall_thickness = 2;

// Set to true for a blank center (add text in your slicer)
customizable = true;

// Customize the blank dimensions
center_row_min = 4;
// Customize the blank dimensions
center_row_max = 7;
// Customize the blank dimensions
center_col_min = 2;
// Customize the blank dimensions
center_col_max = 14;

/**
 * @param r The "radius" of the hexagon at its widest point
 * @param h The extrusion height of the hexagon (z)
 */
module hexagon(r, h) {
  cylinder(h=h, r=r, $fn=6);
}

// The setting (above) is for total wall thickness, but in practice
// (below) there are back-to-back walls.
wall_thickness = hex_wall_thickness / 2;

// height here is the y-axis
height = width * sin(60);
// inner_width and height is for the large hexagon, less the outer walls.
inner_width = width - outer_wall_thickness * 2;
inner_height = inner_width * sin(60);
// Mini hex includes its walls
mini_hex_height = inner_height / rows + 0.002;
mini_hex_radius = mini_hex_height / (2 * sin(60)) + 0.002;

/**
 * Makes a hexagon with the center cut out.
 * Wall thickness is controlled by customization params above.
 * @param r The hexagon "radius" at its widest point
 * @param h The extrusion height (z)
 */
module empty_hexagon(r, h) {
  difference() {
    hexagon(r, h);
    translate([0, 0, -0.001]) hexagon(r - 2 * wall_thickness, h + 0.002);
  }
}

/**
 * Fills the upper right quadrant with mini hexes.
 */
module mini_hex_plate() {
  translate([mini_hex_radius, inner_height / 2, 0]) {
    for(col = [0:2*rows]) {
      x_offset = col * 3 * mini_hex_radius * cos(60) - 0.001;
      y_offset = (col % 2 == 1) ? mini_hex_height / 2 - 0.001 : 0;
      offset_row_max = y_offset > 0 ? center_row_max : center_row_max + 1;
      for(i = [0:rows-1]) {
          y_shift = (mini_hex_height / 2) - (inner_height / 2);
        if (!customizable ||
            i < center_row_min ||
            i > offset_row_max ||
            col < center_col_min ||
            col > center_col_max
        ) {
          translate([x_offset, y_shift + y_offset, 0]) {
            // translate cells to their correct position in the column
            y_translation = i * mini_hex_height;
            translate([0, y_translation, 0]) empty_hexagon(r=mini_hex_radius, h=thickness);
          }
        }
      }
    }
  }
}

// Assemble all the parts
difference() {
  hexagon(width / 2, thickness);
  translate([0, 0, 1]) hexagon(inner_width / 2, thickness);
}

intersection() {
  translate([-inner_width / 2, -inner_height / 2, 0]) mini_hex_plate();
  hexagon(inner_width / 2 + 0.002, thickness);
}
