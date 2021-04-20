import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:simple_clock_flutter/enums.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';
import 'package:simple_clock_flutter/screens/home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  //initialize all packages before app starting
  WidgetsFlutterBinding.ensureInitialized();
  //initialize settings for android
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('appicon');
  //initialize settings for IOS

  IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestBadgePermission: true,
    requestSoundPermission: true,
    requestAlertPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {},
  );
  //deploying all operating system's setting

  InitializationSettings initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) async {
      if (payload != null) {
        debugPrint('notification payload ' + payload);
      }
    },
  );
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
