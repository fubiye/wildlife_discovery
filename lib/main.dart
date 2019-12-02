import 'dart:async';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
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

    stackChildren.addAll(ctx.renders.renderBoxes(size));

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
        onPressed: ctx.imgInput.predictImagePicker,
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }
}