import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/project_model.dart';
import 'package:path/path.dart';

class CustomPieChart extends StatefulWidget {
  CustomPieChart({Key? key, required this.career, required this.currentId})
      : super(key: key);
  // List<Project> careerList;
  Project career;
  int currentId;
  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PieElement element;
  late List<PieElement> elements;
  // late List<PieElement> elements;

  @override
  void initState() {
    // TODO: implement initState
    element = PieElement(widget.career.postRatio! * 100,
        widget.career.careerName, AppColors.mainblue);
    elements = [
      element,
      PieElement(100 - element.value, '여분', AppColors.dividegray)
    ];
    // elements = widget.careerList
    //     .map((career) => PieElement(career.postRatio! * 100, career.careerName,
    //         career.id == widget.currentId ? AppColors.mainblue : AppColors.dividegray))
    //     .toList();
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween(begin: 0.0, end: 360.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    // Future.delayed(
    //     Duration(seconds: 1), () async => await _animationController.forward());
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    // Properly dispose the controller. This is important!
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CustomPaint(
            // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
            size:
                const Size(120, 120), // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
            painter: PieChartPainter(
                elements: elements,
                // strokeWidth: 40,
                animationValue: _animation.value),
          ),
        ),
        // TextButton(
        //     onPressed: () {
        //       _animationController.forward();
        //     },
        //     child: Text("시작")),
        // TextButton(
        //     onPressed: () {
        //       _animationController.reverse();
        //     },
        //     child: Text("돌리기"))
      ],
    );
    ;
  }
}

class PieChartPainter extends CustomPainter {
  int selectIndex = 0;
  List<PieElement> elements;
  double strokeWidth;
  double animationValue;

  PieChartPainter(
      {required this.elements,
      this.strokeWidth = 6,
      required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) async {
    double startangle = -pi / 2;
    for (PieElement element in elements) {
      Paint targetPaint = Paint() // 화면에 그릴 때 쓸 Paint를 정의합니다.
        ..color = element.color
        ..strokeWidth =
            element.color == AppColors.dividegray ? 6 : 15 // 선의 길이를 정합니다.
        ..style = PaintingStyle
            .stroke // 선의 스타일을 정합니다. stroke면 외곽선만 그리고, fill이면 다 채웁니다.
        ..strokeCap = element.name != '여분'
            ? StrokeCap.butt
            : StrokeCap
                .butt; // stroke의 스타일을 정합니다. round를 고르면 stroke의 끝이 둥글게 됩니다.
      double radius = element.color == AppColors.dividegray
          ? min(size.width / 2 - targetPaint.strokeWidth / 2,
              size.height / 2 - targetPaint.strokeWidth / 2)
          : min(
              size.width / 2 - targetPaint.strokeWidth / 2 + strokeWidth,
              size.height / 2 -
                  targetPaint.strokeWidth / 2 +
                  strokeWidth); // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함.
      Offset center =
          Offset(size.width / 2, size.height / 2); // 원이 위젯의 가운데에 그려지게 좌표를 정함.

      double arcAngle = animationValue /
          180.0 *
          pi *
          (element.value / 100); // 호(arc)의 각도를 정함. 정해진 각도만큼만 그리도록 함.
      // startangle += (2 * (strokeWidth / 2) / radius);
      // arcAngle -= (2 * (strokeWidth / 2) / radius);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startangle, arcAngle, false, targetPaint); // 호(arc)를 그림.
      startangle += arcAngle;
    }

    // drawText(canvas, size, " / 100"); // 텍스트를 화면에 표시함.
  }

  // 원의 중앙에 텍스트를 적음.
  // void drawText(Canvas canvas, Size size, String text) {
  //   double fontSize = 16;

  //   TextSpan sp = TextSpan(
  //       style: TextStyle(
  //           fontSize: fontSize,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black),
  //       text: text); // TextSpan은 Text위젯과 거의 동일하다.
  //   TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

  //   tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.
  //   double dx = size.width / 2 - tp.width / 2;
  //   double dy = size.height / 2 - tp.height / 2;

  //   Offset offset = Offset(dx, dy);
  //   tp.paint(canvas, offset);
  // }

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함.
  // double getFontSize(Size size, String text) {
  //   return size.width / text.length * textScaleFactor;
  // }

  @override
  bool shouldRepaint(PieChartPainter old) {
    return old.animationValue != 360.0;
  }
}

class PieElement {
  double value;
  String name;
  Color color;

  PieElement(this.value, this.name, this.color);
}
