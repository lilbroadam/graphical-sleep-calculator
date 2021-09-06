import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';

class SleepGraphPainterData {
  double moonX = 100;
  double sunX = 100;
}

class Drawable {
  static List<Drawable> _drawables = [];

  String name;
  bool interactable = false; // TODO change to isInteractable
  double x, y, width, height;
  double hitBoxMargin = 10;
  
  Drawable(this.name, this.interactable, this.x, this.y, this.width, this.height);

  Offset get offset => Offset(x, y);
  Size get size => Size(width, height);

  bool isHit(Offset offset) {
    // TODO (x + width - offset.dx).abs()
    return (x - offset.dx).abs() < hitBoxMargin
        && (y - offset.dy).abs() < hitBoxMargin;
  }

  static add(Drawable drawable) {
    _drawables.add(drawable);
  }

  static get(String name) {
    for (Drawable drawable in _drawables) {
      if (drawable.name == name) {
        return drawable;
      }
    }
    return null;
  }

  // TODO add iterator
}

class SleepGraphPainter {

  Paint _backgroundPaint;
  Paint _borderPaint;
  Paint _moonPaint;
  Paint _moonCraterPaint;
  Paint _sunPaint;

  SleepGraphPainterData _data;

  static const String MOON_DRAWABLE = 'moon_drawable';
  static const String SUN_DRAWABLE = 'sun_drawable';

  static const double SENTINEL_DIAMETER = 35.0;
  static const double SENTINEL_RADIUS = SENTINEL_DIAMETER / 2;

  // TODO these are temporary. Values should be set by constraints.
  static const double Y_MIN = 100;
  static const double Y_MAX = 300;

  SleepGraphPainter(SleepGraphPainterData data) {
    _data = data;

    // Initialize drawables
    Drawable.add(
      Drawable(MOON_DRAWABLE, true, _data.moonX, Y_MIN, 35.0, 35.0));
    Drawable.add(
      Drawable(SUN_DRAWABLE, true, _data.sunX, Y_MIN, 35.0, 35.0));

    // Initialize paints
    _backgroundPaint = Paint()
      ..color = ThemeManager.theme.backgroundColor
      ..style = PaintingStyle.fill;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    _moonPaint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
    _moonCraterPaint = Paint()
      ..color = Colors.grey[600]
      ..style = PaintingStyle.fill;
    _sunPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
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
    _paintSleepSentinel(canvas, size);
    _paintWakeSentinel(canvas, size);
  }

  void _paintSleepSentinel(Canvas canvas, Size size) {
    final Offset offset = Drawable.get(MOON_DRAWABLE).offset;
    _paintMoon(canvas, size, offset, _moonPaint, _moonCraterPaint);
    _paintLineUnderGraph(canvas, size, offset, _moonPaint);
  }

  void _paintWakeSentinel(Canvas canvas, Size size) {
    final Offset offset = Drawable.get(SUN_DRAWABLE).offset;
    _paintSun(canvas, size, offset, _sunPaint);
    _paintLineUnderGraph(canvas, size, offset, _sunPaint);
  }

  void _paintMoon(Canvas canvas, Size size, Offset offset, Paint bodyPaint, Paint craterPaint) {
    final bigCraterRadius = SENTINEL_RADIUS * 0.3;
    final Offset bigCraterOffset
        = offset.translate(SENTINEL_DIAMETER * -1/10, SENTINEL_DIAMETER * -1/6);
    final mediumCraterRadius = SENTINEL_RADIUS * 0.2;
    final Offset mediumCraterOffset
        = offset.translate(SENTINEL_DIAMETER * 1/8, SENTINEL_DIAMETER * 1/8);
    final smallCraterRadius = SENTINEL_RADIUS * 0.15;
    final Offset smallCraterOffset
        = offset.translate(SENTINEL_DIAMETER * 1/3.5, SENTINEL_DIAMETER * -1/9);
    
    canvas.drawCircle(offset, SENTINEL_RADIUS, bodyPaint);
    canvas.drawCircle(bigCraterOffset, bigCraterRadius, craterPaint);
    canvas.drawCircle(mediumCraterOffset, mediumCraterRadius, craterPaint);
    canvas.drawCircle(smallCraterOffset, smallCraterRadius, craterPaint);
  }

  void _paintSun(Canvas canvas, Size size, Offset offset, Paint bodyPaint) {
    canvas.drawCircle(offset, SENTINEL_RADIUS, bodyPaint);
  }

  void _paintLineUnderGraph(Canvas canvas, Size size, Offset offset, Paint paint) {
    double dx = offset.dx;
    double y1 = _sleepGraphYatX(dx);
    double y2 = Y_MAX; // TODO set to bottom of graph
    canvas.drawLine(Offset(dx, y1), Offset(dx, y2), paint);
  }

  // TODO Caluclate the y value of the sleep graph at x
  double _sleepGraphYatX(double x) {
    return 125;
  }

  void handleHorizontalTouch(Offset localPosition) {
    // TODO use iterator
    for (int i = 0; i < Drawable._drawables.length; i++) {
      Drawable drawable = Drawable._drawables[i];
      if (drawable.interactable) {
        if (drawable.isHit(localPosition)) {
          drawable.x = localPosition.dx;
          break;
        }
      }
    }
  }
}
