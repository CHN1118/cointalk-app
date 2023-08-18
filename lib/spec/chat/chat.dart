import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChannelDetail {
  final String channel; // 会话ID
  final String cName; // 通道名
  final String payload; // 消息内容
  final String from_id; // 消息发送方
  final String from_name; // 消息发送方
  final String to_id; // 消息接收方
  // final String to_name; // 消息接收方
  final String msg_t; // 消息类型
  final String chat_t; // 聊天类型
  final int time; // 消息发送时间
  // final String type; // 消息类型
  String? index; // 数据下标

  ChannelDetail(
      {required this.channel,
      required this.cName,
      required this.payload,
      required this.from_id,
      required this.from_name,
      required this.to_id,
      // required this.to_name,
      required this.msg_t,
      required this.chat_t,
      required this.time,
      // required this.type,
      this.index});

  factory ChannelDetail.fromJson(Map<String, dynamic> json) => _$ChannelDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelDetailToJson(this);
}

class ChatListItem {
  final int chat_id; // 会话ID
  final String head_img; // 发送方头像
  final int from; // 消息发送方
  final String from_name; // 消息发送方
  // final String to; // 消息接收方
  // final String to_name; // 消息接收方
  final String time; // 消息发送时间
  String content; // 消息内容
  final String type; // 消息类型
  int corner; // 新消息角标
  int types; //类型=0 单聊，1=群聊
  String mute; // 静音 0 取消静音 1 静音
  // final String chatType; // 会话类型

  ChatListItem(
      {required this.chat_id,
      required this.head_img,
      required this.from,
      required this.from_name,
      // required this.to,
      // required this.to_name,
      required this.time,
      required this.content,
      required this.type,
      required this.corner,
      required this.types,
      this.mute = '1'
      // required this.chatType,
      });
}

@JsonSerializable()
class SendParam {
  @JsonKey(name: 'channel_id')
  int channelId; //频道id
  @JsonKey(name: 'msg_info')
  dynamic msgInfo;

  SendParam({
    required this.channelId,
    required this.msgInfo,
  });

  factory SendParam.fromJson(Map<String, dynamic> json) => _$SendParamFromJson(json);

  Map<String, dynamic> toJson() => _$SendParamToJson(this);
}

@JsonSerializable()
class MsgInfo {
  @JsonKey(name: 'type')
  String type; //消息类型
  @JsonKey(name: 'msg_id')
  String msgId; //消息ID
  @JsonKey(name: 'content')
  String content; //消息内容
  @JsonKey(name: 'remark')
  String? remark; //备注
  @JsonKey(name: 'time')
  int time; //时间
  @JsonKey(name: 'from_id')
  int fromId; //发送方
  @JsonKey(name: 'nickname')
  String nickName; //昵称
  @JsonKey(name: 'avatar')
  String avatar; //头像
  @JsonKey(name: 'channel_id')
  int channelId; //chid

  MsgInfo({
    required this.type,
    required this.content,
    this.remark,
    required this.msgId,
    required this.time,
    required this.fromId,
    required this.nickName,
    required this.avatar,
    required this.channelId,
  });

  factory MsgInfo.fromJson(Map<String, dynamic> json) => _$MsgInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MsgInfoToJson(this);
}

class ChatData {
  String channel;
  String? payload;
  String? type;
  int? time;
  String? from;
  String? to;
  String? index;

  ChatData({
    required this.channel,
    this.payload,
    this.type,
    this.time,
    this.from,
    this.to,
    this.index,
  });
}

@JsonSerializable()
class GroupChatDetail {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: [])
  final List<Accounts> accounts;
  @JsonKey(defaultValue: 0)
  final int manager;

  const GroupChatDetail({
    required this.name,
    required this.accounts,
    required this.manager,
  });

  factory GroupChatDetail.fromJson(Map<String, dynamic> json) => _$GroupChatDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GroupChatDetailToJson(this);
}

@JsonSerializable()
class Accounts {
  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String userName;
  @JsonKey(defaultValue: '')
  final String avatar;

  const Accounts({
    required this.userId,
    required this.userName,
    required this.avatar,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) => _$AccountsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountsToJson(this);
}

@JsonSerializable()
class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  String? img;
  String? id;

  ContactInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.img,
    this.id,
  });

  @override
  String getSuspensionTag() => tagIndex!;
}

// 聊天频道id
@JsonSerializable()
class ChannelInfo {
  ChannelInfo({
    required this.adminCId,
    required this.bId,
    required this.cList,
    this.createdAt,
    this.id,
    this.infoJson,
    this.key,
    this.latitude,
    this.longitude,
    this.messageIndex,
    this.name,
    this.avatar,
    this.state,
    this.types,
    this.updatedAt,
  });

  ///B端id
  @JsonKey(name: 'admin_c_id')
  int? adminCId;

  ///管理员id
  @JsonKey(name: 'b_id')
  int? bId;

  ///频道内成员ID
  @JsonKey(name: 'c_list')
  List<int> cList;
  @JsonKey(name: 'created_at')
  int? createdAt;

  ///频道id
  int? id;
  @JsonKey(name: 'info_json')

  ///基础数据
  Map<String, String?>? infoJson;

  ///频道key 案例
  String? key;

  ///纬度
  double? latitude;

  ///经度
  double? longitude;

  ///消息index
  @JsonKey(name: 'message_index')
  int? messageIndex;

  ///群名
  String? name;
  String? avatar;

  ///状态0=初始状态默认 1=正常/加好友了 -1=屏蔽
  int? state;

  ///类型 0=单聊 2=群聊
  int? types;
  @JsonKey(name: 'updated_at')
  int? updatedAt;

  factory ChannelInfo.fromJson(Map<String, dynamic> json) => _$ChannelInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelInfoToJson(this);
}

///对方用户消息
///
///types.ConsumerOne
@JsonSerializable()
class ConsumerOne {
  ConsumerOne({
    this.account,
    this.cid,
    this.email,
    this.infoJson,
    this.ip,
    this.latitude,
    this.longitude,
    this.phone,
  });

  ///账号名
  String? account;
  int? cid;

  ///邮箱
  String? email;

  ///基础数据
  Map<String, String?>? infoJson;
  String? ip;

  ///纬度
  double? latitude;

  ///经度
  double? longitude;

  ///手机号
  String? phone;
}

/// 用户信息
@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'cid')
  int cid;
  @JsonKey(name: 'open_id')
  String openId;

  @JsonKey(name: 'info_json')
  Map<String, dynamic> infoJson;

  @JsonKey(name: 'account')
  String account;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'longitude')
  double longitude;

  @JsonKey(name: 'latitude')
  double latitude;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'ip')
  String ip;

  UserInfo({
    required this.cid,
    required this.openId,
    required this.infoJson,
    required this.account,
    required this.phone,
    required this.email,
    required this.longitude,
    required this.latitude,
    required this.avatar,
    required this.nickname,
    required this.ip,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}