part of widget;

///
///
/// this file contains:
/// 1. [ScreenData]
/// 2. [ScreenController]
/// 3. [NavigatorExtension]
/// 4. [RouteSettingsExtension]
/// ...
///
///

/// screen settings
mixin ScreenData {
  /// property:
  /// - [widget]
  /// - [graphPosition], [parseGraphPosition]
  /// ...

  Widget get widget {
    final screen = this as Screen;
    switch (screen) {
      case Screen.chatroom:
        return const ScreenChatroom();
      case Screen.documention:
        return const ScreenDocumention();
      case Screen.org:
        return const ScreenOrg();
      default:
        throw UnimplementedError();
    }
  }

  /// graph position
  Coordinate get graphPosition {
    final page = this as Screen;
    switch (page) {
      case Screen.login:
      case Screen.map:
      case Screen.treasure:
        throw ScreenNotInGraphException();

      // bottom pages
      case Screen.chatroom:
      // return const Offset(0, 2);
      case Screen.org:
      // return const Offset(1, 2);
      case Screen.documention:
      // return const Offset(2, 2);

      // center pages
      case Screen.studyGram:
      // return const Offset(0, 1);
      case Screen.medium:
      // return const Offset(1, 1);
      case Screen.myWay:
      // return const Offset(2, 1);

      // top pages
      case Screen.meetup:
      // return const Offset(0, 0);
      case Screen.schedule:
      // return const Offset(1, 0);
      case Screen.now:
      // return const Offset(2, 0);

      default:
        throw UnimplementedError();
    }
  }

  static ScreenData parseGraphPosition(Coordinate position) {
    for (var page in Screen.values) {
      try {
        if (page.graphPosition == position) {
          return page;
        } else {
          continue;
        }
      } catch (e) {
        if (e is ScreenNotInGraphException) {
          continue;
        } else {
          rethrow;
        }
      }
    }
    throw ScreenNotFoundError('no layout match position: $position');
  }
}

/// screen controller
class ScreenController {
  Screen? from;
  Screen? target;

  ScreenController._(this.from, this.target);

  static final ScreenController _instance = ScreenController._(null, null);

  /// update controller when [NavigatorState] push or pop
  factory ScreenController(RouteSettings settings) {
    final Screen target;
    final Screen? from;
    try {
      target = Screen.values.firstWhere((s) => s.name == settings.name);
      from = settings.arguments as Screen?;
    } catch (_) {
      throw ScreenNotFoundError('$settings');
    }
    return _instance
      ..target = target
      ..from = from;
  }

  Tween<Offset> get targetSlideInTween {
    final tween = Tween(end: Offset.zero);
    if (from == null) {
      return tween..begin = const Offset(0, -1);
    } else {
      switch (from!) {
        case Screen.chatroom:
          if (target == Screen.documention) {
            return tween..begin = const Offset(1, 0);
          } else if (target == Screen.org) {
            return tween..begin = const Offset(-1, 0);
          }
          throw UnimplementedError();

        case Screen.org:
          if (target == Screen.chatroom) {
            return tween..begin = const Offset(1, 0);
            // } else if (to == Screen.documention) {
            //   return tween..begin = const Offset(-1, 0);
          }
          throw UnimplementedError();

        case Screen.documention:
          if (target == Screen.chatroom) {
            return tween..begin = const Offset(-1, 0);
            // } else if (to == Screen.org) {
            //   return tween..begin = const Offset(-1, 0);
          }
          throw UnimplementedError();
        default:
          throw UnimplementedError();
      }
    }
  }

  Tween<Offset> get fromSlideOutTween => targetSlideInTween.push;

  @override
  String toString() => 'ScreenController: ($from => $target)';
}

/// navigator extension
extension NavigatorExtension on NavigatorState {
  Future<T?> navigate<T extends Object?>({
    required Screen from,
    required Screen to,
  }) =>
      pushNamed<T>(to.name, arguments: from);
}

/// route settings extension
extension RouteSettingsExtension on RouteSettings {
  PageRouteBuilder get toPageRouteBuilder {
    final controller = ScreenController(this);
    final currentScreen = controller.target!;

    Tween<Offset> tween = controller.targetSlideInTween;

    void slideOutListener(AnimationStatus status) =>
        status == AnimationStatus.forward
            ? tween = controller.fromSlideOutTween
            : null;

    return PageRouteBuilder<void>(
      pageBuilder: (context, a1, a2) {
        a2.addStatusListener(slideOutListener);
        return currentScreen.widget;
      },
      transitionsBuilder: (context, a1, a2, child) => SlideTransition(
        position: tween.animate(currentScreen == controller.target ? a1 : a2),
        child: child,
      ),
    );
  }
}
