// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessUser _$BusinessUserFromJson(Map<String, dynamic> json) => BusinessUser(
      cid: json['cid'] as int,
      imToken: json['im_token'] as String,
      token: json['token'] as String,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$BusinessUserToJson(BusinessUser instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'im_token': instance.imToken,
      'token': instance.token,
      'userId': instance.userId,
    };
