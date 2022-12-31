part of material;

///
///
/// this file contains:
///
/// - customs
///   - [CustomDialog]
///   - [CustomFab]
///   - [CustomFabTODO]
///   - [CustomFormField]
///   - [CustomOverlayEntry]
///   - [CustomOverlay]
///   - [CustomValueBuilderWidget]
///   - [CustomStreamBuilder]
///
/// - typedefs:
///   - [ValueBuilder]
///
/// - extensions:
///   - [BuildContextExtension]
///   - [WidgetExtension]
///   - [AlignmentExtension]
///   - [StackAlignmentExtension]
///   - [PositionedExtension]
///   - [ContainerExtension]
///
///
/// [CustomValueBuilderWidget.child] is a builder but i named it a 'child' on purpose,
/// in android studio, without 'child' argument, "option, enter" shortcut is not enabled,
/// without shortcut, it is really un convenience for swapping or copy between child and parent
///
///

/// custom dialog
abstract class CustomDialog {
  static Future<M?> showAndGetResult<M>({
    required BuildContext context,
    required String title,
    required String? content,
    required Map<String, M Function()> actionTitleAndActions,
  }) async {
    final List<Widget> actions = <Widget>[];
    M? returnValue;
    actionTitleAndActions.forEach((label, action) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          returnValue = action();
        },
        child: Text(label),
      ));
    });
    await showDialog(
        context: context,
        builder: (context) => content == null
            ? SimpleDialog(title: Text(title), children: actions)
            : AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: actions,
              ));
    return returnValue;
  }

  static Future<M?> showItemListAndGetItem<M>({
    required BuildContext context,
    required String title,
    required List<M> itemList,
  }) async {
    late final M? selectedItem;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 200,
          width: 100,
          child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final M item = itemList[index];
              return Center(
                child: TextButton(
                  onPressed: () {
                    selectedItem = item;
                    Navigator.pop(context);
                  },
                  child: Text(item.toString()),
                ),
              );
            },
          ),
        ),
      ),
    );
    return selectedItem;
  }

  static Future<bool?> decideTureOfFalse({
    required BuildContext context,
  }) async {
    bool? result;
    await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text('True of False?'),
              children: [
                TextButton(
                  onPressed: () {
                    result = true;
                    context.navigator.pop();
                  },
                  child: const Text('true'),
                ),
                TextButton(
                  onPressed: () {
                    result = false;
                    context.navigator.pop();
                  },
                  child: const Text('false'),
                ),
              ],
            ));
    return result;
  }
}

/// expandable floating action button
class CustomFab extends StatefulWidget {
  const CustomFab({
    super.key,
    required this.openIcon,
    required this.childrenIcons,
    this.childrenIconsStackAlignment = Alignment.bottomRight,
    this.iconSize = const Coordinate.d2(56.0, 56.0),
    this.closeIcon = Icons.close,
    this.maxDistance,
  });

  static final CustomFab template = CustomFab(
    openIcon: Icons.add,
    childrenIcons: <IconData, VoidCallback>{
      Icons.baby_changing_station: kVoidCallback,
      Icons.check: kVoidCallback,
      Icons.oil_barrel: kVoidCallback,
    },
  );

  final Coordinate iconSize;
  final IconData openIcon;
  final Map<IconData, VoidCallback> childrenIcons;
  final Alignment childrenIconsStackAlignment;
  final IconData closeIcon;
  final double? maxDistance;

  @override
  State<CustomFab> createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  bool _shouldAnimate = false;

  @override
  Widget build(BuildContext context) {
    final alignment = widget.childrenIconsStackAlignment;
    final iconSize = widget.iconSize;

    return SizedBox.expand(
      child: CustomAnimation(
        motivation: Stacker(
          alignment: alignment,
          deviateAlignment: false,
          children: <Widget, Motivations>{
            ..._elementButtons(alignment.toFabExpandableDirection, iconSize),
            _closeButton(iconSize): Motivations.empty,
            _openButton(iconSize): Motivations.empty,
          },
        ),
        controllerSetting: AnimationControllerSetting(
          updater: (controller) {
            if (_shouldAnimate) {
              isOpen
                  ? controller
                      .forward()
                      .then((_) => setState(() => _shouldAnimate = false))
                  : controller
                      .reverse()
                      .then((_) => setState(() => _shouldAnimate = false));
            }
          },
        ),
      ),
    );
  }

  void _toggle() => setState(() {
        isOpen = !isOpen;
        _shouldAnimate = true;
      });

