import 'dart:io';

import 'consts.dart';

class SharedStates {
  bool busy = false;
  String model = yolo;
  List recognitions;
  File image;
  double imageHeight;
  double imageWidth;
}