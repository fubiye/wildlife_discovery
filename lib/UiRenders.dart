import 'package:flutter/material.dart';
import 'package:wildlife_discovery/AppContextHolder.dart';

class UiRenders {
  AppContextHolder ctx;
  UiRenders(this.ctx);

  List<Widget> renderBoxes(Size screen) {
    if (ctx.state.recognitions == null) return [];
    if (ctx.state.imageHeight == null || ctx.state.imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = ctx.state.imageHeight / ctx.state.imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return ctx.state.recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

}