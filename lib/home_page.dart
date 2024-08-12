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
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), bgPaint);

    face(canvas, dim, borderPaint, facePaint);

    leftEye(canvas, dim, borderPaint, scleraPaint, pupilPaint, irisPaint,
        shinePaint);

    rightEye(canvas, dim, borderPaint, scleraPaint, pupilPaint, irisPaint,
        shinePaint);

    mouth(canvas, dim, borderPaint, mouthPaint, tonguePaint);
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
    dim.w(48.00),
    dim.h(38.15),
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

void mouth(Canvas canvas, DimensionConvert dim, Paint borderPaint,
    Paint mouthPaint, Paint tonguePaint) {
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
