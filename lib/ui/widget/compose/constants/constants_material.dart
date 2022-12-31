part of constants;

///
///
///
///
///
///
///
///
///
///
/// this file collect some generic usages of material widget,
///
/// - [AnimatedContainerUsage]
/// - [AnimatedListUsage]
/// - [OverlayUsage]
///
///
/// - [AnimatedContainerUsageData]
/// - [AnimatedListUsageData]
/// - [OverlayUsageData]
/// ...
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///

/// animated container usage
enum AnimatedContainerUsage {
  template,
  layoutGraph,
  layoutGraphItem,
  layoutGraphItemDistance,
  layoutGraphItemCorner,
  plane,
}

/// animated list usage
enum AnimatedListUsage {
  style0,
  style1,
}

enum OverlayUsage {
  style0,
}

/// the constructors respectively:
/// [AnimatedContainerUsageData.layoutGraph]
/// [AnimatedContainerUsageData.layoutGraphItem]
/// [AnimatedContainerUsageData.layoutGraphItemDistance]
/// [AnimatedContainerUsageData.layoutGraphItemCorner]
/// [AnimatedContainerUsageData.template]
/// [AnimatedContainerUsageData._format]
///

/// animated container operation
// class AnimatedContainerUsageData {
//   Coordinate? get border {
//     switch (category) {
//       case AnimatedContainerUsage.layoutGraph:
//         return _border;
//       case AnimatedContainerUsage.layoutGraphItem:
//       case AnimatedContainerUsage.layoutGraphItemDistance:
//       case AnimatedContainerUsage.layoutGraphItemCorner:
//         return _border!;
//       case AnimatedContainerUsage.plane:
//         return _border!.retain2DAsXY;
//       case AnimatedContainerUsage.template:
//         throw TemplateError();
//     }
//   }
//
//   Widget get child {
//     switch (category) {
//       case AnimatedContainerUsage.layoutGraph:
//       case AnimatedContainerUsage.layoutGraphItem:
//       case AnimatedContainerUsage.layoutGraphItemDistance:
//       case AnimatedContainerUsage.layoutGraphItemCorner:
//       case AnimatedContainerUsage.plane:
//         return _child;
//       case AnimatedContainerUsage.template:
//         throw TemplateError();
//     }
//   }
//
//   final AnimatedContainerUsage category;
//   final Key? key;
//   final Coordinate? _border;
//   final Widget _child;
//
//   const AnimatedContainerUsageData.template()
//       : category = AnimatedContainerUsage.template,
//         key = null,
//         _border = null,
//         _child = kSizedBox;
//
//   const AnimatedContainerUsageData.layoutGraph({
//     this.key,
//     required Graph graph,
//   })  : category = AnimatedContainerUsage.layoutGraph,
//         _border = null,
//         _child = graph;
//
//   /// layout graph item
//   const AnimatedContainerUsageData.layoutGraphItem({
//     required ValueKey<Coordinate> position,
//     required Coordinate border,
//     required Widget child,
//   })  : category = AnimatedContainerUsage.layoutGraphItem,
//         key = position,
//         _border = border,
//         _child = child;
//
//   const AnimatedContainerUsageData.layoutGraphItemDistance({
//     this.key,
//     required Coordinate border,
//     required Widget child,
//   })  : category = AnimatedContainerUsage.layoutGraphItemDistance,
//         _border = border,
//         _child = child;
//
//   const AnimatedContainerUsageData.layoutGraphItemCorner({
//     this.key,
//     required Coordinate border,
//     required Widget child,
//   })  : category = AnimatedContainerUsage.layoutGraphItemCorner,
//         _border = border,
//         _child = child;
//
//   /// plane
//   const AnimatedContainerUsageData.plane({
//     this.key,
//     required Coordinate border,
//     required Widget child,
//   })  : category = AnimatedContainerUsage.plane,
//         _border = border,
//         _child = child;
// }

/// animated list usage data extension
extension AnimatedListUsageData on AnimatedListData {
  Widget itemBuilderStyle0(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final item = this[index];
    final textStyle = context.theme.textTheme.headline4!;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          onTap: () => onTap(index),
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: Colors
                  .primaries[item.toString().length % Colors.primaries.length],
              child: Center(
                child: Text(
                  'Item $item',
                  style: isSelected(index)
                      ? textStyle
                      : textStyle.copyWith(color: Colors.orangeAccent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // style 1
  Widget itemBuilderStyle1(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final item = this[index];
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          height: 48,
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.grey,
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: SizedBox(width: 168, child: Text(item.toString())),
              ),
              IconButton(
                onPressed: () => remove(index),
                color: const Color.fromARGB(255, 200, 200, 200),
                icon: const Icon(Icons.cancel, size: 24),
                splashRadius: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension OverlayUsageData on OverlayUsage {
}