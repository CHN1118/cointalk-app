// ignore_for_file: non_constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallet/common/utils/log.dart';

class Database {
  late GetStorage box = GetStorage();

  late GetStorage ubox;

  databaseAsync() {
    var userID = box.read("userId");
    if (userID != null) {
      GetStorage.init(userID);
      ubox = GetStorage(userID);
    } else {
      Log.log.e("请求接口: userId is null !!!");
    }
  }
}

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var DB = Database();

const storage = FlutterSecureStorage();