part of constants;

///
///
///
///
///
///
///
/// this files contains the constants of:
///   - radian, see [kRadian1Round]
///   - [EdgeInsets], see [kEdgeInsetsNone]
///   - [Offset], see [kCoordinateCenter]
///   - [Border], see [kBorderCircle]
///   - [ProgressIndicator], see [kCircularProgressIndicator]
///   - [SizedBox], see [kSizedBox]
///   - [GridPaper], see [kGridPaper]
///   - [InputDecoration], see [kDecorationInput]
///   - [BoxDecoration], see [kDecorationBox]
///
///
/// - extensions
///   - [PaintBuilderConstants]
///   - [CoordinateConstants]
///
///
///
///
///
///
///
///
///
///
///
///

/// radian
const double kRadian450Angle = pi * 2 + kRadian90Angle;
const double kRadian1Round = pi * 2;
const double kRadian270Angle = kRadian180Angle + kRadian90Angle;
const double kRadian180Angle = pi;
const double kRadian135Angle = pi - kRadian45Angle;
const double kRadian120Angle = pi - kRadian60Angle;
const double kRadian90Angle = pi / 2;
const double kRadian85Angle = kRadian90Angle - kRadian5Angle;
const double kRadian80Angle = kRadian90Angle - kRadian10Angle;
const double kRadian75Angle = kRadian60Angle + kRadian15Angle;
const double kRadian70Angle = kRadian60Angle + kRadian10Angle;
const double kRadian60Angle = pi / 3;
const double kRadian50Angle = kRadian60Angle - kRadian10Angle;
const double kRadian45Angle = pi / 4;
const double kRadian40Angle = kRadian20Angle + kRadian20Angle;
const double kRadian30Angle = pi / 6;
const double kRadian20Angle = pi / 9;
const double kRadian15Angle = pi / 12;
const double kRadian10Angle = pi / 18;
const double kRadian5Angle = pi / 36;
const double kRadian1Angle = pi / 180;
const double kRadian01Angle = kRadian1Angle / 10;
const double kRadian001Angle = kRadian1Angle / 100;

/// edge insets
const EdgeInsets kEdgeInsetsNone = EdgeInsets.all(0);
const EdgeInsets kEdgeInsets100 = EdgeInsets.all(10.0);
const EdgeInsets kEdgeInsets200 = EdgeInsets.all(20.0);
const EdgeInsets kEdgeInsetsK01 = EdgeInsets.all(100.0);
const EdgeInsets kEdgeInsetsK05 = EdgeInsets.all(500.0);
const EdgeInsets kEdgeInsets040 = EdgeInsets.all(4.0);
const EdgeInsets kEdgeInsets160 = EdgeInsets.all(16.0);
const EdgeInsets kEdgeInsets320 = EdgeInsets.all(32.0);
const EdgeInsets kEdgeInsets360 = EdgeInsets.all(36.0);
const EdgeInsets kEdgeInsetsBottom020 = EdgeInsets.all(2.0);

/// coordinate
const Coordinate kCoordinateCenter = Coordinate.d2(0, 0);
const Coordinate kCoordinateTop = Coordinate.d2(0, -1);
const Coordinate kCoordinateLeft = Coordinate.d2(-1, 0);
const Coordinate kCoordinateBottom = Coordinate.d2(0, 1);
const Coordinate kCoordinateRight = Coordinate.d2(1, 0);
const Coordinate kCoordinateTopLeft = Coordinate.d2(-1, -1);
const Coordinate kCoordinateTopRight = Coordinate.d2(1, -1);
const Coordinate kCoordinateBottomLeft = Coordinate.d2(-1, 1);
const Coordinate kCoordinateBottomRight = Coordinate.d2(1, 1);
const Coordinate kCoordinate100BottomRight = Coordinate.d2(100, 100);
const Coordinate kCoordinate100TopLeft = Coordinate.d2(-100, -100);

/// offset, coordinate for scaling
const Offset kOffsetScale1 = Offset(1, 1);
const Offset kOffsetScale2 = Offset(2, 2);
const Offset kOffsetScale3 = Offset(3, 3);
const Offset kOffsetScale5 = Offset(5, 5);
const Offset kOffsetScale10 = Offset(10, 10);

/// border
const CircleBorder kBorderCircle = CircleBorder();
final BorderRadius kBorderRadius8 = BorderRadius.circular(8.0);
final BorderRadius kBorderRadius10 = BorderRadius.circular(10.0);
final BorderRadius kBorderRadius16 = BorderRadius.circular(16.0);

