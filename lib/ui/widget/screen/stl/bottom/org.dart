part of widget;

class ScreenOrg extends StatelessWidget {
  const ScreenOrg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('org'),
        backgroundColor: context.preference.appColor.colorD3,
        elevation: 10.0,
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
