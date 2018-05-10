// First, include the module
use <../../pattern.scad>

// Define the base shape: a very modern moucharabieh
module moucharabieh(l = 10, w = 1) {
  // epsilon is an infinitesimally small value that is added to the outter
  // surfaces in order to get rid of the zero thickness artifacts induced
  // by the "difference" operation.
  epsilon = 0.1;

  difference() {
    // start with a plain square
    square([ l, l ], center=true);

    // and then dig the holes in it
    union() {
      for(i = [0 : 3]) {
        rotate([ 0, 0, i*90 ])
        union() {
          translate([ l / 2 - w, l / 2 - w])
            square([w + epsilon, w + epsilon]);
          translate([ -l / 2 + 2 * w, l / 2 - w])
            square([ l - 4 * w, w + epsilon ]);
          translate([ -l / 2 + 2 * w, -l / 2 + 2 * w ])
            square([ w, w ]);
          translate([ -l / 2 + 2 * w, -l / 2 + 3 * w, 0 ])
            rotate([ 0, 0, -45 ])
              square([ sqrt(2 * pow(w, 2)), sqrt(pow(l/2 - 3*w, 2) + pow(l / 2 - 3 * w, 2)) - w]);
          polygon(points = [ [ 0, w + sqrt(2 * w) ],
                             [ l / 2 - (w + sqrt(2 * w)), l/2],
                             [ -l/2 + (w + sqrt(2 * w)), l/2 ] ]);
        }
      }
      rotate([ 0, 0, 45 ]) square([ sqrt(2 * w), sqrt(2 * w) ], center=true);
    }
  }
}

// Instanciate the base shape, once.
size = 10;
moucharabieh(l=size);

// Define our moves: how the pattern is sprayed
moves = [
  [ size, 0 ], // For the first move, we will translate on x by two times the radius
  [ 0, size ], // For the second move, we will translate on y by two times the radius
];

// Define the boundaries: the area to spray is defined by a rectangle
bounding_box = [
  [ 0, 0 ],     // Lower left corner
  [ 100, 50 ]   // upper right corner
];

translate([ 30, 0, 0 ]) union() {
  // Spray our pattern in the bounding box
  // and extrude it
  linear_extrude(height = 1, center = true)
    spray_pattern(bounding_box, moves)
      moucharabieh(l=size, w=1);

  // Build a border around the moucharabieh
  border = 5;
  linear_extrude(height = border, center = true) difference() {
    polygon(points = [ bounding_box[0] - [ border, border ],
                       [ bounding_box[0].x - border, bounding_box[1].y + border ],
                       bounding_box[1] + [ border, border ],
                       [ bounding_box[1].x + border, bounding_box[0].y - border ] ]);
    polygon(points = [ bounding_box[0],
                       [ bounding_box[0].x, bounding_box[1].y ],
                       bounding_box[1],
                       [ bounding_box[1].x, bounding_box[0].y ] ]);
  }
}
