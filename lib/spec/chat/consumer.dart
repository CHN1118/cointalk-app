import 'package:json_annotation/json_annotation.dart';

part 'consumer.g.dart';

@JsonSerializable()
class Consumer {
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

  Consumer({
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

  static Consumer createBlank() {
    return Consumer(
        cid: 0,
        openId: "",
        infoJson: {},
        account: "",
        phone: "",
        email: "",
        longitude: 0,
        latitude: 0,
        avatar: "https://ispay-app.oss-cn-beijing.aliyuncs.com/chat_def_head.png",
        nickname: "",
        ip: "");
  }

  // 使用内置的工厂函数 _$ConsumerFromJson将Map转换为Consumer实例
  factory Consumer.fromJson(Map<String, dynamic> json) => _$ConsumerFromJson(json);

  // 使用内置的toJson方法将Consumer实例转换为Map
  Map<String, dynamic> toJson() => _$ConsumerToJson(this);
}

@JsonSerializable()
class PeopleNearbyRespConsumer {
  PeopleNearbyRespConsumer({
    required this.cid,
    required this.avatar,
    required this.nickname,
    required this.distance,
  });

  ///cid
  int? cid;

  ///头像
  String? avatar;

  ///昵称
  String? nickname;

  ///距离
  double? distance;

  factory PeopleNearbyRespConsumer.fromJson(Map<String, dynamic> json) => _$PeopleNearbyRespConsumerFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleNearbyRespConsumerToJson(this);
}

@JsonSerializable()
class PeopleNearbyRespChannel {
  PeopleNearbyRespChannel({
    required this.cid,
    required this.avatar,
    required this.name,
    required this.distance,
  });

  ///cid
  int? cid;

  ///头像
  String? avatar;

  ///昵称
  String? name;

  ///距离
  double? distance;

  factory PeopleNearbyRespChannel.fromJson(Map<String, dynamic> json) => _$PeopleNearbyRespChannelFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleNearbyRespChannelToJson(this);
}