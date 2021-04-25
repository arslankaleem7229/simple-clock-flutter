import 'package:flutter/material.dart';

Expanded expandedFloatingActionButton({
  @required Widget widget,
  double elevation = 0,
  @required Color backgroundColor,
  @required Function onClicked,
}) {
  return Expanded(
    child: FloatingActionButton(
      child: widget,
      backgroundColor: backgroundColor,
      elevation: elevation,
      onPressed: onClicked,
    ),
  );
}
