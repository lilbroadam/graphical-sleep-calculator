import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/chart_data.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class SleepGraphPainter {

  ChartData _chartData;

  Paint _backgroundPaint;
  Paint _borderPaint;

  SleepSentinel _sleepSentinel;
  WakeSentinel _wakeSentinel;

  List<Paintable> _paintables = [];

  SleepGraphPainter() {
    _chartData = ChartData(
      borderWidth: 2.5,
      timeLabelMargin: 70.0,
      sleepLabelMargin: 70.0,
    );

    _backgroundPaint = Paint()
        ..color = ThemeManager.theme.backgroundColor
        ..style = PaintingStyle.fill;
    _borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _chartData.borderWidth;

    _sleepSentinel = SleepSentinel(_chartData);
    _wakeSentinel = WakeSentinel(_chartData);
    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    _chartData.resize(size);

    _paintBackground(canvas, size);
    _paintBorder(canvas, size);
    _paintGrid(canvas, size);
    _paintRemLevel(canvas, size);

    for (Paintable paintable in _paintables) {
      paintable.paint(canvas, Size(size.width, _chartData.yAxisY));
    }
  }

  void _paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _backgroundPaint
    );
  }

  void _paintBorder(Canvas canvas, Size size) {
    final strokeWidth = _borderPaint.strokeWidth;
    canvas.drawRect(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth),
      _borderPaint
    );
  }

  // TODO break into paintGrid, paintXAxisLabels, paintYAxisLabels
  void _paintGrid(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(_chartData.xAxisX, _chartData.xAxisYMin),
      Offset(_chartData.xAxisX, _chartData.yAxisY),
      Paint()..color = Colors.white,
    );
    canvas.drawLine(
      Offset(_chartData.xAxisX, _chartData.yAxisY),
      Offset(_chartData.yAxisXMax, _chartData.yAxisY),
      Paint()..color = Colors.white,
    );

    // paint REM level
    // TODO paint text right-aligned
    _paintText(canvas, size, 'Awake', Offset(_chartData.gridMinX, 100));
    _paintText(canvas, size, 'Asleep', Offset(_chartData.gridMinX, 175));
    _paintText(canvas, size, 'Deep sleep', Offset(_chartData.gridMinX, 250));

    // paint times
    _paintText(canvas, size, '10:00pm', Offset(75, _chartData.yAxisY));
    _paintText(canvas, size, '11:30pm', Offset(150, _chartData.yAxisY));
    _paintText(canvas, size, '1:00am', Offset(215, _chartData.yAxisY));
  }

  void _paintRemLevel(canvas, size) {
    Paint remLevelPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    Path remLevelPath = Path();

    // double xStart = 100.0;
    // double yStart = 125.0;
    // double xInterval = 50.0;
    // double yInterval = 100.0;
    // remLevelPath.moveTo(xStart, yStart);
    // remLevelPath.quadraticBezierTo(
    //   xStart + 1 * xInterval, yStart + 0 * yInterval,
    //   xStart + 1 * xInterval, yStart + 1 * yInterval);
    // remLevelPath.quadraticBezierTo(
    //   xStart + 1 * xInterval, yStart + 2 * yInterval,
    //   xStart + 2 * xInterval, yStart + 2 * yInterval);
    // remLevelPath.quadraticBezierTo(
    //   xStart + 3 * xInterval, yStart + 2 * yInterval,
    //   xStart + 3 * xInterval, yStart + 1 * yInterval);
    // remLevelPath.quadraticBezierTo(
    //   xStart + 3 * xInterval, yStart + 0 * yInterval,
    //   xStart + 4 * xInterval, yStart + 0 * yInterval);

    double xStart = 100.0;
    double yStart = 125.0;
    double sleepCycleWidth = 60.0;
    double sleepCycleHeight = 150.0; // 200
    // remLevelPath = getSleepCyclePath(xStart, yStart, sleepCycleWidth, sleepCycleHeight);
    // remLevelPath.addPath(getSleepCyclePath(xStart + sleepCycleWidth * 2, yStart, sleepCycleWidth, sleepCycleHeight), Offset(0, 0));

    remLevelPath = _chartData.getSleepCyclePath();
    remLevelPath.addPath(_chartData.getSleepCyclePath(), Offset(sleepCycleWidth * 2, 0));
    // remLevelPath.addPath
    // remLevelPath.trans

    canvas.drawPath(remLevelPath, remLevelPaint);
  }

  void _paintText(Canvas canvas, Size size, String text, Offset offset) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.white), // TODO get from theme
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  void onGestureEvent(GestureEvent event) {
    // TODO only handle gestures for paintables if gesture is within grid area
    // print('Painter.onGestureEvent(${event.runtimeType})');

    for (Paintable paintable in _paintables) {
      if (paintable.hitTest(event)) {
        paintable.onGestureEvent(event);
      }
    }
  }
}
