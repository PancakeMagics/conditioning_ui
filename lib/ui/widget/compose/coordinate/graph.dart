part of coordinate;

///
/// this file contains,
///
///
/// - data sets:
///   - [GraphData]
///   - [GraphFormat]
///   - [GraphConfiguration]
///   - [GraphConfigurationUtil]
///
/// - typedefs:
///   - [GridItemBuilder]
///
///

/// graph data is a class that help creating [Graph]
class GraphData {
  final GraphFormat format;
  final GraphConfiguration configuration;

  /// [gridItemsBoundary] must be in, be positive, for example
  ///
  /// gridItemsBoundary = 1 means (1 * 1) map
  /// gridItemsBoundary = 2 means (2 * 2) map
  /// gridItemsBoundary = 3 means (3 * 3) map
  /// ...
  ///
  final Coordinate? gridItemsBoundary;

  /// [gridMapBorder] = [] mAmBmCmD = [] ABCD * 4
  ///
  /// mA---------------mB
  /// |        \        |
  /// |     A--\--B     |
  /// |     |  \  |     |
  /// ---------O--------|
  /// |     |  \  |     |
  /// |     C--\--D     |
  /// |        \        |
  /// mC---------------mD
  ///
  /// if there is no more functions on map,
  /// the additional border can be used to ensure displaying background color after slide transition; for example,
  /// clicking MapItem that stay at A point will trigger slide transition,
  /// 1. D to mD
  /// 2. O to D
  /// 3. A to O
  ///
  Coordinate? get gridMapBorder => _gridBorderIsItemBorder
      ? GraphConfiguration.grid._mapBorder(
          gridItemsBoundary: gridItemsBoundary,
          gridItemBorder: _gridBorder,
          gridItemDistance: gridItemDistance)
      : _gridBorder;

  ///  [gridItemBorder], [gridItemDistance]
  ///
  ///  -------------------------------------------
  ///  |                    gridItemBorder.dx    |
  ///  |   gridItemBorder.dy        V            |
  ///  |    |    ---------     ---------         |
  ///  |    |    |       |     |       |         |
  ///  |    ---->| itemA |     | itemB |         |
  ///  |         |       |     |       |         |
  ///  |         ---------     ---------         |
  ///  |                                 <------------ gridItemDistance.dy
  ///  |         ---------     ---------         |
  ///  |         |       |     |       |         |
  ///  |         | itemC |     | itemD |         |
  ///  |         |       |     |       |         |
  ///  |         ---------     ---------         |
  ///  |                    ^                <------------ gridItemCorner
  ///  -------------------- | --------------------
  ///                       |
  ///               gridItemDistance.dx
  ///
  /// [_gridBorder] and [_gridBorderIsItemBorder] simplify the map creation, see [MapData.grid]
  ///
  final Coordinate? _gridBorder;
  final bool _gridBorderIsItemBorder;
  final Coordinate? gridItemDistance;

  Coordinate? get gridItemBorder => _gridBorderIsItemBorder
      ? _gridBorder
      : GraphConfiguration.grid._itemBorder(
          gridItemsBoundary: gridItemsBoundary,
          gridMapBorder: _gridBorder,
          gridItemDistance: gridItemDistance);

  final GridItemBuilder? gridItemsBuilder;
  final GridItemDistanceBuilder? gridItemDistanceBuilder;
  final GridItemCornerBuilder? gridItemCornerBuilder;

  const GraphData.grid({
    required Coordinate gridBorder,
    required bool gridBorderIsItemBorder,
    required Coordinate this.gridItemsBoundary,
    required Coordinate this.gridItemDistance,
    required GridItemBuilder this.gridItemsBuilder,
    required GridItemDistanceBuilder this.gridItemDistanceBuilder,
    required GridItemCornerBuilder this.gridItemCornerBuilder,
  })  : format = GraphFormat.animatedContainer,
        configuration = GraphConfiguration.grid,
        _gridBorder = gridBorder,
        _gridBorderIsItemBorder = gridBorderIsItemBorder;

