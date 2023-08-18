import 'package:get_storage/get_storage.dart';
import 'package:test/test.dart';
// import 'package:flutter_test/flutter_test.dart';

import '../api/account_api.dart';
import '../common/utils/toast_print.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  group('Account', () {
    test('transfer', () async {
      var res = await AccountApi()
          .transfer("0xf32b550067644ff0ec28b1066961948a90f7c4ee", double.parse("50"), "USDT", "yyh123123");
      print("trans test res = $res");
      if (res.data['code'] == 0) {
        ToastPrint.show("转账成功");
      }
    });
  });
}
