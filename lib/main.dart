import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_discovery/BoundBox.dart';

import 'package:wildlife_discovery/GlobalAppBar.dart';

import 'AppContextHolder.dart';
import 'camera.dart';
import 'consts.dart';
import 'dart:math' as math;

List<CameraDescription> cameras;

Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  AppContextHolder ctx = new AppContextHolder();

  @override
  void initState() {
    super.initState();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      ctx.state.recognitions = recognitions;
      ctx.state.imageHeight = imageHeight;
      ctx.state.imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppContextHolder.appState = this;
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

//    stackChildren.add(Positioned(
//      top: 0.0,
//      left: 0.0,
//      width: size.width,
//      child: ctx.state.image == null ? Text('No image selected.') : Image.file(ctx.state.image),
//    ));

//    stackChildren.addAll(ctx.renders.renderBoxes(size));

//    if (ctx.state.busy) {
//      stackChildren.add(const Opacity(
//        child: ModalBarrier(dismissible: false, color: Colors.grey),
//        opacity: 0.3,
//      ));
//      stackChildren.add(const Center(child: CircularProgressIndicator()));
//    }
//    stackChildren.add(Camera(
//      cameras,
//      ctx.state.model,
//      setRecognitions,
//    ));
//
//    stackChildren.add(BoundBox(
//        ctx.state.recognitions == null ? [] : ctx.state.recognitions,
//        math.max(ctx.state.imageHeight, ctx.state.imageWidth),
//        math.min(ctx.state.imageHeight, ctx.state.imageWidth),
//        size.height,
//        size.width,
//        ctx.state.model));
    return Scaffold(
      appBar: GlobalAppBar(ctx:ctx),
      body: Stack(
        children: [
          Camera(
            cameras,
            ctx.state.model,
            setRecognitions,
          ),
          BoundBox(
              ctx.state.recognitions == null ? [] : ctx.state.recognitions,
              math.max(ctx.state.imageHeight, ctx.state.imageWidth),
              math.min(ctx.state.imageHeight, ctx.state.imageWidth),
              size.height,
              size.width,
              ctx.state.model),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ctx.imgInput.predictImagePicker,
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }
}