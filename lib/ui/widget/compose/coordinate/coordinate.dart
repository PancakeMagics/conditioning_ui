part of coordinate;

///
///
/// this file contain
/// - [Coordinate]
/// - [_CoordinateBase]
/// - [Dimension]
/// - [Direction]
///
/// - typedefs
///   - [CoordinateMapper]
///
/// - extensions
///   - [SizeExtension]
///   - [OffsetExtension]
///   - [Geometry]
///   - [DirectionExtension]
///
///
///

/// coordinate
class Coordinate extends Offset with _CoordinateBase {
  @override
  final double dz;

  const Coordinate(double dx, double dy, this.dz) : super(dx, dy);

  const Coordinate.d2(double dx, double dy)
      : dz = 0,
        super(dx, dy);

  const Coordinate.scale(double scale)
      : dz = scale,
        super(scale, scale);

  const Coordinate.ofY(double y)
      : dz = 0,
        super(0, y);

  const Coordinate.ofZ(double z)
      : dz = z,
        super(0, 0);

  static const Coordinate zero = Coordinate(0, 0, 0);

  factory Coordinate.fromDirection({
    required Coordinate radian,
    required double distance,
    Coordinate? center,
    double xProportion = 1.0,
    double yProportion = 1.0,
    double zProportion = 1.0,
  }) {
    final CoordinateMapper mapper;
    final CoordinateMapper centerMapper = center == null
        ? (position) => position * distance
        : (position) => position * distance + center;

    if (xProportion == 1.0 && yProportion == 1.0 && zProportion == 1.0) {
      mapper = centerMapper;
    } else {
      mapper = (coordinate) {
        final position = centerMapper(coordinate);
        return Coordinate(
          position.dx * xProportion,
          position.dy * yProportion,
          position.dz * zProportion,
        );
      };
    }
    return Coordinate.parseDirection(radian, mapper);
  }

  factory Coordinate.parseDirection(
    Coordinate radian,
    CoordinateMapper mapper,
  ) {
    if (radian.dx != 0 && radian.dy != 0) {
      throw CoordinateUnImplementError();
    }
    final zAxisRadian = radian.dz;
    return mapper(Coordinate(cos(zAxisRadian), sin(zAxisRadian), 0));
  }

  static Coordinate max(Coordinate a, Coordinate b) => a > b ? a : b;

  static Coordinate maxDistance(Coordinate a, Coordinate b) =>
      a.distance > b.distance ? a : b;

  Size get toSize {
    assert(dz == 0);

    return Size(dx, dy);
  }

  Coordinate abs() => Coordinate(dx.abs(), dy.abs(), dz.abs());

  Coordinate get toComplementary =>
      (dx > kRadian90Angle && dy > kRadian90Angle && dz > kRadian90Angle) ||
              hasNegative
          ? (throw CoordinateUnImplementError())
          : Coordinate(
              (dx - kRadian90Angle).abs(),
              (dy - kRadian90Angle).abs(),
              (dz - kRadian90Angle).abs(),
            );

// Coordinate get toSupplementary => (dx > kRadianHalfRound &&
//             dy > kRadianHalfRound &&
//             dz > kRadianHalfRound) ||
//         hasNegative
//     ? (throw CoordinateUnImplementError())
//     : Coordinate(
//         (dx - kRadianHalfRound).abs(),
//         (dy - kRadianHalfRound).abs(),
//         (dz - kRadianHalfRound).abs(),
//       );
}

