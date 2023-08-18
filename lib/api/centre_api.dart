import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_storage/get_storage.dart';

import '../common/global/global_url.dart';
import '../db/channel.dart';
import '../db/consumer.dart';
import '../db/kv_box.dart';
import '../event/notify_event.dart';
import '../spec/chat/chat.dart';
import '../spec/chat/message_data.dart';
import 'dio_util.dart';

class CentreApi {
  Dio dio = DioUtil.init();
  Dio dio_sync_db = DioUtil.initSyncDB();
  Dio dio_im = DioUtil.initIM();
  final box = KVBox.GetBox();
  final ubox = KVBox.GetUserBox();

  // final int cid = int.parse(KVBox.GetCid());

  // 获取群聊信息
  Future<Response> channelMemberInfo(String channelId) async {
    //print("------------" + dio.options.baseUrl);
    Response result = await dio_im.post('roomServer/channelMemberInfo', data: {"channelId": channelId});

    return Future(() => result);
  }

  // IM转账
  Future<Response> transferIM(String toID, String amount, String state, String types) async {
    Response result = await dio.post('/app/user/imTransfer', data: {
      "toID": toID,
      "amount": amount,
      "state": state,
      "types": types,
    });
    return Future(() => result);
  }

  // 同步客服数据
  Future<Response> supportSync() async {
    Response result = await dio.post('/app/support/info');
    return Future(() => result);
  }

  // 同步数据
  Future<Response> imSyncDB(int update_time) async {
    Response result = await dio_sync_db.post('/im_sync/syncDB', data: {"update_time": update_time});
    return Future(() => result);
  }

  // 创建群聊
  Future<Response> createGroup(List ids, String avatar, String name, String profile) async {
    Response result = await dio_im.post('/im/room/createGroup', data: {
      "id_arr": ids,
      "avatar": avatar,
      "name": name,
      "json_info": {"profile": profile}
    });
    return Future(() => result);
  }

  // 同步数据
  syncData() async {
    final EventBus eventBus = EventBus();
    setGlobalBus(eventBus);
    var lastUserId = ubox.read("userId");
    while (true) {
      if (!GetStorage().hasData("userId")) {
        break;
      }
      if (GetStorage().read("userId") != lastUserId) {
        lastUserId = GetStorage().read("userId");
      }
      Response res = await dio_im.post(Global.syncUrl + '/im_sync/sync');
      List channelList = ubox.read("channelList") ?? [];
      if (res.data['code'] == 0) {
        List list = res.data['data'];
        for (var i = 0; i < list.length; i++) {
          MessageData msgData = MessageData.fromJson(list[i]);
          switch (msgData.msgTypes) {
            // 消息
            case "channel":
              {
                // 获取客服cid
                int sCid = KVBox.GetSupportCid();
                // print("login sCid ======>>> $sCid");
                // 通过客服cid获取客服频道id，并写入缓存
                if (msgData.from == sCid) {
                  ubox.write(BoxKey.SupportChannelId, msgData.infoId);
                }
                var mf = jsonDecode(msgData.msgInfo);
                //查看是否有这个频道
                await ConsumerDB.ConsumerSolveNull(msgData.from); //用户数据空 则填充
                await ChannelDB.ChannelSolveNull(msgData.channelID); //频道数据若空 则填充
                // 发送人不是自己
                if (msgData.from.toString() != box.read("cid").toString()) {
                  // 将角标+1 并写回缓存
                  int corner = ubox.read(BoxKey.ChannelCorner + msgData.infoId.toString()) ?? 0;
                  corner++;
                  ubox.write(BoxKey.ChannelCorner + msgData.infoId.toString(), corner);
                  // eventBus.fire(NotifyEvent(NotifyEvent.refresh_corner));
                }
                //查看是否有这个发送者
                var syncIndex = ubox.read("channelIndex" + msgData.infoId.toString()) ?? 0;
                ubox.write(msgData.infoId.toString() + '-' + (syncIndex + 1).toString(), mf);
                ubox.write("channelIndex" + msgData.infoId.toString(), syncIndex + 1);
                // 新消息排序到最上面
                var channelList1 = List.from(channelList);
                channelList1.forEach((item) {
                  if (item.toString().substring(12) == mf["channel_id"].toString()) {
                    channelList.remove(item);
                  }
                });
                channelList.add("channelIndex${mf["channel_id"]}");
              }
              break;
            case "channel_info":
              {
                await ubox.write("channelInfo_" + msgData.infoId.toString(), jsonDecode(msgData.msgInfo));
              }
              break;
            case "consumer_info":
              {
                await ubox.write("consumer_" + msgData.infoId.toString(), jsonDecode(msgData.msgInfo));
              }
              break;
            case "channel_refresh":
              {
                await ChannelDB.ChannelRefresh(msgData.channelID);
                break;
                // //刷新频道数据通知
                // //调用接口刷新数据
                // var ret = await contactApi().selectChannelById(msgData.infoId);
                // if (ret.data['data'] != null && ret.data['data'].isNotEmpty) {
                //   var channelInfo = ret.data['data'];
                //   ubox.write('channelInfo_' + channelInfo['id'].toString(), channelInfo); //写入数据
                //   // ubox.write(GKey.ChannelCorner + channelInfo['id'].toString(), 0);
                // }
              }
            default:
              break;
          }
        }

        ubox.write("channelList", channelList);
        eventBus.fire(NotifyEvent(msg: NKey.refresh_chat));
        eventBus.fire(NotifyEvent(msg: NKey.refresh_chat_detail));
        eventBus.fire(NotifyEvent(msg: NKey.refresh_corner));
        // print("send 1 tiao xiaoxi");
        // Eventer.instance.eventBus.fire(Notify(EventKeys.refresh_chat));
        // Eventer.instance.eventBus.fire(Notify(EventKeys.refresh_chat_detail));
      } else {
        // await Future.delayed(Duration(seconds: 10));
      }
    }
  }

  // 发送消息
  Future<int> sendData(SendParam sp) async {
    final EventBus eventBus = globalBus;
    try {
      var spJson = sp.toJson();
      Response res = await dio_im.post(
        Global.serviceIMUrl + "/im/room/sendMessage",
        data: spJson,
      );
      if (res.data['code'] == 0) {
        print("发送成功");
        eventBus.fire(NotifyEvent(msg: NKey.refresh_chat));
      }
      return res.data['code'];
    } catch (e) {
      print('发送异常：$e');
      return -1;
    }
  }
}
