part of controller;

typedef PreferColors = Map<PreferColorPlacement, PreferColor>;
typedef PreferAnimations = Map<PreferAnimationPlacement, PreferAnimation>;

///
/// this file contains
/// 1. [PreferColors]
///   - [PreferColorPlacement]
///   - [PreferColor]
///
/// 2. [PreferAnimations]
///   - [PreferAnimationPlacement]
///   - [PreferAnimation]
/// ...
///
/// they are used in [Preference]
///

/// prefer color
enum PreferColorPlacement {
  navigationGraph,
}

class PreferColor {
  final PreferColorPlacement placement;
  final Color color;

  const PreferColor({
    required this.placement,
    required this.color,
  });
}

/// prefer animations
enum PreferAnimationPlacement {
  navigationMap,
  navigationMapExpand,
  navigationMapShrink,
  navigationMapItem,
  navigationMapItemSelect,
}

class PreferAnimation {
  final PreferAnimationPlacement placement;
  final Duration duration;
  final Curve curve;
  final Decoration? decoration;
  final Color? color;

  const PreferAnimation.container({
    required this.placement,
    required this.duration,
    required this.curve,
    required this.decoration,
    required this.color,
  });
}
