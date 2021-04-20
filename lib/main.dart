import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_clock_flutter/enums.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';
import 'package:simple_clock_flutter/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2D2F41),
      ),
      home: ChangeNotifierProvider<MenuInfo>(
        child: HomePage(),
        create: (context) => MenuInfo(MenuType.clock),
      ),
    );
  }
}
