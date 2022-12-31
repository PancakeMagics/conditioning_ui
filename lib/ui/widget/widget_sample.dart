part of widget;

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> with SingleTickerProviderStateMixin {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final appColor = context.preference.appColor;
    return Material(
      color: Colors.brown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            shape: kBorderCircle,
            child: InkWell(
              splashColor: appColor.colorD2,
              onTap: () async {
                final overlay = context.overlay;

                const duration = kDurationMilli467;

                final entry = CustomOverlayEntry(
                  builder: (context) => PlanesShelf(
                    toggle: toggle,
                    volume: CoordinateConstants.volumeX100y100z150,
                    apparentDeep: kRadian50Angle,
                    targetRotate: kRadian30Angle,
                    combiner: PlanesComposerCommandCombinations.in3_1A_2BT_3BR,
                    setting: (updater) => AnimationControllerSetting.curved(
                      curveForward: Curves.fastOutSlowIn,
                      curveReverse: Curves.fastOutSlowIn,
                      forward: duration,
                      updater: updater,
                    ),
                  ),
                );

                if (overlay.hasEntry) {
                  toggle = !toggle;
                  overlay.update(entry);
                } else {
                  overlay.insert(entry);
                }
              },
              child: const Padding(
                padding: kEdgeInsets100,
                child: Icon(Icons.add),
              ),
            ),
          ),
          kSizedBoxH100,
        ],
      ),
    );
  }
}
