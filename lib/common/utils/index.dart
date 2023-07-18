import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

// 语言
class Utils {
  getLanguage() {
    var lang = box.read('Language');
    if (lang == 'en_US') {
      return const Locale('en', 'US');
    } else if (lang == 'zh_CN') {
      return const Locale('zh', 'CN');
    } else {
      return const Locale('zh', 'CN');
    }
  }
}

// 判断是否登录
String checkLoginStatus() {
  // 延迟一段时间模拟登录状态检查
  if (GetStorage().read('token') == null) {
    return '/';
  } else {
    return '/startup';
  }
}

//获取屏幕宽度
double getScreenWidth(BuildContext context, double v) {
  return MediaQuery.of(context).size.width * v;
}

//获取屏幕高度
double getScreenHeight(BuildContext context, double v) {
  return MediaQuery.of(context).size.height * v;
}

//获取状态栏高度
double getStatusBarHeight(BuildContext context) {
  final appBarHeight = AppBar().preferredSize.height; //*appbar高度
  final toolbarHeight = MediaQuery.of(context).padding.top; //*状态栏高度
  return appBarHeight + toolbarHeight;
}

// 判断是否全屏
bool isFullScreen(context) {
  final padding = MediaQuery.of(context).padding;
  var isf = box.read('isFullScreen');
  if (box.read('isFullScreen') != null) {
    return isf;
  } else {
    if (padding.bottom == 0) {
      box.write('isFullScreen', false);
      return false; // 非全屏模式
    } else {
      box.write('isFullScreen', true);
      return true; // 处于全屏模式
    }
  }
  // 判断顶部和底部安全区域是否为零
}

//销毁isFullScreen
void removeFullScreen() {
  box.remove('isFullScreen');
}
