// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consumer _$ConsumerFromJson(Map<String, dynamic> json) => Consumer(
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

Map<String, dynamic> _$ConsumerToJson(Consumer instance) => <String, dynamic>{
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

PeopleNearbyRespConsumer _$PeopleNearbyRespConsumerFromJson(
        Map<String, dynamic> json) =>
    PeopleNearbyRespConsumer(
      cid: json['cid'] as int?,
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PeopleNearbyRespConsumerToJson(
        PeopleNearbyRespConsumer instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'distance': instance.distance,
    };

PeopleNearbyRespChannel _$PeopleNearbyRespChannelFromJson(
        Map<String, dynamic> json) =>
    PeopleNearbyRespChannel(
      cid: json['cid'] as int?,
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PeopleNearbyRespChannelToJson(
        PeopleNearbyRespChannel instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'avatar': instance.avatar,
      'name': instance.name,
      'distance': instance.distance,
    };