  /// instead of [TransitionConstants.fade], i use [AnimatedOpacity] for better performance.
  Widget _ignoredSized({
    required bool ignoring,
    required bool show,
    required Coordinate iconSize,
    required Widget child,
  }) =>
      IgnorePointer(
        ignoring: ignoring,
        child: AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: kDurationMilli500,
          child: SizedBox(
            width: iconSize.dx,
            height: iconSize.dy,
            child: child,
          ),
        ),
      );

  /// open button
  Widget _openButton(Coordinate iconSize) => _ignoredSized(
        ignoring: isOpen || _shouldAnimate,
        show: !isOpen,
        iconSize: iconSize,
        child: FloatingActionButton(
          splashColor: Colors.white,
          onPressed: _toggle,
          child: Icon(widget.openIcon),
        ),
      );

  /// close button
  Widget _closeButton(Coordinate iconSize) => _ignoredSized(
        ignoring: !isOpen || _shouldAnimate,
        show: isOpen,
        iconSize: iconSize,
        child: Material(
          elevation: 4.0,
          shape: kBorderCircle,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: _toggle,
            splashFactory: InkSparkle.splashFactory,
            child: Padding(
              padding: kEdgeInsets100,
              child: Icon(widget.closeIcon),
            ),
          ),
        ),
      );

  /// element buttons
  Map<Widget, Motivations> _elementButtons(
    double direction,
    Coordinate iconSize,
  ) {
    final iconConfiguration = widget.childrenIcons;
    final amount = iconConfiguration.length;
    final maxDistance = widget.maxDistance ?? amount * 0.6;

    final step = kRadian90Angle / (amount - 1);
    direction -= step;

    return iconConfiguration.fold(
      <Widget, Motivations>{},
      (map, entry) {
        direction += step;
        return map
          ..putIfAbsent(
            _ignoredSized(
                ignoring: !isOpen,
                show: isOpen,
                iconSize: iconSize,
                child: ElevatedButton(
                  onPressed: entry.value,
                  child: Icon(entry.key),
                )),
            () => Motivations(motivations: [
              const Transitioner.rotate(
                tween: TweenConstant(begin: 0, end: kRadian1Round),
              ),
              Transitioner.translate(
                tween: TweenConstant(
                  begin: Offset.zero,
                  end: Offset.fromDirection(direction, maxDistance),
                ),
              ),
            ]),
          );
      },
    );
  }
}

/// horizontal fab
/// TODO: migrate into a custom fab
class CustomFabTODO extends StatefulWidget {
  const CustomFabTODO({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomFabTODO> createState() => _CustomFabTODOState();
}

class _CustomFabTODOState extends State<CustomFabTODO>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List animation = [];
  List icons = [
    Icons.home,
    Icons.settings,
    Icons.location_city,
  ];
  List colors = [Colors.green, Colors.blueGrey, Colors.purple];
  OverlayEntry? overlayEntry;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    for (int i = 3; i > 0; i--) {
      animation.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController!,
          curve: Interval(0.2 * i, 1.0, curve: Curves.ease))));
    }
  }

  _showOverLay() async {
    RenderBox? renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        bottom: renderBox.size.height + 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < animation.length; i++)
              ScaleTransition(
                scale: animation[i],
                child: FloatingActionButton(
                  onPressed: () => context.showSnackBar('press'),
                  backgroundColor: colors[i],
                  mini: true,
                  child: Icon(
                    icons[i],
                  ),
                ),
              )
          ],
        ),
      ),
    );
    animationController!.addListener(() {
      overlayState!.setState(() {});
    });
    animationController!.forward();
    overlayState!.insert(overlayEntry!);

    await Future.delayed(const Duration(seconds: 5))
        .whenComplete(() => animationController!.reverse())
        .whenComplete(() => overlayEntry!.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Overlay'),
      ),
      floatingActionButton: FloatingActionButton(
        key: globalKey,
        onPressed: _showOverLay,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// form field
class CustomFormField extends StatefulWidget {
  const CustomFormField({Key? key}) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //   } else {
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: kDecorationInput.copyWith(labelText: 'field'),
    );
  }
}

/// context extension
extension BuildContextExtension on BuildContext {
  ///
  /// official component
  ///
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  RenderBox get renderBox => findRenderObject() as RenderBox;

  CustomOverlayState get overlay => CustomOverlay.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(String text) => scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(text),
          duration: kDurationSecond1,
        ),
      );

  ThemeData get theme => Theme.of(this);

  NavigatorState get navigator => Navigator.of(this);

// AppLocalizations get loc => AppLocalizations.of(this)!;

  ///
  /// custom component
  ///

  PreferenceState get preference => Preference.of(this);

// Coordinate get sizeCoordinate => Coordinate.d2(size!.width, size!.height);
}

