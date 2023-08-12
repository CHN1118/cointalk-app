import '../api/centre_api.dart';
import '../database/index.dart';
import '../db/kv_box.dart';

late Centre globalCentre;

class Centre {
  Database centreDB = Database();

  static Future prepare() async {
    // db prepare

    globalCentre = Centre();
    await Database().databaseAsync();
    // final EventBus eventBus = EventBus();
    // setGlobalBus(eventBus);
    final box = KVBox.GetBox();
    // if (box.hasData("userId") && box.hasData("token") && box.hasData("im_token")) {
    if (box.hasData("userId")) {
      CentreApi().syncData();
    }
  }
}
