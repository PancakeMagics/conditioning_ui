part of coordinate;

///
/// this file contains
///
/// widgets:
///   - [Planes]
///   - [PlanesComposition]
///   - [PlanesShelf]
///
/// backend:
///   - [PlanesMotivation]
///   - [_PlanesComposerBase]
///   - [_PlanesComposerTranslationManager]
///   - [_PlanesComposerCommandExecutor]
///   - [PlanesComposerTranslation]
///   - [PlanesComposerCommand]
///   - [PlanesComposer]
///
/// typedefs:
///   - [PlaneGenerator]
///   - [PlaneAlignmentGenerator]
///   - [PlaneRotationGenerator]
///   - [PlaneRotationRotatorGenerator]
///   - [PlaneTransformerHostGenerator]
///   - [PlanesComposerCombiner]
///
/// extensions:
///   - [PlanesComposerCommandExtension]
///   - [_PlanesComposerExecutorListExtension]
///
///
///
///
///

/// planes
class Planes extends StatelessWidget {
  const Planes({
    super.key,
    required this.count,
    required this.volume,
    required this.apparentDeep,
    required this.stackAlignment,
    required this.motivation,
    required this.setting,
    this.stackAlignmentShouldDeviate = true,
    this.alignments,
  });

  ///
  /// - [count]
  /// - [volume]
  /// - [apparentDeep]
  /// - [motivation]
  /// - [setting]
  /// - [stackAlignment]
  /// - [stackAlignmentShouldDeviate]
  /// - [alignments]
  ///
  /// * belows points describe the point after [stackAlignmentShouldDeviate] deviate (for [count] == 3)
  ///   - ([alignments])
  ///   - topLeft:
  ///     - ([stackAlignment])
  ///     - bottomLeft --- center
  ///     - bottomRight -- left
  ///     - topLeft ------ topCenter
  ///     - topRight ----- topLeft
  ///   - bottomRight:
  ///     - topRight ----- center       (== topLeft.bottomLeft rotate 180)
  ///     - topLeft ------ right        (== topLeft.bottomRight rotate 180)
  ///     - bottomLeft --- bottomRight  (== topLeft.topRight rotate 180)
  ///     - bottomRight -- bottomCenter (== topLeft.topLeft rotate 180)
  ///
  final int count;
  final Coordinate volume;
  final double apparentDeep; // radian
  final AlignmentGeometry stackAlignment;
  final PlanesMotivation motivation;
  final AnimationControllerSetting setting;
  final bool stackAlignmentShouldDeviate;
  final PlaneAlignmentGenerator? alignments;

  @override
  Widget build(BuildContext context) {
    return CustomAnimation(
      motivation: motivation.motivate(this),
      controllerSetting: setting,
    );
  }

  ///
  /// belows methods and getter
  ///
  /// - [format]
  /// - [_generatePlanes]
  /// - [_rotationWith]
  /// - [_rotators]
  ///
  Map<SizedBox, TransformerHost> format({
    required PlaneTransformerHostGenerator generateHosts,
    required List<Widget> children,
  }) =>
      Map.fromIterables(
        Iterable.generate(count, _generatePlanes(children, volume)),
        Iterable.generate(
          count,
          (index) => generateHosts(
            index,
            alignments ?? (index) => stackAlignment,
            _rotationWith(apparentDeep),
          ),
        ),
      );

  /// planes
  PlaneGenerator _generatePlanes(List<Widget> children, Coordinate volume) {
    final sizes = <Size>[];
    switch (count) {
      // x == width, y == height, z == deep, (XZ plane is the top plane)
      case 3:
        sizes.addAll([
          volume.retainXZAsXY.toSize,
          volume.retainXY.toSize,
          volume.retainYZAsYX.toSize,
        ]);
        break;

      default:
        throw UnimplementedError();
    }
    return (index) => SizedBox.fromSize(
          size: sizes[index],
          child: children[index],
        );
  }

