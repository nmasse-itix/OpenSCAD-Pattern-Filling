use <../../pattern.scad>

thickness = 0.5;
alveolus_size = 5;
xstep = cos(30) * (thickness + sqrt(3) * alveolus_size / 2);
ystep = sin(30) * (thickness + sqrt(3) * alveolus_size / 2);
xmove = [ 2 * xstep, 0 ];
ymove = [ xstep, ystep ];
reinforcement_height = 2;
height = 10;

module reinforced_box(thickness, height, reinforcement_height) {
  // Reinforce the bottom
  difference() {
    linear_extrude(height = reinforcement_height)
      children(0);
    translate([0,0, thickness])
      children(1);
  }

  // Build the walls
  linear_extrude(height = height) {
    difference() {
      children(0);
      offset(-thickness)
        children(0);
    }
  }
}

// The first box has a square base
translate([100, 0])
reinforced_box(thickness, height, reinforcement_height) {
  square([40, 40], center=true);
  spray_pattern([[-20,-20], [20, 20]], [ xmove, ymove])
    cylinder(d = alveolus_size, h = reinforcement_height, center = true, $fn = 6);
}

// The second one has a circular base
reinforced_box(thickness, height, reinforcement_height) {
  circle(d=40, center=true);
  spray_pattern([[-20,-20], [20, 20]], [ xmove, ymove])
    cylinder(d = alveolus_size, h = reinforcement_height, center = true, $fn = 6);
}
