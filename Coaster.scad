/* Mike Kasberg - Coaster */

// Width of the coaster at its widest point
width = 110;

// Thickness of the coaster
thickness = 5;

// How many rows of hexagons?
rows = 9;

/**
 * @param r The "radius" of the hexagon at its widest point
 * @param h The height of the hexagon
 */
module hexagon(r, h) {
  cylinder(h=h, r=r, $fn=6);
}

//hexagon(width / 2, thickness);

height = width * sin(60);
// Thickness of the hex pattern walls
wall_thickness = width / rows / 20;
// Mini hex includes the walls in its radius.
mini_hex_height = (height + (rows - 1) * wall_thickness) / rows;
mini_hex_radius = mini_hex_height / (2 * sin(60));

module empty_hexagon(r, h) {
  difference() {
    hexagon(r, h);
    translate([0, 0, -0.001]) hexagon(r - 2 * wall_thickness, h + 0.002);
  }
}

// Fills the upper right quadrand with mini hexes.
module mini_hex_plate() {
  translate([mini_hex_radius, height / 2, 0]) {
    for(col = [0:2*rows]) {
      x_offset = col * 3 * mini_hex_radius * cos(60) - (col * wall_thickness);
      y_offset = (col % 2 == 1) ? mini_hex_height / 2 : 0;
      for(i = [0:rows-1]) {
        y_shift = (mini_hex_height / 2) - (height / 2);
        translate([x_offset, y_shift + y_offset, 0]) {
          y_translation = i * (mini_hex_height - wall_thickness);
          translate([0, y_translation, 0]) empty_hexagon(r=mini_hex_radius, h=thickness);
        }
      }
    }
  }
}


hexagon(width / 2, thickness);

translate([-width / 2, -height / 2, 1]) mini_hex_plate();

