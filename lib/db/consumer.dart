import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import '../api/contact_api.dart';
import '../spec/chat/consumer.dart';
import 'channel.dart';
import 'kv_box.dart';

class ConsumerDB {
  // 获取对方用户信息 缓存没有就从接口获取
  static Future<Consumer> GetConsumerByCid(GetStorage ubox, int toCid) async {
    try {
      var userInfo = ubox.read("consumer_" + toCid.toString());
      // print("readStr------>${readStr}");
      // var userInfo = jsonDecode(readStr);
      return Consumer.fromJson(userInfo);
    } catch (err) {
      var ret = await contactApi().selectConsumerByCid(toCid);
      if (ret.data['data'] != null && ret.data['data'].isNotEmpty) {
        var consumerInfo = ret.data['data'];
        ubox.write('consumer_' + toCid.toString(), consumerInfo); //写入数据
      }
      return GetCacheConsumerByCid(ubox, toCid);
    }
  }

  // 从本地缓存获取对方用户信息
  static Consumer GetCacheConsumerByCid(GetStorage ubox, int toCid) {
    var userInfo = ubox.read("consumer_" + toCid.toString());
    print("userInfo------>${userInfo}");
    if (userInfo is Consumer) {
      return userInfo;
    } else if (userInfo is Map<String, dynamic>) {
      return Consumer.fromJson(userInfo);
    } else if (userInfo is String) {
      return Consumer.fromJson(jsonDecode(userInfo));
    } else {
      return Consumer.createBlank();
    }
  }

  // 从接口获取对方用户信息
  static Future<Consumer> GetOnlineConsumerByCid(GetStorage ubox, int toCid) async {
    var res = await contactApi().selectConsumerByCid(toCid);
    // if (res.data['data'] != null && res.data['data'].isNotEmpty) {
    var consumerInfo = res.data['data'];
    // print("consumerInfo========"+consumerInfo.toString());
    ubox.write('consumer_' + toCid.toString(), consumerInfo); //写入数据
    return Consumer.fromJson(consumerInfo);
    // }
    // return null;
  }

  //【用户】 检测是否有数据 没有就填充
  static Future<void> ConsumerSolveNull(int cid, {GetStorage? ubox}) async {
    ubox ??= KVBox.GetUserBox();
    if (!ubox.hasData("consumer_" + cid.toString())) {
      var ret = await contactApi().selectConsumerByCid(cid);
      if (ret.data['data'] != null && ret.data['data'].isNotEmpty) {
        ubox.write('consumer_' + cid.toString(), ret.data['data']); //写入数据
      }
    }
  }

  // 获取对方cid
  static Future<int> GetConsumerCid(String channelId) async {
    var ubox = KVBox.GetUserBox();
    var channelInfo = ChannelDB.GetChannelToConsumer(ubox, channelId);
    var myCid = KVBox.GetCidInt();
    print("channelInfo.cList = ${channelInfo.cList}");
    print("myCid = ${myCid}");
    // 找出对方cid
    var toCid = 0;
    channelInfo.cList.forEach((cid) {
      if (cid != myCid) {
        toCid = cid;
      }
    });
    return toCid;
  }
}
