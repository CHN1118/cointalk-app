// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_db_ret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntList _$IntListFromJson(Map<String, dynamic> json) => IntList(
      list: (json['list'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$IntListToJson(IntList instance) => <String, dynamic>{
      'list': instance.list,
    };

RelationView _$RelationViewFromJson(Map<String, dynamic> json) => RelationView(
      cId: json['cid'] as int,
      channelId: json['channel_id'] as int,
      state: json['state'] as int,
      toNoteName: json['to_note_name'] as String,
    );

Map<String, dynamic> _$RelationViewToJson(RelationView instance) =>
    <String, dynamic>{
      'cid': instance.cId,
      'channel_id': instance.channelId,
      'state': instance.state,
      'to_note_name': instance.toNoteName,
    };

ConsumerInfo _$ConsumerInfoFromJson(Map<String, dynamic> json) => ConsumerInfo(
      cId: json['cid'] as int,
      openId: json['open_id'] as String,
      createdAt: json['created_at'] as int,
      updatedAt: json['updated_at'] as int,
      appUserId: json['app_user_id'] as int,
      businessId: json['business_id'] as int,
      token: json['token'] as String,
      tokenTime: json['token_time'] as int,
      infoJson: Map<String, String>.from(json['info_json'] as Map),
      account: json['account'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      ip: json['ip'] as String,
      avatar: json['avatar'] as String,
      nickname: json['nickname'] as String,
      friendsCIDs:
          (json['FriendsCIDs'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ConsumerInfoToJson(ConsumerInfo instance) =>
    <String, dynamic>{
      'cid': instance.cId,
      'open_id': instance.openId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'app_user_id': instance.appUserId,
      'business_id': instance.businessId,
      'token': instance.token,
      'token_time': instance.tokenTime,
      'info_json': instance.infoJson,
      'account': instance.account,
      'phone': instance.phone,
      'email': instance.email,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'ip': instance.ip,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'FriendsCIDs': instance.friendsCIDs,
    };

SyncDBRet _$SyncDBRetFromJson(Map<String, dynamic> json) => SyncDBRet(
      relationList: (json['relation_list'] as List<dynamic>)
          .map((e) => RelationView.fromJson(e as Map<String, dynamic>))
          .toList(),
      consumerList: (json['consumer_list'] as List<dynamic>)
          .map((e) => Consumer.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateTime: json['update_time'] as int,
      userInfo:
          ConsumerInfo.fromJson(json['user_info'] as Map<String, dynamic>),
      relationAll:
          (json['relation_all'] as List<dynamic>).map((e) => e as int).toList(),
      blacklistAll: (json['blacklist_all'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$SyncDBRetToJson(SyncDBRet instance) => <String, dynamic>{
      'relation_list': instance.relationList,
      'consumer_list': instance.consumerList,
      'update_time': instance.updateTime,
      'user_info': instance.userInfo,
      'relation_all': instance.relationAll,
      'blacklist_all': instance.blacklistAll,
    };
