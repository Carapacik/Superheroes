import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void checkContainerColor({
  required final Container container,
  required final Color color,
  final Color? secondColor,
}) {
  final String widgetName = "Container";
  expect(
    container.color,
    isNotNull,
    reason: "$widgetName should have not null color property",
  );
  expect(
    container.color,
    secondColor != null ? isOneOrAnother(color, secondColor) : color,
    reason: "$widgetName should have color ${secondColor != null ? "either "
        "$color or $secondColor" : color}",
  );
}


void checkContainerDecorationColor({
  required final Container container,
  required final Color color,
  final Color? secondColor,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).color,
    isNotNull,
    reason: "$widgetName decoration should have not null color",
  );
  expect(
    (container.decoration as BoxDecoration).color,
    secondColor != null ? isOneOrAnother(color, secondColor) : color,
    reason: "$widgetName decoration should have color ${secondColor != null ? "either "
        "$color or $secondColor" : color}",
  );
}


void checkContainerDecorationShape({
  required final Container container,
  required final BoxShape shape,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).shape,
    shape,
    reason: "$widgetName decoration should have shape $shape}",
  );
}

void checkContainerDecorationBorderRadius({
  required final Container container,
  required final BorderRadius borderRadius,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).borderRadius,
    isNotNull,
    reason: "$widgetName decoration should have not null borderRadius",
  );

  expect(
    (container.decoration as BoxDecoration).borderRadius,
    isInstanceOf<BorderRadius>(),
    reason: "$widgetName decoration's borderRadius has type of BorderRadius",
  );

  expect(
    (container.decoration as BoxDecoration).borderRadius as BorderRadius,
    borderRadius,
    reason: "$widgetName decoration's borderRadius should be $borderRadius",
  );
}

void checkContainerBorder({
  required final Container container,
  required final Border border,
  final Border? secondBorder,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).border,
    isInstanceOf<Border>(),
    reason: "$widgetName border should be a Border type",
  );
  expect(
    (container.decoration as BoxDecoration).border as Border,
    secondBorder != null ? isOneOrAnother(border, secondBorder) : border,
    reason: "$widgetName should have border ${secondBorder != null ? "either "
        "$border or $secondBorder" : border}",
  );
}

void checkContainerEdgeInsetsProperties({
  required final Container container,
  final EdgeInsetsCheck? padding,
  final EdgeInsetsCheck? margin,
  final EdgeInsetsCheck? paddingOrMargin,
}) {
  assert(padding != null || margin != null || paddingOrMargin != null);
  if (paddingOrMargin != null) {
    assert(padding == null && margin == null);
  }
  final String widgetName = "Container";
  if (margin != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.margin,
      paramName: "margin",
      edgeInsetsCheck: margin,
    );
  }
  if (padding != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.padding,
      paramName: "padding",
      edgeInsetsCheck: padding,
    );
  }
  if (paddingOrMargin != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.padding ?? container.margin,
      paramName: "margin or padding",
      edgeInsetsCheck: paddingOrMargin,
    );
  }
}

void checkContainerWidthOrHeightProperties({
  required final Container container,
  required final WidthAndHeight widthAndHeight,
  final WidthAndHeight? secondWidthAndHeight,
}) {
  final String widgetName = "Container";
  final widthAndHeightConstraints = BoxConstraints.tightFor(
    width: widthAndHeight.width,
    height: widthAndHeight.height,
  );
  expect(
    container.constraints,
    secondWidthAndHeight != null
        ? isOneOrAnother(
            widthAndHeightConstraints,
            BoxConstraints.tightFor(
              width: secondWidthAndHeight.width,
              height: secondWidthAndHeight.height,
            ),
          )
        : widthAndHeightConstraints,
    reason: "$widgetName should have ${secondWidthAndHeight != null ? "either "
        "width ${widthAndHeight.width} and height ${widthAndHeight.height} or "
        "width ${secondWidthAndHeight.width} and height "
        "${secondWidthAndHeight.height}" : "width "
        "${widthAndHeight.width} and height ${widthAndHeight.height}"}",
  );
}

void checkContainerAlignment({
  required final Container container,
  required final Alignment alignment,
}) {
  final String widgetName = "Container";
  expect(
    container.alignment,
    isNotNull,
    reason: "$widgetName should have not null alignment property",
  );
  expect(
    container.alignment,
    alignment,
    reason: "$widgetName should have alignment $alignment",
  );
}

void checkEdgeInsetParam({
  required final String widgetName,
  required final EdgeInsetsGeometry? param,
  required final String paramName,
  required final EdgeInsetsCheck edgeInsetsCheck,
}) {
  expect(
    param,
    isNotNull,
    reason: "$widgetName should have not null $paramName",
  );
  expect(
    param,
    isInstanceOf<EdgeInsets>(),
    reason: "$widgetName $paramName should be EdgeInsets type",
  );

  if (edgeInsetsCheck.top != null) {
    _checkOneEdgeInsetParam(
      widgetName: widgetName,
      paramName: paramName,
      sideName: "top",
      actualValue: (param as EdgeInsets).top,
      rightValue: edgeInsetsCheck.top!,
    );
  }
  if (edgeInsetsCheck.bottom != null) {
    _checkOneEdgeInsetParam(
      widgetName: widgetName,
      paramName: paramName,
      sideName: "bottom",
      actualValue: (param as EdgeInsets).bottom,
      rightValue: edgeInsetsCheck.bottom!,
    );
  }
  if (edgeInsetsCheck.left != null) {
    _checkOneEdgeInsetParam(
      widgetName: widgetName,
      paramName: paramName,
      sideName: "left",
      actualValue: (param as EdgeInsets).left,
      rightValue: edgeInsetsCheck.left!,
    );
  }
  if (edgeInsetsCheck.right != null) {
    _checkOneEdgeInsetParam(
      widgetName: widgetName,
      paramName: paramName,
      sideName: "right",
      actualValue: (param as EdgeInsets).right,
      rightValue: edgeInsetsCheck.right!,
    );
  }
}

void _checkOneEdgeInsetParam({
  required final String widgetName,
  required final String paramName,
  required final String sideName,
  required final double? actualValue,
  required final double rightValue,
}) {
  expect(
    actualValue,
    rightValue,
    reason: "$widgetName $paramName should have $sideName value of $rightValue",
  );
}

void _checkTextStyleProperty<T>({
  required final String widgetName,
  required final T? property,
  required final String propertyName,
  required final T rightValue,
  final T? secondRightValue,
}) {
  expect(
    property,
    isNotNull,
    reason: "The style of $widgetName should have not null $propertyName property",
  );
  expect(
    property,
    secondRightValue != null ? isOneOrAnother(rightValue, secondRightValue) : rightValue,
    reason: "The style of $widgetName should have $propertyName "
        "${secondRightValue != null ? "either $rightValue or $secondRightValue" : rightValue}",
  );
}

class EdgeInsetsCheck {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const EdgeInsetsCheck({this.top, this.bottom, this.left, this.right});

  @override
  String toString() {
    return 'EdgeInsetsCheck{top: $top, bottom: $bottom, left: $left, right: $right}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EdgeInsetsCheck &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          bottom == other.bottom &&
          left == other.left &&
          right == other.right;

  @override
  int get hashCode => top.hashCode ^ bottom.hashCode ^ left.hashCode ^ right.hashCode;
}

class WidthAndHeight {
  final double? width;
  final double? height;

  WidthAndHeight({this.width, this.height});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidthAndHeight &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'WidthAndHeight{width: $width, height: $height}';
  }
}
