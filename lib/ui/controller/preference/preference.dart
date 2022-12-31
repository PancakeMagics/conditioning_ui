part of controller;

class Preference extends StatefulWidget {
  const Preference({
    Key? key,
    this.theme,
    this.appColor,
    this.animations,
    required this.child,
  }) : super(key: key);
  final ThemeData? theme;
  final MainColor? appColor;
  final PreferAnimations? animations;
  final Widget child;

  @override
  State<Preference> createState() => PreferenceState();

  static PreferenceState of(BuildContext context) =>
      context.findAncestorStateOfType<PreferenceState>()!;
}

class PreferenceState extends State<Preference> {
  ThemeData? _theme;
  late MainColor _appColor;

  set setTheme(ThemeData data) => setState(() => _theme = data);

  // set setAppColor(MainColor mainColor) => setState(() => _appColor = mainColor); // setState won't update
  set setAppColor(MainColor mainColor) => _appColor = mainColor;

  ThemeData? get theme => _theme;
  MainColor get appColor => _appColor;


  final Map<PreferAnimationPlacement, PreferAnimation> animations = {};

  @override
  void initState() {
    _update(super.initState);
  }

  @override
  void didUpdateWidget(covariant Preference oldWidget) =>
      _update(() => super.didUpdateWidget(oldWidget));

  void _update(void Function() doneUpdate) {
    _theme = widget.theme;
    _appColor = widget.appColor ?? MainColor.blue;
    // final a = widget.animations;
    // animations.addAll(Map.fromEntries(
    //   PreferAnimationPlacement.values.map(
    //     (type) => MapEntry(type, a[type] ?? type.defaultPreference),
    //   ),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
