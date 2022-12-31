// ignore_for_file: invalid_use_of_protected_member
part of material;

///
///
/// this file contains:
///
/// - widgets:
///   - [CustomAnimatedContainer]
///   - [CustomAnimatedSwitcher]
///   - [CustomAnimatedList]
///   - [CustomAnimatedPositioned]
///   - [CustomAnimatedPositionedStack]
///
/// - data set:
///   - [AnimatedListData]
///
///
///
///

/// animated container
class CustomAnimatedContainer extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decorationForeground;
  final Decoration? decorationBackground;
  final Duration animationDuration;
  final Curve animationCurve;
  final VoidCallback? animationOnEnd;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final AlignmentGeometry? childAlignment;
  final Size? size;
  final Widget child;

  const CustomAnimatedContainer({
    super.key,
    this.size,
    this.padding,
    this.margin,
    this.decorationForeground,
    this.decorationBackground,
    this.animationDuration = kDurationSecond1,
    this.animationCurve = Curves.fastOutSlowIn,
    this.animationOnEnd,
    this.childAlignment,
    this.transform,
    this.transformAlignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: key,
      width: size?.width,
      height: size?.height,
      padding: padding,
      margin: margin,
      foregroundDecoration: decorationForeground,
      decoration: decorationBackground,
      duration: animationDuration,
      curve: animationCurve,
      onEnd: animationOnEnd,
      transform: transform,
      transformAlignment: transformAlignment,
      alignment: childAlignment,
      child: child,
    );
  }
}

/// animated switcher
class CustomAnimatedSwitcher extends StatelessWidget {
  const CustomAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = kDurationMilli500,
    this.durationReverse = kDurationMilli500,
    this.curveSwitchIn = Curves.linear,
    this.curveSwitchOut = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
  });

  final Duration duration;
  final Duration durationReverse;
  final Curve curveSwitchIn;
  final Curve curveSwitchOut;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: durationReverse,
      switchInCurve: curveSwitchIn,
      switchOutCurve: curveSwitchOut,
      transitionBuilder: transitionBuilder,
      layoutBuilder: layoutBuilder,
      child: child,
    );
  }
}

/// animated list data
class AnimatedListData<E> {
  const AnimatedListData({
    required this.usages,
    required this.listKey,
    required this.items,
    this.selectedItems,
  });

  final AnimatedListUsage usages;
  final GlobalKey<AnimatedListState> listKey;
  final List<E> items;
  final Map<int, bool>? selectedItems;

  AnimatedListState get _listState => listKey.currentState!;

  AnimatedListItemBuilder get itemBuilder {
    if (selectedItems != null) {
      assert(selectedItems!.length == items.length);
    }

    switch (usages) {
      case AnimatedListUsage.style0:
        return itemBuilderStyle0;
      case AnimatedListUsage.style1:
        return itemBuilderStyle1;
    }
  }

  /// usages
  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);

  bool isSelected(int index) => selectedItems?[index] ?? false;

  void insert(int index, E item) {
    items.insert(index, item);
    _listState.insertItem(index);
  }

  void remove(int index) {
    try {
      final item = items[index];

      _listState.removeItem(
        index,
        (context, animation) {
          void listener(AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              items.remove(item);
              animation.removeStatusListener(listener);
            }
          }

          animation.addStatusListener(listener);

          return itemBuilder(context, index, animation);
        },
      );
    } catch (_) {
      throw UnimplementedError();
    }
  }

  void onTap(int index) {
    if (selectedItems != null) {
      _listState.setState(() {
        selectedItems!.update(index, (value) => !value);
      });
    }
  }
}

/// animated list
class CustomAnimatedList<E> extends StatelessWidget {
  const CustomAnimatedList({
    super.key,
    required this.list,
  });

  final AnimatedListData<E> list;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: list.listKey,
      initialItemCount: list.length,
      itemBuilder: list.itemBuilder,
    );
  }
}


/// custom animated positioned
class CustomAnimatedPositioned extends StatelessWidget {
  const CustomAnimatedPositioned({
    super.key,
    required this.position,
    required this.child,
    this.curve = Curves.fastOutSlowIn,
    this.duration = kDurationSecond1,
    this.onEnd,
  });

  final Positioned position;
  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rect = position.rect;
    if (rect == null) {
      return AnimatedPositioned(
        key: key,
        left: position.left,
        top: position.top,
        right: position.right,
        bottom: position.bottom,
        curve: curve,
        duration: duration,
        onEnd: onEnd,
        child: child,
      );
    } else {
      return AnimatedPositioned.fromRect(
        key: key,
        rect: rect,
        curve: curve,
        duration: duration,
        onEnd: onEnd,
        child: child,
      );
    }
  }
}

/// custom animated positioned stack
class CustomAnimatedPositionedStack extends StatelessWidget {
  const CustomAnimatedPositionedStack({
    super.key,
    required this.border,
    required this.children,
    this.childrenAlignment = Alignment.center,
  });

  final Coordinate border;
  final List<CustomAnimatedPositioned> children;
  final Alignment childrenAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: border.dx,
      height: border.dy,
      child: Stack(
        alignment: childrenAlignment,
        children: children,
      ),
    );
  }
}
