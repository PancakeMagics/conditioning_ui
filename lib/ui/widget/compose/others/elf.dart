part of compose;

///
/// an happy small little [Elf] live in the environment, it interact and provide some functions for user to do somethings.
///
/// TODO: think of elf settings, elf function
class Elf extends StatefulWidget {
  const Elf({
    super.key,
    required this.environment,
  });

  final Widget environment;

  @override
  State<Elf> createState() => _ElfState();
}

class _ElfState extends State<Elf> {
  final _key = GlobalKey();
  late Positioned _position;

  @override
  void initState() {
    super.initState();
    _position = Positioned.fromRect(
      rect: Offset.zero & const Size(100, 100),
      child: Container(),
    );
  }

  void _elfOnTap() {
    setState(() {
      final renderBox = _key.currentContext!.renderBox;
      // _position = Position.rect(Offset.zero & renderBox.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColor = context.preference.appColor;
    return Stack(
      children: [
        widget.environment,
        CustomAnimatedPositioned(
          key: _key,
          position: _position,
          child: InkWell(
            onTap: _elfOnTap,
            child: Card(
              color: appColor.colorD2,
              child: kSizeWH50.toSizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
