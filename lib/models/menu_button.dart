import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/models/text_widget.dart';

Padding buildMenuButton({@required String image, @required String label}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Column(
        children: [
          Image.asset(image, scale: 1.5),
          SizedBox(height: 16),
          kText(text: label, fontWeight: FontWeight.bold, fontSize: 14)
        ],
      ),
      onPressed: () => print(label),
    ),
  );
}