const double kBorderWidth1 = 1.0;
const double kBorderWidth2 = 2.0;
const Border kBorderBoxCenter3 = Border.fromBorderSide(
  BorderSide(
    width: 3.0,
    strokeAlign: StrokeAlign.center,
  ),
);

/// progress indicator
const CircularProgressIndicator kCircularProgressIndicator =
    CircularProgressIndicator();
const LinearProgressIndicator kLinearProgressIndicator =
    LinearProgressIndicator();
const RefreshProgressIndicator kRefreshProgressIndicator =
    RefreshProgressIndicator();

/// size
const Size kSizeWH10 = Size(10, 10);
const Size kSizeWH50 = Size(50, 50);
const Size kSizeWH100 = Size(100, 100);
const Size kSizeWH200 = Size(200, 200);
const Size kSizeWH300 = Size(300, 300);

/// sized box
const SizedBox kSizedBox = SizedBox();
const SizedBox kSizedBoxH10 = SizedBox(height: 10);
const SizedBox kSizedBoxH20 = SizedBox(height: 20);
const SizedBox kSizedBoxH100 = SizedBox(height: 100);

/// container
final Expanded kExpandedContainer = Expanded(child: Container());

final Container kContainerWH100Red = Container(
  width: 100,
  height: 100,
  color: Colors.red,
);

final Container kContainerWH100Yellow = Container(
  width: 100,
  height: 100,
  color: Colors.yellow,
);

final Container kContainerWH300Blue = Container(
  width: 300,
  height: 300,
  color: Colors.blueAccent,
);

final Container kContainerWH300Green = Container(
  width: 300,
  height: 300,
  color: Colors.green,
);

/// grid paper
const GridPaper kGridPaper = GridPaper();
const GridPaper kGridPaperSimple = GridPaper(
  color: Colors.white,
  interval: 100,
  subdivisions: 1,
);

const List<GridPaper> kListGridPaperSimple = [
  kGridPaperSimple,
  kGridPaperSimple,
  kGridPaperSimple,
];

const List<List<GridPaper>> kListListGridPaperSimple = [
  [kGridPaperSimple, kGridPaperSimple, kGridPaperSimple,],
  [kGridPaperSimple, kGridPaperSimple, kGridPaperSimple,]
];

/// input decoration
const InputDecoration kDecorationInput =
    InputDecoration.collapsed(hintText: '');

/// box decoration
/// - 1 shadow see [kDecorationBoxShadow1Of1]
/// - 2 shadow see [kDecorationBoxShadow2Of1]
///
const BoxDecoration kDecorationBox = BoxDecoration();
final BoxDecoration kDecorationBoxBorder = BoxDecoration(
  border: Border.all(
      color: Colors
          .black), // the border width in container will reduce the size of child
);

/// box decoration --- 1 shadow
const BoxDecoration kDecorationBoxShadow1Of1 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 15.0,
      spreadRadius: 25.0,
      offset: Offset(2.0, 2.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of2 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 60.0,
      spreadRadius: 40.0,
      offset: Offset(0, -5.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of3 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      spreadRadius: 10.0,
      offset: Offset.zero,
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of4 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 10.0,
      spreadRadius: -25.0,
      offset: Offset(0, 1.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of5 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 20.0,
      spreadRadius: 10.0,
      offset: Offset(0, 6.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of6 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 6.0,
      spreadRadius: 15.0,
      offset: Offset(3.0, 3.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of7 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 8.0,
      spreadRadius: 0.0,
      offset: Offset(80.0, -5.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of8 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 0.0,
      spreadRadius: 12.0,
      offset: Offset(2.0, 0.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of9 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 0.0,
      spreadRadius: 3.0,
      offset: Offset(-12.0, -16.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of10 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black,
      blurRadius: 40.0,
      blurStyle: BlurStyle.outer,
      spreadRadius: 40.0,
      offset: Offset(2.0, 5.0),
    )
  ],
);

///
///
///
/// 11 - 20 (grey)
///
///
///

const BoxDecoration kDecorationBoxShadow1Of11 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 1.0,
      spreadRadius: 12.0,
      offset: Offset(0, 1.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of12 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 10.0,
      spreadRadius: 0.0,
      offset: Offset(2.0, 6.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of13 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 10.0,
      offset: Offset(0, 3.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of14 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 20.0,
      spreadRadius: 10.0,
      offset: Offset(4.0, 30.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of15 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      blurStyle: BlurStyle.outer,
      spreadRadius: 10.0,
      offset: Offset.zero,
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of16 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 10.0,
      offset: Offset(30, 15.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of17 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.orange,
      blurRadius: 20.0,
      spreadRadius: 2.0,
      offset: Offset(0, 0.0),
    )
  ],
);
const BoxDecoration kDecorationBoxShadow1Of18 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 8.0,
      offset: Offset(5.0, 20.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of19 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 5.0,
      offset: Offset(10.0, 0.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of20 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.grey,
      blurRadius: 1.0,
      spreadRadius: -10.0,
      offset: Offset(35.0, -8.0),
    )
  ],
);

const BoxDecoration kDecorationBoxShadow1Of21 = BoxDecoration(
  border: Border(),
  boxShadow: <BoxShadow>[
    BoxShadow(
      blurRadius: 16.0,
      spreadRadius: 3.0,
    ),
  ],
);

/// box decoration --- 2 shadow
const BoxDecoration kDecorationBoxShadow2Of1 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      blurRadius: 1.0,
      spreadRadius: 1.0,
      color: Colors.brown,
    ),
    BoxShadow(
      blurRadius: 1.0,
      spreadRadius: 10.0,
      blurStyle: BlurStyle.outer,
      color: Colors.black,
    ),
  ],
);
const BoxDecoration kDecorationBoxShadow2Of2 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      blurRadius: 5.0,
      spreadRadius: 5.0,
      color: Colors.blueGrey,
    ),
    BoxShadow(
      blurRadius: 10.0,
      spreadRadius: 10.0,
      blurStyle: BlurStyle.outer,
      color: Colors.black,
    ),
  ],
);

