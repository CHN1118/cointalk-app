import 'package:dio/dio.dart';
import 'dio_util.dart';

class contactApi {
  Dio dio_im = DioUtil.initIM();

  //查找好友
  Future<Response> addContact(String str) async {
    Response result = await dio_im.post('/im/room/consumerQuery', data: {"str": str});
    return Future(() => result);
  }

  //创建单聊
  Future<Response> addChannelChat(int c_id) async {
    Response result = await dio_im.post('/im/room/createChannelOne', data: {"c_id": c_id});

    return Future(() => result);
  }

  //查询频道数据
  Future<Response> selectChannelById(int channel_id) async {
    Response result = await dio_im.post('/im/room/selectChannelById', data: {"channel_id": channel_id});
    return Future(() => result);
  }

  //查询用户信息
  Future<Response> selectConsumerByCid(int c_id) async {
    Response result = await dio_im.post('/im/room/selectConsumerByCid', data: {"c_id": c_id});
    return Future(() => result);
  }

  //查询用户关系
  Future<Response> selectConsumerRelationByCid(int c_id) async {
    Response result = await dio_im.post('/im/room/getToRelation', data: {"c_id": c_id});
    return Future(() => result);
  }

  //更新频道内的好友关系
  Future<Response> updateChannelJsonInfoState(int channel_id, int state) async {
    Response result =
        await dio_im.post('/im/room/updateChannelJsonInfoState', data: {"channel_id": channel_id, "state": state});
    return Future(() => result);
  }
}
