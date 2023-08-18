import 'package:get_storage/get_storage.dart';

import '../api/contact_api.dart';
import '../spec/chat/chat.dart';
import '../spec/chat/consumer.dart';
import 'consumer.dart';
import 'kv_box.dart';

class ChannelDB{
  //通过频道Id获取频道Info
  static ChannelInfo GetChannelToConsumer(GetStorage ubox,String channelID){
    var channelInfo = ubox.read('channelInfo_' + channelID);
    print("channelInfo-----------------------------------------");
    print(channelInfo);
    print("channelInfo-----------------------------------------");
   return ChannelInfo.fromJson(channelInfo);
  }

  // 获取单聊的对方个人信息
  static Future<Consumer> GetConsumer(GetStorage ubox,ChannelInfo channelInfo,int myCid) async {
    // 找出对方cid
    var toCid = 0;
    channelInfo.cList.forEach((cid) {
      if(cid != myCid){
        toCid = cid;
      }
    });
    return await ConsumerDB.GetConsumerByCid(ubox,toCid);
  }

  // 从本地缓存获取用户信息
  static Consumer GetCacheConsumer(GetStorage ubox,ChannelInfo channelInfo,int myCid)  {
    print("myCid = ${myCid}");
    // 找出对方cid
    var toCid = 0;
    channelInfo.cList.forEach((cid) {
      if(cid != myCid){
        toCid = cid;
      }
    });
    print("toCid = ${toCid}");
    return ConsumerDB.GetCacheConsumerByCid(ubox,toCid);
  }

  //【频道】 检查是否有频道数据 没有则填充
  static Future<void> ChannelSolveNull(int channelId) async {
    GetStorage ubox = KVBox.GetUserBox();
    if (!ubox.hasData("channelInfo_" + channelId.toString())) {
      var ret = await contactApi().selectChannelById(channelId);
      if (ret.data['data'] != null && ret.data['data'].isNotEmpty) {
        ubox.write('channelInfo_' + channelId.toString(), ret.data['data']); //写入数据
      }
    }
  }
  //【频道】 检查是否有频道数据 没有则填充
  static Future<void> ChannelRefresh(int channelId) async {
    GetStorage ubox = KVBox.GetUserBox();
    var ret = await contactApi().selectChannelById(channelId);
    if (ret.data['data'] != null && ret.data['data'].isNotEmpty) {
      ubox.write('channelInfo_' + channelId.toString(), ret.data['data']); //写入数据
    }
  }
}