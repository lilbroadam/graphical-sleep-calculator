import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph_painter.dart';

class SleepGraphLeaf extends LeafRenderObjectWidget {

  @override
  RenderSleepGraph createRenderObject(BuildContext context) {
    return new RenderSleepGraph();
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    /* TODO
    renderObject
      ..property1 = value1
      ..property2 = value2;
    */
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(ColorProperty('barColor', barColor));
    // ^ where barColor is an instance variable of this class
  }
}

class RenderSleepGraph extends RenderBox {
  
  RenderSleepGraph();

  // TODO overriding this is unnecessary?
  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(
        Size(constraints.maxWidth, constraints.maxHeight));
  }

  final _painter = SleepGraphPainter();

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    _painter.paint(canvas, size);
    canvas.restore();
  }
}
