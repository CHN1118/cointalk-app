import 'package:json_annotation/json_annotation.dart';

part 'message_data.g.dart'; // 自动生成的文件

@JsonSerializable()
class MessageData {
  @JsonKey(name: 'msg_info')
  String msgInfo;

  @JsonKey(name: 'info_id')
  int infoId;

  @JsonKey(name: 'msg_type')
  String msgTypes;

  @JsonKey(name: 'time_unix')
  int timeUnix;

  @JsonKey(name: 'from_cid')
  int from;

  @JsonKey(name: 'channel_id')
  int channelID;

  @JsonKey(name: 'index')
  String index;

  @JsonKey(name: 'db_key')
  String dbKey;

  MessageData(
      {required this.msgInfo,
        required this.infoId,
        required this.msgTypes,
        required this.timeUnix,
        required this.from,
        required this.channelID,
        required this.index,
        required this.dbKey});

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDataToJson(this);
}
