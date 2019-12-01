import 'dart:io';

import 'main.dart';

class SharedStates {
  bool busy = false;
  String model = yolo;
  List recognitions;
  File image;
  double imageHeight;
  double imageWidth;
}