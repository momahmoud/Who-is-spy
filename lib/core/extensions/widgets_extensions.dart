import 'package:flutter/material.dart';

extension WidgetModifier on Widget {
  Padding paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Padding paddingStart(double value) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: value),
      child: this,
    );
  }

  Padding paddingOnly(
      {double? start, double? end, double? top, double? bottom,}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start ?? 0,
        end: end ?? 0,
        top: top ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }

  Padding paddingEnd(double value) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: value),
      child: this,
    );
  }

  Padding paddingBottom(double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: value),
      child: this,
    );
  }

  Padding paddingTop(double value) {
    return Padding(
      padding: EdgeInsets.only(top: value),
      child: this,
    );
  }

  Padding paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  Padding paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget background(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
      ),
      child: this,
    );
  }

  Widget cornerRadius(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: this,
    );
  }

  Widget align([AlignmentGeometry alignment = Alignment.center]) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }
}
extension ColumnPadding on Column {
  Widget wrapWithPadding({
    double paddingRight = 0.0,
    double paddingLeft = 0.0,
    double paddingBottom = 0.0,
    double paddingTop = 0.0,
    double margin = 0.0,
  }) {
    final List<Padding> paddedChildren = children.map((Widget child) {
      return Padding(
        padding: EdgeInsets.only(
          right: paddingRight,
          left: paddingLeft,
          bottom: paddingBottom,
          top: paddingTop,
        ),
        child: child,
      );
    }).toList();

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: paddedChildren,
    );
  }
}

extension RowPadding on Row {
  Widget wrapWithPadding(
      {
        double paddingRight = 0.0,
        double paddingLeft = 0.0,
        double paddingBottom = 0.0,
        double paddingTop = 0.0,
        double margin = 0.0,
      }) {
    final List<Container> reversedChildren = children
        .map(
          (Widget e) => Container(
        padding: EdgeInsets.only(
          right: paddingRight,
          left: paddingLeft,
          bottom: paddingBottom,
          top: paddingTop,
        ),
        margin: EdgeInsets.all(margin),
        child: e,
      ),
    )
        .toList();
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: reversedChildren,
    );
  }
}

extension WrapCenter on Widget {
  Widget wrapCenter() {
    return Center(
      child: this,
    );
  }
}
