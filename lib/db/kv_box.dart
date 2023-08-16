import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api/contact_api.dart';
import '../centre/centre.dart';
import '../spec/chat/chat.dart';
import '../spec/chat/sync_db_ret.dart';

class BoxKey {
  static BoxKey instance = BoxKey();

  static const String ChannelCorner = "channelCorner_"; // 角标
  static const String ChannelTotalCorner = "channelTotalCorner"; // 总角标
  static const String ChannelMute = "channelMute_"; // 频道静音
  static const String Relation = "relation_"; //关系
  static const String UserInfo = "cUserInfo"; //用户信息
  static const String ChannelList = "channelList"; //聊天频道列表
  static const String ChannelIndex = "channelIndex";
  static const String SupportChannelId = "supportChannelId"; //客服频道id
  static const String SupportCid = "supportCid"; //客服cid
  static const String Address = "address"; //地址
}

class KVBox {
  // 大box
  static GetStorage GetBox() {
    return GetStorage();
  }

  // 用户小box
  static GetStorage GetUserBox() {
    // return GetStorage(GetStorage().read("userId").toString());
    return globalCentre.centreDB.ubox;
  }

  // 获取用户userId
  static String GetUserId() {
    GetStorage box = GetBox();
    String userId = box.read("userId").toString();
    print("GetUserId userId = ${userId}");
    return userId;
  }

  // 获取用户cid
  static String GetCid() {
    GetStorage box = GetBox();
    String cid = box.read("cid").toString();
    print("GetCid cid = ${cid}");
    return cid;
  }

  // 获取用户cid
  static int GetCidInt() {
    GetStorage box = GetBox();
    int cid = int.parse(box.read("cid"));
    return cid;
  }

  // 获取当前用户信息
  static UserInfo GetUserInfo() {
    GetStorage box = GetBox();
    UserInfo uInfo = UserInfo.fromJson(box.read(BoxKey.UserInfo));
    print("GetUserInfo uInfo = ${uInfo}");
    return uInfo;
  }

  // 获取频道最新消息下标 int
  static int GetChannelIndex(int channelId) {
    GetStorage ubox = GetUserBox();
    int index = ubox.read("channelIndex" + channelId.toString()) ?? 0;
    print("GetChannelIndex index = ${index}");
    return index;
  }

  // 写入频道最新消息下标 int
  static SetChannelIndex(int channelId, int index) async {
    GetStorage ubox = GetUserBox();
    print("SetChannelIndex index = ${index}");
    await ubox.write("channelIndex" + channelId.toString(), index);
  }

  // 根据消息key获取缓存聊天消息
  static MsgInfo? GetMsgInfo(String msgKey) {
    GetStorage ubox = GetUserBox();
    MsgInfo mi = MsgInfo.fromJson(ubox.read(msgKey));
    print("GetMsgInfo msgInfo = ${mi}");
    return mi;
  }

  // 获取频道信息
  static ChannelInfo GetChannelInfo(int channelId) {
    GetStorage ubox = GetUserBox();
    ChannelInfo channelInfo = ChannelInfo.fromJson(ubox.read('channelInfo_${channelId}'));
    print("GetChannelInfo channelId = ${channelId}");
    print("GetChannelInfo channelInfo = ${channelInfo.toJson().toString()}");
    return channelInfo;
  }

  //获取当前用户是否设置频道免打扰 0 取消静音 1 静音
  static String GetMuteChannel(int channelId) {
    UserInfo userInfo = GetUserInfo();
    String muteFlag = userInfo.infoJson[BoxKey.ChannelMute + channelId.toString()] ?? "0";
    print("GetMuteChannel muteFlag = ${muteFlag}");
    return muteFlag;
  }

  //获取有其他用户的关系数据
  static RelationView GetRelation(int cid) {
    GetStorage ubox = GetUserBox();
    var relation = ubox.read(BoxKey.Relation + cid.toString());
    return RelationView.fromJson(relation);
  }

