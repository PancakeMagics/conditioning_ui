part of constants;

///
///
/// this file contains:
///
/// functions:
///   - [_voidCallback]
///
/// others
///   - [StreamConstants]
///   - [PlanesComposerCommandCombinations]
///
///

/// functions
void _voidCallback() {}
const VoidCallback kVoidCallback = _voidCallback;

const MapEntry<Alignment, Alignment> kAlignmentTopLeftPairBottomRight =
    MapEntry(Alignment.topLeft, Alignment.bottomRight);

const MapEntry<Alignment, Alignment> kAlignmentBottomRightPairTopLeft =
    MapEntry(Alignment.bottomRight, Alignment.topLeft);

extension StreamConstants on Stream {
  static Stream<double> getDoubleStream(
    int elementCount, {
    Duration interval = kDurationSecond1,
  }) async* {
    for (int i = 0; i < elementCount; i++) {
      yield i.toDouble();
      await Future.delayed(interval);
    }
  }

  static Stream<FollowerBuilder> getFollowerStream(
    int elementCount, {
    Duration interval = kDurationSecond1,
    Offset begin = Offset.zero,
    Offset distance = kOffsetScale10,
  }) async* {
    Offset offset = begin;
    for (int i = 0; i < elementCount; i++, offset += distance) {
      yield (link) => Follower(
            link: link,
            leaderOffset: offset,
            anchorOnLeader: Alignment.center,
            child: kContainerWH300Green,
          );
      await Future.delayed(interval);
    }
  }
}

