part of material;

///
///
/// this file contains:
/// - [LeaderBuilder]
/// - [FollowerBuilder]
/// - [LeaderShip] (follower controller)
///
///
///

/// leader
class Leader {
  final Key? key;
  final LayerLink link;
  final Widget child;

  const Leader({
    this.key,
    required this.link,
    required this.child,
  });

  CompositedTransformTarget get toCompositedTransformTarget =>
      CompositedTransformTarget(
        key: key,
        link: link,
        child: child,
      );
}

/// follower state
enum FollowerState {
  join,
  leave,
}

/// follower
class Follower {
  final Key? key;
  final LayerLink link;
  final FollowerState state;
  final bool showDespiteUnlink;
  final Offset leaderOffset;
  final Alignment anchorOnLeader;
  final Alignment anchorOnFollower;
  final Widget child;

  CustomOverlayEntry? overlayEntryController;

  Follower({
    this.key,
    required this.link,
    required this.leaderOffset,
    required this.child,
    this.state = FollowerState.join,
    this.anchorOnLeader = Alignment.topLeft,
    this.anchorOnFollower = Alignment.topLeft,
    this.showDespiteUnlink = false,
  });

  CompositedTransformFollower get toCompositedTransformFollower =>
      CompositedTransformFollower(
        key: key,
        link: link,
        showWhenUnlinked: showDespiteUnlink,
        targetAnchor: anchorOnLeader,
        followerAnchor: anchorOnFollower,
        offset: leaderOffset,
        child: child,
      );

  CustomOverlayEntry getOverlayEntryController(BuildContext leaderContext) {
    overlayEntryController = CustomOverlayEntry(
      builder: (context) => toCompositedTransformFollower,
      centerSized: leaderContext.renderBox.size,
    );
    return overlayEntryController!;
  }
}

/// follower controller
class LeaderShip extends StatefulWidget {
  const LeaderShip({
    super.key,
    required this.leaderBuilder,
    required this.followerStream,
    this.followOnOverlay = true,
  });

  final LeaderBuilder leaderBuilder;
  final Stream<FollowerBuilder> followerStream;
  final bool followOnOverlay;

  @override
  State<LeaderShip> createState() => _LeaderShipState();
}

class _LeaderShipState extends State<LeaderShip> {
  final LayerLink _layerLink = LayerLink();

  StreamSubscription<FollowerBuilder>? _followerSubscription;

  @override
  void didUpdateWidget(covariant LeaderShip oldWidget) {
    _followerSubscription?.cancel();
    _followerSubscription = widget.followerStream.listen((builder) {
      final follower = builder(_layerLink);
      final overlay = context.overlay;

      final state = follower.state;
      switch (state) {
        case FollowerState.join:
          overlay.insert(follower.getOverlayEntryController(context));
          break;
        case FollowerState.leave:
          overlay.remove(follower.overlayEntryController);
          break;
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) =>
      widget.leaderBuilder(_layerLink).toCompositedTransformTarget;
}

///
///
/// typedef
///
///

typedef LeaderBuilder = Leader Function(LayerLink link);
typedef FollowerBuilder = Follower Function(LayerLink link);