  //通过cid获取有其他用户的关系数据
  static Future<RelationView> GetRelationToCidAsync(int cid) async {
    GetStorage ubox = GetUserBox();
    try {
      var relation = ubox.read(BoxKey.Relation + cid.toString());
      return RelationView.fromJson(relation);
    } catch (err) {
      var ret = await contactApi().selectConsumerRelationByCid(cid);
      SetRelation(cid, ret.data['data']);
      RelationView relationView = RelationView.fromJson(ret.data['data']);
      return relationView;
    }
  }

  // 获取角标
  static int GetCorner(int channelId) {
    GetStorage ubox = GetUserBox();
    int corner = ubox.read(BoxKey.ChannelCorner + channelId.toString()) ?? 0;
    print("GetCorner corner = ${corner}");
    return corner;
  }

  // 存入角标
  static SetCorner(int channelId, int cornerValue) {
    GetStorage ubox = GetUserBox();
    ubox.write(BoxKey.ChannelCorner + channelId.toString(), cornerValue);
  }

  // 获取总角标
  static int GetTotalCorner() {
    GetStorage ubox = GetUserBox();
    int corner = ubox.read(BoxKey.ChannelTotalCorner) ?? 0;
    print("GetTotalCorner corner = ${corner}");
    return corner;
  }

  // 存入总角标
  static SetTotalCorner(int cornerValue) {
    GetStorage ubox = GetUserBox();
    ubox.write(BoxKey.ChannelTotalCorner, cornerValue);
  }

  // 存入Token
  static SetToken(String token) {
    GetStorage box = GetBox();
    box.write("token", token);
  }

  // 存入ImToken
  static SetImToken(String imToken) {
    GetStorage box = GetBox();
    box.write("im_token", imToken);
  }

// 存入cid
  static SetCid(String cid) {
    GetStorage box = GetBox();
    box.write("cid", cid);
  }

  // 存入userId
  static SetUserId(String userId) async {
    GetStorage box = GetBox();
    await box.write("userId", userId);
  }

  // 存入频道信息
  static SetChannelInfo(String channelId, Map<String, dynamic> channelInfo) {
    GetStorage uBox = GetUserBox();
    uBox.write("channelInfo_" + channelId, channelInfo);
  }

  // 存入人物关系
  static SetRelationAll(String channelId, ChannelInfo channelInfo) {
    GetStorage uBox = GetUserBox();
    uBox.write("channelInfo_" + channelId, channelInfo);
  }

  //存入有其他用户的关系数据
  static SetRelation(int cid, Map<String, dynamic> relationInfo) {
    GetStorage ubox = GetUserBox();
    ubox.write(BoxKey.Relation + cid.toString(), relationInfo);
  }

  //存入置顶聊天频道
  static SetTopChat(int channelId) {
    GetStorage ubox = GetUserBox();
    ubox.write(channelId.toString() + "-isTop", true);
  }

  //取消置顶聊天频道
  static RmvTopChat(int channelId) {
    GetStorage ubox = GetUserBox();
    ubox.remove(channelId.toString() + "-isTop");
  }

  //获取聊天频道列表key
  static List GetChannelList() {
    GetStorage ubox = GetUserBox();
    return ubox.read(BoxKey.ChannelList) ?? [];
  }

  //存入聊天频道列表
  static SetChannelList(List channelList) async {
    GetStorage ubox = GetUserBox();
    await ubox.write(BoxKey.ChannelList, channelList);
  }

  // 获取客服Cid
  static int GetSupportCid() {
    GetStorage ubox = GetUserBox();
    int sCid = ubox.read(BoxKey.SupportCid) ?? 0;
    print("GetSupportCid cid = ${sCid}");
    return sCid;
  }

  // 存入客服Cid
  static SetSupportCid(int sCid) {
    GetStorage ubox = GetUserBox();
    ubox.write(BoxKey.SupportCid, sCid);
  }

  // 获取地址
  static String GetAddress() {
    GetStorage ubox = GetUserBox();
    String add = ubox.read(BoxKey.Address) ?? "";
    print("GetAddress add = ${add}");
    return add;
  }

  // 存入地址
  static SetAddress(String address) {
    GetStorage ubox = GetUserBox();
    ubox.write(BoxKey.Address, address);
  }
}
