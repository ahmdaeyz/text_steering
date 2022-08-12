import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:text_steering/main.dart';

/// This widget is responsible for drawing the main canvas and implementing
/// a simple "game loop" to continuously update it.
class SceneWidget extends StatefulWidget {
  const SceneWidget(this.app, {this.onUpdate});

  final ValueChanged<double>? onUpdate;

  final AppState app;

  @override
  State createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  Ticker? ticker;
  Duration currentTime = Duration.zero;
  double dt = 0.0;

  void _handleTick(Duration time) {
    setState(() {
      dt = (time - currentTime).inMicroseconds / 1000000;
      currentTime = time;
      widget.app.currentScene.update(dt);
    });
  }

  void _handleStateChange() {
    ticker?.start();
  }

  @override
  void initState() {
    super.initState();
    ticker = Ticker(_handleTick)..start();
  }

  @override
  void dispose() {
    super.dispose();
    ticker?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScenePainter(widget.app),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.app);

  AppState app;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    app.currentScene.render(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
}
