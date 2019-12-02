import 'dart:io';

import 'consts.dart';

class SharedStates {
  bool busy = false;
  String model = ssd;
  List recognitions;
  File image;
  double imageHeight = 0;
  double imageWidth = 0;
  String inputMode = IMG_MODEL;
}