const BoxDecoration kDecorationBoxShadow2Of3 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      offset: kCoordinateRight,
      blurRadius: 5.0,
      spreadRadius: 10.0,
      color: Colors.indigo,
    ),
    BoxShadow(
      offset: kCoordinateBottomRight,
      blurRadius: 10.0,
      spreadRadius: 20.0,
      blurStyle: BlurStyle.outer,
      color: Colors.grey,
    ),
  ],
);

const BoxDecoration kDecorationBoxShadow2Of4 = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      offset: kCoordinateLeft,
      blurRadius: 1.0,
      spreadRadius: 1.0,
      color: Colors.teal,
    ),
    BoxShadow(
      offset: kCoordinateBottomLeft,
      blurRadius: 1.0,
      spreadRadius: 1.0,
      blurStyle: BlurStyle.outer,
      color: Colors.deepPurple,
    ),
  ],
);

/// paint builder constants
extension PaintBuilderConstants on Paint {
  PaintBuilder builder({
    Color color = Colors.transparent,
    bool isAntialias = true,
    PaintingStyle style = PaintingStyle.fill,
  }) =>
      () => this
        ..color = color
        ..isAntiAlias = isAntialias
        ..style = style;
}

extension CoordinateConstants on Coordinate {
  ///
  /// radian
  ///
  static const Coordinate xAxis450Angle = Coordinate(kRadian450Angle, 0, 0);
  static const Coordinate xAxis1RoundRadian = Coordinate(kRadian1Round, 0, 0);
  static const Coordinate xAxisHalfRound = Coordinate(kRadian180Angle, 0, 0);
  static const Coordinate xAxis90Angle = Coordinate(kRadian90Angle, 0, 0);
  static const Coordinate xAxis80Angle = Coordinate(kRadian80Angle, 0, 0);
  static const Coordinate xAxis70Angle = Coordinate(kRadian70Angle, 0, 0);
  static const Coordinate xAxis60Angle = Coordinate(kRadian60Angle, 0, 0);
  static const Coordinate xAxis50Angle = Coordinate(kRadian50Angle, 0, 0);
  static const Coordinate xAxis45Angle = Coordinate(kRadian45Angle, 0, 0);
  static const Coordinate xAxis40Angle = Coordinate(kRadian40Angle, 0, 0);
  static const Coordinate xAxis30Angle = Coordinate(kRadian30Angle, 0, 0);
  static const Coordinate xAxis20Angle = Coordinate(kRadian20Angle, 0, 0);
  static const Coordinate xAxis10Angle = Coordinate(kRadian10Angle, 0, 0);

  static const Coordinate yAxis450Angle = Coordinate(0, kRadian450Angle, 0);
  static const Coordinate yAxis1RoundRadian = Coordinate(0, kRadian1Round, 0);
  static const Coordinate yAxisHalfRound = Coordinate(0, kRadian180Angle, 0);
  static const Coordinate yAxis90Angle = Coordinate(0, kRadian90Angle, 0);
  static const Coordinate yAxis80Angle = Coordinate(0, kRadian80Angle, 0);
  static const Coordinate yAxis70Angle = Coordinate(0, kRadian70Angle, 0);
  static const Coordinate yAxis60Angle = Coordinate(0, kRadian60Angle, 0);
  static const Coordinate yAxis50Angle = Coordinate(0, kRadian50Angle, 0);
  static const Coordinate yAxis45Angle = Coordinate(0, kRadian45Angle, 0);
  static const Coordinate yAxis40Angle = Coordinate(0, kRadian40Angle, 0);
  static const Coordinate yAxis30Angle = Coordinate(0, kRadian30Angle, 0);
  static const Coordinate yAxis20Angle = Coordinate(0, kRadian20Angle, 0);
  static const Coordinate yAxis10Angle = Coordinate(0, kRadian10Angle, 0);

