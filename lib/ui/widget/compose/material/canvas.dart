part of material;

///
///
/// this file contains:
///
/// - widgets:
///   - [Clipper]
///   - [Painter]
///
/// - backend:
///   - [_CustomClipper]
///   - [_CustomPainter]
///   - [PathCubitExtension]
///   - [PathBuilder]
///   - [PaintBuilder]
///
/// - tips:
/// [Clipper] is for [CustomAnimation.motivation], and must type the widget as [CustomAnimation]<[PathBuilder]>
///
///
/// ...
///

/// clipper
class Clipper extends Motivation<PathBuilder> {
  final Clip behavior;

  const Clipper({
    required super.tween,
    super.forward,
    super.reverse,
    this.behavior = Clip.antiAlias,
  }) : super(builder: null);

  @override
  AnimationsBuilder get builder => (animation, child) => ClipPath(
        clipper: _CustomClipper(animation.first.value),
        clipBehavior: behavior,
        child: child,
      );
}

/// painter
class Painter extends StatelessWidget {
  const Painter({
    super.key,
    required this.paintBuilder,
    required this.pathBuilder,
    this.cornerRadius = 0,
    this.elevation = 0,
  });

  final PaintBuilder paintBuilder;
  final PathBuilder pathBuilder;
  final double cornerRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomPainter(
        paintBuilder: paintBuilder,
        pathBuilder: pathBuilder,
        cornerRadius: cornerRadius,
        elevation: elevation,
      ),
    );
  }
}

///
///
///
/// backend
///
///
///

/// custom clipper
class _CustomClipper extends CustomClipper<Path> {
  final PathBuilder pathBuilder;

  const _CustomClipper(this.pathBuilder);

  @override
  Path getClip(Size size) => pathBuilder(size);

  @override
  bool shouldReclip(_CustomClipper oldClipper) =>
      oldClipper.pathBuilder != pathBuilder;
}

/// custom painter
class _CustomPainter extends CustomPainter {
  final PaintBuilder paintBuilder;
  final PathBuilder pathBuilder;
  final double cornerRadius;
  final double elevation;

  _CustomPainter({
    required this.paintBuilder,
    required this.pathBuilder,
    required this.cornerRadius,
    required this.elevation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = paintBuilder();
    final path = pathBuilder(size);
    if ((elevation) > 0) {
      canvas.drawShadow(path, Colors.black, elevation, false);
    }
    canvas.drawPath(path, paint);
  }

  // late Path path;
  // @override
  // bool hitTest(Offset position) => _path.contains(position);

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) => oldDelegate != this;

  @override
  bool operator ==(covariant _CustomPainter other) => identical(this, other);

  @override
  int get hashCode => Object.hash(
        paintBuilder.hashCode,
        pathBuilder.hashCode,
        cornerRadius.hashCode,
        elevation.hashCode,
      );
}


/// path cubit extension
extension PathCubitExtension on Path {
  void regularPolygonCubicBezier({
    required int cornerIndex,
    required Offset corner,
    required Offset start,
    required Offset end,
    required double factor,
  }) {
    final startX = start.dx;
    final startY = start.dy;

    cornerIndex == 0 ? moveTo(startX, startY) : lineTo(startX, startY);

    final c1 = Geometry.cubicPointBetween(corner, start, factor);
    final c2 = Geometry.cubicPointBetween(end, corner, factor);
    cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
  }
}


/// path builder, paint builder
typedef PathBuilder = Path Function(Size size);
typedef PaintBuilder = Paint Function();