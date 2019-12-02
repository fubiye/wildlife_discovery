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

  onInputModeSelect(){
    setState(() {
        ctx.state.inputMode = VIDEO_MODEL;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppContextHolder.appState = this;
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];
    if(ctx.state.inputMode == IMG_MODEL){
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: ctx.state.image == null ? Text('No image selected.') : Image.file(ctx.state.image),
      ));
      stackChildren.addAll(ctx.renders.renderBoxes(size));
      if (ctx.state.busy) {
        stackChildren.add(const Opacity(
          child: ModalBarrier(dismissible: false, color: Colors.grey),
          opacity: 0.3,
        ));
        stackChildren.add(const Center(child: CircularProgressIndicator()));
      }
    }else{
      stackChildren.add(Camera(
        cameras,
        ctx.state.model,
        setRecognitions,
      ));

      stackChildren.add(BoundBox(
          ctx.state.recognitions == null ? [] : ctx.state.recognitions,
          math.max(ctx.state.imageHeight, ctx.state.imageWidth),
          math.min(ctx.state.imageHeight, ctx.state.imageWidth),
          size.height,
          size.width,
          ctx.state.model));
    }

    return Scaffold(
      appBar: GlobalAppBar(ctx:ctx),
      body: Stack(
        children: stackChildren
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onInputModeSelect,
        tooltip: '选择输入',
        child: PopupMenuButton<InputMethod>(
          onSelected: (InputMethod inputMethod) async {
            setState(() {
              if(inputMethod == InputMethod.IMG){
                ctx.state.model = yolo;
                ctx.state.inputMode = IMG_MODEL;
                ctx.imgInput.predictImagePicker();

              }else{
                ctx.state.model = ssd;
                ctx.state.inputMode = VIDEO_MODEL;
              }
            });
            await ctx.models.loadModel();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<InputMethod>>[
            const PopupMenuItem<InputMethod>(
              value: InputMethod.IMG,
              child: Text('图片'),
            ),
            const PopupMenuItem<InputMethod>(
              value: InputMethod.VIDEO,
              child: Text('视频'),
            ),
          ],
        )
      ),
    );
  }
}