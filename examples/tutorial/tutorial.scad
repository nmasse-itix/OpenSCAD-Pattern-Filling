/*
 * Pattern spraying tutorial
 *
 * In this tutorial, we will spray the famous pattern of a football ball.
 */

// First, include the module
use <../../pattern.scad>

// Define the base shape: an octogon and a square
// "r" is the radius of the circle defining the octogon
// The size and the position of the square is determined also from this value
module mypattern(r) {
  // The octogon
  rotate([0,0,22.5])
    circle(r=r, center=true, $fn=8);

  // The square
  l = 2 * r * sin(22.5);
  translate([r,r,0])
    rotate([0,0,45])
      square([l,l], center=true);
}

// Instanciate the base shape, once.
r = 2;
mypattern(r);

// Define our moves: how the pattern is sprayed
moves = [
  [ 2*r, 0], // For the first move, we will translate on x by two times the radius
  [ 0, 2*r], // For the second move, we will translate on y by two times the radius
];

// Define the boundaries: the area to spray is defined by a rectangle
bounding_box = [
  [0,0],     // Lower left corner
  [20, 20]   // upper right corner
];

// Spray our pattern in the bounding box
translate([-40, 0, 0])
spray_pattern(bounding_box, moves)
  mypattern(r);

// Because we love clean edges, we cut the sprayed pattern at the bounding box size.
translate([20, 0, 0])
intersection() {
  spray_pattern(bounding_box, moves)
    mypattern(r);
  square(bounding_box[1] - bounding_box[0]);
}
