part of widget;

class ScreenDocumention extends StatelessWidget {
  const ScreenDocumention({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('documention'),
        backgroundColor: context.preference.appColor.colorD3,
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
