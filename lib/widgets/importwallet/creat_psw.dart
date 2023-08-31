// ignore_for_file: unused_field, non_constant_identifier_names, avoid_print, deprecated_member_use, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:password_strength/password_strength.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/biometricauthentication.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/widgets/importwallet/import_wallet.dart';

class CreatPsw extends StatefulWidget {
  CreatPsw({
    super.key,
    this.title = '创建登录密码',
    this.import = false,
  });
  String title;
  bool? import;
  @override
  State<CreatPsw> createState() => ICreatPswState();
}

class ICreatPswState extends State<CreatPsw> with WidgetsBindingObserver {
  final TextEditingController _setPswtext = TextEditingController(); //设置密码
  final FocusNode _setPswFocus = FocusNode(); //设置密码
  final TextEditingController _confirmPswtext = TextEditingController(); //确认密码
  final FocusNode _confirmPswFocus = FocusNode(); //确认密码

  var Bio = Biometric();

  bool isEBV = false; //是否开启生物识别
  bool isEye = true; //是否显示密码
  bool isFocus = false; //是否聚焦
  bool isFocus1 = false; //是否聚焦
  bool isSupported = DB.box.read('isSupported'); //是否支持生物识别

  String availableBiometrics =
      DB.box.read('availableBiometrics') ?? ''; //获取可用的生物识别技术

