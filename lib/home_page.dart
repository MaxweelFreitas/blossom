import 'package:blossom/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //Setting SysemUIOverlay
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    //Setting SystmeUIMode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(500, 500),
              painter: Blossom(),
            ),
          ],
        ),
      ),
    );
  }
}

class Blossom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DimensionConvert dim = DimensionConvert(size: size);
    Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2;
    Paint bgPaint = Paint()..color = const Color(0xffF37735);
    //Face
    Paint facePaint = Paint()..color = const Color(0xffFEDEDD);
    //Eyes
    Paint scleraPaint = Paint()..color = const Color(0xffFFFFFF);
    Paint pupilPaint = Paint();
    Paint irisPaint = Paint()
      ..color = const Color(0xffD3344F); //TODO: Add shader to make it realistic
    Paint shinePaint = Paint()..color = const Color(0xffFFFFFF);
    //MouthPaint
    Paint mouthPaint = Paint()
      ..color = const Color(0xffFF0000); //TODO: Add shader to make it realistic
    Paint tonguePaint = Paint()
      ..color = const Color(0xffD1908E); //TODO: Add shader to make it realistic
    //Fringe
    Paint fringePaint = Paint()
      ..color = const Color(0xffFE8709); //TODO: Add shader to make it realistic
    //HairTie
    Paint hairTiePaint = Paint()
      ..color = const Color(0xffFE0000); //TODO: Add shader to make it realistic
    //Hair
    Paint hairPaint = Paint()
      ..color = const Color(0xffFE8709); //TODO: Add shader to make it realistic
    //Dress
    Paint dressPaint = Paint()..color = const Color(0xffDB2061);
    Paint dressBandPaint = Paint()..color = const Color(0xff000000);

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), bgPaint);

    hairTie(canvas, dim, borderPaint, hairTiePaint);
    hair(canvas, dim, borderPaint, hairPaint);
    dress(canvas, dim, borderPaint, dressPaint, dressBandPaint);
    face(canvas, dim, borderPaint, facePaint);
    leftEye(canvas, dim, borderPaint, scleraPaint, pupilPaint, irisPaint,
        shinePaint);
    rightEye(canvas, dim, borderPaint, scleraPaint, pupilPaint, irisPaint,
        shinePaint);
    mouth(canvas, dim, borderPaint, mouthPaint, tonguePaint);
    fringe(canvas, dim, borderPaint, fringePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void face(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint facePaint,
) {
  Rect faceRect = Rect.fromLTRB(
    dim.w(25.48),
    dim.h(32.07),
    dim.w(73.67),
    dim.h(72.93),
  );

  Path facePath = Path()..addOval(faceRect);

  canvas.drawPath(facePath, facePaint);
  canvas.drawPath(facePath, borderPaint);
}

void leftEye(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint scleraPaint,
  Paint pupilPaint,
  Paint irisPaint,
  Paint shinePaint,
) {
  Rect faceRect = Rect.fromLTRB(
    dim.w(25.48),
    dim.h(32.07),
    dim.w(73.67),
    dim.h(72.93),
  );

  Rect scleraRect = Rect.fromLTRB(
    dim.w(-08.36),
    dim.h(-12.59),
    dim.w(08.36),
    dim.h(12.59),
  );

  Rect irisRect = Rect.fromLTRB(
    dim.w(27.52),
    dim.h(40.20),
    dim.w(42.76),
    dim.h(64.40),
  );

  Rect pupilRect = Rect.fromLTRB(
    dim.w(28.82),
    dim.h(40.77),
    dim.w(42.65),
    dim.h(61.87),
  );

  Rect sShineRect = Rect.fromLTRB(
    dim.w(36.08),
    dim.h(46.80),
    dim.w(37.27),
    dim.h(48.00),
  );

  Rect bShineRect = Rect.fromLTRB(
    dim.w(34.46),
    dim.h(49.00),
    dim.w(40.00),
    dim.h(56.46),
  );

  //Sclera
  //Coordenadas polares para cartesianas
  const lScleraAngle = -16.5;
  final originLSclera = Offset(dim.w(31.98), dim.h(53.39));

  final posLeftSclera = polarToCartesianPoint(
    origin: originLSclera,
    originDistance: 0,
    radianAngle: degreesToRadian(lScleraAngle),
  );

  Path facePath = Path()..addOval(faceRect);
  Path scleraPath = Path()..addOval(scleraRect);
  Path irisPath = Path()..addOval(irisRect);
  Path pupilPath = Path()..addOval(pupilRect);
  Path sShinePath = Path()..addOval(sShineRect);
  Path bShinePath = Path()..addOval(bShineRect);

  // Rotate ScleraPath path using a matrix
  Matrix4 scleraMatrix4 = Matrix4.identity()
    ..translate(posLeftSclera.dx, posLeftSclera.dy)
    ..rotateZ(degreesToRadian(-16.5));

  scleraPath = scleraPath.transform(scleraMatrix4.storage);

  final intersectScleraPath = Path.combine(
    PathOperation.intersect,
    facePath,
    scleraPath,
  );

  final intersectIrisPath = Path.combine(
    PathOperation.intersect,
    intersectScleraPath,
    irisPath,
  );

  final intersectPupilPath = Path.combine(
    PathOperation.intersect,
    intersectScleraPath,
    pupilPath,
  );

  //draw
  canvas.save();
  canvas.drawPath(intersectScleraPath, scleraPaint);
  canvas.drawPath(intersectScleraPath, borderPaint);
  canvas.drawPath(intersectIrisPath, irisPaint);
  canvas.drawPath(intersectIrisPath, borderPaint);
  canvas.drawPath(intersectPupilPath, pupilPaint);
  canvas.restore();
  canvas.drawPath(sShinePath, shinePaint);
  canvas.drawPath(bShinePath, shinePaint);
}

void rightEye(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint scleraPaint,
  Paint pupilPaint,
  Paint irisPaint,
  Paint shinePaint,
) {
  Rect scleraRect = Rect.fromLTRB(
    dim.w(47.50),
    dim.h(38.60),
    dim.w(73.62),
    dim.h(65.88),
  );

  Rect irisRect = Rect.fromLTRB(
    dim.w(48.81),
    dim.h(38.64),
    dim.w(72.53),
    dim.h(63.53),
  );

  Rect pupilRect = Rect.fromLTRB(
    dim.w(50.42),
    dim.h(40.34),
    dim.w(70.91),
    dim.h(61.03),
  );

  Rect sShineRect = Rect.fromLTRB(
    dim.w(63.90),
    dim.h(45.56),
    dim.w(65.74),
    dim.h(47.41),
  );

  Rect bShineRect = Rect.fromLTRB(
    dim.w(56.67),
    dim.h(47.11),
    dim.w(64.14),
    dim.h(54.58),
  );

  Path scleraPath = Path()..addOval(scleraRect);
  Path irisPath = Path()..addOval(irisRect);
  Path pupilPath = Path()..addOval(pupilRect);
  Path sShinePath = Path()..addOval(sShineRect);
  Path bShinePath = Path()..addOval(bShineRect);

  canvas.drawPath(scleraPath, scleraPaint);
  canvas.drawPath(scleraPath, borderPaint);
  canvas.drawPath(irisPath, irisPaint);
  canvas.drawPath(irisPath, borderPaint);
  canvas.drawPath(pupilPath, pupilPaint);
  canvas.drawPath(sShinePath, shinePaint);
  canvas.drawPath(bShinePath, shinePaint);
}

void mouth(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint mouthPaint,
  Paint tonguePaint,
) {
  Rect mouthRect = Rect.fromLTRB(
    dim.w(-02.84),
    dim.h(-04.18),
    dim.w(02.84),
    dim.h(04.18),
  );

  Rect upperLipRect = Rect.fromLTRB(
    dim.w(43.15),
    dim.h(57.02),
    dim.w(49.09),
    dim.h(63.97),
  );

  Rect tongueRect = Rect.fromLTRB(
    dim.w(47.57),
    dim.h(65.39),
    dim.w(51.29),
    dim.h(70.12),
  );

  //Coordenadas polares para cartesianas
  const mouthAngle = -22.34;
  final originMouth = Offset(dim.w(47.00), dim.h(64.41));

  final posMouth = polarToCartesianPoint(
    origin: originMouth,
    originDistance: 0,
    radianAngle: degreesToRadian(mouthAngle),
  );

  Path mouthPath = Path()..addOval(mouthRect);
  Path upperLipPath = Path()..addOval(upperLipRect);
  Path tonguePath = Path()..addOval(tongueRect);

  // Rotate ScleraPath path using a matrix
  Matrix4 mouthMatrix4 = Matrix4.identity()
    ..translate(posMouth.dx, posMouth.dy)
    ..rotateZ(degreesToRadian(mouthAngle));

  mouthPath = mouthPath.transform(mouthMatrix4.storage);

  final lipMouthCutPath = Path.combine(
    PathOperation.difference,
    mouthPath,
    upperLipPath,
  );

  final tongueCutPath = Path.combine(
    PathOperation.intersect,
    mouthPath,
    tonguePath,
  );

  // canvas.drawPath(mouthPath, borderPaint);
  //draw
  canvas.save();
  canvas.drawPath(lipMouthCutPath, mouthPaint);
  canvas.drawPath(tongueCutPath, tonguePaint);
  canvas.drawPath(lipMouthCutPath, borderPaint);

  canvas.restore();
}

void fringe(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint fringePaint,
) {
  Rect faceRect = Rect.fromLTRB(
    dim.w(25.48),
    dim.h(32.07),
    dim.w(73.67),
    dim.h(72.93),
  );

  Rect cutFringeDownRect = Rect.fromLTRB(
    dim.w(06.87),
    dim.h(41.89),
    dim.w(99.26),
    dim.h(111.47),
  );

  Rect cutFringeC1Rect = Rect.fromLTRB(
    dim.w(31.46),
    dim.h(37.03),
    dim.w(55.84),
    dim.h(61.90),
  );

  Rect cutFringeC2Rect = Rect.fromLTRB(
    dim.w(34.21),
    dim.h(30.42),
    dim.w(57.69),
    dim.h(75.23),
  );

  Rect cutFringeC3Rect = Rect.fromLTRB(
    dim.w(37.91),
    dim.h(25.63),
    dim.w(89.86),
    dim.h(88.73),
  );

  Rect cutFringeC4Rect = Rect.fromLTRB(
    dim.w(44.37),
    dim.h(-06.91),
    dim.w(102.91),
    dim.h(72.45),
  );

  Rect cutFringeC5Rect = Rect.fromLTRB(
    dim.w(12.47),
    dim.h(32.41),
    dim.w(66.57),
    dim.h(75.66),
  );

  Rect cutFringeC6Rect = Rect.fromLTRB(
    dim.w(03.06),
    dim.h(23.24),
    dim.w(62.31),
    dim.h(96.12),
  );

  Path facePath = Path()..addOval(faceRect);
  Path cutFringePath = Path()..addOval(cutFringeDownRect);
  Path cutFringeC1Path = Path()..addOval(cutFringeC1Rect);
  Path cutFringeC2Path = Path()..addOval(cutFringeC2Rect);
  Path cutFringeC3Path = Path()..addOval(cutFringeC3Rect);
  Path cutFringeC4Path = Path()..addOval(cutFringeC4Rect);
  Path cutFringeC5Path = Path()..addOval(cutFringeC5Rect);
  Path cutFringeC6Path = Path()..addOval(cutFringeC6Rect);

  final diffFringePath = Path.combine(
    PathOperation.difference,
    facePath,
    cutFringePath,
  );

  //C1 - C2
  final cutFringeC1 = Path.combine(
    PathOperation.difference,
    cutFringeC1Path,
    cutFringeC2Path,
  );

  final cutFringeC2 = Path.combine(
    PathOperation.difference,
    cutFringeC1,
    cutFringePath,
  );

  final fringeMinusC2 = Path.combine(
    PathOperation.difference,
    diffFringePath,
    cutFringeC2,
  );

  //C3 - C4
  final cutFringeC3 = Path.combine(
    PathOperation.difference,
    cutFringeC3Path,
    cutFringeC4Path,
  );

  final cutFringeC4 = Path.combine(
    PathOperation.difference,
    cutFringeC3,
    cutFringePath,
  );

  final fringeMinusC4 = Path.combine(
    PathOperation.difference,
    fringeMinusC2,
    cutFringeC4,
  );

  //C5 - C6
  final cutFringeC5 = Path.combine(
    PathOperation.difference,
    cutFringeC5Path,
    cutFringeC6Path,
  );

  final cutFringeC6 = Path.combine(
    PathOperation.difference,
    cutFringeC5,
    cutFringePath,
  );

  final fringeMinusC6 = Path.combine(
    PathOperation.difference,
    fringeMinusC4,
    cutFringeC6,
  );

  canvas.drawPath(fringeMinusC6, fringePaint);
  canvas.drawPath(fringeMinusC6, borderPaint);
}

void hairTie(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint hairTiePaint,
) {
  Rect hairTieRect = Rect.fromLTRB(
    dim.w(44.12),
    dim.h(28.47),
    dim.w(51.76),
    dim.h(39.59),
  );

  Rect hairTieRightRect = Rect.fromLTRB(
    dim.w(-09.06),
    dim.h(-18.78),
    dim.w(09.06),
    dim.h(18.78),
  );

  //HairTieRight
  //Coordenadas polares para cartesianas
  const hairTieRightAngle = 37.13;
  final originMouth = Offset(dim.w(63.41), dim.h(21.08));

  final posMouth = polarToCartesianPoint(
    origin: originMouth,
    originDistance: 0,
    radianAngle: degreesToRadian(hairTieRightAngle),
  );

  // Rotate HairTieRight path using a matrix
  Matrix4 hairTieRightMatrix4 = Matrix4.identity()
    ..translate(posMouth.dx, posMouth.dy)
    ..rotateZ(degreesToRadian(hairTieRightAngle));

  Path hairTieRightPath = Path()..addOval(hairTieRightRect);
  hairTieRightPath = hairTieRightPath.transform(hairTieRightMatrix4.storage);
  Path hairTiePath = Path()..addOval(hairTieRect);

  Path hairTieLeftPath = Path()
        ..moveTo(dim.w(37.45), dim.h(36.72))
        ..quadraticBezierTo(
          dim.w(34.50), dim.h(34.58), //
          dim.w(35.36), dim.h(26.41),
        )
        ..quadraticBezierTo(
          dim.w(38.58), dim.h(11.47), //
          dim.w(51.74), dim.h(04.08),
        )
        ..quadraticBezierTo(
          dim.w(53.33), dim.h(03.23), //
          dim.w(55.00), dim.h(02.90),
        )
        ..quadraticBezierTo(
          dim.w(58.72), dim.h(03.43), //
          dim.w(58.09), dim.h(07.05),
        )
        ..quadraticBezierTo(
          dim.w(55.97), dim.h(22.11), //
          dim.w(51.74), dim.h(26.41),
        )
        ..lineTo(dim.w(51.79), dim.h(38.78))

      //
      ;

  canvas.drawPath(hairTieLeftPath, hairTiePaint);
  canvas.drawPath(hairTieLeftPath, borderPaint);
  canvas.drawPath(hairTieRightPath, hairTiePaint);
  canvas.drawPath(hairTieRightPath, borderPaint);
  canvas.drawPath(hairTiePath, hairTiePaint);
  canvas.drawPath(hairTiePath, borderPaint);
}

void hair(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint hairPaint,
) {
  Path hairPath = Path()
    ..moveTo(dim.w(55.64), dim.h(69.85))
    ..quadraticBezierTo(
      dim.w(58.00), dim.h(90.64), //
      dim.w(42.13), dim.h(96.24),
    )
    ..quadraticBezierTo(
      dim.w(27.50), dim.h(98.00), //
      dim.w(24.50), dim.h(86.50),
    )
    ..quadraticBezierTo(
      dim.w(23.50), dim.h(78.11), //
      dim.w(29.06), dim.h(74.15),
    )
    ..quadraticBezierTo(
      dim.w(27.15), dim.h(75.10), //
      dim.w(26.60), dim.h(79.26),
    )
    ..quadraticBezierTo(
      dim.w(26.50), dim.h(81.98), //
      dim.w(30.06), dim.h(82.00),
    )
    ..quadraticBezierTo(
      dim.w(38.73), dim.h(80.50), //
      dim.w(43.36), dim.h(69.85),
    );

  Path r1HairPath = Path()
    ..moveTo(dim.w(24.52), dim.h(86.53))
    ..lineTo(dim.w(27.61), dim.h(86.53));

  Path r2HairPath = Path()
    ..moveTo(dim.w(28.27), dim.h(92.77))
    ..quadraticBezierTo(
      dim.w(31.29), dim.h(92.00), //
      dim.w(33.75), dim.h(90.03),
    );

  Path r3HairPath = Path()
    ..moveTo(dim.w(33.33), dim.h(95.64))
    ..quadraticBezierTo(
      dim.w(35.00), dim.h(94.94), //
      dim.w(35.84), dim.h(93.62),
    );

  canvas.drawPath(hairPath, hairPaint);
  canvas.drawPath(hairPath, borderPaint);
  canvas.drawPath(r1HairPath, borderPaint);
  canvas.drawPath(r2HairPath, borderPaint);
  canvas.drawPath(r3HairPath, borderPaint);
}

void dress(
  Canvas canvas,
  DimensionConvert dim,
  Paint borderPaint,
  Paint dressPaint,
  Paint dressBandPaint,
) {
  Rect band1Rect = Rect.fromLTRB(
    dim.w(09.04),
    dim.h(71.89),
    dim.w(63.80),
    dim.h(126.64),
  );
  Rect band2Rect = Rect.fromLTRB(
    dim.w(05.76),
    dim.h(75.84),
    dim.w(60.51),
    dim.h(130.60),
  );

  Path band1Path = Path()..addOval(band1Rect);
  Path band2Path = Path()..addOval(band2Rect);

  Path dressPath = Path()
    ..moveTo(dim.w(55.37), dim.h(70.94))
    ..quadraticBezierTo(
      dim.w(53.50), dim.h(83.24), //
      dim.w(50.56), dim.h(88.11),
    )
    ..quadraticBezierTo(
      dim.w(46.61), dim.h(82.20), //
      dim.w(40.68), dim.h(79.77),
    )
    ..quadraticBezierTo(
      dim.w(44.16), dim.h(76.15), //
      dim.w(47.46), dim.h(70.94),
    );

  //Band
  final subBand1 = Path.combine(
    PathOperation.difference,
    band1Path,
    band2Path,
  );

  final subDressBand = Path.combine(
    PathOperation.intersect,
    dressPath,
    subBand1,
  );

  canvas.drawPath(dressPath, dressPaint);
  canvas.drawPath(dressPath, borderPaint);
  canvas.drawPath(subDressBand, dressBandPaint);
}