/// overlay entry controller
class CustomOverlayEntry {
  final Key? key;
  final OverlayEntry overlayEntry;
  AnimationController? controller;

  CustomOverlayEntry._({
    this.key,
    required this.overlayEntry,
    this.controller,
  });

  factory CustomOverlayEntry({
    Key? key,
    required WidgetBuilder builder,
    MotivationBase? motivation,
    AnimationController? controller,
    Size? centerSized,
  }) {
    late final CustomOverlayEntry entry;

    Widget getWidget(BuildContext context) => CustomAnimation(
          motivation: motivation ?? TransitionConstants.fadeIn,
          controllerSetting: AnimationControllerSetting(
            initializer: (tickerProvider, d1, d2) {
              entry.controller =
                  AnimationControllerSetting.initializeController(
                      tickerProvider, d1, d2)
                    ..forward();
              return entry.controller!;
            },
          ),
          child: builder(context),
        );

    entry = CustomOverlayEntry._(
      key: key,
      overlayEntry: OverlayEntry(
        builder: (context) => centerSized == null
            ? getWidget(context)
            : Center(
                child: SizedBox(
                  width: centerSized.width,
                  height: centerSized.height,
                  child: getWidget(context),
                ),
              ),
      ),
      controller: controller,
    );
    return entry;
  }
}

/// overlay controller
class CustomOverlay extends StatefulWidget {
  const CustomOverlay({required this.child}) : super(key: null);

  final Widget child;

  @override
  State<CustomOverlay> createState() => CustomOverlayState();

  static CustomOverlayState of(BuildContext context) =>
      context.findAncestorStateOfType()!;
}

class CustomOverlayState extends State<CustomOverlay>
    with SingleTickerProviderStateMixin {
  final List<CustomOverlayEntry> entries = [];

  OverlayState get overlay => Overlay.of(context)!;

  bool get hasEntry => entries.isNotEmpty;

  @override
  Widget build(BuildContext context) => widget.child;

  /// insert
  void insert(CustomOverlayEntry entry, {VoidCallback? listener}) {
    entries.add(entry);
    overlay.insert(entry.overlayEntry);
    if (listener != null) {
      entry.overlayEntry.addListener(listener);
    }
  }

  /// update
  void update(CustomOverlayEntry entry) {
    try {
      entries
          .firstWhere((e) => e.key == entry.key)
          .overlayEntry
          .markNeedsBuild();
    } catch (_) {
      throw OverlayEntryNotExistError();
    }
  }

  /// remove last
  void removeLast() {
    try {
      entries.last.controller!
          .reverse()
          .then((_) => entries.removeLast().overlayEntry.remove());
    } catch (_) {
      throw OverlayEntriesEmptyError();
    }
  }

  /// remove
  void remove(CustomOverlayEntry? entry) {
    if (entry != null && entries.contains(entry)) {
      entry.controller!.reverse().then((_) => entry.overlayEntry.remove());
    } else {
      throw OverlayEntryNotExistError();
    }
  }
}

/// custom value widget
class CustomValueBuilderWidget<T> extends StatefulWidget {
  const CustomValueBuilderWidget({
    super.key,
    required this.value,
    required this.child,
  });

  final T? value;
  final ValueBuilder<T> child;

  @override
  State<CustomValueBuilderWidget<T>> createState() =>
      _CustomValueBuilderWidgetState<T>();
}

class _CustomValueBuilderWidgetState<T>
    extends State<CustomValueBuilderWidget<T>> {
  late final ValueNotifier<T?> _notifier;

  @override
  void initState() {
    _notifier = ValueNotifier(null);
    _update();
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomValueBuilderWidget<T> oldWidget) {
    _update();
    super.didUpdateWidget(oldWidget);
  }

  void _update() => _notifier.value = widget.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      key: ValueKey(_notifier),
      valueListenable: _notifier,
      builder: (context, value, child) => widget.child(context, value),
      child: widget.child(context, _notifier.value),
    );
  }
}

/// custom stream builder
class CustomStreamBuilder<T> extends StatefulWidget {
  const CustomStreamBuilder({
    super.key,
    this.initialData,
    required this.stream,
    required this.child,
    this.waitingDataBuilder,
    this.doneConnectBuilder,
    this.noneConnectBuilder = _defaultNoneConnectedBuilder,
  });

  final T? initialData;
  final Stream<T> stream;
  final ValueBuilder<T> child;
  final ValueBuilder<T>? waitingDataBuilder;
  final ValueBuilder<T>? doneConnectBuilder;
  final WidgetBuilder noneConnectBuilder;

