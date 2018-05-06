module spray_pattern(bounding_box, move_patterns) {
  size = bounding_box[1] - bounding_box[0];
  xn = floor(size.x / move_patterns[0].x);
  yn = floor(size.y / move_patterns[1].y);
  origin = bounding_box[0];

  for (y = [0:1:yn]) {
    for (x = [0:1:xn]) {
      move = [x, y] * move_patterns;
      complement = [
        move.x >= 0 && move.x <= size.x ? 0 : -(xn + 1) * floor(move.x / ((xn + 1) * move_patterns[0].x)),
        move.y >= 0 && move.y <= size.y ? 0 : -(xn + 1) * floor(move.y / ((xn + 1) * move_patterns[0].y))
      ];
      adjusted_move = origin + ([x, y] + complement) * move_patterns;
      translate(adjusted_move)
        children();
    }
  }
}
