import 'package:flutter/material.dart';

buildtimePicker(
    {BuildContext buildContext,
    Function(int) selected,
    ListWheelChildDelegate listWheelChildDelegate}) {
  return Container(
    width: MediaQuery.of(buildContext).size.width * 0.12,
    height: 50.0,
    child: ListWheelScrollView.useDelegate(
      squeeze: 0.5,
      itemExtent: 25.0,
      diameterRatio: 1.5,
      onSelectedItemChanged: selected,
      controller: FixedExtentScrollController(initialItem: 00),
      // useMagnifier: true,
      childDelegate: listWheelChildDelegate,
    ),
  );
}

ListWheelChildLoopingListDelegate listWheelChildLoopingListDelegate(
    {@required int value}) {
  return ListWheelChildLoopingListDelegate(
      children: List<Widget>.generate(value, (int index) {
    return TimeText(
      text: index.toString(),
    );
  }));
}

class TimeText extends StatelessWidget {
  final String text;

  TimeText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.padLeft(2, '0'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      ),
    );
  }
}
