import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class SleepGraphPainter {

  // TODO move into a GridData object?
  double gridMinX;
  double gridMaxX;
  double gridMinY;
  double gridMaxY;
  double xAxisLabelSpacing = 70.0;
  double yAxisLabelSpacing = 70.0;

  static const BORDER_WIDTH = 5.0;

  Paint _backgroundPaint = Paint()
      ..color = ThemeManager.theme.backgroundColor
      ..style = PaintingStyle.fill;
  Paint _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = BORDER_WIDTH;

  SleepSentinel _sleepSentinel;
  WakeSentinel _wakeSentinel;

  List<Paintable> _paintables = [];

  SleepGraphPainter() {
    _sleepSentinel = SleepSentinel();
    _wakeSentinel = WakeSentinel();

    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    gridMinX = BORDER_WIDTH;
    gridMaxX = size.width - BORDER_WIDTH;
    gridMinY = BORDER_WIDTH;
    gridMaxY = size.height - BORDER_WIDTH;

    _paintBackground(canvas, size);
    _paintBorder(canvas, size);
    _paintGrid(canvas, size);

    double yAxisY = gridMaxY - xAxisLabelSpacing - BORDER_WIDTH;

    for (Paintable paintable in _paintables) {
      paintable.paint(canvas, Size(size.width, yAxisY));
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
    final halfStrokeWidth = strokeWidth / 2;

    // TODO corners aren't being drawn properly
    // Offset topLeft = Offset(0 + halfStrokeWidth, 0);
    // Offset topRight = Offset(size.width - halfStrokeWidth, 0);
    // Offset bottomLeft = Offset(0 + halfStrokeWidth, size.height);
    // Offset bottomRight = Offset(size.width - halfStrokeWidth, size.height);
    // canvas.drawLine(topLeft, topRight, _borderPaint);
    // canvas.drawLine(topRight, bottomRight, _borderPaint);
    // canvas.drawLine(bottomRight, bottomLeft, _borderPaint);
    // canvas.drawLine(bottomLeft, topLeft, _borderPaint);

    // TODO make sure this is being draw accurately
    canvas.drawRect(
      Rect.fromLTWH(
        0 + halfStrokeWidth,
        0,
        size.width - strokeWidth,
        size.height - strokeWidth),
      _borderPaint
    );
  }

  // TODO break into paintGrid, paintXAxisLabels, paintYAxisLabels
  void _paintGrid(Canvas canvas, Size size) {
    double xAxisX = gridMinX + yAxisLabelSpacing + BORDER_WIDTH;
    double xAxisYMin = gridMinY;
    double xAxisYMax = gridMaxY;
    double yAxisY = gridMaxY - xAxisLabelSpacing - BORDER_WIDTH;
    double yAxisXMin = gridMinX;
    double yAxisXMax = gridMaxX;

    canvas.drawLine(
      Offset(xAxisX, xAxisYMin),
      Offset(xAxisX, yAxisY),
      Paint()..color = Colors.white,
    );
    canvas.drawLine(
      Offset(xAxisX, yAxisY),
      Offset(yAxisXMax, yAxisY),
      Paint()..color = Colors.white,
    );

    // paint REM level
    // TODO paint text right-aligned
    _paintText(canvas, size, 'Awake', Offset(gridMinX, 100));
    _paintText(canvas, size, 'Asleep', Offset(gridMinX, 175));
    _paintText(canvas, size, 'Deep sleep', Offset(gridMinX, 250));

    // paint times
    _paintText(canvas, size, '10:00pm', Offset(75, yAxisY));
    _paintText(canvas, size, '11:30pm', Offset(150, yAxisY));
    _paintText(canvas, size, '1:00am', Offset(215, yAxisY));
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

  // TODO Caluclate the y value of the sleep graph at x
  double _sleepGraphYatX(double x) {
    return 125;
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