  static const Coordinate zAxis450Angle = Coordinate(0, 0, kRadian450Angle);
  static const Coordinate zAxis1RoundRadian = Coordinate(0, 0, kRadian1Round);
  static const Coordinate zAxisHalfRound = Coordinate(0, 0, kRadian180Angle);
  static const Coordinate zAxis90Angle = Coordinate(0, 0, kRadian90Angle);
  static const Coordinate zAxis80Angle = Coordinate(0, 0, kRadian80Angle);
  static const Coordinate zAxis70Angle = Coordinate(0, 0, kRadian70Angle);
  static const Coordinate zAxis60Angle = Coordinate(0, 0, kRadian60Angle);
  static const Coordinate zAxis50Angle = Coordinate(0, 0, kRadian50Angle);
  static const Coordinate zAxis45Angle = Coordinate(0, 0, kRadian45Angle);
  static const Coordinate zAxis40Angle = Coordinate(0, 0, kRadian40Angle);
  static const Coordinate zAxis30Angle = Coordinate(0, 0, kRadian30Angle);
  static const Coordinate zAxis20Angle = Coordinate(0, 0, kRadian20Angle);
  static const Coordinate zAxis10Angle = Coordinate(0, 0, kRadian10Angle);

  ///
  /// scale
  ///
  static const Coordinate scale1 = Coordinate.scale(1);
  static const Coordinate scale2 = Coordinate.scale(2);
  static const Coordinate scale3 = Coordinate.scale(3);
  static const Coordinate scale5 = Coordinate.scale(5);
  static const Coordinate scale10 = Coordinate.scale(10);
  static const Coordinate scale50 = Coordinate.scale(100);
  static const Coordinate scale100 = Coordinate.scale(100);
  static const Coordinate scale300 = Coordinate.scale(300);
  static const Coordinate scale500 = Coordinate.scale(500);

  ///
  /// volume
  ///
  static const Coordinate volumeX100y100z100 = Coordinate(100, 100, 100);
  static const Coordinate volumeX150y100z100 = Coordinate(150, 100, 100);
  static const Coordinate volumeX100y150z100 = Coordinate(100, 150, 100);
  static const Coordinate volumeX100y100z150 = Coordinate(100, 100, 150);
  static const Coordinate volumeX100y150z150 = Coordinate(100, 150, 150);
  static const Coordinate volumeX150y100z150 = Coordinate(150, 100, 150);
  static const Coordinate volumeX150y150z100 = Coordinate(150, 150, 100);
  static const Coordinate volumeX150y150z150 = Coordinate(150, 150, 150);
  static const Coordinate volumeX200y100z100 = Coordinate(200, 100, 100);
  static const Coordinate volumeX100y200z100 = Coordinate(100, 200, 100);
  static const Coordinate volumeX100y100z200 = Coordinate(100, 100, 200);
  static const Coordinate volumeX100y200z200 = Coordinate(100, 200, 200);
  static const Coordinate volumeX200y100z200 = Coordinate(200, 100, 200);
  static const Coordinate volumeX200y200z100 = Coordinate(200, 200, 100);
  static const Coordinate volumeX200y200z200 = Coordinate(200, 200, 200);
  static const Coordinate volumeX200y150z100 = Coordinate(200, 100, 100);
  static const Coordinate volumeX200y150z150 = Coordinate(200, 100, 100);
  static const Coordinate volumeX200y100z150 = Coordinate(200, 100, 100);
  static const Coordinate volumeX100y200z150 = Coordinate(100, 200, 100);
  static const Coordinate volumeX150y200z100 = Coordinate(100, 200, 100);
  static const Coordinate volumeX150y200z150 = Coordinate(100, 200, 100);
  static const Coordinate volumeX150y100z200 = Coordinate(100, 100, 200);
  static const Coordinate volumeX150y150z200 = Coordinate(100, 100, 200);
  static const Coordinate volumeX100y150z200 = Coordinate(100, 100, 200);
  static const Coordinate volumeX150y200z200 = Coordinate(100, 200, 200);
  static const Coordinate volumeX200y150z200 = Coordinate(200, 100, 200);
  static const Coordinate volumeX200y200z150 = Coordinate(200, 200, 100);
}
