part of constants;

///
///
///
/// this file contains:
///
/// constants:
///   - [TweenConstant], see [kTweenDouble0]
///   - [Interval], see [kIntervalFastOutSlowIn00To05]
///   - [Duration], see [kDurationSecond1]
///   ...
///
/// extensions:
///   - [TransitionConstants]
///   - [TransformConstants]
///
///   - [PathBuilderConstants]
///   - [ClipperConstants]
///   ...
///
///

const TweenConstant<double> kTweenDouble0 = TweenConstant.constant(0);
const TweenConstant<double> kTweenDouble0To1 =
    TweenConstant(begin: 0, end: 1.0);
const TweenConstant<Offset> kTweenOffset0 = TweenConstant.constant(Offset.zero);
const TweenConstant<Coordinate> kTweenCoordinate0 =
    TweenConstant.constant(Coordinate.zero);
const TweenConstant<Coordinate> kTweenCoordinate1 =
    TweenConstant.constant(CoordinateConstants.scale1);

const Interval kIntervalEaseInOut00To04 =
    Interval(0.0, 0.4, curve: Curves.easeInOut);
const Interval kIntervalFastOutSlowIn00To05 =
    Interval(0, 0.5, curve: Curves.fastOutSlowIn);
const Interval kIntervalEaseOut00To06 =
    Interval(0.0, 0.6, curve: Curves.easeOut);
const Interval kIntervalEaseInOut02To08 =
    Interval(0.2, 0.8, curve: Curves.easeInOut);
const Interval kIntervalEaseInOut04To10 =
    Interval(0.4, 1.0, curve: Curves.easeInOut);

const Duration kDurationMilli100 = Duration(milliseconds: 100);
const Duration kDurationMilli200 = Duration(milliseconds: 200);
const Duration kDurationMilli300 = Duration(milliseconds: 300);
const Duration kDurationMilli400 = Duration(milliseconds: 400);
const Duration kDurationMilli460 = Duration(milliseconds: 460);
const Duration kDurationMilli466 = Duration(milliseconds: 466);
const Duration kDurationMilli467 = Duration(milliseconds: 467);
const Duration kDurationMilli468 = Duration(milliseconds: 468);
const Duration kDurationMilli470 = Duration(milliseconds: 470);
const Duration kDurationMilli480 = Duration(milliseconds: 480);
const Duration kDurationMilli500 = Duration(milliseconds: 500);
const Duration kDurationMilli600 = Duration(milliseconds: 600);
const Duration kDurationMilli700 = Duration(milliseconds: 700);
const Duration kDurationMilli800 = Duration(milliseconds: 800);
const Duration kDurationSecond1 = Duration(seconds: 1);
const Duration kDurationSecond2 = Duration(seconds: 2);
const Duration kDurationSecond3 = Duration(seconds: 3);
const Duration kDurationSecond5 = Duration(seconds: 5);
const Duration kDurationSecond10 = Duration(seconds: 10);

///
///
/// extensions
///
///

/// transition data
extension TransitionConstants on Transitioner {
  static const Transitioner fadeIn = Transitioner.fade(tween: kTweenDouble0To1);

  static List<Iterable<Transitioner>> style0 = [
    style0Begin,
    // style0Follow1,
    // style0Follow2,
    // style0End,
  ];

  static const List<Transitioner> style0Begin = [
    Transitioner.translate(
        tween: TweenConstant(begin: Offset.zero, end: kCoordinateRight)),
    Transitioner.decoration(
        tween: TweenConstant(
      begin: kDecorationBoxShadow2Of1,
      end: kDecorationBoxShadow2Of2,
    )),
  ];

// static Iterable<Transitioner> get style0Follow1 => style0Begin.foreachFollow(
//       mapTween: (tween) => tween is Tween<Offset>
//           ? tween.follow<Offset>(tween.end! * 1.2 + kCoordinateTop)
//           : (tween as DecorationTween)
//               .followDecoration(kDecorationBoxShadow2Of3),
//     );
//
// static Iterable<Transitioner> get style0Follow2 =>
//     style0Follow1.foreachFollow(
//       mapTween: (tween) => tween is Tween<Offset>
//           ? tween.follow<Offset>(tween.end! * -1.2)
//           : (tween as DecorationTween)
//               .followDecoration(kDecorationBoxShadow2Of4),
//     );
//
// static Iterable<Transitioner> get style0End => style0Follow2.foreachFollow(
//       mapTween: (tween) => tween is Tween<Offset>
//           ? tween.follow<Offset>(Offset.zero)
//           : (tween as DecorationTween)
//               .followDecoration(kDecorationBoxShadow2Of1),
//     );
}

/// transformer constants
extension TransformConstants on Transformer {
  static const Transformer translateNone =
      Transformer.translate(tween: kTweenCoordinate0);

  static const Transformer rotateNone =
      Transformer.rotate(tween: kTweenCoordinate0);

  static const Transformer scale1 = Transformer.scale(tween: kTweenCoordinate1);
}

