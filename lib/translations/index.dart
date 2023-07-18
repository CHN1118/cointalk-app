import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login_nation': 'Nation',
        },
        'zh_CN': {
          'login_nation': '国家和地区',
        }
      };
}
