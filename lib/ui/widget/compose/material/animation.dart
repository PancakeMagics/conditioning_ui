part of material;

///
/// this file responsible for [AnimationController], [Animation], [Tween], [Transform], transitions implementation,
///
/// - widgets:
///   - [CustomAnimation]
///
/// - backend:
///   - [AnimationControllerSetting]
///   - [MotivationBase]
///   - [Motivation]
///   - [Motivations]
///   - [Stacker]
///   - [TransformerBase]
///   - [TransformCategory]
///   - [Transformer]
///   - [TransformerHost]
///   - [TransformerHostStacker]
///   - [TransitionCategory]
///   - [Transitioner]
///
/// - typedefs:
///   - [AnimationBuilder], [AnimationsBuilder], [AnimationControllerInitializer], [AnimationControllerListener]
///   - [Matrix4Computation], [Matrix4ComputationValueMapper], [MotivationMapper]
///
/// - others:
///   - [Matrix4Constant]
///   - [AnimationExtension]
///   - [AnimationBuilderIterableExtension]
///   - [AnimationsBuilderIterableExtension]
///   - [TransformerComputations]
///
///
/// info:
///
///---[MotivationBase]
///   It contains [MotivationBase.attach], [MotivationBase.builder],
///   both of them called in [CustomAnimationState._updateAnimation]; they are essential member for all the motivation.
///   Belows class inherits [MotivationBase], assigning them to [CustomAnimation.motivation] triggers animation.
///   - [Motivation]
///    - [Transformer]
///    - [Transitioner]
///    - [Clipper]
///    ...
///   - [Motivations]
///     - [Stacker]
///       - [TransformerHostStacker]
///         - [PlanesMotivation]
///     - [TransformerHost]
///     ...
///
///---[TransformerBase]
///   it contains [TransformerBase.matrix4Constant], [TransformerBase.matrix4], [TransformerBase.alignment],
///   below class inherits [TransformerBase]
///   - [Transformer]
///   - [TransformerHost]
///
/// ---
///
///
///

/// custom animations
class CustomAnimation<T> extends StatefulWidget {
  const CustomAnimation({
    super.key,
    required this.motivation,
    this.child = kSizedBox,
    this.controllerSetting = AnimationControllerSetting.defaultSetting,
  });

  final MotivationBase<T> motivation;
  final Widget child;
  final AnimationControllerSetting controllerSetting;

  @override
  State<CustomAnimation<T>> createState() => CustomAnimationState<T>();
}

