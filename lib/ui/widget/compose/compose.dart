library compose;


import 'package:flutter/material.dart';
import 'package:conditioning_ui/main.dart';
import 'package:conditioning_ui/ui/controller/controller.dart';
import 'package:conditioning_ui/ui/widget/compose/coordinate/api.dart';

import 'package:conditioning_ui/ui/widget/compose/material/_material.dart';

import 'constants/constants.dart';

part 'e.dart';

part 'others/elf.dart';
part 'others/paper/paper.dart';
part 'others/paper/paper_penetration.dart';
part 'others/paper/paper_penetration_view.dart';
part 'others/penetration/penetration.dart';
part 'others/penetration/penetration_clip.dart';

part 'others/animated_text.dart';
part 'others/item_mutation.dart';



///
/// in my application, the basic unit is a "love"; 1 love = 10 pixel
///
class Love {
  final double _value;
  double get value => _value;
  const Love(this._value);

}
