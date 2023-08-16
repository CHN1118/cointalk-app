import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 用户信息
@JsonSerializable()
class BusinessUser {
  BusinessUser({
    required this.cid,
    required this.imToken,
    required this.token,
    required this.userId,
  });

  @JsonKey(name: 'cid')

  ///cid
  int cid;
  @JsonKey(name: 'im_token')

  ///imToken
  String imToken;

  @JsonKey(name: 'token')

  ///token
  String token;
  @JsonKey(name: 'userId')

  ///用户Id
  int userId;

  factory BusinessUser.fromJson(Map<String, dynamic> json) => _$BusinessUserFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessUserToJson(this);
}