/// basic mixin for [Coordinate]
mixin _CoordinateBase on Offset {
  double get dz;

  bool get isNot3D => (dz == 0 || dx == 0 || dy == 0);

  bool get isNegative => (dz < 0 && dx < 0 && dy < 0);

  bool get hasNegative => (dz < 0 || dx < 0 || dy < 0);

  Coordinate get retainX => Coordinate(dx, 0, 0);
  Coordinate get retainY => Coordinate(0, dy, 0);

  Coordinate get retainXY => Coordinate(dx, dy, 0);

  Coordinate get retainYZAsYX => Coordinate(dz, dy, 0);

  Coordinate get retainYZAsXY => Coordinate(dy, dz, 0);

  Coordinate get retainXZAsXY => Coordinate(dx, dz, 0);

  Coordinate get retainXZAsYX => Coordinate(dz, dx, 0);

  @override
  double get distanceSquared => super.distanceSquared + dz * dz;

  @override
  double get distance => sqrt(distanceSquared);

  double get volume => dx * dy * dz;

  /// TODO: understand [math.atan]
  @override
  double get direction => throw UnimplementedError();

  @override
  bool get isFinite => super.isFinite && dz.isFinite;

  @override
  bool get isInfinite => super.isInfinite && dz.isInfinite;

  @override
  Coordinate operator +(covariant Coordinate other) =>
      Coordinate(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Coordinate operator -(covariant Coordinate other) =>
      Coordinate(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Offset operator -() => Coordinate(-dx, -dy, -dz);

  @override
  Coordinate operator *(double operand) => Coordinate(
        dx * operand,
        dy * operand,
        dz * operand,
      );

  @override
  Coordinate operator /(double operand) => Coordinate(
        dx / operand,
        dy / operand,
        dz / operand,
      );

  @override
  Coordinate operator ~/(double operand) => Coordinate(
        (dx ~/ operand).toDouble(),
        (dy ~/ operand).toDouble(),
        (dz ~/ operand).toDouble(),
      );

  @override
  Coordinate operator %(double operand) => Coordinate(
        dx % operand,
        dy % operand,
        dz % operand,
      );

  @override
  bool operator <(covariant Coordinate other) =>
      dz < other.dz && (super < other);

  @override
  bool operator <=(covariant Coordinate other) =>
      dz <= other.dz && (super <= other);

  @override
  bool operator >(covariant Coordinate other) =>
      dz > other.dz && (super > other);

  @override
  bool operator >=(covariant Coordinate other) =>
      dz >= other.dz && (super >= other);

  @override
  bool operator ==(covariant Coordinate other) =>
      dz == other.dz && (super == other);

  @override
  int get hashCode => Object.hash(super.hashCode, dz);

  @override
  Rect operator &(Size other) =>
      isNot3D ? (super & other) : (throw CoordinateUnImplementError());

  @override
  Coordinate scale(
    double scaleX,
    double scaleY, {
    double scaleZ = 0,
  }) =>
      Coordinate(dx * scaleX, dy * scaleY, dz * scaleZ);

  @override
  Coordinate translate(
    double translateX,
    double translateY, {
    double translateZ = 0,
  }) =>
      Coordinate(
        dx + translateX,
        dy + translateY,
        dz + translateZ,
      );

  @override
  String toString() => 'Coordinate('
      '${dx.toStringAsFixed(1)}, '
      '${dy.toStringAsFixed(1)}, '
      '${dz.toStringAsFixed(1)})';
}

/// dimension
enum Dimension { x, y, z }

/// direction
enum Direction { center, front, back, left, top, right, bottom }

///
/// typedef
///
typedef CoordinateMapper = Coordinate Function(Coordinate coordinate);

///
/// extensions
///
///

/// size extension
extension SizeExtension on Size {
  Coordinate get toCoordinate => Coordinate.d2(width, height);

  Coordinate diagonalPosition(Offset zero) =>
      Coordinate.d2(zero.dx + width, zero.dy + height);

  SizedBox toSizedBox({Widget? child}) => SizedBox.fromSize(
        size: this,
        child: child,
      );
}

/// offset extension
extension OffsetExtension on Offset {
  Coordinate get toCoordinate => Coordinate.d2(dx, dy);

  Offset get toReciprocal => Offset(1 / dx, 1 / dy);

  Coordinate adjustScaffold(GlobalKey key) {
    final translation = key.currentContext
        ?.findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();
    if (translation != null) {
      return Coordinate.d2(
        dx - translation.x,
        dy - translation.y,
      );
    } else {
      return toCoordinate;
    }
  }

  /// Get Rect from GlobalKey.
// static Rect? getRectFromKey(GlobalKey globalKey) {
//   var object = globalKey.currentContext?.findRenderObject();
//   var translation = object?.getTransformTo(null).getTranslation();
//   var size = object?.semanticBounds.size;
//
//   if (translation != null && size != null) {
//     return Rect.fromLTWH(
//         translation.x, translation.y, size.width, size.height);
//   } else {
//     return null;
//   }
// }
}

/// geometry
extension Geometry on Offset {
  List<Offset> cornersOfPolygon({
    required int cornerCount,
    required double radius,
  }) {
    Offset corner(double radian) => Offset(
          dx + radius * cos(radian),
          dy + radius * sin(radian),
        );

    return List<Offset>.generate(
      cornerCount,
      (index) => corner(kRadian1Round / cornerCount * index),
      growable: false,
    );
  }

  static Offset cubicPointBetween(Offset a, Offset b, double factor) =>
      a + (b - a) * factor;

  static Offset cubicRadius(Offset a, Offset b, double radian) =>
      cubicPointBetween(a, b, radian / (a - b).distance);
}

// extension CoordinateSet on Set<Coordinate> {
//   bool isEqual(Set<Coordinate> other) {
//     every((e1) {
//       late final bool hasEqual;
//       try {
//         final item = other.firstWhere((e2) => e1 == e2);
//         hasEqual = other.remove(item);
//       } catch (_) {
//         hasEqual = false;
//       }
//       return hasEqual;
//     });
//     return other.isEmpty;
//   }
// }
//
// /// map item util
// extension CoordinateMapItemUtil on CoordinateMapItem {
//   bool positionIsEqual(CoordinateMapItem other) =>
//       key == other.key && mapPosition == other.mapPosition;
// }
//
// extension CoordinateMapItemSet on Set<CoordinateMapItem> {
//   bool positionsAreEqual(Set<CoordinateMapItem> other) {
//     try {
//       return every((e1) => other.remove(
//             other.firstWhere((e2) => e1.positionIsEqual(e2)),
//           ));
//     } catch (_) {
//       return false;
//     }
//   }
//
//   bool positionsAreNotEqual(Set<CoordinateMapItem> other) =>
//       !positionsAreEqual(other);
//
//   Set<CoordinateMapItem> positionDifference(Set<CoordinateMapItem> other) =>
//       where((e1) => other.any((e2) => e2.mapPosition != e1.mapPosition))
//           .toSet();
// }

extension DirectionExtension on Direction {
  bool get is3D => this == Direction.front || this == Direction.back;
}
