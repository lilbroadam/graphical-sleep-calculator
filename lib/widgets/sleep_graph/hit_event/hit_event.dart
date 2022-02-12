import 'package:flutter/gestures.dart';

abstract class GestureEvent {
  get details;
  Offset get localPosition;
}

/* HORIZONATL DRAG EVENTS */

abstract class HorizontalDragEvent extends GestureEvent {}

class HorizontalDragDownEvent extends HorizontalDragEvent {
  DragDownDetails details;
  get localPosition => details.localPosition;
  HorizontalDragDownEvent(this.details);
}

class HorizontalDragStartEvent extends HorizontalDragEvent {
  DragStartDetails details;
  get localPosition => details.localPosition;
  HorizontalDragStartEvent(this.details);
}

class HorizontalDragUpdateEvent extends HorizontalDragEvent {
  DragUpdateDetails details;
  get localPosition => details.localPosition;
  HorizontalDragUpdateEvent(this.details);
}

class HorizontalDragEndEvent extends HorizontalDragEvent {
  DragEndDetails  details;
  get localPosition => null;
  HorizontalDragEndEvent(this.details);
}

class HorizontalDragCancelEvent extends HorizontalDragEvent {
  get details => null;
  get localPosition => null;
  HorizontalDragCancelEvent();
}

/* TAP EVENTS */

abstract class TapEvent extends GestureEvent {}

class TapUpEvent extends TapEvent {
  TapUpDetails details;
  get localPosition => details.localPosition;
  TapUpEvent(this.details);
}
