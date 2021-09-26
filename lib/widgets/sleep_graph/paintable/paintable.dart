import 'package:flutter/cupertino.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';

// TODO implements HitTestable/HitTestTarget or BoxHitTest class?
abstract class Paintable {

  // TODO change to a comprehensive hitbox solution
  bool isInteractable;
  Offset offset;

  Paintable () : isInteractable = true;

  void paint(Canvas canvas, Size size);

  // TODO
  // bool hitTest(GestureEvent, BoxHitTestResult, ...)
  bool hitTest(GestureEvent hitOffset);

  void onGestureEvent(GestureEvent event);
}
