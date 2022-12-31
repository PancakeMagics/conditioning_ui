part of material;

///
///
/// this file contains:
///
/// - class
///   - [TweenConstant]
///   - [CustomTween]
///   - [TargetsTween]
///   - [PathBuilderTween]
///   - [OvalTween]
///
/// - typedefs
///   - [OnLerp]
///   - [MapTweenConstant]
///
/// - extensions
///   - [TweenExtension]
///   - [TweenDecorationExtension]
///   - [TweenOffsetExtension]
///   - [CurveExtension]
///
///
/// - tips
/// [CustomTween] usually go through [CustomAnimation] by [Motivation] and it's subclasses, in the type of [TweenConstant]
///
///

/// tween constant
class TweenConstant<T> {
  final T? begin;
  final T? end;
  final CustomTweenData? custom;

  const TweenConstant({
    required this.begin,
    required this.end,
    this.custom,
  });

  const TweenConstant.constant(
      T? value, {
        this.custom,
      })  : begin = value,
        end = value;

  Tween<T> get toTween {
    ///
    /// custom tweens
    ///
    final custom = this.custom;
    if (custom != null) {
      final category = custom.category;
      switch (category) {
        case CustomTweenCategory.targets:
          return TargetsTween<T>(
            begin: begin as T,
            end: end as T,
            onLerp: custom.onLerp as OnLerp<T>,
          );

        case CustomTweenCategory.pathBuilder:
          return PathBuilderTween(
            begin: begin as PathBuilder,
            end: end as PathBuilder,
            onLerp: custom.onLerp as OnLerp<PathBuilder>,
          ) as Tween<T>;

        case CustomTweenCategory.oval:
          return OvalTween(
            beginRadian: begin as Coordinate,
            endRadian: end as Coordinate,
            center: custom.ovalCenter!,
            radius: custom.ovalRadius!,
            proportionX: custom.ovalProportionX!,
            proportionY: custom.ovalProportionY!,
          ) as Tween<T>;
      }

      ///
      /// built-in tweens
      ///
    } else if (T == Size) {
      return SizeTween(
        begin: begin as Size,
        end: end as Size,
      ) as Tween<T>;
    } else if (T == Decoration) {
      return DecorationTween(
        begin: begin as Decoration,
        end: end as Decoration,
      ) as Tween<T>;
    } else if (T == TextStyle) {
      return TextStyleTween(
        begin: begin as TextStyle,
        end: end as TextStyle,
      ) as Tween<T>;
    } else {
      return Tween(begin: begin, end: end);
    }
  }
}

/// custom tween category
enum CustomTweenCategory {
  targets,
  pathBuilder,
  oval,
}

/// custom tween data
class CustomTweenData {
  final CustomTweenCategory category;
  final OnLerp? onLerp;
  final Coordinate? ovalCenter;
  final double? ovalRadius;
  final double? ovalProportionX;
  final double? ovalProportionY;
  final MapEntry<Offset, Offset>? pathBuilderCenterTween;
  final MapEntry<double, double>? pathBuilderRadiusTween;

  const CustomTweenData({
    required this.category,
    this.onLerp,
  })  : ovalCenter = null,
        ovalRadius = null,
        ovalProportionX = null,
        ovalProportionY = null,
        pathBuilderCenterTween = null,
        pathBuilderRadiusTween = null,
        assert(
            category != CustomTweenCategory.oval &&
                category != CustomTweenCategory.pathBuilder,
            'use custom constructor instead');

  const CustomTweenData.oval({
    required Coordinate center,
    required double radius,
    required double proportionX,
    required double proportionY,
  })  : category = CustomTweenCategory.oval,
        onLerp = null,
        pathBuilderCenterTween = null,
        pathBuilderRadiusTween = null,
        ovalProportionX = proportionX,
        ovalProportionY = proportionY,
        ovalCenter = center,
        ovalRadius = radius;

  const CustomTweenData.pathBuilderCircle({
    required MapEntry<Offset, Offset> centerTween,
    required MapEntry<double, double> radiusTween,
    bool inverted = false,
  })  : category = CustomTweenCategory.pathBuilder,
        onLerp = null,
        ovalCenter = null,
        ovalRadius = null,
        ovalProportionX = null,
        ovalProportionY = null,
        pathBuilderCenterTween = centerTween,
        pathBuilderRadiusTween = radiusTween;
}