  /// rotation with
  PlaneRotationGenerator _rotationWith(double apparentDeep) {
    final apparentComplementary = (kRadian90Angle - apparentDeep).abs();

    final directions = <Coordinate>[];
    switch (count) {
      case 3:
        directions.add(Coordinate(apparentDeep, 0, 0));
        directions.add(Coordinate(apparentComplementary, 0, 0));
        directions.add(Coordinate(apparentComplementary, kRadian90Angle, 0));
        break;

      default:
        throw UnimplementedError();
    }

    final rotators = _rotators;
    return (index, radianStart, radianEnd) => Transformer.rotate(
          tween: TweenConstant(
            begin: directions[index] + rotators(index, radianStart),
            end: directions[index] + rotators(index, radianEnd),
          ),
        );
  }

  /// rotators
  PlaneRotationRotatorGenerator get _rotators {
    switch (count) {
      case 3:
        return (indexOfPlanes, radian) => indexOfPlanes == 0
            ? Coordinate(0, 0, radian)
            : Coordinate(0, radian, 0);

      default:
        throw UnimplementedError();
    }
  }
}

/// planes composition
class PlanesComposition extends StatefulWidget {
  const PlanesComposition({
    super.key,
    required this.compose,
    required this.composer,
    required this.combiner,
    required this.setting,
    this.composeCommand = AnimationCommand.conditionalReverse,
    this.children = kListListGridPaperSimple,
  });

  final bool compose;
  final AnimationControllerSettingInitializer setting;
  final PlanesComposer composer;
  final AnimationCommand composeCommand;

  ///
  /// [combiner]
  /// see [PlanesComposerCommandCombinations] for combinations
  /// [PlanesComposerCommandCombinations.in1]
  /// [PlanesComposerCommandCombinations.in2_1A_2B]
  /// [PlanesComposerCommandCombinations.in3_1A_2BR_3BT]
  /// [PlanesComposerCommandCombinations.in4_1RA_2TB_3RB_4TA]
  /// ...
  ///
  /// total amount:
  /// (in1) C4_4 +
  /// (in2) C4_1 * C3_3 * 2! + C4_2 * C2_2 * 2! / 2! +
  /// (in3) C4_2 * C2_1 * C1_1 * 3! / 2! +
  /// (in4) C4_1 * C3_1 * C2_1 * C1_1 * 4! / 4! =
  /// 1 + 14 + 36 + 24 = 75 #
  ///
  final PlanesComposerCombiner combiner;
  final List<List<Widget>> children;

  Map<int, List<Set<TransformCategory>>> get steps =>
      PlanesComposerCommandCombinations.i.step(combiner).map(
            (index, step) => MapEntry(index, [
              step
                  .where((e) => e.childIndex == 0)
                  .map((e) => e.transformCategory)
                  .toSet(),
              step
                  .where((e) => e.childIndex == 1)
                  .map((e) => e.transformCategory)
                  .toSet(),
            ]),
          );

  @override
  State<PlanesComposition> createState() => _PlanesCompositionState();
}

class _PlanesCompositionState extends State<PlanesComposition> {
  ///
  /// - [_composed]
  /// - [_isAnimating]
  /// - [_stepForwardOrReverse]
  /// - [_childrenCount]
  /// - [_stepIndexLast]
  /// - [_stepIndex]
  /// - [_step]
  /// - [_stepped]
  ///
  bool _composed = false;
  bool _isAnimating = false;
  bool? _stepForwardOrReverse;
  late int _stepIndex;
  late int _childrenCount;
  late int _stepIndexLast;
  final List<Set<TransformCategory>> _step = [];
  final List<Set<TransformCategory>> _stepped = [];

  void _update() {
    _childrenCount = widget.children.length;

    assert(
      widget.children.lengths.reduce((l1, l2) => l1 + l2) ==
          _childrenCount * widget.composer.planesCount,
      'invalid composer, children',
    );

    _step.addAll(List.generate(_childrenCount, (_) => {}));
    _stepped.addAll(List.generate(_childrenCount, (_) => {}));
  }

