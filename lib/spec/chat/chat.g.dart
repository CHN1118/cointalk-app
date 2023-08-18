// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelDetail _$ChannelDetailFromJson(Map<String, dynamic> json) =>
    ChannelDetail(
      channel: json['channel'] as String,
      cName: json['cName'] as String,
      payload: json['payload'] as String,
      from_id: json['from_id'] as String,
      from_name: json['from_name'] as String,
      to_id: json['to_id'] as String,
      msg_t: json['msg_t'] as String,
      chat_t: json['chat_t'] as String,
      time: json['time'] as int,
      index: json['index'] as String?,
    );

Map<String, dynamic> _$ChannelDetailToJson(ChannelDetail instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'cName': instance.cName,
      'payload': instance.payload,
      'from_id': instance.from_id,
      'from_name': instance.from_name,
      'to_id': instance.to_id,
      'msg_t': instance.msg_t,
      'chat_t': instance.chat_t,
      'time': instance.time,
      'index': instance.index,
    };

SendParam _$SendParamFromJson(Map<String, dynamic> json) => SendParam(
      channelId: json['channel_id'] as int,
      msgInfo: json['msg_info'],
    );

Map<String, dynamic> _$SendParamToJson(SendParam instance) => <String, dynamic>{
      'channel_id': instance.channelId,
      'msg_info': instance.msgInfo,
    };

MsgInfo _$MsgInfoFromJson(Map<String, dynamic> json) => MsgInfo(
      type: json['type'] as String,
      content: json['content'] as String,
      remark: json['remark'] as String?,
      msgId: json['msg_id'] as String,
      time: json['time'] as int,
      fromId: json['from_id'] as int,
      nickName: json['nickname'] as String,
      avatar: json['avatar'] as String,
      channelId: json['channel_id'] as int,
    );

Map<String, dynamic> _$MsgInfoToJson(MsgInfo instance) => <String, dynamic>{
      'type': instance.type,
      'msg_id': instance.msgId,
      'content': instance.content,
      'remark': instance.remark,
      'time': instance.time,
      'from_id': instance.fromId,
      'nickname': instance.nickName,
      'avatar': instance.avatar,
      'channel_id': instance.channelId,
    };

GroupChatDetail _$GroupChatDetailFromJson(Map<String, dynamic> json) =>
    GroupChatDetail(
      name: json['name'] as String? ?? '',
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => Accounts.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      manager: json['manager'] as int? ?? 0,
    );

Map<String, dynamic> _$GroupChatDetailToJson(GroupChatDetail instance) =>
    <String, dynamic>{
      'name': instance.name,
      'accounts': instance.accounts,
      'manager': instance.manager,
    };

Accounts _$AccountsFromJson(Map<String, dynamic> json) => Accounts(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );

Map<String, dynamic> _$AccountsToJson(Accounts instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'avatar': instance.avatar,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      name: json['name'] as String,
      tagIndex: json['tagIndex'] as String?,
      namePinyin: json['namePinyin'] as String?,
      img: json['img'] as String?,
      id: json['id'] as String?,
    )..isShowSuspension = json['isShowSuspension'] as bool;

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'isShowSuspension': instance.isShowSuspension,
      'name': instance.name,
      'tagIndex': instance.tagIndex,
      'namePinyin': instance.namePinyin,
      'img': instance.img,
      'id': instance.id,
    };

ChannelInfo _$ChannelInfoFromJson(Map<String, dynamic> json) => ChannelInfo(
      adminCId: json['admin_c_id'] as int?,
      bId: json['b_id'] as int?,
      cList: (json['c_list'] as List<dynamic>).map((e) => e as int).toList(),
      createdAt: json['created_at'] as int?,
      id: json['id'] as int?,
      infoJson: (json['info_json'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String?),
      ),
      key: json['key'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      messageIndex: json['message_index'] as int?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      state: json['state'] as int?,
      types: json['types'] as int?,
      updatedAt: json['updated_at'] as int?,
    );

Map<String, dynamic> _$ChannelInfoToJson(ChannelInfo instance) =>
    <String, dynamic>{
      'admin_c_id': instance.adminCId,
      'b_id': instance.bId,
      'c_list': instance.cList,
      'created_at': instance.createdAt,
      'id': instance.id,
      'info_json': instance.infoJson,
      'key': instance.key,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'message_index': instance.messageIndex,
      'name': instance.name,
      'avatar': instance.avatar,
      'state': instance.state,
      'types': instance.types,
      'updated_at': instance.updatedAt,
    };

ConsumerOne _$ConsumerOneFromJson(Map<String, dynamic> json) => ConsumerOne(
      account: json['account'] as String?,
      cid: json['cid'] as int?,
      email: json['email'] as String?,
      infoJson: (json['infoJson'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String?),
      ),
      ip: json['ip'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ConsumerOneToJson(ConsumerOne instance) =>
    <String, dynamic>{
      'account': instance.account,
      'cid': instance.cid,
      'email': instance.email,
      'infoJson': instance.infoJson,
      'ip': instance.ip,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      cid: json['cid'] as int,
      openId: json['open_id'] as String,
      infoJson: json['info_json'] as Map<String, dynamic>,
      account: json['account'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      avatar: json['avatar'] as String,
      nickname: json['nickname'] as String,
      ip: json['ip'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'cid': instance.cid,
      'open_id': instance.openId,
      'info_json': instance.infoJson,
      'account': instance.account,
      'phone': instance.phone,
      'email': instance.email,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'ip': instance.ip,
    };