/// path builder data:
extension PathBuilderConstants on Path {
  /// - [PathBuilderConstants.circlePathBuilder]
  /// - [PathBuilderConstants.rectPathBuilder]
  /// - [PathBuilderConstants.regularPolygonBuilder]
  /// - [PathBuilderConstants.trapeziumPathBuilder]
  /// - [PathBuilderConstants.pencilPathBuilder]
  /// circle
  ///
  static PathBuilder circlePathBuilder({
    required Offset center,
    required double radius,
    bool inverted = false,
  }) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    return inverted
        ? (size) => path
          ..addRect(Offset.zero & size)
          ..fillType = PathFillType.evenOdd
        : (size) => path;
  }

  /// rect
  ///
  /// A
  ///  --------
  ///  |      |       [cornerA] = A
  ///  |      |       [cornerB] = B
  ///  --------
  ///          B
  ///
  static PathBuilder rectPathBuilder({
    required Offset cornerA,
    required Offset cornerB,
    bool inverted = false,
  }) {
    final path = Path()..addRect(Rect.fromPoints(cornerA, cornerB));
    return inverted
        ? (size) => path
          ..addRect(Offset.zero & size)
          ..fillType = PathFillType.evenOdd
        : (size) => path;
  }

  /// polygon builder
  ///
  static PathBuilder regularPolygonBuilder({
    required List<Offset> corners,
    double cornerRadius = 0,
    double cornerCubicPointFactor = 1,
    bool inverted = false,
  }) {
    assert(corners.isNotEmpty && corners.length != 1 && corners.length != 2);
    late final Path path;

    if (cornerRadius <= 0) {
      path = Path()..addPolygon(corners, false);
    } else {
      assert(cornerCubicPointFactor <= 1, 'invalid factor');

      final maxIndex = corners.length - 1;
      final radius = cornerRadius * tan(pi / (maxIndex + 1));

      Path p = Path();
      corners.asMap().forEach((index, corner) {
        p = p
          ..regularPolygonCubicBezier(
            corner: corner,
            cornerIndex: index,
            start: Geometry.cubicRadius(
              corner,
              index > 0 ? corners[index - 1] : corners[maxIndex],
              radius,
            ),
            end: Geometry.cubicRadius(
              corner,
              index < maxIndex ? corners[index + 1] : corners[0],
              radius,
            ),
            factor: cornerCubicPointFactor,
          );
      });
      path = p;
    }
    return inverted
        ? (size) => path
          ..addRect(Offset.zero & size)
          ..fillType = PathFillType.evenOdd
        : (size) => path;
  }

  /// trapezium
  ///
  /// [parallelFactor] = AB / CD
  ///
  /// A   B
  ///  ---
  /// /   \
  /// -----
  /// C    D
  ///
  static PathBuilder trapeziumPathBuilder(
    double parallelFactor, {
    bool inverted = false,
  }) {
    assert(parallelFactor < 1, 'invalid trapezium');

    Path builder(Size size) {
      final width = size.width;
      final height = size.height;
      final padding = width * ((1 - parallelFactor) / 2);

      return Path()
        ..moveTo(padding, 0.0)
        ..lineTo(width - padding, 0.0)
        ..lineTo(width, height)
        ..lineTo(0.0, height)
        ..lineTo(padding, 0.0);
    }

    return inverted
        ? (size) => builder(size)..addRect(Offset.zero & size)
        : (size) => builder(size);
  }

  /// pencil
  ///
  /// [parallelFactor] description see [trapeziumPathBuilder]
  ///
  /// -----
  /// |   |
  /// |   |   b = (the length of '|')
  /// |   |
  /// \   /   a = (the length of '\' and '/')
  ///  ---
  ///
  /// [bodyFactor] = a / b
  ///
  static PathBuilder pencilPathBuilder(
    double parallelFactor,
    double bodyFactor, {
    bool inverted = false,
  }) {
    assert(parallelFactor < 1, 'invalid pencil');
    Path builder(Size size) {
      final width = size.width;
      final height = size.height;
      final pencilTailPadding = width * ((1 - parallelFactor) / 2);
      final pencilBody = height * (1 / (1 + bodyFactor));

      return Path()
        ..lineTo(width, 0.0)
        ..lineTo(width, pencilBody)
        ..lineTo(width - pencilTailPadding, height)
        ..lineTo(pencilTailPadding, height)
        ..lineTo(0.0, pencilBody)
        ..lineTo(0.0, 0.0);
    }

    return inverted
        ? (size) => builder(size)..addRect(Offset.zero & size)
        : (size) => builder(size);
  }
}

/// clipper constants
extension ClipperConstants on Clipper {
  static Clipper borderRouter = const Clipper(
    tween: TweenConstant(
      begin: null,
      end: null,
      custom: CustomTweenData.pathBuilderCircle(
        centerTween: MapEntry(Offset.zero, Offset(101, 101)),
        radiusTween: MapEntry(20.0, 100.0),
      ),
    ),
  );
}
