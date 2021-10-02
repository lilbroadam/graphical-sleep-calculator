import 'package:flutter/material.dart';

class ChartData {
  double borderWidth;
  double timeLabelMargin;
  double sleepLabelMargin;

  double gridMinX;
  double gridMaxX;
  double gridMinY;
  double gridMaxY;

  double xAxisX;
  double xAxisYMin;
  double xAxisYMax;
  double yAxisY;
  double yAxisXMin;
  double yAxisXMax;

  ChartData ({
    this.borderWidth,
    this.timeLabelMargin,
    this.sleepLabelMargin,
  });

  void resize(Size size) {
    gridMinX = borderWidth;
    gridMaxX = size.width - borderWidth;
    gridMinY = borderWidth;
    gridMaxY = size.height - borderWidth;

    xAxisX = gridMinX + sleepLabelMargin + borderWidth;
    xAxisYMin = gridMinY;
    xAxisYMax = gridMaxY;
    yAxisY = gridMaxY - sleepLabelMargin - borderWidth;
    yAxisXMin = gridMinX;
    yAxisXMax = gridMaxX;
  }

  // TODO Caluclate the y value of the sleep graph at hour x
  // double yAtX(double x) {}
}