  ///
  /// validate all the builders,
  ///
  /// because that come from other [StatefulWidget]
  ///
  Widget validate(Widget widget) {
    if (configuration == GraphConfiguration.grid) {
      widget as CustomAnimatedContainer;
      assert(widget.size!.toCoordinate < gridItemBorder!);
    }

    return widget;
  }
}


class Graph extends StatelessWidget {
  const Graph({
    super.key,
    required this.data,
  });

  final GraphData data;

  @override
  Widget build(BuildContext context) {
    switch (data.configuration) {
      case GraphConfiguration.grid:
      // coordinates
        final graphBorder = data.gridMapBorder!;
        final itemsBoundary = data.gridItemsBoundary!;
        final itemBorder = data.gridItemBorder!;
        final distance = data.gridItemDistance!;

        // builders
        final itemBuilder = data.gridItemsBuilder!;
        final distanceBuilder = data.gridItemDistanceBuilder!;
        final cornerBuilder = data.gridItemCornerBuilder!;

        final itemConstraint = BoxConstraints.tightFor(
          height: itemBorder.dy,
          width: itemBorder.dx,
        );
        final distanceConstraintHorizontal = BoxConstraints.tightFor(
          height: itemBorder.dy,
          width: distance.dx,
        );
        final distanceConstraintVertical = BoxConstraints.tightFor(
          height: distance.dy,
          width: distance.dx,
        );
        final cornerConstraint = BoxConstraints.tightFor(
          height: distance.dy,
          width: distance.dx,
        );

        return SizedBox(
          width: graphBorder.dx,
          height: graphBorder.dy,
          child: Column(
            children: WidgetExtension.sandwich(
              boundary: itemsBoundary.dy.toInt(),
              breadConstraints: BoxConstraints.tightFor(
                width: graphBorder.dx,
                height: itemBorder.dy,
              ),
              meatConstraints: BoxConstraints.tightFor(
                width: graphBorder.dx,
                height: distance.dy,
              ),
              bread: (y) => Row(
                children: WidgetExtension.sandwich(
                  boundary: itemsBoundary.dx.toInt(),
                  breadConstraints: itemConstraint,
                  meatConstraints: distanceConstraintHorizontal,
                  bread: (x) => data.validate(itemBuilder(
                    itemConstraint,
                    Coordinate.d2((x + 1), (y + 1)),
                  )),
                  meat: (x) => data.validate(distanceBuilder(
                    distanceConstraintHorizontal,
                    Coordinate.d2((x + 1), (y + 1)),
                    Coordinate.d2((x + 2), (y + 1)),
                  )),
                ),
              ),
              meat: (y) => Row(
                children: WidgetExtension.sandwich(
                  boundary: itemsBoundary.dx.toInt(),
                  breadConstraints: distanceConstraintVertical,
                  meatConstraints: cornerConstraint,
                  bread: (x) => data.validate(distanceBuilder(
                    distanceConstraintVertical,
                    Coordinate.d2((x + 1), (y + 1)),
                    Coordinate.d2((x + 1), (y + 2)),
                  )),
                  meat: (x) => data.validate(cornerBuilder(
                    distanceConstraintVertical,
                    Coordinate.d2((x + 1), (y + 1)),
                    Coordinate.d2((x + 1), (y + 2)),
                    Coordinate.d2((x + 2), (y + 1)),
                    Coordinate.d2((x + 2), (y + 2)),
                  )),
                ),
              ),
            ),
          ),
        );
      default:
        throw UnimplementedError();
    }
  }
}

/// graph scale
class GraphScaleTransition extends StatefulWidget {
  const GraphScaleTransition({
    Key? key,
    required this.mapItemSize,
    required this.zoomOut,
    required this.child,
    this.mapItemDistance,
    this.mapViewPadding,
    this.mapBackgroundColor,
  }) : super(key: key);
  final bool zoomOut;
  final Widget child;
  final Color? mapBackgroundColor;
  final Coordinate mapItemSize;
  final Coordinate? mapItemDistance;
  final EdgeInsets? mapViewPadding;

  @override
  State<GraphScaleTransition> createState() => _MapScaleTransitionState();
}

