import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/chart_data.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';

abstract class Sentinel extends Paintable {

  static const double SENTINEL_DIAMETER = 35.0;
  static const double SENTINEL_RADIUS = SENTINEL_DIAMETER / 2;
  static const double HIT_BOX_MARGIN = 25.0;

  // What sentinel is current being dragged. Null if no sentinel being dragged.
  // Necessary to account for delays between calls to hitTest() so it doesn't
  // return false when a dragged point moves outside of the hitbox between 
  // frames. Also necessary so when a sentinel overlaps with another sentinel,
  // only the position of the one being dragged is updated.
  Sentinel _draggingSentinel;

  // If this sentinel is currently toggled to locked.
  bool isLocked;

  // TODO have a way that ensures bodyPaint is initialized by children
  Paint _bodyPaint;
  get bodyPaint => _bodyPaint;
  set bodyPaint (paint) => _bodyPaint = paint;

  ChartData _chartData;

  Sentinel (this._chartData) : isLocked = false;

  /// Paint the body of this sentinel
  // TODO pass a GridData object so Paintables know where to paint themselves?
  @override
  void paint(Canvas canvas, Size size) {
    _paintSentinelLine(canvas, size);
    canvas.drawCircle(offset, Sentinel.SENTINEL_RADIUS, bodyPaint);
  }

  void _paintSentinelLine(Canvas canvas, Size size) {
    double dx = offset.dx;
    double y1 = 125.0; // TODO get line y from sleep graph
    double y2 = 300; // TODO get bottom y from slee graph
    // canvas.drawLine(Offset(dx, y1), Offset(dx, y2), _bodyPaint);
    canvas.drawLine(Offset(dx, y1), Offset(dx, size.height), _bodyPaint);
  }

  /// Returns true if [event] is within this Sentinel's hitbox.
  /// If hit, update location to [event.localPosition].
  // TODO handle case when sentinels are overlapping
  @override
  bool hitTest(GestureEvent event) {
    if (!isInteractable) {
      return false;
    }

    // Check that [event] is within the chart area
    if (event.localPosition != null
        && (event.localPosition.dx < _chartData.xAxisX + SENTINEL_RADIUS
        || event.localPosition.dy > _chartData.yAxisY)) {
      _draggingSentinel = null; // Drop the sentinel
      return false;
    }

    if (_draggingSentinel != null ||
        event is HorizontalDragEndEvent ||
        event is HorizontalDragCancelEvent) {
      return true;
    }

    // TODO (x + width - offset.dx).abs()
    var hitOffset = event.localPosition;
    bool hit = (offset.dx - hitOffset.dx).abs() < HIT_BOX_MARGIN
            && (offset.dy - hitOffset.dy).abs() < HIT_BOX_MARGIN;

    return hit;
  }

  @override
  void onGestureEvent(GestureEvent event);

  // TODO change to private method that children can call
  void onHorizontalDragEvent(HorizontalDragEvent event) {
    // print('Sentinel.onHorizontalDragEvent(${event.runtimeType})');
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


class SleepSentinel extends Sentinel {

  final _bigCraterRadius = Sentinel.SENTINEL_RADIUS * 0.3;
  final _mediumCraterRadius = Sentinel.SENTINEL_RADIUS * 0.2;
  final _smallCraterRadius = Sentinel.SENTINEL_RADIUS * 0.15;

  final Paint _unlockedBodyPaint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
  
  final Paint _lockedBodyPaint = Paint()
      ..color = Colors.grey[500]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  final Paint _craterPaint = Paint()
      ..color = Colors.grey[600]
      ..style = PaintingStyle.fill;

  SleepSentinel (_chartData) : super(_chartData) {
    // TODO set bodyPaint by calling super constructor
    bodyPaint = _unlockedBodyPaint;

     // TODO get init location from sleep graph
    offset = Offset(100, 100);
  }

  /// Have SleepSentinel paint itself at [offset].
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    final Offset bigCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * -1/10, Sentinel.SENTINEL_DIAMETER * -1/6);
    final Offset mediumCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * 1/8, Sentinel.SENTINEL_DIAMETER * 1/8);
    final Offset smallCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * 1/3.5, Sentinel.SENTINEL_DIAMETER * -1/9);

    canvas.drawCircle(bigCraterOffset, _bigCraterRadius, _craterPaint);
    canvas.drawCircle(mediumCraterOffset, _mediumCraterRadius, _craterPaint);
    canvas.drawCircle(smallCraterOffset, _smallCraterRadius, _craterPaint);
  }

  @override
  void onGestureEvent(GestureEvent event) {
    // print('SleepSentinel.onGestureEvent(${event.runtimeType})');
    if (event is TapUpEvent) {
      isLocked = !isLocked;
      bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }
}


class WakeSentinel extends Sentinel {

  final Paint _unlockedBodyPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  final Paint _lockedBodyPaint = Paint()
      ..color = Colors.yellow[800]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  WakeSentinel (_chartData) : super(_chartData) {
    // TODO set bodyPaint by calling super constructor
    super.bodyPaint = _unlockedBodyPaint;

    offset = Offset(300, 100); // TODO get init location from sleep graph
  }

  /// Have WakeSentinel paint itself at [offset].
  /// WakeSentinel will update it's internal location to [offset]
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
  }

  @override
  void onGestureEvent(GestureEvent event) {
    // print('WakeSentinel.onGestureEvent(${event.runtimeType})');
    if (event is TapUpEvent) {
      isLocked = !isLocked;
      bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }
}
