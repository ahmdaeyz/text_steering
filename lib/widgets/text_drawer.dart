import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:radiance/steering.dart';
import 'package:text_steering/models/entity.dart';
import 'package:text_steering/models/text_point.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class TextDrawer extends StatefulWidget {
  final Function(List<Entity>) addPoints;
  final String text;

  const TextDrawer({Key? key, required this.addPoints, required this.text})
      : super(key: key);

  @override
  State<TextDrawer> createState() => _TextDrawerState();
}

class _TextDrawerState extends State<TextDrawer> {
  final GlobalKey theKey = GlobalKey();
  bool isVisible = true;
  List<Vector2>? whitePixels;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.text.isNotEmpty) {
        RenderRepaintBoundary boundary =
            theKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage();
        final whites = <Entity>[];
        var byteData = (await image.toByteData()) as ByteData;
        for (int col = 0; col < image.width; col++) {
          for (int row = 0; row < image.height; row++) {
            final pixelOffset = ((row * image.width) + col) * 4;
            final rgbaColor = byteData.getUint32(pixelOffset);
            if (rgbaColor == 0xFFFFFFFF) {
              final randomizingList = List.generate(
                  2 + Random.secure().nextInt(10),
                  (index) => Random.secure().nextBool());
              if (randomizingList
                  .reduce((value, element) => value && element)) {
                final thePoint = TextPoint(
                    position: Vector2(col.toDouble(), row.toDouble()),
                    velocity: Vector2(40, -10),
                    size: 10,
                    maxSpeed: 30);
                thePoint.behavior = Seek(
                    owner: thePoint,
                    point: Vector2(col.toDouble(), row.toDouble()));
                whites.add(thePoint);
              }
            }
          }
        }
        setState(() {
          isVisible = false;
        });

        widget.addPoints(whites);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.text.isNotEmpty
        ? Visibility(
            key: theKey,
            visible: isVisible,
            child: RepaintBoundary(
                child: Container(
              color: Colors.black,
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 150),
              ),
            )),
          )
        : const SizedBox.shrink();
  }
}
