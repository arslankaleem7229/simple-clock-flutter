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

Padding colonText() {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: kText(
        text: ':',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black),
  );
}