  double strength = 0.0; //密码强度

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setPswFocus.requestFocus();
    _setPswFocus.addListener(() {
      isFocus1 = _setPswFocus.hasFocus;
      setState(() {});
    });
    _confirmPswFocus.addListener(() {
      isFocus = _confirmPswFocus.hasFocus;
      isEye = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _setPswtext.dispose();
    _setPswFocus.dispose();
    _confirmPswtext.dispose();
    _confirmPswFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 监听键盘隐藏事件
    final bool isKeyboardOpen =
        WidgetsBinding.instance.window.viewInsets.bottom != 0;
    if (!isKeyboardOpen) {
      isEye = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        isEye = true;
        setState(() {});
      }, // 点击空白处隐藏键盘
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: OpClick(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 75.h),
          width: 390.w,
          height: 844.h,
          child: Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.w900)),
                SizedBox(height: 15.h),
                Opacity(
                  opacity: 0.5,
                  child: Text('此密码仅用于本设备上解锁xxapp',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: 27.h),
                Text('设置密码',
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w400)),
                SizedBox(height: 10.h),
                //*设置密码
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 52.w,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor2.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4.w),
                        border: Border.all(
                            color: isFocus1
                                ? AppTheme.themeColor
                                : Colors.transparent,
                            width: 1.w),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _setPswtext,
                          focusNode: _setPswFocus,
                          obscureText: isEye,
                          obscuringCharacter: '*',
                          maxLength: 18, // 最大长度为18位
                          onEditingComplete: () {
                            // 点击键盘完成按钮
                            FocusScope.of(context)
                                .requestFocus(_confirmPswFocus); // 聚焦确认密码
                          },
                          onChanged: (String value) {
                            strength = estimatePasswordStrength(value);
                            String trimmedText =
                                value.replaceAll(' ', ''); // 去除空格
                            if (trimmedText != value) {
                              final int cursorPosition =
                                  _setPswtext.selection.baseOffset -
                                      1; // 获取光标位置
                              final TextSelection newSelection =
                                  TextSelection.collapsed(
                                      offset: cursorPosition);
                              setState(() {
                                _setPswtext.value = TextEditingValue(
                                  text: trimmedText,
                                  selection: newSelection,
                                ); // 设置新的值
                              });
                            }
                            setState(() {});
                          },
                          cursorHeight: 18.w, // 设置光标高度
                          cursorWidth: 2.0, // 设置光标宽度
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // 移除边框
                            hintStyle:
                                TextStyle(color: Colors.grey), // 设置提示文本颜色
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12), // 设置内容内边距
                          ),
                          buildCounter: (BuildContext context,
                                  {int? currentLength,
                                  int? maxLength,
                                  bool? isFocused}) =>
                              null,
                        ),
                      ),
                    ),
                    if (isFocus1 && _setPswtext.text != '')
                      Positioned(
                          right: 10.w,
                          top: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: 20.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  strength < 0.3
                                      ? '弱'
                                      : strength < 0.7
                                          ? '中'
                                          : '强',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 8.w,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    color: strength < 0.3
                                        ? Colors.red
                                        : strength < 0.7
                                            ? Colors.yellow
                                            : Colors.green,
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                )
                              ],
                            ),
                          ))
                  ],
                ),
                SizedBox(height: 8.h),
                Text('确认密码',
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w400)),
                SizedBox(height: 10.h),
                //*确认密码
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor2.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4.w),
                        border: Border.all(
                            color: isFocus
                                ? AppTheme.themeColor
                                : Colors.transparent,
                            width: 1.w),
                      ),
                    ),
                    if (_setPswtext.text != '' &&
                        _confirmPswtext.text != '' &&
                        _setPswtext.text != _confirmPswtext.text)
                      Positioned(
                        bottom: 2.w,
                        left: 15.w,
                        child: SizedBox(
                          width: 100.w,
                          child: Text('密码不一致',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red)),
                        ),
                      ),
                    Container(
                      height: 52.w,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Center(
                        child: TextFormField(
                          controller: _confirmPswtext,
                          focusNode: _confirmPswFocus,
                          obscureText: isEye,
                          onChanged: (value) {
                            String trimmedText =
                                value.replaceAll(' ', ''); // 去除空格
                            if (trimmedText != value) {
                              final int cursorPosition =
                                  _confirmPswtext.selection.baseOffset - 1;
                              final TextSelection newSelection =
                                  TextSelection.collapsed(
                                      offset: cursorPosition);
                              setState(() {
                                _confirmPswtext.value = TextEditingValue(
                                  text: trimmedText,
                                  selection: newSelection,
                                );
                              });
                            }
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            isEye = true;
                            setState(() {});
                          },
                          obscuringCharacter: '*',
                          maxLength: 18, // 最大长度为18位
                          cursorHeight: 18.w, // 设置光标高度
                          cursorWidth: 2.0, // 设置光标宽度
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // 移除边框
                            hintStyle:
                                TextStyle(color: Colors.grey), // 设置提示文本颜色
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12), // 设置内容内边距
                          ),
                          buildCounter: (BuildContext context,
                                  {int? currentLength,
                                  int? maxLength,
                                  bool? isFocused}) =>
                              null,
                        ),
                      ),
                    ),
                    if (isFocus)
                      Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: OpClick(
                            onTap: () {
                              isEye = !isEye;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60.w,
                              child: Icon(
                                color: const Color(0xFF7F8391),
                                size: 16.sp,
                                isEye ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          )),
                  ],
                ),
                SizedBox(height: 17.h),
                //*开启生物识别
                if (isSupported && availableBiometrics != '')
                  SizedBox(
                    height: 22.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('开启人脸识别验证',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400)),
                        OpClick(
                          onTap: setFiceID,
                          child: Container(
                            height: 22.w,
                            width: 33.w,
                            padding: EdgeInsets.fromLTRB(0, 3.w, 0, 3.w),
                            child: Container(
                              padding: EdgeInsets.only(left: 3.w, right: 3.w),
                              decoration: BoxDecoration(
                                color: isEBV
                                    ? AppTheme.themeColor.withOpacity(.8)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(11.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.1),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
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
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                const Expanded(child: SizedBox()),
                //*下一步
                Center(
                  child: OpClick(
                    onTap: Next,
                    child: Container(
                      width: 325.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.circular(4.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '确认',
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setFiceID() async {
    HapticFeedback.selectionClick(); //震动
    FocusScope.of(context).requestFocus(FocusNode());
    if (isEBV) {
      isEBV = false; //关闭生物识别
      DB.box.write('isEBV', isEBV);
      setState(() {});
      return;
    }
    bool isYes = await Bio.authenticate(); //生物识别
    print('生物识别结果：$isYes');
    if (!isYes) return; //生物识别失败
    isEBV = true; //开启生物识别
    setState(() {});
  }

  Next() async {
    //! 开启加载
    await EasyLoading.show();
    //* 未输入密码
    if (_setPswtext.text == '' && _confirmPswtext.text == '') {
      await EasyLoading.dismiss();
      Cdog.show(context, '请输入密码');
      return;
    }
    //* 两次密码不一致
    if (_setPswtext.text != _confirmPswtext.text) {
      await EasyLoading.dismiss();
      Cdog.show(context, '两次密码不一致');
      return;
    }
    //* 密码强度不够
    if (strength < 0.3) {
      await EasyLoading.dismiss();
      Cdog.show(context, '密码强度不够');
      return;
    }
    //* 完全符合要求
    if (_setPswtext.text == _confirmPswtext.text &&
        _setPswtext.text != '' &&
        _confirmPswtext.text != '' &&
        strength > 0.3) {
      final Map<String, dynamic> arguments = {
        'walletPassword': _setPswtext.text,
        'isEBV': isEBV,
        'import': widget.import,
      };
      await EasyLoading.dismiss();
      if (widget.title == '创建钱包密码') {
        Get.off(() => const ImportW(), arguments: arguments);
      } else {
        Get.offNamed(
          '/walletname',
          arguments: arguments,
        );
      }
    }
  }
}
