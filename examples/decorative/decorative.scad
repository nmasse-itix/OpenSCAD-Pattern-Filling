// First, include the module
use <../../pattern.scad>

// Define the base shape: a curvy bean
module bean(r1, r2, spacing, h1, h2) {
  translate([ -spacing / 2, 0, 0 ]) circle(r = r1, center = true);
  translate([ spacing / 2, 0, 0 ]) circle(r = r1, center = true);
  difference() {
    square([ spacing, h1 * 2 ], center = true);
    translate([0, h2, 0]) circle(r = r2, center = true);
    translate([0, -h2, 0]) circle(r = r2, center = true);
  }
}

module bean_pattern(bounding_box, r1 = 5, r2 = 10, spacing = 20, margin = 1) {
  h2 = sqrt(pow(r1 + r2, 2) - pow(spacing / 2, 2)); // Pythagore theorem
  h1 = h2 * r1 / (r2 + r1); // Thales theorem
  distance = h2 - r2 + margin + spacing / 2 + r1;

  // Define our moves: how the pattern is sprayed
  moves = [
    [ r1 * 2 + spacing + 2 * (h2 - r2 + margin), 0 ],
    [ 0, r1 * 2 + spacing + 2 * (h2 - r2 + margin) ],
  ];

  spray_pattern(bounding_box, moves) {
    // four beans arranged in a way the pattern repeat itself
    bean(r1, r2, spacing, h1, h2);
    translate([ 0, distance ]) rotate([0, 0, 90]) bean(r1, r2, spacing, h1, h2);
    translate([ distance, distance ]) bean(r1, r2, spacing, h1, h2);
    translate([ distance, 0 ]) rotate([0, 0, 90]) bean(r1, r2, spacing, h1, h2);
  }
}

// Instanciate the base shape, once.
translate([-100, -100, 0])
  bean_pattern([[0,0],[10,10]]);

// The size of our box that will receive the decorative pattern
margin = 5;
width = 110;
length = 210;

// Define the boundaries: the area to spray is defined by a rectangle
bounding_box = [
  [ margin, margin ],                   // Lower left corner
  [ length + margin, width + margin ]   // upper right corner
];

scale([ 1, 1, -1 ]) // Flip on z axis
difference () {
  // The box
  cube([ length + 2 * margin, width + 2 * margin, 20 ]);

  // A linear extrusion of the pattern
  linear_extrude(3, center=true, convexity = 4) { // Due to the bean shape, convexity needs to be set
    intersection () { // crop the pattern to the final size, leaving a margin around
      translate(bounding_box[0])
        square(size = [ length, width ]);
      bean_pattern(bounding_box);
    }
  }
}
