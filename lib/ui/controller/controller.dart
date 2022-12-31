library controller;

import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:conditioning_ui/ui/widget/compose/material/_material.dart';
import '../widget/widget.dart';


part 'controller_graph.dart';
part 'controller_room.dart';
part 'stream.dart';

part 'preference/prefer_data.dart';
part 'preference/prefer_main.dart';
part 'preference/prefer_main_extension.dart';
part 'preference/preference.dart';


abstract class MainController {
  static Widget mainScreen() {
    return const Preference(
      theme: null,
      appColor: MainColor.blue,
      animations: {},
      // child: CustomApp(
      //   screen: Screen.chatroom,
      // ),
      child: MaterialApp(
        home: CustomOverlay(child: Sample()),
      ),
    );
  }
}