import 'package:get_storage/get_storage.dart';

import '../api/contact_api.dart';
import '../spec/chat/sync_db_ret.dart';
import 'kv_box.dart';

//关系结数据
class RelationDB {
  //获取有其他用户的关系数据
  static RelationView? GetRelationToCid(int cid, {GetStorage? ubox}) {
    print("cid=====>${cid}");
    ubox ??= KVBox.GetUserBox();
    print("key=====>${"relation_" + cid.toString()}");
    var relationView = ubox.read("relation_" + cid.toString());
    print("relationView=====>${relationView}");
    if (relationView == null) {
      return null;
    }
    return RelationView.fromJson(relationView);
  }

  static SetRelationByCid(int toCid, Map? rvMap, {GetStorage? ubox}) async {
    ubox ??= KVBox.GetUserBox();
    await ubox.write("relation_" + toCid.toString(), rvMap);
  }

  static Future<RelationView?> GetRelationToCidAsync(int cid, {GetStorage? ubox}) async {
    ubox ??= KVBox.GetUserBox();
    try {
      var jsonBytes = ubox.read("relation_" + cid.toString());
      return RelationView.fromJson(jsonBytes);
    } catch (err) {
      var ret = await contactApi().selectConsumerRelationByCid(cid);
      if (ret.data['code'] == 0) {
        ubox.write('relation_' + cid.toString(), ret.data['data']);
        RelationView relationView = RelationView.fromJson(ret.data['data']);
        return relationView;
      } else {
        return null;
      }
    }
  }

  // static Future<void> RelationToCidRefresh(int cid, {GetStorage? ubox}) async {
  //   ubox ??= KVBox.GetUserBox();
  //   var ret = await contactApi().selectConsumerRelationByCid(cid);
  //   if (ret.data['code'] == 0) {
  //     ubox.write('relation_' + cid.toString(), ret.data['data']);
  //   }
  // }

  //获取通讯录
  static List<int> GetRelationCidArr({GetStorage? ubox}) {
    ubox ??= KVBox.GetUserBox();
    return ubox.read("relation_all");
  }

  //获取通讯录
  static List<int> GetBlacklistArr({GetStorage? ubox}) {
    ubox ??= KVBox.GetUserBox();
    return ubox.read("blacklist_all");
  }
}
