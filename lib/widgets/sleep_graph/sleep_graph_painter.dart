import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';

class SleepGraphPainter {

  Paint _backgroundPaint;
  Paint _borderPaint;

  SleepGraphPainter() {
    _backgroundPaint = Paint()
      ..color = ThemeManager.theme.backgroundColor
      ..style = PaintingStyle.fill;

    _borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
  }

  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintBorder(canvas, size);

    _paintGraph(canvas, size);
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

  void _paintGraph(Canvas canvas, Size size) {
    _paintMoon(canvas, size);
    _paintSun(canvas, size);
  }

  void _paintMoon(Canvas canvas, Size size) {
    // TODO refactor so moon and sun are sized from the same variable
    final moonDiameter = 35.0;
    final moonRadius = moonDiameter / 2;
    final Offset moonOffset = Offset(100, 100);
    final bigCraterRadius = moonRadius * 0.3;
    final Offset bigCraterOffset
        = moonOffset.translate(moonDiameter * -1/10, moonDiameter * -1/6);
    final mediumCraterRadius = moonRadius * 0.2;
    final Offset mediumCraterOffset
        = moonOffset.translate(moonDiameter * 1/8, moonDiameter * 1/8);
    final smallCraterRadius = moonRadius * 0.15;
    final Offset smallCraterOffset
        = moonOffset.translate(moonDiameter * 1/3.5, moonDiameter * -1/10);

    final Paint moonPaint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.fill;
    final Paint craterPaint = Paint()
      ..color = Colors.grey[600]
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(moonOffset, moonRadius, moonPaint);
    canvas.drawCircle(bigCraterOffset, bigCraterRadius, craterPaint);
    canvas.drawCircle(mediumCraterOffset, mediumCraterRadius, craterPaint);
    canvas.drawCircle(smallCraterOffset, smallCraterRadius, craterPaint);
  }

  void _paintSun(Canvas canvas, Size size) {
    final sunDiameter = 35.0;
    final sunRadius = sunDiameter / 2;
    final Offset sunOffset = Offset(200, 100);

    final Paint sunPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill;

    canvas.drawCircle(sunOffset, sunRadius, sunPaint);
  }
}
