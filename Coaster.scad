/* Mike Kasberg - Coaster */

// Width of the coaster at its widest point
width = 110;

// Thickness of the coaster
thickness = 5;

// How many rows of hexagons?
rows = 13;

// Thickness of the hex pattern walls
wall_thickness = 0.3;

// Thickness of the outer walls
outer_wall_thickness = 2;

/**
 * @param r The "radius" of the hexagon at its widest point
 * @param h The height of the hexagon
 */
module hexagon(r, h) {
  cylinder(h=h, r=r, $fn=6);
}

height = width * sin(60);
// inner_width is for the large hexagon, less the shell.
inner_width = width - outer_wall_thickness * 2;
inner_height = inner_width * sin(60);
// Mini hex includes its walls
mini_hex_height = inner_height / rows + 0.002;
mini_hex_radius = mini_hex_height / (2 * sin(60)) + 0.002;


module empty_hexagon(r, h) {
  difference() {
    hexagon(r, h);
    translate([0, 0, -0.001]) hexagon(r - 2 * wall_thickness, h + 0.002);
  }
}

// Fills the upper right quadrant with mini hexes.
module mini_hex_plate() {
  translate([mini_hex_radius, inner_height / 2, 0]) {
    for(col = [0:2*rows]) {
      x_offset = col * 3 * mini_hex_radius * cos(60) - 0.001;
      y_offset = (col % 2 == 1) ? mini_hex_height / 2 - 0.001 : 0;
      for(i = [0:rows-1]) {
        y_shift = (mini_hex_height / 2) - (inner_height / 2);
        translate([x_offset, y_shift + y_offset, 0]) {
          y_translation = i * mini_hex_height;
          translate([0, y_translation, 0]) empty_hexagon(r=mini_hex_radius, h=thickness);
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

