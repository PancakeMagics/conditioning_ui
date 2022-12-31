part of compose;

enum PenetrationType {
  penetration,
  spotlight,
}


class PenetrationClip extends StatefulWidget {
  // final PenetrationType type;

  /// circle
  final Offset center;
  final double radius;

  /// rect
  // final Offset cornerA;
  // final Offset cornerB;

  final Widget child;
  final bool enabled;
  final Widget? descriptionWidget;
  final Color? unFocusedColor;
  final GestureTapCallback? unFocusedAreaOnTap;

  const PenetrationClip({
    Key? key,
    required this.child,
    required this.enabled,
    required this.center,
    required this.radius,
    // required this.cornerA,
    // required this.cornerB,
    this.descriptionWidget,
    this.unFocusedColor,
    this.unFocusedAreaOnTap,
  }) : super(key: key);

  @override
  PenetrationClipState createState() => PenetrationClipState();

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

// /// Calculate target radius.
// static double calcRadius(Rect target) {
//   // Calculate the long side of target rect.
//   // 長辺を計算
//   var a = target.right - target.left; // Horizontal
//   var b = target.bottom - target.top; // Vertical
//   var c = sqrt((a * a) + (b * b)); // the long side
//   // Calculate radius
//   // 半径
//   var r = c / 2;
//   return r;
// }

}

class PenetrationClipState extends State<PenetrationClip>
    with SingleTickerProviderStateMixin {
  GlobalKey stickyKey = GlobalKey();
  late AnimationController _controller;
  late Animation _animation;
  late Tween _tween;
  late double _fraction;
  late Offset _center;
  late Offset _maxWindowOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fraction = 0.0;
    _tween = Tween(begin: 0.0, end: 1.0);
    _animation =
        _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
          ..addListener(() {
            setState(() {
              _fraction = _animation.value;
            });
          });

    _maxWindowOffset = windowSize.toCoordinate;

    _center = const Offset(0.0, 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PenetrationClip oldWidget) {
    // _center = ((widget.cornerA + widget.cornerB) / 2).adjustScaffold(stickyKey);

    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stickyKey,
      children: widget.enabled
          ? <Widget>[
              widget.child,
              GestureDetector(
                child: ClipPath(
                  // clipper: RectangleClipper(//TODO: operate with _fraction
                  //   cornerA: _center * (1-_fraction),
                  // cornerB: (_center * (1 - _fraction)) + (_maxWindowOffset * _fraction),
                  // cornerB: _center + (_maxWindowOffset - _center) * _fraction,
                  // ),
                  child: Stack(
                    children: [
                      Container(
                        color: widget.unFocusedColor ??
                            const Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (widget.unFocusedAreaOnTap != null) {
                    widget.unFocusedAreaOnTap!();
                  }
                },
              ),
            ]
          : <Widget>[
              widget.child,
            ],
    );
  }

// final GlobalKey _stickyKey = GlobalKey();
// late AnimationController _controller;
// late Animation _animation;
// double _fraction = 0.0;
//
// @override
// void initState() {
//   super.initState();
//   _controller = AnimationController(
//     duration: const Duration(seconds: 1),
//     vsync: this,
//   );
//   _fraction = 0.0;
//   _animation = Tween(begin: 0.0, end: 1.0)
//       .animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
//     ..addListener(() {
//       setState(() {
//         _fraction = _animation.value;
//       });
//     })
//     ..addStatusListener((status) {
//     });
// }
//
// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }
//
// @override
// void didUpdateWidget(SpotlightClipper oldWidget) {
//   if (widget.enabled) {
//     _controller.forward();
//   } else {
//     _controller.reverse();
//   }
//   super.didUpdateWidget(oldWidget);
// }
//
// @override
// Widget build(BuildContext context) {
//   return Stack(
//     key: _stickyKey,
//     children: _fraction > 0.1
//         ? <Widget>[
//       widget.child,
//       GestureDetector(
//         child: ClipPath(
//           clipper: InvertedCircleClipper(
//             center: widget.center.adjustScaffold(_stickyKey),
//             radius: widget.radius * (1.0 / _fraction),
//           ),
//           child: Container(
//             color: widget.unFocusedColor ??
//                 const Color.fromRGBO(0, 0, 0, 0.6),
//           ),
//         ),
//         onTap: () {
//           if (widget.unFocusedAreaOnTap != null) {
//             widget.unFocusedAreaOnTap!();
//           }
//         },
//       ),
//     ]
//         : <Widget>[widget.child],
//   );
// }

}
