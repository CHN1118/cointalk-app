import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../db/kv_box.dart';

class Hash{
  static String genMsgHashId() {
    var bUid = KVBox.GetUserId();
    var cUid = KVBox.GetCid();
    var now = DateTime.now().millisecondsSinceEpoch;
    var bytes = utf8.encode(bUid + cUid + now.toString()); // 任何字符串
    var digest = sha256.convert(bytes); // 使用SHA256哈希
    var hash = digest.toString();
    return hash;
  }
}