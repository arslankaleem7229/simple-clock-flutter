import 'package:flutter/foundation.dart';
import 'package:simple_clock_flutter/enums.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  String imageSource;
  MenuInfo(this.menuType, {this.imageSource, this.title});

  updateMenuInfo(MenuInfo menuInfo) {
    this.title = menuInfo.title;
    this.menuType = menuInfo.menuType;
    this.imageSource = menuInfo.imageSource;
    notifyListeners();
  }
}
