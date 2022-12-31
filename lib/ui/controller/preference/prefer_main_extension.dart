part of controller;

///
/// this file contains
/// 1. 
///


/// default animation preferences
extension PreferAnimationDefaultData on PreferAnimationPlacement {
  PreferAnimation get defaultPreference {
    throw UnimplementedError();
  }
}

/// default color preferences
/// 
///
extension PreferColorDefaultData on MainColor {
  // static const pureRed = Color(0xFFff0000);
  // static const pureRedGreen = Color(0xFFffff00);
  // static const pureGreen = Color(0xFF00ff00);
  // static const pureGreenBlue = Color(0xFF00ffff);
  // static const pureBlue = Color(0xFF0000ff);
  // static const pureBlueRed = Color(0xFFff00ff);

  static MainColor get randomMainColor {
    final randomInt = Random().nextInt(6);
    switch (randomInt) {
      case 0:
        return MainColor.red;
      case 1:
        return MainColor.orange;
      case 2:
        return MainColor.yellow;
      case 3:
        return MainColor.green;
      case 4:
        return MainColor.blue;
      case 5:
        return MainColor.purple;
      default:
        throw UnimplementedError();
    }
  }

  /// R
  static const redB1 = Color(0xFFffe0e0);
  static const redB2 = Color(0xFFffcdcd);
  static const redB3 = Color(0xFFf09999);
  static const redPrimary = Color(0xFFdd5555);
  static const redD3 = Color(0xFF991515);
  static const redD2 = Color(0xFF771010);
  static const redD1 = Color(0xFF440000);

  /// G
  static const greenB1 = Color(0xFFe0ffe0);
  static const greenB2 = Color(0xFFcdffcd);
  static const greenB3 = Color(0xFF99f099);
  static const greenPrimary = Color(0xFF22dd22);
  static const greenD3 = Color(0xFF2c772c);
  static const greenD2 = Color(0xFF1d661d);
  static const greenD1 = Color(0xFF004400);

  /// B
  static const blueB1 = Color(0xFFe0e0ff);
  static const blueB2 = Color(0xFFcdcdff);
  static const blueB3 = Color(0xFFaeaef0);
  static const bluePrimary = Color(0xFF5656dd);
  static const blueD3 = Color(0xFF2c2caa);
  static const blueD2 = Color(0xFF1d1d99);
  static const blueD1 = Color(0xFF000044);

  /// oranges that G over B oranges
  static const orangeB1 = Color(0xFFffeeaa);
  static const orangeB2 = Color(0xFFffcc99);
  static const orangeB3 = Color(0xFFffaa77);
  static const orangePrimary = Color(0xFFdd6644);
  static const orangeD3 = Color(0xFF885511);
  static const orangeD2 = Color(0xFF663300);
  static const orangeD1 = Color(0xFF551100);

  /// yellows that R over G
  static const yellowB1 = Color(0xFFffffee);
  static const yellowB1_1 = Color(0xFFffeeee);
  static const yellowB2 = Color(0xFFffeeaa);
  static const yellowB3 = Color(0xFFffee11);
  static const yellowPrimary = Color(0xFFddcc88);
  static const yellowD3 = Color(0xFFaa9944);
  static const yellowD2 = Color(0xFF998844);
  static const yellowD1 = Color(0xFF776633);

  /// purples that B over R
  static const purpleB1 = Color(0xFFececff);
  static const purpleB2 = Color(0xFFdcdcff);
  static const purpleB3 = Color(0xFFbcbcff);
  static const purpleB4 = Color(0xFFa1a7ee);
  static const purplePrimary = Color(0xFF8833dd);
  static const purpleD3 = Color(0xFFaa44cc);
  static const purpleD2 = Color(0xFF8811bb);
  static const purpleD1 = Color(0xFF4400aa);

  bool get isRed => this == MainColor.red;

  bool get isOrange => this == MainColor.orange;

  bool get isYellow => this == MainColor.yellow;

  bool get isGreen => this == MainColor.green;

  bool get isBlue => this == MainColor.blue;

  bool get isPurple => this == MainColor.purple;

  Color get colorB1 {
    switch (this) {
      case MainColor.red:
        return redB1;
      case MainColor.orange:
        return orangeB1;
      case MainColor.yellow:
        return yellowB1;
      case MainColor.green:
        return greenB1;
      case MainColor.blue:
        return blueB1;
      case MainColor.purple:
        return purpleB1;
    }
  }

  Color get colorB2 {
    switch (this) {
      case MainColor.red:
        return redB2;
      case MainColor.orange:
        return orangeB2;
      case MainColor.yellow:
        return yellowB2;
      case MainColor.green:
        return greenB2;
      case MainColor.blue:
        return blueB2;
      case MainColor.purple:
        return purpleB2;
    }
  }

  Color get primaryColor {
    switch (this) {
      case MainColor.red:
        return redPrimary;
      case MainColor.orange:
        return orangePrimary;
      case MainColor.yellow:
        return yellowPrimary;
      case MainColor.green:
        return greenPrimary;
      case MainColor.blue:
        return bluePrimary;
      case MainColor.purple:
        return purplePrimary;
    }
  }

  Color get colorB3 {
    switch (this) {
      case MainColor.red:
        return redB3;
      case MainColor.orange:
        return orangeB3;
      case MainColor.yellow:
        return yellowB3;
      case MainColor.green:
        return greenB3;
      case MainColor.blue:
        return blueB3;
      case MainColor.purple:
        return purpleB3;
    }
  }

  Color get colorD1 {
    switch (this) {
      case MainColor.red:
        return redD1;
      case MainColor.orange:
        return orangeD1;
      case MainColor.yellow:
        return yellowD1;
      case MainColor.green:
        return greenD1;
      case MainColor.blue:
        return blueD1;
      case MainColor.purple:
        return purpleD1;
    }
  }

  Color get colorD2 {
    switch (this) {
      case MainColor.red:
        return redD2;
      case MainColor.orange:
        return orangeD2;
      case MainColor.yellow:
        return yellowD2;
      case MainColor.green:
        return greenD2;
      case MainColor.blue:
        return blueD2;
      case MainColor.purple:
        return purpleD2;
    }
  }

  Color get colorD3 {
    switch (this) {
      case MainColor.red:
        return redD3;
      case MainColor.orange:
        return orangeD3;
      case MainColor.yellow:
        return yellowD3;
      case MainColor.green:
        return greenD3;
      case MainColor.blue:
        return blueD3;
      case MainColor.purple:
        return purpleD3;
    }
  }
}