class _MapScaleTransitionState extends State<GraphScaleTransition>
    with SingleTickerProviderStateMixin {
  /// for scale transition
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final Tween<double> _scaleTween;

  bool _notYetAdjustWindow = true;
  late final Coordinate _mapItemSize;
  late final Coordinate _mapItemDistance;
  late final Coordinate _mapSize;
  late final Coordinate _mapSizeRestriction;
  late final int _mapBoundary;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: kDurationSecond1,
    );
    _scaleTween = Tween<double>(begin: 1, end: 1 / 10);
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.fastOutSlowIn,
    ).drive(_scaleTween);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphScaleTransition oldWidget) {
    if (widget.zoomOut) {
      _scaleController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // if (_notYetAdjustWindow) {
    //   _adjustWindow();
    // }
    return Container(
      color: context.preference.appColor.colorB1,
    );
    // return OverflowBox(
    //   maxWidth: _mapSize.dx,
    //   maxHeight: _mapSize.dy,
    //   child: Container(
    //     color:
    //         widget.mapBackgroundColor ?? context.preference.preferColor.colorB1,
    //     child: ScaleTransition(
    //       scale: _scaleAnimation,
    //       child: Center(
    //         // child: MapScaleTransitionSlide(
    //         //   boundary: _mapBoundary,
    //         //   itemsGenerator: _mapItems.addAll,
    //         //   zoomOutCompleted: _scaleController.value == 1,
    //         //   zoomInOnTap: () {
    //         //     _scaleController.reverse();
    //         //   },
    //         //   child: _map,
    //         // ),
    //         child: Container(),
    //       ),
    //     ),
    //   ),
    // );
  }

  void _adjustWindow() {
    _mapItemSize = widget.mapItemSize;
    _mapItemDistance = widget.mapItemDistance ?? const Coordinate.d2(150.0, 150.0);

    final mapViewPadding = widget.mapViewPadding ??
        EdgeInsets.symmetric(
          horizontal: _mapItemSize.dx / 10,
          vertical: _mapItemSize.dy / 8,
        );
    final finalMapViewPadding = mapViewPadding.topLeft * 2 / _scaleTween.end!;
    final finalWindowSize = _mapItemSize / _scaleTween.end!;
    _mapSizeRestriction = finalWindowSize - finalMapViewPadding.toCoordinate;
    _mapSize = finalWindowSize * 4;
    _mapBoundary = _findMapBoundary();

    _notYetAdjustWindow = false;
  }

  int _findMapBoundary() {
    int mapBoundary = 1;
    while (true) {

      // final mapSize = CoordinateMapElementConfiguration.getMapBorderOfGridStyle(
      //   boundary: boundary,
      //   itemBorder: itemBorder,
      //   distance: distance,
      // );

      // if (mapSize > _mapSizeRestriction) {
      //   return mapBoundary - 2;
      // } else {
      //   mapBoundary += 2;
      // }
    }
  }
}
// class GraphSlideTransition extends StatefulWidget {
//   const GraphSlideTransition({
//     Key? key,
//     required this.boundary,
//     required this.itemsGenerator,
//     required this.zoomOutCompleted,
//     required this.zoomInOnTap,
//     required this.child,
//   }) : super(key: key);
//   final int boundary;
//   final void Function(Set<CoordinateMapItem> items) itemsGenerator;
//   final bool zoomOutCompleted;
//   final void Function() zoomInOnTap;
//   final Widget child;
//
//   @override
//   State<GraphSlideTransition> createState() =>
//       _MapScaleTransitionSlideState();
// }
//
// class _MapScaleTransitionSlideState extends State<GraphSlideTransition> {
//   final Map<Offset, CoordinateMapItem> _items = {};
//   GlobalKey? focusedKey;
//
//   void mapItemOnTap(GlobalKey key) {
//     setState(() {
//       // focusedKey = key;
//       // context.showSnackBar('${Layout.parseMapPosition(position)}');
//     });
//   }
//
//   @override
//   void initState() {
//     final key = GlobalKey();
//     // Layout.parseMapPosition(position).mapItemUnfocused(
//     //   key: key,
//     //   onTap: () => mapItemOnTap(key),
//     // )
//
//     itemsGenerator:
//     (boundary) {
//       final Set<CoordinateMapItem> items = {};
//       for (var x = 0; x < boundary; x++) {
//         for (var y = 0; y < boundary; y++) {
//           final position = Offset(x.toDouble(), y.toDouble());
//
//           if (_items.containsKey(position)) {
//             items.add(_items[position]!);
//           } else {
//             final key = GlobalKey();
//             // final item = CoordinateMapElement(
//             //   key: key,
//             //   mapPosition: position,
//             //   onFocus: () => mapItemOnTap(key),
//             // );
//             // TODO: only mutate the focused item
//             // final inputItem =
//             //     focusedKey == key ? item.defaultFocusedItem : item;
//             // items.add(inputItem);
//           }
//         }
//       }
//       return items;
//     };
//
//     widget.boundary;
//
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(covariant GraphSlideTransition oldWidget) {
//     if (widget.zoomOutCompleted) {
//
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
//
//   void _focus(MapEntry<int, int> coordinate) {
//     setState(() {
//       // _focusedMapPiece = coordinate;
//     });
//   }
// }



/// graph format
///
/// [PlaneConfiguration] is difference from [PlanesFormat];
/// this represent the "graph style", while that focus on the items configuration on each graph
///
enum GraphFormat {
  animatedContainer,
}

/// graph configuration
///
/// [GraphFormat] is difference from [GraphConfiguration];
/// this focus on the items configuration on each graph, while that represent the "graph style"
///
enum GraphConfiguration {
  grid;
}

/// extension on configuration style
extension GraphConfigurationUtil on GraphConfiguration {
  Coordinate _mapBorder({
    required Coordinate? gridItemsBoundary,
    required Coordinate? gridItemBorder,
    required Coordinate? gridItemDistance,
  }) {
    switch (this) {
    // grid
      case GraphConfiguration.grid:
        assert(gridItemsBoundary != null &&
            gridItemBorder != null &&
            gridItemDistance != null);

        double calculate(double boundary, double item, double distance) =>
            (item + distance) * boundary - distance;

        return Coordinate(
          calculate(
            gridItemsBoundary!.dx,
            gridItemBorder!.dx,
            gridItemDistance!.dx,
          ),
          calculate(
            gridItemsBoundary.dy,
            gridItemBorder.dy,
            gridItemDistance.dy,
          ),
          calculate(
            gridItemsBoundary.dz,
            gridItemBorder.dz,
            gridItemDistance.dz,
          ),
        );
    }
  }

  Coordinate _itemBorder({
    required Coordinate? gridItemsBoundary,
    required Coordinate? gridMapBorder,
    required Coordinate? gridItemDistance,
  }) {
    switch (this) {
    // grid
      case GraphConfiguration.grid:
        assert(gridItemsBoundary != null &&
            gridMapBorder != null &&
            gridItemDistance != null);

        double calculate(double map, double boundary, double distance) =>
            (map + distance) / boundary - distance;

        return Coordinate(
          calculate(
              gridMapBorder!.dx, gridItemsBoundary!.dx, gridItemDistance!.dx),
          calculate(
              gridMapBorder.dy, gridItemsBoundary.dy, gridItemDistance.dy),
          calculate(
              gridMapBorder.dz, gridItemsBoundary.dz, gridItemDistance.dz),
        );
    }
  }
}

/// builders
typedef GridItemBuilder = Widget Function(
    BoxConstraints constraints,
    Coordinate position,
    );

typedef GridItemDistanceBuilder = Widget Function(
    BoxConstraints constraints,
    Coordinate nearByItemPositionA,
    Coordinate nearByItemPositionB,
    );
typedef GridItemCornerBuilder = Widget Function(
    BoxConstraints constraints,
    Coordinate nearByItemPositionA,
    Coordinate nearByItemPositionB,
    Coordinate nearByItemPositionC,
    Coordinate nearByItemPositionD,
    );
