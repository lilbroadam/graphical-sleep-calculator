import 'package:flutter/cupertino.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';

abstract class Sentinel extends Paintable {

  static const double SENTINEL_DIAMETER = 35.0;
  static const double SENTINEL_RADIUS = SENTINEL_DIAMETER / 2;

  Paint _bodyPaint;

  get bodyPaint => _bodyPaint;

  set bodyPaint (Paint paint) {
    _bodyPaint = paint;
  }

  Sentinel ();

  void paint(Canvas canvas, Size size);

  void paintSentinelLine(Canvas canvas, Size size) {
    double dx = offset.dx;
    double y1 = 125.0; // TODO get line y from sleep graph
    double y2 = 300; // TODO get bottom y from slee graph
    canvas.drawLine(Offset(dx, y1), Offset(dx, y2), _bodyPaint);
  }

  /// Returns true if [hitOffset] is within this Sentinel's hitbox.
  /// If hit, update location to [hitOffset].
  bool isHit(Offset hitOffset) {
    if (!isInteractable) {
      return false;
    }

    // TODO (x + width - offset.dx).abs()
    bool hit = (offset.dx - hitOffset.dx).abs() < hitBoxMargin
            && (offset.dy - hitOffset.dy).abs() < hitBoxMargin;

    if (hit) {
      offset = Offset(hitOffset.dx, offset.dy);
    }

    return hit;
  }
}
