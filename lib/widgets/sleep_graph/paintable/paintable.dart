import 'package:flutter/cupertino.dart';

abstract class Paintable {

  // TODO change to a comprehensive hitbox solution
  bool isInteractable = true;
  double hitBoxMargin = 10.0;
  Offset offset;

  Paintable ();

  void paint(Canvas canvas, Size size);

  bool isHit(Offset hitOffset);
}
