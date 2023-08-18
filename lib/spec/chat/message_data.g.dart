// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageData _$MessageDataFromJson(Map<String, dynamic> json) => MessageData(
      msgInfo: json['msg_info'] as String,
      infoId: json['info_id'] as int,
      msgTypes: json['msg_type'] as String,
      timeUnix: json['time_unix'] as int,
      from: json['from_cid'] as int,
      channelID: json['channel_id'] as int,
      index: json['index'] as String,
      dbKey: json['db_key'] as String,
    );

Map<String, dynamic> _$MessageDataToJson(MessageData instance) =>
    <String, dynamic>{
      'msg_info': instance.msgInfo,
      'info_id': instance.infoId,
      'msg_type': instance.msgTypes,
      'time_unix': instance.timeUnix,
      'from_cid': instance.from,
      'channel_id': instance.channelID,
      'index': instance.index,
      'db_key': instance.dbKey,
    };
