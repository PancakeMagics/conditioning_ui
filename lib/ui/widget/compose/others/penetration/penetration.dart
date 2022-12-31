part of compose;

class Penetration extends StatefulWidget {
  const Penetration({Key? key}) : super(key: key);

  @override
  State<Penetration> createState() => _PenetrationState();
}

class _PenetrationState extends State<Penetration> {
  bool _enableSpotlight = false;
  Offset _spotlightCenter = const Offset(0.0, 0.0);
  double _spotlightRadius = 0.0;

  final GlobalKey _button1Key = GlobalKey();
  final GlobalKey _button2Key = GlobalKey();
  final GlobalKey _button3Key = GlobalKey();

  void _requireSpotlight(GlobalKey key) {
    if (_enableSpotlight) {
      _enableSpotlight = false;
    } else {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final radius = size.height >= size.width ? size.height : size.width;
      final cornerOffset = renderBox.localToGlobal(Offset.zero);
      _spotlightCenter = size.center(cornerOffset);
      _spotlightRadius = radius;
      _enableSpotlight = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PenetrationClip(
      enabled: _enableSpotlight,
      center: _spotlightCenter,
      radius: _spotlightRadius,
      unFocusedAreaOnTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text('spotlight circle')],
          ),
          duration: const Duration(milliseconds: 400),
        ));
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: _button1Key,
                  onPressed: () =>
                      setState(() => _requireSpotlight(_button1Key)),
                  icon: const Icon(Icons.confirmation_num_outlined),
                ),
                IconButton(
                  key: _button2Key,
                  onPressed: () =>
                      setState(() => _requireSpotlight(_button2Key)),
                  icon: const Icon(Icons.baby_changing_station),
                ),
                IconButton(
                  key: _button3Key,
                  onPressed: () =>
                      setState(() => _requireSpotlight(_button3Key)),
                  icon: const Icon(Icons.confirmation_number_sharp),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // _spotlight = !_spotlight;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
