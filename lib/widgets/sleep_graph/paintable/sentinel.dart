import 'package:flutter/cupertino.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';

abstract class Sentinel extends Paintable {

  static const double SENTINEL_DIAMETER = 35.0;
  static const double SENTINEL_RADIUS = SENTINEL_DIAMETER / 2;

  Paint _bodyPaint;

  // What sentinel is current being dragged. Null if no sentinel being dragged.
  // Necessary to account for delays between calls to hitTest() so it doesn't
  // return false when a dragged point moves outside of the hitbox between 
  // frames. Also necessary so when a sentinel overlaps with another sentinel,
  // only the position of the one being dragged is updated.
  Sentinel _draggingSentinel;

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

  /// Returns true if [event] is within this Sentinel's hitbox.
  /// If hit, update location to [hitOffset].
  bool hitTest(GestureEvent event) {
    if (!isInteractable) {
      return false;
    }

    if (_draggingSentinel != null ||
        event is HorizontalDragEndEvent ||
        event is HorizontalDragCancelEvent) {
      return true;
    }

    // TODO (x + width - offset.dx).abs()
    var hitOffset = event.localPosition;
    bool hit = (offset.dx - hitOffset.dx).abs() < hitBoxMargin
            && (offset.dy - hitOffset.dy).abs() < hitBoxMargin;

    return hit;
  }

  void onGestureEvent(GestureEvent event);

  // TODO change to private method that children can call
  void onHorizontalDragEvent(HorizontalDragEvent event) {
    print('Sentinel.onHorizontalDragEvent(${event.runtimeType})');
    Offset eventOffset = event.localPosition;
    if (event is HorizontalDragStartEvent) {
      _draggingSentinel = this;
    } else if (event is HorizontalDragUpdateEvent) {
      if (this == _draggingSentinel) {
        offset = Offset(eventOffset.dx, offset.dy);
      }
    } else if (event is HorizontalDragEndEvent ||
        event is HorizontalDragCancelEvent) {
      _draggingSentinel = null;
    }
  }
}
