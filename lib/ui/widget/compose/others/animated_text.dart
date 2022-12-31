part of compose;

class AnimatedTextTyping extends StatefulWidget {
  const AnimatedTextTyping({
    super.key,
    required this.height,
    required this.width,
    required this.text,
  });

  final double height;
  final double width;
  final String text;

  @override
  State<AnimatedTextTyping> createState() => _AnimatedTextTypingState();
}

class _AnimatedTextTypingState extends State<AnimatedTextTyping> {
  late String _oldText;
  late String _newText;

  bool get _enableAnimation => _oldText != _newText;
  bool _enableTextA = false;

  bool get _enableTextB => !_enableTextA;

  @override
  void initState() {
    _oldText = '';
    _newText = widget.text;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedTextTyping oldWidget) {
    final oldText = oldWidget.text;
    final newText = widget.text;
    if (oldText != newText) {
      _oldText = oldText;
      _newText = newText;
      _enableTextA = !_enableTextA;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          _getAnimatedTextWithEnable(_enableAnimation && _enableTextA),
          _getAnimatedTextWithEnable(_enableAnimation && _enableTextB),
        ],
      ),
    );
  }

  Widget _getAnimatedTextWithEnable(bool enable) => Center(
        child: AnimatedOpacity(
          opacity: enable ? 1.0 : 0.0,
          duration: kDurationMilli300,
          child:
          // enable
          //     ? AnimatedTextKit(
          //         totalRepeatCount: 1,
          //         animatedTexts: [
          //           TyperAnimatedText(_newText, speed: kDurationMilli300),
                    // ColorizeAnimatedText(_title, textStyle: const TextStyle(fontSize: 24), colors: [Colors.white, Colors.blue]),
                    // FadeAnimatedText(_title),
                    // FlickerAnimatedText(_title),
                    // RotateAnimatedText(_title),
                    // ScaleAnimatedText(_title),
                    // TypewriterAnimatedText(_title),
                    // WavyAnimatedText(_title),
                  // ],
                // )
              // :
            Text(_oldText),
        ),
      );
}
