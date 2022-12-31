part of compose;

class PenPesPractice extends StatefulWidget {
  const PenPesPractice({Key? key}) : super(key: key);

  @override
  State<PenPesPractice> createState() => _PenPesPracticeState();
}

class _PenPesPracticeState extends State<PenPesPractice> {
  final Map<int, GlobalKey> _itemMap = <int, GlobalKey>{};
  late Paper? _paper;

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      _itemMap.putIfAbsent(i, () => GlobalKey());
    }
    _paper = null;

    super.initState();
  }

  void _itemOnTap(int index, GlobalKey key) {
    final renderBox = key.currentContext!.renderBox;
    _paper = Paper(
      itemZeroOffset: renderBox.localToGlobal(Offset.zero).toCoordinate,
      itemSize: renderBox.size,
      itemIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PenPaper(
      pesItem: _paper,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: kEdgeInsets320,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => Material(
                key: _itemMap[index],
                child: InkWell(
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: kEdgeInsets200,
                    decoration: const BoxDecoration(color: Colors.blueGrey),
                  ),
                  onTap: () => setState(
                    () => _itemOnTap(
                      index,
                      _itemMap[index]!,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