  @override
  void initState() {
    _update();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlanesComposition oldWidget) {
    if (!_isAnimating && oldWidget.compose != widget.compose) {
      _step.clear();
      _stepped.clear();
      _update();

      /// update step index
      void updateIndex({required int from, required int to}) {
        _stepIndex = from;
        _stepIndexLast = to;
        _stepForwardOrReverse = widget.compose;
        _findStep();
      }

      /// find out index 'from' and 'to'
      final maxStepIndex = widget.steps.length * _childrenCount;
      final command = widget.composeCommand;
      switch (command) {
        case AnimationCommand.conditionalReverse:
          updateIndex(
            from: _composed ? maxStepIndex : 1,
            to: _composed ? 1 : maxStepIndex,
          );
          break;

        case AnimationCommand.resetWhenUpdate:
          updateIndex(from: 1, to: maxStepIndex);
          break;

        case AnimationCommand.conditionalReset:
        case AnimationCommand.reverseWhenUpdate:
          throw UnimplementedError();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  /// find forward step or reverse step
  void _findStep({bool isFinish = false, bool shouldSetState = false}) =>
      isFinish
          ? _composed = !_composed
          : () {
              _step.forEachAddAll(
                widget.steps[(_stepIndex / _childrenCount).ceil()],
              );
              shouldSetState ? setState(() {}) : null;
            }();

  /// stepping controller
  void _steppingController(AnimationController controller) {
    _isAnimating = true;
    controller.reset();
    controller.forward().then((_) {
      _stepped.forEachAddAll(_step);
      _stepIndex == _stepIndexLast
          ? _isAnimating = false
          : () {
              _stepIndex += _stepForwardOrReverse! ? 1 : -1;
              _findStep(
                isFinish: _stepIndex == _stepIndexLast,
                shouldSetState: true,
              );
            }();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.composer._planes(
        animationIsForward: _stepForwardOrReverse,
        animationControllerSetting: widget.setting(_steppingController),
        alignments: [Alignment.topLeft, Alignment.bottomRight],
        executorsList: _PlanesComposerCommandExecutor.fromSteps(
          categories: [TransformCategory.translate, TransformCategory.rotate],
          step: _step,
          stepped: _stepped,
        ),
        children: widget.children,
      ),
    );
  }
}

/// planes shelf
class PlanesShelf extends StatefulWidget {
  const PlanesShelf({
    super.key,
    required this.toggle,
    required this.volume,
    required this.apparentDeep,
    required this.targetRotate,
    required this.setting,
    this.targetTranslation = PlanesComposerTranslation.centerEnclose,
    this.combiner = PlanesComposerCommandCombinations.in3_1AT_2AR_3B,
    this.columnAlignment = MainAxisAlignment.center,
    this.rowAlignment = MainAxisAlignment.center,
  });

  final bool toggle;
  final Coordinate volume;
  final double apparentDeep;
  final double targetRotate;
  final PlanesComposerTranslation targetTranslation;
  final AnimationControllerSettingInitializer setting;
  final PlanesComposerCombiner combiner;

  /// alignment
  final MainAxisAlignment columnAlignment;
  final MainAxisAlignment rowAlignment;

  PlanesComposer get composer => PlanesComposer(
        volume: volume,
        apparentDeepRadian: apparentDeep,
        targetRotate: targetRotate,
        targetTranslation: targetTranslation,
      );

  @override
  State<PlanesShelf> createState() => _PlanesShelfState();
}

class _PlanesShelfState extends State<PlanesShelf> {
  final List<List<bool>> togglesList = [];

  @override
  void initState() {
    _update();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlanesShelf oldWidget) {
    _update();
    super.didUpdateWidget(oldWidget);
  }

  ///
  /// TODO:
  /// 1. calculate the column, row amount, create [togglesList] in correct amount
  /// 2, align each item from center
  /// 2. generate a stream of [togglesList], toggle each one after another, listen to [widget.toggle]'s changes
  ///
  void _update() {
    final toggle = widget.toggle;
    togglesList.clear();
    togglesList.addAll(List.generate(
      3,
      (_) => List.generate(3, (_) => toggle),
    ));
  }

  /// clipper r rect
  ClipRRect _clipperRRect({
    required double opacity,
    required Color color,
  }) =>
      ClipRRect(
        borderRadius: kBorderRadius8,
        child: Opacity(
          opacity: opacity,
          child: Container(
            color: color,
          ),
        ),
      );

  /// row
  Row _row({
    required List<bool> toggles,
    required PlanesComposition Function(bool compose) compose,
  }) =>
      Row(
        mainAxisAlignment: widget.rowAlignment,
        children: toggles.map((t) => compose(t)).toList(growable: false),
      );

  @override
  Widget build(BuildContext context) {
    final appColor = context.preference.appColor;

    PlanesComposition compose(bool toggle) => PlanesComposition(
          compose: toggle,
          composer: widget.composer,
          combiner: widget.combiner,
          setting: widget.setting,
          children: [
            [
              _clipperRRect(opacity: 1, color: appColor.colorB1),
              _clipperRRect(opacity: 0.6, color: appColor.colorB2),
              _clipperRRect(opacity: 0.6, color: appColor.colorB3),
            ],
            [
              _clipperRRect(opacity: 1, color: appColor.colorB3),
              _clipperRRect(opacity: 0.5, color: appColor.colorB2),
              _clipperRRect(opacity: 0.5, color: appColor.colorB3),
            ],
          ],
        );

    return SizedBox(
      width: 500,
      height: 500,
      child: Column(
        mainAxisAlignment: widget.columnAlignment,
        children: togglesList
            .map((toggles) => _row(toggles: toggles, compose: compose))
            .toList(growable: false),
      ),
    );
  }
}

///
///
/// backend
///
///

/// planes motivation
class PlanesMotivation extends TransformerHostStacker {
  final Planes? planes;
  final List<Widget> _children;

  ///
  /// [planesRotateStart] in here can only describe the rotation on each plane,
  /// see [TransformerHostStacker.host] for rotating, translating, scaling all planes.
  ///
  final double planesRotateStart;
  final double planesRotateEnd;
  final Transformer planesScaling;
  final Transformer planesTranslating;

  const PlanesMotivation({
    super.host,
    required List<Widget> children,
    this.planesRotateStart = kRadian60Angle,
    this.planesRotateEnd = kRadian60Angle,
    this.planesScaling = TransformConstants.scale1,
    this.planesTranslating = TransformConstants.translateNone,
    bool alignmentStackDeviate = true,
  })  : _children = children,
        planes = null,
        super(
          children: null,
          deviateAlignment: alignmentStackDeviate,
        );

  const PlanesMotivation._({
    required super.host,
    required this.planes,
    required List<Widget> children,
    required this.planesRotateStart,
    required this.planesRotateEnd,
    required this.planesScaling,
    required this.planesTranslating,
    required bool alignmentStackDeviate,
  })  : _children = children,
        super(
          children: null,
          deviateAlignment: alignmentStackDeviate,
        );

  ///
  /// for the sake of [TransformerHostStacker.builder],
  /// [children] prevent from composing every animation tick
  ///
  @override
  Map<Widget, TransformerHost> get children => planes == null
      ? (throw PlanesMotivationNotMotivatableError())
      : planes!.format(
          generateHosts: (index, alignments, rotating) =>
              TransformerHost.transformable(
            alignment: alignments(index),
            rotating: rotating(index, planesRotateStart, planesRotateEnd),
            scaling: planesScaling,
            translating: planesTranslating,
          ),
          children: _children,
        );

  /// motivate
  PlanesMotivation motivate(Planes planes) => PlanesMotivation._(
        host: host,
        planes: planes,
        children: _children,
        planesRotateStart: planesRotateStart,
        planesRotateEnd: planesRotateEnd,
        planesScaling: planesScaling,
        planesTranslating: planesTranslating,
        alignmentStackDeviate: deviateAlignment,
      );

  /// alignment
  @override
  AlignmentGeometry get alignment => planes == null
      ? (throw PlanesMotivationNotMotivatableError())
      : planes!.stackAlignment;
}

/// volumed planes composer
abstract class _PlanesComposerBase {
  final Coordinate volume;
  final int planesCount;
  final double apparentDeepRadian; // radian
  final double borderWidth;
  final double targetRotate; // radian
  final PlanesComposerTranslation targetTranslation;

  const _PlanesComposerBase({
    /// used for container
    required this.borderWidth,

    /// used for planes setup
    required this.volume,
    required this.planesCount,
    required this.apparentDeepRadian,

    /// used for target animation
    required this.targetRotate,
    required this.targetTranslation,
  });

  ///
  ///
  /// - [width]
  /// - [height]
  /// - [deep]
  /// - [_apparentHeight]
  /// - [_topPlaneDiagonal]
  /// - [_center]
  /// - [_containerWidth]
  /// - [_containerHeight]
  /// - [_container]
  /// - [_planesContainer]
  /// - [_planesSetup]
  /// - [_planesHost]
  ///
  ///
  double get width => volume.dx;

  double get height => volume.dy;

  double get deep => volume.dz;

  double get _apparentHeight => height * sin(apparentDeepRadian);

  double get _topPlaneDiagonal => sqrt(width * width + deep * deep);

  double get _center => sqrt(width * width + deep * deep + height * height) / 2;

  double get _containerWidth => max(width, deep);

  double get _containerHeight => max(height, deep);

  /// container
  Widget _container(Widget child) => borderWidth == 0
      ? SizedBox(width: _containerWidth, height: _containerHeight, child: child)
      : Container(
          width: _containerWidth + borderWidth * 2,
          height: _containerHeight + borderWidth * 2,
          decoration: BoxDecoration(border: Border.all(width: borderWidth)),
          child: child,
        );

  /// plane container
  Widget _planesContainer({
    required PlanesMotivation motivation,
    required AnimationControllerSetting setting,
    required Alignment alignment,
  }) =>
      _container(
        Planes(
          motivation: motivation,
          setting: setting,
          count: planesCount,
          stackAlignment: alignment,
          apparentDeep: apparentDeepRadian,
          volume: volume,
        ),
      );

  ///
  ///
  /// rotation usages:
  /// [_topPlaneDiagonalRotateStart]
  /// [_topPlaneDiagonalRotate]
  ///
  ///
  double get _topPlaneDiagonalRotate =>
      _topPlaneDiagonalRotateStart + targetRotate;

  double get _topPlaneDiagonalRotateStart {
    final tangent = deep / width;
    if (tangent == 1) {
      return kRadian45Angle;
    } else {
      final isOver45 = tangent > 1;

      double value;
      double radian = isOver45 ? kRadian45Angle : 0.0;
      final end = isOver45 ? kRadian90Angle : kRadian45Angle;
      while (radian <= end) {
        value = tangent - tan(radian);

        if (value > 1E-4) {
          radian += kRadian1Angle;
        } else if (value > 1E-1) {
          radian += kRadian01Angle;
        } else {
          break;
        }
      }
      return radian;
    }
  }

  ///
  ///
  /// translation usages:
  /// - [_targetTranslation]
  ///
  ///

  /// target translation
  Coordinate _targetTranslation(Alignment current) {
    late final _PlanesComposerTranslationManager translation;

    ///
    /// top left
    ///
    if (current == Alignment.topLeft) {
      translation = _PlanesComposerTranslationManager(
        category: targetTranslation,
        pair: kAlignmentTopLeftPairBottomRight,
        radianApparentDeep: apparentDeepRadian,
        radianDeltaTopPlaneDiagonal: _topPlaneDiagonalRotate + kRadian180Angle,
        lengthTopPlaneDiagonal: _topPlaneDiagonal,
        lengthCenter: _center,
        center: Coordinate(_containerWidth / 2, _containerHeight / 2, 0),
        corner: Coordinate(
          _containerWidth,
          _containerHeight - _apparentHeight,
          0,
        ),
        height: Coordinate.ofY(-_apparentHeight),
      );

      ///
      /// bottom right
      ///
    } else if (current == Alignment.bottomRight) {
      translation = _PlanesComposerTranslationManager(
        category: targetTranslation,
        pair: kAlignmentBottomRightPairTopLeft,
        radianApparentDeep: apparentDeepRadian,
        radianDeltaTopPlaneDiagonal: _topPlaneDiagonalRotate,
        lengthTopPlaneDiagonal: _topPlaneDiagonal,
        lengthCenter: _center,
        center: Coordinate(-_containerWidth / 2, -_containerHeight / 2, 0),
        corner: Coordinate(
          -_containerWidth,
          -_containerHeight + _apparentHeight,
          0,
        ),
        height: Coordinate.ofY(_apparentHeight),
      );
    } else {
      throw UnimplementedError();
    }
    return translation.value;
  }
}

/// translated planes composer data
class _PlanesComposerTranslationManager {
  final PlanesComposerTranslation category;
  final MapEntry<Alignment, Alignment> pair;
  final double radianApparentDeep;
  final double radianDeltaTopPlaneDiagonal;
  final double lengthTopPlaneDiagonal;
  final double lengthCenter;
  final Coordinate center;
  final Coordinate corner;
  final Coordinate height;

  const _PlanesComposerTranslationManager({
    required this.category,
    required this.pair,
    required this.radianApparentDeep,
    required this.radianDeltaTopPlaneDiagonal,
    required this.lengthTopPlaneDiagonal,
    required this.lengthCenter,
    required this.center,
    required this.corner,
    required this.height,
  });

  bool get isTopLeft => pair.key == Alignment.topLeft;

  Coordinate projectionOf(double distance) => Coordinate.fromDirection(
        radian: Coordinate.ofZ(radianDeltaTopPlaneDiagonal),
        distance: distance,
        yProportion: cos(radianApparentDeep),
      );

  Coordinate get value {
    switch (category) {

      ///
      /// align
      ///
      case PlanesComposerTranslation.aAlignB:
        return isTopLeft ? corner : Coordinate.zero;
      case PlanesComposerTranslation.bAlignA:
        return isTopLeft ? Coordinate.zero : corner;

      ///
      /// enclose
      ///
      case PlanesComposerTranslation.bEncloseA:
        return isTopLeft
            ? Coordinate.zero
            : corner + projectionOf(lengthTopPlaneDiagonal);

      case PlanesComposerTranslation.aEncloseB:
        return isTopLeft
            ? corner + projectionOf(lengthTopPlaneDiagonal)
            : Coordinate.zero;

      ///
      /// center
      ///
      case PlanesComposerTranslation.center:
        return center;

      case PlanesComposerTranslation.centerTouch:
        return center + projectionOf(lengthTopPlaneDiagonal) / 2;

      // stagger
      case PlanesComposerTranslation.centerStagger:
        return center + projectionOf(lengthTopPlaneDiagonal);

      // enclose
      case PlanesComposerTranslation.centerEncloseDistanceFar:
        return center + projectionOf(lengthCenter);

      case PlanesComposerTranslation.centerEncloseDistance:
        return center + projectionOf(lengthCenter) * 2;

      case PlanesComposerTranslation.centerEnclose:
        return center + (projectionOf(lengthTopPlaneDiagonal) + height) / 2;
    }
  }
}

/// planes composer command executor
class _PlanesComposerCommandExecutor {
  final TransformCategory category;
  final bool shouldAnimate;
  final bool haveAnimate;

  const _PlanesComposerCommandExecutor._({
    required this.category,
    required this.shouldAnimate,
    required this.haveAnimate,
  });

  static List<List<_PlanesComposerCommandExecutor>> fromSteps({
    required List<TransformCategory> categories,
    required List<Set<TransformCategory>> step,
    required List<Set<TransformCategory>> stepped,
  }) =>
      step.foldWith(
        [],
        stepped,
            (result, shouldStep, haveStepped) => result
          ..add(categories
              .map((category) => _PlanesComposerCommandExecutor._(
            category: category,
            shouldAnimate: shouldStep.contains(category),
            haveAnimate: haveStepped.contains(category),
          ))
              .toList(growable: false)),
      );
}

/// planes composer command, see [PlanesComposition.steps] or [_PlanesCompositionState._stepIndex] for detail.
class PlanesComposerCommand {
  final TransformCategory transformCategory;
  final int childIndex;

  const PlanesComposerCommand({
    required this.transformCategory,
    required this.childIndex,
  });
}

/// planes composer translation category
enum PlanesComposerTranslation {
  aAlignB,
  bAlignA,
  aEncloseB,
  bEncloseA,

  ///
  /// translate together
  ///
  center,
  centerTouch,
  centerStagger,
  centerEnclose,
  centerEncloseDistance,
  centerEncloseDistanceFar,
}

/// planes composer
class PlanesComposer extends _PlanesComposerBase {
  const PlanesComposer({
    required super.volume,
    required super.apparentDeepRadian,
    required super.targetRotate,
    required super.targetTranslation,
    super.planesCount = 3,
    super.borderWidth = 0.0,
  });

  Coordinate _translate({
    required bool? isForward,
    required bool toTarget,
    required Coordinate target,
  }) =>
      isForward == null
          ? Coordinate.zero
          : isForward
              ? toTarget
                  ? target
                  : Coordinate.zero
              : toTarget
                  ? Coordinate.zero
                  : target;

  double _rotate({
    required bool? isForward,
    required bool toTarget,
  }) =>
      isForward == null
          ? 0
          : isForward
              ? toTarget
                  ? targetRotate
                  : 0
              : toTarget
                  ? 0
                  : targetRotate;

  /// planes
  ///
  /// TODO: this method only accept 'forward' curve and 'forward' duration of [animationControllerSetting],
  ///
  List<Widget> _planes({
    required bool? animationIsForward,
    required AnimationControllerSetting animationControllerSetting,
    required List<Alignment> alignments,
    required List<List<_PlanesComposerCommandExecutor>> executorsList,
    required List<List<Widget>> children,
  }) {
    assert(
      alignments.length == executorsList.length &&
          alignments.length == children.length,
      'invalid length',
    );
    final result = <Widget>[];

    final childrenLength = alignments.length;
    for (var i = 0; i < childrenLength; i++) {
      final alignment = alignments[i];
      final command = executorsList[i];
      final commandT = command.translate;
      final commandR = command.rotate;

      final translation = _targetTranslation(alignment);
      result.add(
        _planesContainer(
          motivation: PlanesMotivation(
            host: TransformerHost.transformable(
              translating: Transformer.translate(
                tween: TweenConstant(
                  begin: _translate(
                    isForward: animationIsForward,
                    toTarget: commandT.haveAnimate,
                    target: translation,
                  ),
                  end: _translate(
                    isForward: animationIsForward,
                    toTarget: commandT.shouldAnimate,
                    target: translation,
                  ),
                ),
              ),
            ),
            planesRotateStart: _rotate(
              isForward: animationIsForward,
              toTarget: commandR.haveAnimate,
            ),
            planesRotateEnd: _rotate(
              isForward: animationIsForward,
              toTarget: commandR.shouldAnimate,
            ),
            children: children[i],
          ),
          setting: animationControllerSetting,
          alignment: alignment,
        ),
      );
    }
    return result;
  }
}

///
///
/// typedefs
///
///

/// generators
typedef PlaneGenerator = SizedBox Function(int indexOfPlanes);
typedef PlaneAlignmentGenerator = AlignmentGeometry Function(int indexOfPlanes);
typedef PlaneRotationRotatorGenerator = Coordinate Function(
  int indexOfPlanes,
  double radian,
);
typedef PlaneRotationGenerator = Transformer Function(
  int indexOfPlanes,
  double radianStart,
  double radianEnd,
);

typedef PlaneTransformerGenerator = Transformer Function(int indexOfPlanes);
typedef PlaneTransformerHostGenerator = TransformerHost Function(
  int indexOfPlanes,
  PlaneAlignmentGenerator alignments,
  PlaneRotationGenerator rotating,
);

typedef PlanesComposerCombiner = Combiner<PlanesComposerCommand>;

///
///
/// extensions
///
///

/// planes composer combination extension
extension PlanesComposerCommandExtension on PlanesComposerCommand {
  static const Set<PlanesComposerCommand> valuesSet = {
    PlanesComposerCommand(
      transformCategory: TransformCategory.rotate,
      childIndex: 0,
    ),
    PlanesComposerCommand(
      transformCategory: TransformCategory.rotate,
      childIndex: 1,
    ),
    PlanesComposerCommand(
      transformCategory: TransformCategory.translate,
      childIndex: 0,
    ),
    PlanesComposerCommand(
      transformCategory: TransformCategory.translate,
      childIndex: 1,
    ),
  };
}

/// planes composer executor list extension
extension _PlanesComposerExecutorListExtension
    on List<_PlanesComposerCommandExecutor> {
  _PlanesComposerCommandExecutor get translate => firstWhere(
        (element) => element.category == TransformCategory.translate,
      );

  _PlanesComposerCommandExecutor get rotate => firstWhere(
        (element) => element.category == TransformCategory.rotate,
      );

  // _PlanesComposerCommandExecutor get scale => firstWhere(
  //       (element) => element.category == TransformCategory.scale,
  //     );
}
