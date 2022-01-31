import 'package:flutter/cupertino.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';

// TODO implements HitTestable/HitTestTarget or BoxHitTest class?
abstract class Paintable2 {
  // TODO change to e comprehensive hitbox solution
  bool isInteractable;
  Offset offset;

  Paintable2() : isInteractable = true;

  void paint(Canvas canvas, Size size);

  // TODO
  // bool hitTest(GestureEvent, BoxHitTestResult, ...)
  bool hitTest(GestureEvent hitOffset);

  void onGestureEvent(GestureEvent event);
}