/// combination planes composer command
extension PlanesComposerCommandCombinations
    on Combination<PlanesComposerCommand> {
  ///
  /// time diversity:
  /// 1.
  ///   - rA-rB-tA-tB
  ///   - 1 #
  /// 2.
  ///   - rA-rB-tA, tB (2!)
  ///   - rA-rB, tA-tB (2!)
  ///   - (C4_3 + C4_2) * 2! = 10 * 2 = 20 #
  /// 3.
  ///   - rArB, tA, tB (3!)
  ///   - rAtA, rAtB, rBtA, rBtB, tAtB ...
  ///   - C4_2 * 3! = 6 * 6 = 36 #
  /// 4.
  ///   - 4! = 24 #
  ///
  static const Combination<PlanesComposerCommand> i = Combination(
    source: PlanesComposerCommandExtension.valuesSet,
  );

  /// time diversity 1
  static const PlanesComposerCombiner in1 = _in1;

  static int _in1(PlanesComposerCommand command) => 1;

  ///
  /// time diversity 2
  ///
  static const PlanesComposerCombiner in2_1RA_2Other = _in2_1RA_2Other;
  static const PlanesComposerCombiner in2_1RB_2Other = _in2_1RB_2Other;
  static const PlanesComposerCombiner in2_1TA_2Other = _in2_1TA_2Other;
  static const PlanesComposerCombiner in2_1TB_2Other = _in2_1TB_2Other;
  static const PlanesComposerCombiner in2_1Other_2RA = _in2_1Other_2RA;
  static const PlanesComposerCombiner in2_1Other_2RB = _in2_1Other_2RB;
  static const PlanesComposerCombiner in2_1Other_2TA = _in2_1Other_2TA;
  static const PlanesComposerCombiner in2_1Other_2TB = _in2_1Other_2TB;
  static const PlanesComposerCombiner in2_1A_2B = _in2_1A_2B;
  static const PlanesComposerCombiner in2_1B_2A = _in2_1B_2A;
  static const PlanesComposerCombiner in2_1R_2T = _in2_1R_2T;
  static const PlanesComposerCombiner in2_1T_2R = _in2_1T_2R;
  static const PlanesComposerCombiner in2_1RaTb_2RbTa = _in2_1RaTb_2RbTa;
  static const PlanesComposerCombiner in2_1RbTa_2RaTa = _in2_1RbTa_2RaTa;

  static int _in2_1RA_2Other(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1RB_2Other(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1TA_2Other(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1TB_2Other(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1Other_2RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1Other_2RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1Other_2TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1Other_2TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1A_2B(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1B_2A(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1R_2T(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1T_2R(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1RaTb_2RbTa(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in2_1RbTa_2RaTa(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else {
      throw CombinationUnImplementError();
    }
  }

  ///
  /// time diversity 3
  ///
  static const PlanesComposerCombiner in3_1R_2TA_3TB = _in3_1R_2TA_3TB;
  static const PlanesComposerCombiner in3_1R_2TB_3TA = _in3_1R_2TB_3TA;
  static const PlanesComposerCombiner in3_1T_2RA_3RB = _in3_1T_2RA_3RB;
  static const PlanesComposerCombiner in3_1T_2RB_3RA = _in3_1T_2RB_3RA;
  static const PlanesComposerCombiner in3_1A_2BR_3BT = _in3_1A_2BR_3BT;
  static const PlanesComposerCombiner in3_1A_2BT_3BR = _in3_1A_2BT_3BR;
  static const PlanesComposerCombiner in3_1B_2AT_3AR = _in3_1B_2AT_3AR;
  static const PlanesComposerCombiner in3_1B_2AR_3AT = _in3_1B_2AR_3AT;
  static const PlanesComposerCombiner in3_1TB_2R_3TA = _in3_1TB_2R_3TA;
  static const PlanesComposerCombiner in3_1TA_2R_3TB = _in3_1TA_2R_3TB;
  static const PlanesComposerCombiner in3_1RA_2T_3RB = _in3_1RA_2T_3RB;
  static const PlanesComposerCombiner in3_1RB_2T_3RA = _in3_1RB_2T_3RA;
  static const PlanesComposerCombiner in3_1BR_2A_3BT = _in3_1BR_2A_3BT;
  static const PlanesComposerCombiner in3_1BT_2A_3BR = _in3_1BT_2A_3BR;
  static const PlanesComposerCombiner in3_1AT_2B_3AR = _in3_1AT_2B_3AR;
  static const PlanesComposerCombiner in3_1AR_2B_3AT = _in3_1AR_2B_3AT;
  static const PlanesComposerCombiner in3_1TA_2TB_3R = _in3_1TA_2TB_3R;
  static const PlanesComposerCombiner in3_1TB_2TA_3R = _in3_1TB_2TA_3R;
  static const PlanesComposerCombiner in3_1RA_2RB_3T = _in3_1RA_2RB_3T;
  static const PlanesComposerCombiner in3_1RB_2RA_3T = _in3_1RB_2RA_3T;
  static const PlanesComposerCombiner in3_1BR_2BT_3A = _in3_1BR_2BT_3A;
  static const PlanesComposerCombiner in3_1BT_2BR_3A = _in3_1BT_2BR_3A;
  static const PlanesComposerCombiner in3_1AT_2AR_3B = _in3_1AT_2AR_3B;
  static const PlanesComposerCombiner in3_1AR_2AT_3B = _in3_1AR_2AT_3B;
  static const PlanesComposerCombiner in3_1RaTb_2RB_3TA = _in3_1RaTb_2RB_3TA;
  static const PlanesComposerCombiner in3_1RaTb_2TA_3RB = _in3_1RaTb_2TA_3RB;
  static const PlanesComposerCombiner in3_1RbTa_2RA_3TB = _in3_1RbTa_2RA_3TB;
  static const PlanesComposerCombiner in3_1RbTa_2TB_3RA = _in3_1RbTa_2TB_3RA;
  static const PlanesComposerCombiner in3_1RA_2RbTa_3TB = _in3_1RA_2RbTa_3TB;
  static const PlanesComposerCombiner in3_1TB_2RbTa_3RA = _in3_1TB_2RbTa_3RA;
  static const PlanesComposerCombiner in3_1RB_2RaTb_3TA = _in3_1RB_2RaTb_3TA;
  static const PlanesComposerCombiner in3_1TA_2RaTb_3RB = _in3_1TA_2RaTb_3RB;
  static const PlanesComposerCombiner in3_1RA_2TB_3RbTa = _in3_1RA_2TB_3RbTa;
  static const PlanesComposerCombiner in3_1TB_2RA_3RbTa = _in3_1TB_2RA_3RbTa;
  static const PlanesComposerCombiner in3_1RB_2TA_3RaTb = _in3_1RB_2TA_3RaTb;
  static const PlanesComposerCombiner in3_1TA_2RB_3RaTb = _in3_1TA_2RB_3RaTb;

  static int _in3_1R_2TA_3TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TA_2R_3TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TB_2TA_3R(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1R_2TB_3TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TB_2R_3TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TA_2TB_3R(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1T_2RA_3RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RA_2T_3RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RB_2RA_3T(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1T_2RB_3RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RB_2T_3RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RA_2RB_3T(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1A_2BR_3BT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1BR_2A_3BT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1BT_2BR_3A(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1A_2BT_3BR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1BT_2A_3BR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1BR_2BT_3A(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1B_2AT_3AR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1AT_2B_3AR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1AR_2AT_3B(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1B_2AR_3AT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1AR_2B_3AT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1AT_2AR_3B(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RaTb_2RB_3TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RaTb_2TA_3RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RbTa_2RA_3TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RbTa_2TB_3RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RA_2RbTa_3TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TB_2RbTa_3RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RB_2RaTb_3TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TA_2RaTb_3RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RA_2TB_3RbTa(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TB_2RA_3RbTa(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 1 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 0) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1RB_2TA_3RaTb(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in3_1TA_2RB_3RaTb(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
            command.childIndex == 0 ||
        command.transformCategory == TransformCategory.translate &&
            command.childIndex == 1) {
      return 3;
    } else {
      throw CombinationUnImplementError();
    }
  }

  ///
  /// time diversity 4
  ///
  static const PlanesComposerCombiner in4_12RAB_34TAB = _in4_12RAB_34TAB;
  static const PlanesComposerCombiner in4_12RAB_34TBA = _in4_12RAB_34TBA;
  static const PlanesComposerCombiner in4_12RBA_34TAB = _in4_12RBA_34TAB;
  static const PlanesComposerCombiner in4_12RBA_34TBA = _in4_12RBA_34TBA;
  static const PlanesComposerCombiner in4_12TAB_34RAB = _in4_12TAB_34RAB;
  static const PlanesComposerCombiner in4_12TAB_34RBA = _in4_12TAB_34RBA;
  static const PlanesComposerCombiner in4_12TBA_34RAB = _in4_12TBA_34RAB;
  static const PlanesComposerCombiner in4_12TBA_34RBA = _in4_12TBA_34RBA;
  static const PlanesComposerCombiner in4_12ART_34BRT = _in4_12ART_34BRT;
  static const PlanesComposerCombiner in4_12ART_34BTR = _in4_12ART_34BTR;
  static const PlanesComposerCombiner in4_12ATR_34BRT = _in4_12ATR_34BRT;
  static const PlanesComposerCombiner in4_12ATR_34BTR = _in4_12ATR_34BTR;
  static const PlanesComposerCombiner in4_12BRT_34ART = _in4_12BRT_34ART;
  static const PlanesComposerCombiner in4_12BRT_34ATR = _in4_12BRT_34ATR;
  static const PlanesComposerCombiner in4_12BTR_34ART = _in4_12BTR_34ART;
  static const PlanesComposerCombiner in4_12BTR_34ATR = _in4_12BTR_34ATR;
  static const PlanesComposerCombiner in4_1RA_2TB_3RB_4TA =
      _in4_1RA_2TB_3RB_4TA;
  static const PlanesComposerCombiner in4_1RA_2TB_3TA_4RB =
      _in4_1RA_2TB_3TA_4RB;
  static const PlanesComposerCombiner in4_1TB_2RA_3RB_4TA =
      _in4_1TB_2RA_3RB_4TA;
  static const PlanesComposerCombiner in4_1TB_2RA_3TA_4RB =
      _in4_1TB_2RA_3TA_4RB;
  static const PlanesComposerCombiner in4_1RB_2TA_3RA_4TB =
      _in4_1RB_2TA_3RA_4TB;
  static const PlanesComposerCombiner in4_1RB_2TA_3TB_4RA =
      _in4_1RB_2TA_3TB_4RA;
  static const PlanesComposerCombiner in4_1TA_2RB_3RA_4TB =
      _in4_1TA_2RB_3RA_4TB;
  static const PlanesComposerCombiner in4_1TA_2RB_3TB_4RA =
      _in4_1TA_2RB_3TB_4RA;

  static int _in4_12RAB_34TAB(PlanesComposerCommand command) =>
      command.transformCategory.index + 1;

  static int _in4_12RAB_34TBA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12RBA_34TAB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12RBA_34TBA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12TAB_34RAB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12TAB_34RBA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12TBA_34RAB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12TBA_34RBA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12ART_34BRT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12ART_34BTR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12ATR_34BRT(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12ATR_34BTR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12BRT_34ART(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12BRT_34ATR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12BTR_34ART(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_12BTR_34ATR(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1RA_2TB_3RB_4TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1RA_2TB_3TA_4RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1TB_2RA_3RB_4TA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1TB_2RA_3TA_4RB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1RB_2TA_3RA_4TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1RB_2TA_3TB_4RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 1;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1TA_2RB_3RA_4TB(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 3;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }

  static int _in4_1TA_2RB_3TB_4RA(PlanesComposerCommand command) {
    if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 0) {
      return 1;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 1) {
      return 2;
    } else if (command.transformCategory == TransformCategory.translate &&
        command.childIndex == 1) {
      return 3;
    } else if (command.transformCategory == TransformCategory.rotate &&
        command.childIndex == 0) {
      return 4;
    } else {
      throw CombinationUnImplementError();
    }
  }
}
