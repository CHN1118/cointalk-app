import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../centre/centre.dart';

class Database {
  late GetStorage box = GetStorage();

  late GetStorage ubox;

  // databaseAsync() {
  //   var userID = box.read("userId");
  //   if (userID != null) {
  //     Log.log.e("databaseAsync userId === $userID");
  //     GetStorage.init(userID);
  //     ubox = GetStorage(userID);
  //   } else {
  //     ubox = GetStorage();
  //     Log.log.e("userId is null !!!");
  //   }
  // }
  Future databaseAsync() async {
    box = GetStorage();
    globalCentre.centreDB.box = box;
    if (!box.hasData("userId")) {
      print("userId is not exist");
      return Future(() => null);
    }
    var userID = box.read("userId").toString();
    // String userID = box.read("userId");
    // uid = box.read("userId");
    print("Database userId==============================${box.read("userId")}");
    if (userID != '') {
      // open userBox in database
      await GetStorage.init(userID);
      print("GetStorage userId==============================${userID}");
      ubox = GetStorage(userID);
      globalCentre.centreDB.ubox = ubox;
    }
    return Future(() => null);
  }
}

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var DB = Database();

const storage = FlutterSecureStorage();
