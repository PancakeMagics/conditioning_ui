import 'dart:ui' show window;

import 'package:flutter/material.dart';
import 'package:conditioning_ui/ui/controller/controller.dart';

late final MediaQueryData mediaQueryData;
late final Size windowSize;

void main() async {
  mediaQueryData = MediaQueryData.fromWindow(window);
  windowSize = mediaQueryData.size;


  runApp(MainController.mainScreen());
}

///
/// res:
/// cubic bezier: https://pub.dev/packages/bezier, advance [PathBuilderConstants]
///
///
const _readMe = '';