class CustomAnimationState<T> extends State<CustomAnimation<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late AnimationControllerSetting _controllerSetting;

  late Iterable<Animation<T>> _animations;

  /// un typed animations builder due to type cast error
  late AnimationsBuilder _animationsBuilder;

  @override
  void initState() {
    _controllerSetting = widget.controllerSetting;
    _controller = _controllerSetting.initialize(this);
    _updateAnimation(isInit: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomAnimation<T> oldWidget) {
    if (_controller.isAnimating) {
      _controllerSetting.onAnimating?.call();
    } else {
      _updateAnimation(isInit: false);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateAnimation({required bool isInit}) {
    final motivation = _controllerSetting.setup(widget.motivation);
    _animations = motivation.attach(_controller);
    _animationsBuilder = motivation.builder;
    _controllerSetting.update(_controller, isInit, setState);
  }

  @override
  Widget build(BuildContext context) =>
      _animationsBuilder(_animations, widget.child);
}

///
///
/// backend
///
///

/// animation command
enum AnimationCommand {
  conditionalReset,
  conditionalReverse,
  resetWhenUpdate,
  reverseWhenUpdate,
}

/// animation setting
class AnimationControllerSetting {
  final Duration forward;
  final Duration reverse;
  final Curve? forwardCurve;
  final Curve? reverseCurve;
  final AnimationControllerInitializer initializer;
  final AnimationControllerListener updater;
  final bool setStateEveryTickUntilCompleted;
  final bool triggerAnimationWhenUpdate;
  final VoidCallback? onAnimating;

  const AnimationControllerSetting({
    this.forward = kDurationSecond1,
    this.reverse = kDurationSecond1,
    this.initializer = initializeController,
    this.updater = listenNothing,
    this.setStateEveryTickUntilCompleted = false,
    this.triggerAnimationWhenUpdate = true,
    this.onAnimating,
  })  : forwardCurve = null,
        reverseCurve = null;

  const AnimationControllerSetting.curved({
    required Curve curveForward,
    required Curve curveReverse,
    this.forward = kDurationSecond1,
    this.reverse = kDurationSecond1,
    this.initializer = initializeController,
    this.updater = listenResetAndForward,
    this.setStateEveryTickUntilCompleted = false,
    this.triggerAnimationWhenUpdate = true,
    this.onAnimating,
  })  : forwardCurve = curveForward,
        reverseCurve = curveReverse;

  static const AnimationControllerSetting defaultSetting =
      AnimationControllerSetting();

  static const AnimationControllerSetting
      defaultSettingWithSetStateEveryTickUntilCompleted =
      AnimationControllerSetting(setStateEveryTickUntilCompleted: true);

  static const AnimationControllerSetting
      defaultSettingWithSetStateEveryTickUntilCompletedCurvedRepeat =
      AnimationControllerSetting.curved(
    curveForward: Curves.fastOutSlowIn,
    curveReverse: Curves.fastOutSlowIn,
    forward: kDurationSecond5,
    setStateEveryTickUntilCompleted: true,
    updater: AnimationControllerSetting.listenRepeat,
  );

  static AnimationController initializeController(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      AnimationController(
        vsync: tickerProvider,
        duration: forward,
        reverseDuration: reverse,
      );

  static void listenNothing(AnimationController c) {}

  static void listenForward(AnimationController c) => c.forward();

  static void listenResetAndForward(AnimationController controller) {
    controller.reset();
    controller.forward();
  }

  static void listenForwardOrReverse(AnimationController controller) {
    if (controller.status == AnimationStatus.dismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  static void listenRepeat(AnimationController controller) {
    controller.repeat();
  }

  AnimationController initialize(TickerProvider tickerProvider) =>
      initializer(tickerProvider, forward, reverse);

  MotivationBase<T> setup<T>(MotivationBase<T> motivation) =>
      forwardCurve == null
          ? motivation
          : motivation.curveWithController(forwardCurve!, reverseCurve!);

  void update<T>(
    AnimationController controller,
    bool isInit,
    void Function(VoidCallback callback) setState,
  ) {
    if (!isInit && triggerAnimationWhenUpdate) {
      controller.addSetStateListener(
        setState,
        untilAnimationCompleted: setStateEveryTickUntilCompleted,
      );
      updater(controller);
    }
  }
}

///
/// motivation base
///
mixin MotivationBase<T> {
  Iterable<Animation<T>> attach(AnimationController controller);

  AnimationsBuilder get builder;

  MotivationBase<T> curveWithController(Curve forward, Curve reverse);
}

/// motivation
class Motivation<T> with MotivationBase<T> {
  final TweenConstant<T> _tween;
  final Curve? forward;
  final Curve? reverse;
  final AnimationBuilder _builder;

  const Motivation({
    required TweenConstant<T> tween,
    AnimationBuilder? builder,
    this.forward,
    this.reverse,
  })  : _builder = builder ?? defaultBuilder,
        _tween = tween;

  static const Motivation none = Motivation(tween: kTweenDouble0);
  static const Motivation from0To1 = Motivation(tween: kTweenDouble0To1);
  static const AnimationBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(Animation animations, Widget child) => child;

  Tween<T> get tween => _tween.toTween;

  Animation<T> _attach(AnimationController controller) =>
      tween.animate(CurvedAnimation(
        parent: controller,
        curve: forward ?? Curves.fastOutSlowIn,
        reverseCurve: reverse ?? Curves.fastOutSlowIn,
      ));

  @override
  Iterable<Animation<T>> attach(AnimationController controller) =>
      [_attach(controller)];

  @override
  AnimationsBuilder get builder => (ans, child) => _builder(ans.first, child);

  Motivation<T> map(MotivationMapper<T> mapper) => mapper(this);

  void checkBeforeCurveWithController() {
    if (forward != null || reverse != null) {
      throw MotivationCurveConflictError();
    }
  }

  /// see [AnimationControllerSetting.setup]
  @override
  Motivation<T> curveWithController(Curve forward, Curve reverse) {
    checkBeforeCurveWithController();
    return Motivation(
      tween: _tween,
      builder: _builder,
      forward: forward,
      reverse: reverse,
    );
  }

  Motivation<T> follow(MapTweenConstant<T> mapper) => Motivation(
        tween: mapper(_tween),
        forward: forward,
        reverse: reverse,
        builder: _builder,
      );
}

/// motivations
class Motivations<M extends MotivationBase<T>, T> with MotivationBase<T> {
  ///
  /// although all the [Motivations] subclasses must have an [Iterable] motivations,
  /// nullable [_motivations] makes their instance being able to be constant without computation;
  /// see [Stacker.motivations] for example
  ///
  final Iterable<M>? _motivations;

  const Motivations({
    required Iterable<M>? motivations,
  }) : _motivations = motivations;

  static const Motivations empty = Motivations(motivations: []);

  Iterable<M> get motivations => _motivations!;

  Iterable<Motivation<T>> get _flattedMotivation {
    final motivations = this.motivations;

    if (motivations is Iterable<Motivation<T>>) {
      return motivations as Iterable<Motivation<T>>;

      //
    } else if (motivations is Iterable<Motivations<Motivation<T>, T>>) {
      return (motivations as Iterable<Motivations<Motivation<T>, T>>)
          .map((ms) => ms.motivations)
          .flat();

      //
    } else if (motivations
        is Iterable<Motivations<Motivations<Motivation<T>, T>, T>>) {
      return (motivations
              as Iterable<Motivations<Motivations<Motivation<T>, T>, T>>)
          .map((ms1) => ms1.motivations.map((ms2) => ms2.motivations).flat())
          .flat();

      //
    } else {
      throw UnimplementedError('$this');
    }
  }

  @override
  Iterable<Animation<T>> attach(AnimationController controller) =>
      _flattedMotivation.map((motivation) => motivation._attach(controller));

  @override
  AnimationsBuilder get builder => _flattedMotivation
      .map((motivation) => motivation._builder)
      .toList(growable: false)
      .animate;

  @override
  Motivations<MotivationBase<T>, T> curveWithController(
    Curve forward,
    Curve reverse,
  ) =>
      Motivations(
        motivations: _flattedMotivation.map(
          (motivation) => motivation.curveWithController(forward, reverse),
        ),
      );

  ///
  /// these getters help subclasses to return [MotivationBase.builder]
  ///
  int get motivationsLength => motivations.length;

  List<AnimationsBuilder> get animationsBuilderList => motivations
      .map((motivation) => motivation.builder)
      .toList(growable: false);

  Iterable<int> get animationsBuilderChunks {
    final motivations = this.motivations;

    if (motivations is Iterable<Motivation<T>>) {
      return Iterable.generate(motivationsLength, (_) => 1);

      //
    } else if (motivations is Iterable<Motivations<Motivation<T>, T>>) {
      return (motivations as Iterable<Motivations<Motivation<T>, T>>)
          .map((iterable) => iterable.motivationsLength);

      //
    } else if (motivations
        is Iterable<Motivations<Motivations<Motivation<T>, T>, T>>) {
      throw UnimplementedError();

      //
    } else {
      throw UnimplementedError();
    }
  }

  ///
  /// motivations methods
  ///
// Motivations<M, T> foreachMap(MapMotivation<T> mapper) =>
//     Motivations(motivations.map((m) => m.map(mapper) as M));
//
// Motivations<M, T> foreachFollow(MapTween<T> mapper) =>
//     Motivations(motivations.map((m) => m.follow(mapper) as M));
}

/// stacker
class Stacker<W extends Widget, M extends MotivationBase<T>, T>
    extends Motivations<M, T> {
  ///
  /// nullable properties makes inheritance more flexible
  ///
  final Map<W, M>? _children;
  final AlignmentGeometry alignment;
  final bool deviateAlignment;

  Map<W, M> get children => _children ?? {};

  const Stacker({
    required Map<W, M>? children,
    this.alignment = Alignment.topLeft,
    this.deviateAlignment = true,
  })  : _children = children,
        super(motivations: null);

  @override
  Iterable<M> get motivations => children.values;

  // Map<W, M> curveMotivation(
  Map<W, Motivations<Motivation<T>, T>> curveMotivation(
    Curve forward,
    Curve reverse,
  ) =>
      children.map((widget, motivation) {
        final curvedM = motivation.curveWithController(forward, reverse);
        return MapEntry(
          widget,
          (curvedM is Motivation<T>)
              ? Motivations<Motivation<T>, T>(motivations: [curvedM])
              : curvedM as Motivations<Motivation<T>, T>,
        );
      });

  @override
  Stacker<W, MotivationBase<T>, T> curveWithController(
    Curve forward,
    Curve reverse,
  ) =>
      Stacker(
        children: curveMotivation(forward, reverse),
        alignment: alignment,
        deviateAlignment: deviateAlignment,
      );

  @override
  AnimationsBuilder get builder => stack();

  AnimationsBuilder stack({int skip = 0}) {
    final chunk = animationsBuilderChunks.skip(skip);
    final builders = animationsBuilderList.sublist(skip);
    final children = this.children.keys.toList(growable: false);

    Stack build(Iterable<Animation> animations) => _stack(
          animationsChunks: animations.chunk(chunk),
          animationsBuilders: builders,
          children: children,
        );

    /// check if deviate alignment
    if (deviateAlignment) {
      if (alignment is Alignment) {
        final deviate = (alignment as Alignment).deviateBuilder;
        return (animations, _) => deviate(build(animations));
      } else {
        throw AlignmentUnImplementsError();
      }
    } else {
      return (animations, _) => build(animations);
    }
  }

  Stack _stack({
    required Iterable<Iterable<Animation>> animationsChunks,
    required List<AnimationsBuilder> animationsBuilders,
    required List<Widget> children,
  }) =>
      Stack(
        alignment: alignment,
        children: animationsBuilders.animate(animationsChunks, children),
      );
}

/// transformer base
mixin TransformerBase {
  Matrix4Constant get matrix4Constant => Matrix4Constant.identityInstance;

  Matrix4 get matrix4 => matrix4Constant.toMatrix4;

  AlignmentGeometry? get alignment;
}

/// transform category
enum TransformCategory {
  scale,
  rotate,
  translate,
}

/// transformer 3d
class Transformer extends Motivation<Coordinate> with TransformerBase {
  @override
  final AlignmentGeometry alignment;

  final TransformCategory category;
  final Matrix4Computation? computation;

  const Transformer._({
    required this.category,
    required this.alignment,
    required super.tween,
    required super.forward,
    required super.reverse,
    required this.computation,
  }) : super(builder: null);

  const Transformer.scale({
    required super.tween,
    this.alignment = Alignment.center,
    super.forward,
    super.reverse,
  })  : computation = null,
        category = TransformCategory.scale,
        super(builder: null);

  const Transformer.rotate({
    required super.tween,
    this.alignment = Alignment.center,
    super.forward,
    super.reverse,
  })  : computation = null,
        category = TransformCategory.rotate,
        super(builder: null);

  const Transformer.custom({
    required super.tween,
    required this.computation,
    this.alignment = Alignment.center,
    super.forward,
    super.reverse,
  })  : category = TransformCategory.rotate,
        super(builder: null);

  const Transformer.translate({
    required super.tween,
    this.alignment = Alignment.center,
    super.forward,
    super.reverse,
  })  : computation = null,
        category = TransformCategory.translate,
        super(builder: null);

  ///
  /// implementations
  ///

  AnimationBuilder transform(Matrix4Computation computation) =>
      ((animation, child) => Transform(
            transform: computation(matrix4, animation.value),
            alignment: alignment,
            child: child,
          ));

  @override
  AnimationBuilder get _builder {
    if (computation == null) {
      switch (category) {
        case TransformCategory.scale:
          return transform(TransformerComputations.scaling);

        case TransformCategory.rotate:
          return transform(TransformerComputations.rotating());

        case TransformCategory.translate:
          return transform(TransformerComputations.translating);
      }
    } else {
      return transform(computation!);
    }
  }

  @override
  Transformer curveWithController(Curve forward, Curve reverse) {
    checkBeforeCurveWithController();
    return Transformer._(
      category: category,
      alignment: alignment,
      tween: _tween,
      forward: forward,
      reverse: reverse,
      computation: computation,
    );
  }

  @override
  Transformer map(MotivationMapper<Coordinate> mapper) =>
      super.map(mapper) as Transformer;

  @override
  Transformer follow(MapTweenConstant<Coordinate> mapper) => Transformer._(
        category: category,
        tween: mapper(_tween),
        forward: forward,
        reverse: reverse,
        alignment: alignment,
        computation: computation,
      );

  ///
  /// transformer methods
  ///

  Transformer link(
    Matrix4 matrix4,
    AlignmentGeometry alignment, {
    Matrix4Computation? computation,
  }) =>
      Transformer._(
        category: category,
        tween: _tween,
        forward: forward,
        reverse: reverse,
        alignment: alignment,
        computation: computation ?? this.computation,
      );
}

/// transformer host
class TransformerHost extends Motivations<Motivation<Coordinate>, Coordinate>
    with TransformerBase {
  @override
  final Matrix4Constant matrix4Constant;
  @override
  final AlignmentGeometry alignment;

  final Coordinate? _scaled;
  final Coordinate? _rotated;
  final Coordinate? _translated;

  final Transformer? _scaling;
  final Transformer? _rotating;
  final Transformer? _translating;

  /// see [translationScale] for detail
  final double distanceToObserver;

  const TransformerHost({
    this.alignment = Alignment.center,
    Coordinate scaled = CoordinateConstants.scale1,
    Coordinate rotated = Coordinate.zero,
    Coordinate translated = Coordinate.zero,
    this.distanceToObserver = defaultDistanceFromContentToObserver,
  })  : matrix4Constant = Matrix4Constant.identityInstance,
        _scaled = scaled,
        _rotated = rotated,
        _translated = translated,
        _scaling = null,
        _rotating = null,
        _translating = null,
        super(motivations: null);

  const TransformerHost.transformable({
    this.alignment = Alignment.center,
    Transformer scaling = TransformConstants.scale1,
    Transformer rotating = TransformConstants.rotateNone,
    Transformer translating = TransformConstants.translateNone,
    this.distanceToObserver = defaultDistanceFromContentToObserver,
  })  : matrix4Constant = Matrix4Constant.identityInstance,
        _scaled = null,
        _rotated = null,
        _translated = null,
        _scaling = scaling,
        _rotating = rotating,
        _translating = translating,
        super(motivations: null);

  static const TransformerHost none = TransformerHost();
  static const double defaultDistanceFromContentToObserver = 1000;

  Transformer _transform(TransformCategory category) {
    switch (category) {
      case TransformCategory.scale:
        assert(
            _scaling == null || _scaling?.category == TransformCategory.scale);
        return _scaling ??
            Transformer.scale(tween: TweenConstant.constant(_scaled));

      case TransformCategory.rotate:
        assert(_rotating == null ||
            _rotating?.category == TransformCategory.rotate);
        return _rotating ??
            Transformer.rotate(tween: TweenConstant.constant(_rotated));

      case TransformCategory.translate:
        assert(_translating == null ||
            _translating?.category == TransformCategory.translate);
        return _translating ??
            Transformer.translate(tween: TweenConstant.constant(_translated));
    }
  }

  Transformer get scaling => _transform(TransformCategory.scale);

  Transformer get rotating => _transform(TransformCategory.rotate);

  Transformer get translating => _transform(TransformCategory.translate);

  ///
  /// scaling when translating [Coordinate.dz]
  ///
  /// c: content    (on Coordinate.dz == 0)
  /// o: observer   (on Coordinate.dz == [defaultDistanceFromContentToObserver])
  ///
  /// - [translating.tween.begin] * [translating.tween.end] > 0 == true
  /// - proportion: (o - begin) : (o - end) = borderBegin : borderEnd
  ///
  /// sizeScale = sizeBegin / sizeEnd = (o - [translating.tween.begin])^2 / (o - [translating.tween.end])^2
  /// borderScale = [deltaBegin] / [deltaEnd]
  ///

  Transformer get translationScale {
    final tween = translating.tween;
    final deltaBegin = distanceToObserver - tween.begin!.dz;
    final deltaEnd = distanceToObserver - tween.end!.dz;

    assert(
      /// delta == 0 is on observer
      deltaBegin > 0 && deltaEnd > 0,
      "try not to observe things on your eye or behind your head",
    );

    final scaleProportion = deltaBegin / deltaEnd;

    return Transformer.scale(
      alignment: translating.alignment,
      tween: TweenConstant(
        begin: CoordinateConstants.scale1,
        end: Coordinate.scale(scaleProportion),
      ),
      forward: translating.forward,
      reverse: translating.reverse,
    );
  }

  @override
  Iterable<Motivation<Coordinate>> get motivations => [
        scaling.link(matrix4, alignment),
        rotating.link(matrix4, alignment),
        translating.link(matrix4, alignment),
        translationScale.link(matrix4, alignment),
      ];

  @override
  TransformerHost curveWithController(Curve forward, Curve reverse) =>
      TransformerHost.transformable(
        alignment: alignment,
        scaling: scaling.curveWithController(forward, reverse),
        rotating: rotating.curveWithController(forward, reverse),
        translating: translating.curveWithController(forward, reverse),
        distanceToObserver: distanceToObserver,
      );
}

/// transformer host stacker
class TransformerHostStacker
    extends Stacker<Widget, TransformerHost, Coordinate> {
  final TransformerHost host;

  const TransformerHostStacker({
    this.host = TransformerHost.none,
    super.alignment,
    super.deviateAlignment,
    super.children,
  });

  ///
  /// [motivations] is [Iterable]<[TransformerHost]>
  /// [motivationsLength] is planes count (length of iterable [motivations])
  ///
  /// [animationsBuilderChunks] is iterable int of the length of [TransformerHost.motivations]
  /// [animationsBuilderList] is a list of [Motivations.builder]s that come form [TransformerHost].
  /// a [TransformerHost]'s builder comes from [Motivations.builder],
  /// and [TransformerHost.motivations] is [Iterable]<[Motivation]>.
  /// in conclusion,
  /// the first depth of [animationsBuilderList] is [motivationsLength],
  /// the second depth of [animationsBuilderList] depend on the amount of [TransformerHost.motivations].
  ///
  /// in this case,
  /// [motivations] lead to 4 * (1 + n) [AnimationBuilder], because a [TransformerHost] trigger 4 [AnimationBuilder]
  ///
  @override
  Iterable<TransformerHost> get motivations => [host, ...super.motivations];

  @override
  TransformerHostStacker curveWithController(Curve forward, Curve reverse) =>
      TransformerHostStacker(
        host: host,
        alignment: alignment,
        deviateAlignment: deviateAlignment,
        children: children.map(
          (widget, motivation) => MapEntry(
            widget,
            motivation.curveWithController(forward, reverse),
          ),
        ),
      );

  @override
  AnimationsBuilder get builder {
    final hostMotivationCount = host.motivations.length;
    final hostBuilder = host.builder;

    return (animations, child) => hostBuilder(
          animations.take(hostMotivationCount),
          stack(skip: 1)(animations.skip(hostMotivationCount), child),
        );
  }
}

/// transition category
enum TransitionCategory {
  translate,
  scale,
  rotate,
  size,
  fade,
  sliverFade,
  align,
  decoration,
  textStyle,
  positioned,
  relativePositioned,
}

/// transitioner
class Transitioner<T> extends Motivation<T> {
  final TransitionCategory category;
  final Alignment? scaleAlignment;
  final Axis? sizeAxis;
  final double? sizeAxisAlignment;
  final Size? relativePositionSize;

  const Transitioner._({
    required this.category,
    required super.tween,
    required super.forward,
    required super.reverse,
    required this.scaleAlignment,
    required this.sizeAxis,
    required this.sizeAxisAlignment,
    required this.relativePositionSize,
  }) : super(builder: null);

  const Transitioner.fade({
    required TweenConstant<double> tween,
    super.forward,
    super.reverse,
  })  : category = TransitionCategory.fade,
        scaleAlignment = null,
        sizeAxis = null,
        sizeAxisAlignment = null,
        relativePositionSize = null,
        super(builder: null, tween: tween as TweenConstant<T>);

  const Transitioner.scale({
    required TweenConstant<double> tween,
    super.forward,
    super.reverse,
    this.scaleAlignment,
  })  : category = TransitionCategory.scale,
        sizeAxis = null,
        sizeAxisAlignment = null,
        relativePositionSize = null,
        super(builder: null, tween: tween as TweenConstant<T>);

  const Transitioner.translate({
    required TweenConstant<Offset> tween,
    super.forward,
    super.reverse,
  })  : category = TransitionCategory.translate,
        scaleAlignment = null,
        sizeAxis = null,
        sizeAxisAlignment = null,
        relativePositionSize = null,
        super(builder: null, tween: tween as TweenConstant<T>);

  const Transitioner.rotate({
    required TweenConstant<double> tween,
    super.forward,
    super.reverse,
  })  : category = TransitionCategory.rotate,
        scaleAlignment = null,
        sizeAxis = null,
        sizeAxisAlignment = null,
        relativePositionSize = null,
        super(builder: null, tween: tween as TweenConstant<T>);

  const Transitioner.decoration({
    required TweenConstant<Decoration> tween,
    super.forward,
    super.reverse,
  })  : category = TransitionCategory.decoration,
        scaleAlignment = null,
        sizeAxis = null,
        sizeAxisAlignment = null,
        relativePositionSize = null,
        super(builder: null, tween: tween as TweenConstant<T>);

  ///
  /// motivation implementation
  ///

  @override
  AnimationBuilder get _builder {
    switch (category) {
      case TransitionCategory.decoration:
        return (animation, child) => DecoratedBoxTransition(
              decoration: animation as Animation<Decoration>,
              child: child,
            );

      case TransitionCategory.translate:
        return (animation, child) => SlideTransition(
              position: animation as Animation<Offset>,
              child: child,
            );

      case TransitionCategory.align:
        return (animation, child) => AlignTransition(
              alignment: animation as Animation<Alignment>,
              child: child,
            );

      case TransitionCategory.textStyle:
        return (animation, child) => DefaultTextStyleTransition(
              style: animation as Animation<TextStyle>,
              child: child,
            );

      case TransitionCategory.positioned:
        return (animation, child) => PositionedTransition(
              rect: animation as Animation<RelativeRect>,
              child: child,
            );

      case TransitionCategory.relativePositioned:
        return (animation, child) => RelativePositionedTransition(
              rect: animation as Animation<Rect>,
              size: relativePositionSize!,
              child: child,
            );

      case TransitionCategory.rotate:
        return (animation, child) => RotationTransition(
              turns: animation as Animation<double>,
              child: child,
            );

      case TransitionCategory.fade:
        return (animation, child) => FadeTransition(
              opacity: animation as Animation<double>,
              child: child,
            );

      case TransitionCategory.sliverFade:
        return (animation, child) => SliverFadeTransition(
              opacity: animation as Animation<double>,
              sliver: child,
            );

      case TransitionCategory.scale:
        return (animation, child) => ScaleTransition(
              scale: animation as Animation<double>,
              alignment: scaleAlignment ?? Alignment.center,
              child: child,
            );

      case TransitionCategory.size:
        return (animation, child) => SizeTransition(
              sizeFactor: animation as Animation<double>,
              axis: sizeAxis ?? Axis.vertical,
              axisAlignment: sizeAxisAlignment ?? 0.0,
              child: child,
            );
    }
  }

  @override
  Transitioner<T> map(MotivationMapper<T> mapper) =>
      super.map(mapper) as Transitioner<T>;

  @override
  Transitioner<T> follow(MapTweenConstant<T> mapper) => Transitioner._(
        category: category,
        tween: mapper(_tween),
        forward: forward,
        reverse: reverse,
        scaleAlignment: scaleAlignment,
        sizeAxis: sizeAxis,
        sizeAxisAlignment: sizeAxisAlignment,
        relativePositionSize: relativePositionSize,
      );

  @override
  Motivation<T> curveWithController(Curve forward, Curve reverse) {
    checkBeforeCurveWithController();
    return Transitioner._(
      category: category,
      tween: _tween,
      forward: forward,
      reverse: reverse,
      scaleAlignment: scaleAlignment,
      sizeAxis: sizeAxis,
      sizeAxisAlignment: sizeAxisAlignment,
      relativePositionSize: relativePositionSize,
    );
  }
}

///
///
/// typedefs
///
///

/// animation controller initializer,
typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider tickerProvider,
  Duration forward,
  Duration reverse,
);

/// animation controller listener will be called when [CustomAnimationState.didUpdateWidget],
///    - [CustomAnimation.link]
///    - it's help [CustomAnimation]'s parent to control animation flow when update widget
///    - this function can be placed in many place, rather than [CustomAnimation.link]
///    ...
typedef AnimationControllerListener = void Function(
  AnimationController controller,
);

/// animation controller setting initializer
typedef AnimationControllerSettingInitializer = AnimationControllerSetting
    Function(
  AnimationControllerListener updater,
);

///
/// animations builder will be called when [CustomAnimationState.build],
///    - [CustomAnimation.builder]
///    - its argument, iterable [Animation], is according to [CustomAnimation.motivation].
///    - it's the main function helping [CustomAnimation] to build widget.
///
/// tip:
/// "AnimationsBuilder<dynamic>" cannot cast from "AnimationsBuilder<Type>"
/// so it is better not to type [AnimationsBuilder] with generic type
///
typedef AnimationsBuilder<T> = Widget Function(
  Iterable<Animation<T>> animations,
  Widget child,
);

/// animation builder should be returned by subclassed of [Motivation]
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

typedef AnimationMapper<T> = Iterable<Animation> Function(
  Iterable<Animation> animations,
);

/// matrix4 computation
///
/// [T] types
/// - [double] for 2d scaling, rotation
/// - [Offset] for 2d translation
/// - [Coordinate] for 3D scaling, translation, rotation
///
typedef Matrix4Computation<T> = Matrix4 Function(Matrix4 matrix4, T value);

/// matrix4 computation value mapper
typedef Matrix4ComputationValueMapper = double Function(
  Dimension dimension,
  double value,
);

/// motivation mapper
typedef MotivationMapper<T> = Motivation<T> Function(Motivation<T> motivation);

///
///
/// others
///
///
///

/// matrix4 constant
class Matrix4Constant {
  final List<double> matrix4List;

  const Matrix4Constant(this.matrix4List);

  const Matrix4Constant.identity() : matrix4List = identityList;

  static const List<double> identityList = [
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];

  static const Matrix4Constant identityInstance = Matrix4Constant.identity();

  factory Matrix4Constant.from(Matrix4 matrix4) => Matrix4Constant([
        matrix4.entry(0, 0),
        matrix4.entry(0, 1),
        matrix4.entry(0, 2),
        matrix4.entry(0, 3),
        matrix4.entry(1, 0),
        matrix4.entry(1, 1),
        matrix4.entry(1, 2),
        matrix4.entry(1, 3),
        matrix4.entry(2, 0),
        matrix4.entry(2, 1),
        matrix4.entry(2, 2),
        matrix4.entry(2, 3),
        matrix4.entry(3, 0),
        matrix4.entry(3, 1),
        matrix4.entry(3, 2),
        matrix4.entry(3, 3),
      ]);

  Matrix4 get toMatrix4 => Matrix4.fromList(matrix4List);
}

/// animation extension
extension AnimationExtension on Animation {
  void _removeListenerWhenCompleted(
    AnimationStatus status,
    VoidCallback listener,
    AnimationStatusListener sl,
  ) {
    if (status == AnimationStatus.completed) {
      removeListener(listener);
      removeStatusListener(sl);
    }
  }

  void _removeStatusListenerWhenCompleted(
    AnimationStatus status,
    AnimationStatusListener listener,
    AnimationStatusListener sl,
  ) {
    if (status == AnimationStatus.completed) {
      removeStatusListener(listener);
      removeStatusListener(sl);
    }
  }

  void addListenerUntilAnimationCompleted(VoidCallback listener) {
    void removeWhenCompletedListener(AnimationStatus status) =>
        _removeListenerWhenCompleted(
            status, listener, removeWhenCompletedListener);
    addListener(listener);
    addStatusListener(removeWhenCompletedListener);
  }

  void addStatusListenerUntilAnimationCompleted(
    AnimationStatusListener listener,
  ) {
    void removeWhenCompletedListener(AnimationStatus status) =>
        _removeStatusListenerWhenCompleted(
            status, listener, removeWhenCompletedListener);
    addStatusListener(listener);
    addStatusListener(removeWhenCompletedListener);
  }

  void addSetStateListener(
    void Function(VoidCallback callback) setState, {
    bool untilAnimationCompleted = true,
  }) {
    void setStateListener() => setState(() {});

    untilAnimationCompleted
        ? addListenerUntilAnimationCompleted(setStateListener)
        : addListener(setStateListener);
  }
}

/// animation builder iterable extension
extension AnimationBuilderIterableExtension on List<AnimationBuilder> {
  Widget animate(Iterable<Animation> animations, Widget child) =>
      animations.foldWithIndex(
        child,
        (child, animation, index) => this[index](animation, child),
      );
}

/// animations builder iterable extension
extension AnimationsBuilderIterableExtension on List<AnimationsBuilder> {
  List<Widget> animate(
    Iterable<Iterable<Animation>> animationsList,
    List<Widget> children,
  ) =>
      animationsList.foldWithIndex(
        [],
        (list, animations, index) => list
          ..add(
            this[index](animations, children[index]),
          ),
      );
}

/// matrix4 computations
extension TransformerComputations on Matrix4Computation {
  ///
  /// scale, rotate, translate
  ///
  static Matrix4Computation get scaling => (matrix4, value) =>
      matrix4.scaled((value as Coordinate).dx, value.dy, value.dz);

  static Matrix4Computation rotating({Matrix4ComputationValueMapper? mapper}) {
    final rotate = mapper == null
        ? (value) => Matrix4.identity()
          ..rotateX((value as Coordinate).dx)
          ..rotateY(value.dy)
          ..rotateZ(value.dz)
        : (value) => Matrix4.identity()
          ..rotateX(mapper(Dimension.x, (value as Coordinate).dx))
          ..rotateY(mapper(Dimension.y, value.dy))
          ..rotateZ(mapper(Dimension.z, value.dz));

    return (matrix4, value) =>
        matrix4..setRotation(rotate(value).getRotation());
  }

  static Matrix4Computation get translating => (matrix4, value) =>
      matrix4..translate((value as Coordinate).dx, value.dy, value.dz);

// static Matrix4Computation setPerspective() {
//   (m, value) =>
// }

}
