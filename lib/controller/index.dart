import 'dart:ui';
import 'package:get/get.dart';
import 'package:wallet/database/index.dart';

class Controller extends GetxController {
  bool isLogin = false;
  var language = '中文'.obs;

  setLanguage() {
    var lang = DB.box.read('Language');
    if (lang == 'en_US') {
      language.value = 'English';
    } else if (lang == 'zh_CN') {
      language.value = '中文';
    } else if (lang == null) {
      language.value = '中文';
    }
  }

  changeLanguage() {
    var lang = DB.box.read('Language');
    if (lang == 'en_US') {
      DB.box.write('Language', 'zh_CN');
      const locale = Locale('zh', 'CN');
      Get.updateLocale(locale);
    } else if (lang == 'zh_CN') {
      DB.box.write('Language', 'en_US');
      const locale = Locale('en', 'US');
      Get.updateLocale(locale);
    } else {
      DB.box.write('Language', 'zh_CN');
      const locale = Locale('zh', 'CN');
      Get.updateLocale(locale);
    }
    setLanguage();
  }
}
