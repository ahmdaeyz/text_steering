import 'dart:math';

import 'package:flutter/material.dart';
import 'package:text_steering/models/entity.dart';
import 'package:text_steering/models/scene.dart';
import 'package:text_steering/widgets/scene.dart';
import 'package:text_steering/widgets/text_drawer.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late Scene currentScene;

  @override
  void initState() {
    super.initState();
    currentScene = Scene("Text Steering");
  }

  List<Entity>? points;
  double? currentDt;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Steering',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: Builder(builder: (context) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onSubmitted: (value) {
                    currentScene.entities.clear();
                    currentScene.reset();
                    setState(() {
                      currentText = value;
                    });
                  },
                ),
              )),
              Center(
                child: SizedBox(
                  key: ValueKey(currentText),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: MouseRegion(
                    onHover: (details) {
                      points?.forEach((point) {
                        if ((point.position.x >=
                                details.localPosition.dx - 30) &&
                            point.position.x <=
                                (details.localPosition.dx + 30) &&
                            point.position.y >=
                                (details.localPosition.dy - 30) &&
                            point.position.y <=
                                (details.localPosition.dy + 30)) {
                          point.position.setFrom(
                              point.position + Vector2.random(Random()));
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        TextDrawer(
                          text: currentText,
                          addPoints: (entities) {
                            points = entities;
                            currentScene.addAll(entities);
                          },
                        ),
                        SceneWidget(
                          this,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