  static Widget _defaultNoneConnectedBuilder(BuildContext context) =>
      kCircularProgressIndicator;

  @override
  State<CustomStreamBuilder<T>> createState() => _CustomStreamBuilderState<T>();
}

class _CustomStreamBuilderState<T> extends State<CustomStreamBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    final ValueBuilder<T> builder = widget.child;
    return StreamBuilder<T>(
      initialData: widget.initialData,
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw StreamError(snapshot.error, stackTrace: snapshot.stackTrace);
        } else {
          final status = snapshot.connectionState;
          final data = snapshot.data;
          switch (status) {
            case ConnectionState.none:
              return widget.noneConnectBuilder(context);

            case ConnectionState.waiting:
              return widget.waitingDataBuilder?.call(context, data) ??
                  builder(context, data);

            case ConnectionState.active:
              return builder(context, data);

            case ConnectionState.done:
              return widget.doneConnectBuilder?.call(context, data) ??
                  builder(context, data);
          }
        }
      },
    );
  }
}

/// custom value widget builder
typedef ValueBuilder<T> = Widget Function(BuildContext context, T? value);
typedef CustomWidgetBuilder = Widget Function(Widget child);

///
///
///
///
/// extensions
///
///
///

/// widget extension
extension WidgetExtension on Widget {
  static List<Widget> sandwich({
    bool isRow = true,
    required int boundary,
    required BoxConstraints breadConstraints,
    required BoxConstraints meatConstraints,
    required Widget Function(int index) bread,
    required Widget Function(int indexOfPreviousBread) meat,
  }) {
    List<Widget> children(int index) => [
          Container(constraints: breadConstraints, child: bread(index)),
          index != boundary
              ? Container(constraints: meatConstraints, child: meat(index))
              : const SizedBox()
        ];

    return isRow
        ? List<Row>.generate(
            boundary,
            (index) => Row(
              children: children(index),
            ),
          )
        : List<Column>.generate(
            boundary,
            (index) => Column(
              children: children(index),
            ),
          );
  }
}

/// alignment extension
extension AlignmentExtension on Alignment {
  double get toFabExpandableDirection {
    if (this == Alignment.bottomRight) {
      return kRadian180Angle;
    } else if (this == Alignment.bottomLeft) {
      return -kRadian90Angle;
    } else if (this == Alignment.bottomCenter) {
      return -kRadian60Angle * 2;
    } else {
      throw AlignmentUnImplementsError();
    }
  }

  CustomWidgetBuilder get deviateBuilder {
    if (this == Alignment.center) {
      return (child) => child;

      //
    } else {
      ///
      /// row builder
      ///
      final CustomWidgetBuilder row;
      Row getRow(List<Widget> children) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          );

      if (x == 0) {
        row = (child) => getRow([child]);
      } else if (x == 1) {
        row = (child) => getRow([child, kExpandedContainer]);
      } else if (x == -1) {
        row = (child) => getRow([kExpandedContainer, child]);
      } else {
        throw AlignmentUnImplementsError();
      }

      ///
      /// column builder
      ///
      final CustomWidgetBuilder column;
      Column getColumn(List<Widget> children) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: children,
          );

      if (y == 0) {
        column = (child) => getColumn([child]);
      } else if (y == 1) {
        column = (child) => getColumn([row(child), kExpandedContainer]);
      } else if (y == -1) {
        column = (child) => getColumn([kExpandedContainer, row(child)]);
      } else {
        throw AlignmentUnImplementsError();
      }

      return (child) => column(child);
    }
  }
}

/// positioned extension
extension PositionedExtension on Positioned {
  Rect? get rect =>
      (left == null || top == null || width == null || height == null)
          ? null
          : Rect.fromLTWH(left!, top!, width!, height!);

  Positioned copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
    Widget? child,
  }) =>
      Positioned(
        left: left ?? this.left,
        right: right ?? this.right,
        top: top ?? this.top,
        bottom: bottom ?? this.bottom,
        width: width ?? this.width,
        height: height ?? this.height,
        child: child ?? this.child,
      );
}

/// container extension
extension ContainerExtension on Container {
  Container copyWith({
    Key? key,
    Widget? child,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) =>
      Container(
        key: key ?? this.key,
        alignment: alignment ?? this.alignment,
        padding: padding ?? this.padding,
        color: color ?? this.color,
        decoration: decoration ?? this.decoration,
        foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
        constraints: constraints ?? this.constraints,
        margin: margin ?? this.margin,
        transform: transform ?? this.transform,
        transformAlignment: transformAlignment ?? this.transformAlignment,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        child: child ?? this.child,
      );
}