/// custom tween
abstract class CustomTween<T> extends Tween<T> {
  final OnLerp<T> onLerp;

  CustomTween({
    required T begin,
    required T end,
    required this.onLerp,
  }) : super(begin: begin, end: end);

  CustomTweenCategory get category;

  @override
  T get begin => super.begin!;

  @override
  T get end => super.end!;

  @override
  T transform(double t) => onLerp(t);
}

/// targets tween
class TargetsTween<T> extends CustomTween<T> {
  @override
  CustomTweenCategory get category => CustomTweenCategory.targets;

  TargetsTween({
    required super.begin,
    required super.end,
    required super.onLerp,
  });

  factory TargetsTween.targets({
    required T begin,
    required T end,
    required Iterable<T> targets,
  }) {
    assert(targets.first != begin && targets.last != end, 'invalid targets');

    T current = begin;
    final tweens = targets.map((target) {
      final previous = current;
      current = target;
      return Tween(begin: previous, end: current);
    }).toList()
      ..add(Tween(begin: current, end: end))
      ..toList(growable: false);

    final piece = 1 / tweens.length;

    int index = 0;

    return TargetsTween(
      begin: begin,
      end: end,
      onLerp: (t) {
        if (t > piece * (index + 1)) {
          index++;
        }
        return tweens[index].transform(t);
      },
    );
  }
}

/// path builder tween
class PathBuilderTween extends CustomTween<PathBuilder> {
  @override
  CustomTweenCategory get category => CustomTweenCategory.pathBuilder;

  PathBuilderTween({
    required super.begin,
    required super.end,
    required super.onLerp,
  });

  factory PathBuilderTween.circle({
    required Tween<Offset> centerTween,
    required Tween<double> radiusTween,
    bool inverted = false,
  }) =>
      PathBuilderTween(
        begin: PathBuilderConstants.circlePathBuilder(
          center: centerTween.begin!,
          radius: radiusTween.begin!,
          inverted: inverted,
        ),
        end: PathBuilderConstants.circlePathBuilder(
          center: centerTween.end!,
          radius: radiusTween.end!,
          inverted: inverted,
        ),
        onLerp: (t) => PathBuilderConstants.circlePathBuilder(
          center: centerTween.transform(t),
          radius: radiusTween.transform(t),
        ),
      );

  factory PathBuilderTween.rect({
    required Tween<Offset> cornerATween,
    required Tween<Offset> cornerBTween,
  }) =>
      PathBuilderTween(
        begin: PathBuilderConstants.rectPathBuilder(
          cornerA: cornerATween.begin!,
          cornerB: cornerBTween.begin!,
        ),
        end: PathBuilderConstants.rectPathBuilder(
          cornerA: cornerATween.end!,
          cornerB: cornerBTween.end!,
        ),
        onLerp: (t) => PathBuilderConstants.rectPathBuilder(
          cornerA: cornerATween.transform(t),
          cornerB: cornerBTween.transform(t),
        ),
      );

// factory PathBuilderTween.regularPolygon({
//   required Tween<List<Offset>> cornersTween,
//   bool offsetShouldAdjustScaffold = false,
// }) {
//   final begin = cornersTween.begin!;
//   final end = cornersTween.end!;
//   if (begin.length == end.length) {
//     return PathBuilderTween._(
//       begin: PathBuilders.regularPolygonBuilder(corners: begin),
//       end: PathBuilders.regularPolygonBuilder(corners: end),
//     );
//   } else {
//     throw UnimplementedError();
//   }
// }
}

class OvalTween extends CustomTween<Coordinate> {
  @override
  CustomTweenCategory get category => CustomTweenCategory.oval;

  OvalTween._({
    required super.begin,
    required super.end,
    required super.onLerp,
  });

  ///
  /// [endRadian] < [beginRadian] is clockwise
  /// [endRadian] > [beginRadian] is counterclockwise
  ///
  factory OvalTween({
    required Coordinate beginRadian,
    required Coordinate endRadian,
    required Coordinate center,
    required double radius,
    double proportionX = 1,
    double proportionY = 1,
  }) {
    assert(proportionX > 0 && proportionY > 0, 'invalid oval');

    final radianTween = Tween(begin: beginRadian, end: endRadian);

    Coordinate onLerp(t) => Coordinate.fromDirection(
          radian: radianTween.transform(t),
          distance: radius,
          center: center,
          xProportion: proportionX,
          yProportion: proportionY,
        );

    return OvalTween._(
      begin: radianTween.begin!,
      end: radianTween.end!,
      onLerp: onLerp,
    );
  }
}

