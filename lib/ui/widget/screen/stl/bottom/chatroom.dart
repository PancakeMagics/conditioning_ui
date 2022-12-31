part of widget;

class ScreenChatroom extends StatelessWidget {
  const ScreenChatroom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chat room'),
        // backgroundColor: context.preference.appColor.colorD3,
        elevation: 10.0,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => context.navigator.navigate(
                    from: Screen.chatroom,
                    to: Screen.documention,
                  ),
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => context.navigator.navigate(
                    from: Screen.chatroom,
                    to: Screen.org,
                  ),
                  child: const Icon(Icons.slideshow),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                // ElevatedButton(
                //   onPressed: () => context.app.theme = ThemeData(
                //     appBarTheme: AppBarTheme(
                //       backgroundColor: PreferColorDefaultData.randomMainColor.colorD2,
                //     ),
                //   ),
                //   child: const Icon(Icons.change_circle),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
