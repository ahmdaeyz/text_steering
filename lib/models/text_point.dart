import 'package:flutter/material.dart';
import 'package:radiance/steering.dart';
import 'package:text_steering/models/entity.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class TextPoint extends Entity {
  TextPoint({
    Vector2? position,
    Vector2? velocity,
    required double maxSpeed,
    double size = 6,
  }) : super(
          position: position,
          size: size,
          velocity: velocity,
          kinematics: LightKinematics(maxSpeed),
        ) {
    path = Path()
      ..addOval(Rect.fromLTWH(0, size, 5, 5))
      ..close();
    paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.black;
  }

  late final Path path;
  late final Paint paint;

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(angle);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  List<Vector2> get vectors => [velocity];
}
