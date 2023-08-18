import 'package:json_annotation/json_annotation.dart';

import 'consumer.dart';

part 'sync_db_ret.g.dart'; // 自动生成的文件

@JsonSerializable()
class IntList {
  List<int> list;

  IntList({required this.list});

  factory IntList.fromJson(Map<String, dynamic> json) => _$IntListFromJson(json);

  Map<String, dynamic> toJson() => _$IntListToJson(this);
}

typedef MpsStr = Map<String, String>;


@JsonSerializable()
class RelationView {
  @JsonKey(name: 'cid')
  int cId;

  @JsonKey(name: 'channel_id')
  int channelId;

  @JsonKey(name: 'state')
  int state;

  @JsonKey(name: 'to_note_name')
  String toNoteName;

  RelationView({
    required this.cId,
    required this.channelId,
    required this.state,
    required this.toNoteName,
  });

  factory RelationView.fromJson(Map<String, dynamic> json) => _$RelationViewFromJson(json);

  Map<String, dynamic> toJson() => _$RelationViewToJson(this);
}

@JsonSerializable()
class ConsumerInfo {
  @JsonKey(name: 'cid')
  int cId;

  @JsonKey(name: 'open_id')
  String openId;

  @JsonKey(name: 'created_at')
  int createdAt;

  @JsonKey(name: 'updated_at')
  int updatedAt;

  @JsonKey(name: 'app_user_id')
  int appUserId;

  @JsonKey(name: 'business_id')
  int businessId;

  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'token_time')
  int tokenTime;

  @JsonKey(name: 'info_json')
  Map<String, String> infoJson;

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

  @JsonKey(name: 'ip')
  String ip;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'FriendsCIDs')
  List<int> friendsCIDs;

  ConsumerInfo({
  required  this.cId,
  required  this.openId,
  required  this.createdAt,
  required  this.updatedAt,
  required  this.appUserId,
  required  this.businessId,
  required  this.token,
  required  this.tokenTime,
  required  this.infoJson,
  required  this.account,
  required  this.phone,
  required  this.email,
  required  this.longitude,
  required  this.latitude,
  required  this.ip,
  required  this.avatar,
  required  this.nickname,
  required  this.friendsCIDs,
  });

  factory ConsumerInfo.fromJson(Map<String, dynamic> json) =>
      _$ConsumerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConsumerInfoToJson(this);
}


@JsonSerializable()
class SyncDBRet {
  @JsonKey(name: 'relation_list')
  List<RelationView> relationList;

  @JsonKey(name: 'consumer_list')
  List<Consumer> consumerList;

  @JsonKey(name: 'update_time')
  int updateTime;

  @JsonKey(name: 'user_info')
  ConsumerInfo userInfo;

  @JsonKey(name: 'relation_all')
  List<int> relationAll;

  @JsonKey(name: 'blacklist_all')
  List<int> blacklistAll;

  SyncDBRet({
  required  this.relationList,
  required  this.consumerList,
  required  this.updateTime,
  required  this.userInfo,
  required  this.relationAll,
  required  this.blacklistAll,
  });

  factory SyncDBRet.fromJson(Map<String, dynamic> json) =>
      _$SyncDBRetFromJson(json);

  Map<String, dynamic> toJson() => _$SyncDBRetToJson(this);
}