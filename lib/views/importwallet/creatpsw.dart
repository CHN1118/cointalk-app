// ignore_for_file: unused_field, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/biometricauthentication.dart';
import 'package:wallet/database/index.dart';

class CreatPsw extends StatefulWidget {
  const CreatPsw({super.key});

  @override
  State<CreatPsw> createState() => ICreatPswState();
}

class ICreatPswState extends State<CreatPsw> {
  final TextEditingController _setPswtext = TextEditingController();
  final FocusNode _setPswFocus = FocusNode();
  final TextEditingController _confirmPswtext = TextEditingController();
  final FocusNode _confirmPswFocus = FocusNode();

  var Bio = Biometric();

  bool isEBV = DB.box.read('isEBV'); //是否开启生物识别
  bool isSupported = DB.box.read('isSupported'); //是否支持生物识别

  String availableBiometrics =
      DB.box.read('availableBiometrics') ?? ''; //获取可用的生物识别技术

  @override
  void initState() {
    print(isSupported);
    print(availableBiometrics);
    super.initState();
  }

  @override
  void dispose() {
    _setPswtext.dispose();
    _setPswFocus.dispose();
    _confirmPswtext.dispose();
    _confirmPswFocus.dispose();
    if (DB.box.read('token') == null) {
      DB.box.write('isEBV', false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).requestFocus(FocusNode()), // 点击空白处隐藏键盘
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
          child: SizedBox(
            width: 390.w,
            child: Padding(
              padding: EdgeInsets.only(left: 26.w, right: 26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('创建登录密码',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w900)),
                  SizedBox(height: 15.w),
                  Opacity(
                    opacity: 0.5,
                    child: Text('此密码仅用于本设备上解锁xxapp',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(height: 27.w),
                  Text('设置密码',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400)),
                  SizedBox(height: 10.w),
                  //*设置密码
                  Container(
                    height: 52.w,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    decoration: BoxDecoration(
                      color: AppTheme.themeColor2,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: TextFormField(
                      controller: _setPswtext,
                      // 设置错误文本
                      focusNode: _setPswFocus,
                      cursorHeight: 18.w, // 设置光标高度
                      cursorWidth: 2.0, // 设置光标宽度
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        border: InputBorder.none, // 移除边框
                        hintStyle: TextStyle(color: Colors.grey), // 设置提示文本颜色
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12), // 设置内容内边距
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  Text('确认密码',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400)),
                  SizedBox(height: 10.w),
                  //*确认密码
                  Container(
                    height: 52.w,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    decoration: BoxDecoration(
                      color: AppTheme.themeColor2,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: TextFormField(
                      controller: _confirmPswtext,
                      // 设置错误文本
                      focusNode: _confirmPswFocus,
                      cursorHeight: 18.w, // 设置光标高度
                      cursorWidth: 2.0, // 设置光标宽度
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        border: InputBorder.none, // 移除边框
                        hintStyle: TextStyle(color: Colors.grey), // 设置提示文本颜色
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12), // 设置内容内边距
                      ),
                    ),
                  ),
                  SizedBox(height: 17.w),
                  isSupported
                      ? SizedBox(
                          height: 22.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('开启人脸识别验证',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400)),
                              InkWell(
                                onTap: setFiceID,
                                child: Container(
                                  height: 22.w,
                                  width: 33.w,
                                  padding: EdgeInsets.fromLTRB(0, 3.w, 0, 3.w),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 3.w, right: 3.w),
                                    decoration: BoxDecoration(
                                      color: isEBV
                                          ? AppTheme.themeColor.withOpacity(.8)
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(11.w),
                                    ),
                                    child: Row(
                                      children: [
                                        isEBV
                                            ? const Expanded(child: SizedBox())
                                            : const SizedBox(),
                                        Container(
                                          height: 10.w,
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.w),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setFiceID() async {
    HapticFeedback.heavyImpact();
    bool isYes = await Bio.authenticate();
    print(isYes);
    if (!isYes) return;
    isEBV = !isEBV;
    DB.box.write('isEBV', isEBV);
    setState(() {});
  }
}
