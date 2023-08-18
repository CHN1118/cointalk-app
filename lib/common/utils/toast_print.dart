import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import '../../db/kv_box.dart';

class ToastPrint {
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 12.0,
    );
  }

  static netNone() {
    Fluttertoast.showToast(
      msg: '离线模式: 无网络连接',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Color(0xFF242426),
      textColor: Color(0xFFE84C88),
      fontSize: 14.0,
      timeInSecForIosWeb: 2,
    );
  }

  static netMobile() {
    Fluttertoast.showToast(
      msg: '当前为非Wi-Fi环境, 请注意流量消耗',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Color(0xFF242426),
      textColor: Colors.white,
      fontSize: 14.0,
      timeInSecForIosWeb: 2,
    );
  }

  static  messageFailToast( resp){
    final   GetStorage box = KVBox.GetBox();//*初始化本地存储
    var lang = box.read('Language');
    if (lang == 'zh_CN') {
      // 简体中文
      var message=resp['data']['message_zh'];
      if (message!=null && message!='') {
        show(message);
      }
    }else if (lang == 'en_US') {
      // 英文
      var message=resp['data']['message'];
      if (message!=null && message!='') {
        show(message);
      }
    }else if (lang =='zh_TW') {
      // 繁体中文

      var message=resp['data']['message_zh'];
      if (message!=null && message!='') {
        show(message);
      }

    }
  }
}
