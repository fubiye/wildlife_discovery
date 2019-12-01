import 'dart:async';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wildlife_discovery/GlobalAppBar.dart';

import 'AppContextHolder.dart';
import 'consts.dart';

void main() => runApp(new App());

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

  Future predictImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      ctx.state.busy = true;
    });
    ctx.models.predictImage(image);
  }

  @override
  void initState() {
    super.initState();
  }
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

  @override
  Widget build(BuildContext context) {
    AppContextHolder.appState = this;
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: ctx.state.image == null ? Text('No image selected.') : Image.file(ctx.state.image),
      ));
    if (ctx.state.model == ssd || ctx.state.model == yolo) {
      stackChildren.addAll(renderBoxes(size));
    }


    if (ctx.state.busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: GlobalAppBar(ctx:ctx),
      body: Stack(
        children: stackChildren,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: predictImagePicker,
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }
}