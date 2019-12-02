import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart';

import 'AppContextHolder.dart';
import 'consts.dart';

class Models {
  AppContextHolder ctx;
  Models(this.ctx);

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      switch (ctx.state.model) {
        case yolo:
          res = await Tflite.loadModel(
            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt",
          );
          break;
        default:
          res = await Tflite.loadModel(
              model: "assets/ssd_mobilenet.tflite",
              labels: "assets/ssd_mobilenet.txt");
          break;
      }
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future predictImage(File image) async {
    if (image == null) return;

    switch (ctx.state.model) {
      case yolo:
        await yolov2Tiny(image);
        break;
      case ssd:
        await ssdMobileNet(image);
        break;
      default:
        await recognizeImage(image);
    }

    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
        AppContextHolder.appState.setState(() {
        ctx.state.imageHeight = info.image.height.toDouble();
        ctx.state.imageWidth = info.image.width.toDouble();
      });
    }));

    AppContextHolder.appState.setState(() {
      ctx.state.image = image;
      ctx.state.busy = false;
    });
  }

  Future yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1,
    );
    AppContextHolder.appState.setState(() {
      ctx.state.recognitions = recognitions;
    });
  }

  Future ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      numResultsPerClass: 5,
    );
    AppContextHolder.appState.setState(() {
      ctx.state.recognitions = recognitions;
    });
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    AppContextHolder.appState.setState(() {
      ctx.state.recognitions = recognitions;
    });
  }

}



