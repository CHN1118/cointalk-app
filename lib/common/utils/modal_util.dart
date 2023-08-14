import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

import '../style/common_style.dart';

class ModalUtil {
  ///  显示弹窗
  static Future<bool?> showCircularModal(
      BuildContext context, Widget view) async {
    final completer = Completer<bool>();
    await showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return view;
      },
    ).then((value) {
      if (value != null) {
        completer.complete(value);
      } else {
        completer.complete(false); // 或者你选择的其他默认值
      }
      return completer.future;
    });
    return completer.future;
  }



/// 显示地址选择器 三级的
  static void showAddressPicker(BuildContext context, List locations,
      Function(String, String, String) onAddressChanged) {
    String initProvince = locations[0];
    String initCity = locations[1];
    String? initTown = locations[2];
    Pickers.showAddressPicker(
      context,
      initProvince: initProvince,
      initCity: initCity,
      initTown: initTown,
      onConfirm: (p, c, t) {
        initProvince = p;
        initCity = c;
        initTown = t;
        onAddressChanged(initProvince, initCity, initCity);
      },
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(25, 0, 0, 0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

/// 拼接城市
  static String spliceCityName({String? pname, String? cname, String? tname}) {
    if (strEmpty(pname)) return '不限';
    StringBuffer sb = StringBuffer();
    sb.write(pname);
    if (strEmpty(cname)) return sb.toString();
    sb.write(' - ');
    sb.write(cname);
    if (strEmpty(tname)) return sb.toString();
    sb.write(' - ');
    sb.write(tname);
    return sb.toString();
  }

  /// 字符串为空
  static bool strEmpty(String? value) {
    if (value == null) return true;

    return value.trim().isEmpty;
  }

  static void showCustomDatePicker({
    required BuildContext context,
    DateMode mode = DateMode.YMD,
  required PDuration selectDate,
    required Function(PDuration) onConfirm,
  }) {
    Pickers.showDatePicker(
      context,

      mode: mode,
        selectDate:selectDate,
      suffix: Suffix(years: '', month: '', days: ''),
      pickerStyle: PickerStyle(
        headDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        itemOverlay: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(25, 0, 0, 0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ), //样式
      onConfirm: onConfirm,
    );
  }

}

/// showCircularModal 的标题+关闭按钮
Widget showCircularModalTitle(BuildContext context,String title, onTap) {
  return Container(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 24,
              height: 24,
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: CommonStyle.text_18_black_w400,
        ),
      ],
    ),
  );
}


