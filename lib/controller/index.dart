import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage(); //*初始化本地存储

class Controller extends GetxController {
  bool isLogin = false;
  var language = '中文'.obs;

  setLanguage() {
    var lang = box.read('Language');
    if (lang == 'en_US') {
      language.value = 'English';
    } else if (lang == 'zh_CN') {
      language.value = '中文';
    } else if (lang == null) {
      language.value = '中文';
    }
  }

  changeLanguage() {
    var lang = box.read('Language');
    if (lang == 'en_US') {
      box.write('Language', 'zh_CN');
      const locale = Locale('zh', 'CN');
      Get.updateLocale(locale);
    } else if (lang == 'zh_CN') {
      box.write('Language', 'en_US');
      const locale = Locale('en', 'US');
      Get.updateLocale(locale);
    } else {
      box.write('Language', 'zh_CN');
      const locale = Locale('zh', 'CN');
      Get.updateLocale(locale);
    }
    setLanguage();
  }
}