///
///
/// typedefs
///
///

typedef OnLerp<T> = T Function(double t);

typedef MapTweenConstant<T> = TweenConstant<T> Function(TweenConstant<T> tween);

///
///
/// extensions
///
///

/// tween extensions
extension TweenExtension on Tween<Object> {
  Tween<T> follow<T>(T next) => Tween<T>(begin: end as T, end: next);
}

extension TweenDecorationExtension on DecorationTween {
  Tween<Decoration> followDecoration(Decoration next) => DecorationTween(
        begin: end,
        end: next,
      ); // use Tween<Decoration> cannot lerp properly
}

extension TweenOffsetExtension on Tween<Offset> {
  Tween<Offset> get push => Tween(begin: Offset.zero, end: -begin!);
}

extension CurveExtension on Curve {
  Curve get getFitReverseCurve {
    switch (this) {

      /// forward:
      /// Scale small be like throwing a ball to sky,
      /// Scale big be like a kiss that come from another universe
      /// Decoration spread makes center obvious; fast linear is good to focus, other than forcing animation duration short
      /// Decoration shrink like a convergence of object,
      ///
      ///
      /// reverse:
      /// Scale big be like be thew by a ball
      /// Scale small be like there is a magnet that being more closely
      /// Decoration shrink await awhile, shouldn't be used along, its animation-end-tense is good to make nervous.
      ///
      /// usage:
      ///
      case Curves.fastLinearToSlowEaseIn:
        return Curves.fastLinearToSlowEaseIn;

      case Curves.ease:
        return Curves.ease;
      case Curves.easeIn:
        return Curves.easeIn;
      case Curves.easeInToLinear:
        return Curves.easeInToLinear;
      case Curves.easeInSine:
        return Curves.easeInSine;
      case Curves.easeInQuad:
        return Curves.easeInQuad;
      case Curves.easeInCubic:
        return Curves.easeInCubic;
      case Curves.easeInQuart:
        return Curves.easeInQuart;
      case Curves.easeInQuint:
        return Curves.easeInQuint;
      case Curves.easeInExpo:
        return Curves.easeInExpo;
      case Curves.easeInCirc:
        return Curves.easeInCirc;
      case Curves.easeInBack:
        return Curves.easeInBack;
      case Curves.easeOut:
        return Curves.easeOut;
      case Curves.linearToEaseOut:
        return Curves.linearToEaseOut;
      case Curves.easeOutSine:
        return Curves.easeOutSine;
      case Curves.easeOutQuad:
        return Curves.easeOutQuad;
      case Curves.easeOutCubic:
        return Curves.easeOutCubic;
      case Curves.easeOutQuart:
        return Curves.easeOutQuart;
      case Curves.easeOutQuint:
        return Curves.easeOutQuint;
      case Curves.easeOutExpo:
        return Curves.easeOutExpo;
      case Curves.easeOutCirc:
        return Curves.easeOutCirc;
      case Curves.easeOutBack:
        return Curves.easeOutBack;
      case Curves.easeInOut:
        return Curves.easeInOut;
      case Curves.easeInOutSine:
        return Curves.easeInOutSine;
      case Curves.easeInOutQuad:
        return Curves.easeInOutQuad;
      case Curves.easeInOutCubic:
        return Curves.easeInOutCubic;
      case Curves.easeInOutQuart:
        return Curves.easeInOutQuart;
      case Curves.easeInOutQuint:
        return Curves.easeInOutQuint;
      case Curves.easeInOutExpo:
        return Curves.easeInOutExpo;
      case Curves.easeInOutCirc:
        return Curves.easeInOutCirc;
      case Curves.easeInOutBack:
        return Curves.easeInOutBack;
      case Curves.fastOutSlowIn:
        return Curves.fastOutSlowIn;
      case Curves.slowMiddle:
        return Curves.slowMiddle;

      case Curves.linear:
        return Curves.linear;
      default:
        throw UnimplementedError();
    }
  }
}
