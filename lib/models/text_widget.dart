import 'package:flutter/material.dart';

Text kText(
    {@required String text,
    @required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    String fontfamily = 'avenir',
    Color color = Colors.white}) {
  return Text(text,
      style: TextStyle(
          fontFamily: fontfamily,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight));
}
