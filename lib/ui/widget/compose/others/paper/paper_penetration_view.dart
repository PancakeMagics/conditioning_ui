part of compose;

class PenPaperView extends StatefulWidget {
  const PenPaperView({Key? key}) : super(key: key);

  @override
  State<PenPaperView> createState() => _PenPaperViewState();
}

class _PenPaperViewState extends State<PenPaperView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Text('wow $index');
        },
      ),
    );
  }
}
