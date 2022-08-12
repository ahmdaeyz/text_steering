import 'dart:ui';

import 'package:text_steering/models/entity.dart';

class Scene {
  Scene(this.name);

  /// The name of the [Scene], shown in the left menu.
  final String name;
  final List<Entity> entities = [];

  void add(Entity e) {
    e.saveState();
    entities.add(e);
  }

  void addAll(Iterable<Entity> entities) {
    entities.forEach(add);
  }

  void update(double dt) {
    for (var e in entities) {
      e.update(dt);
    }
  }

  void render(Canvas canvas) {
    for (var e in entities) {
      e.render(canvas);
    }
  }

  void reset() {
    for (var e in entities) {
      e.restoreState();
    }
  }
}
