// ResetPassword

// ignore_for_file: non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:password_strength/password_strength.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/log.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/components/op_click.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => WResetPasswordState();
}

class WResetPasswordState extends State<ResetPassword> {
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    wallet_focus.addListener(() {
      // 监听确认密码输入框聚焦事件
      isFocus = wallet_focus.hasFocus;
      // isEye = true;
      setState(() {});
    });
    _setPswFocus.addListener(() {
      // 监听确认密码输入框聚焦事件
      isFocus1 = _setPswFocus.hasFocus;
      // isEye = true;
      setState(() {});
    });
    _confirmPswFocus.addListener(() {
      // 监听确认密码输入框聚焦事件
      isFocus2 = _confirmPswFocus.hasFocus;
      // isEye = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    wallet_focus.dispose();
    _setPswFocus.dispose();
    _confirmPswFocus.dispose();
    super.dispose();
  }

  final TextEditingController wallet_text = TextEditingController(); //助记词
  final FocusNode wallet_focus = FocusNode();
  bool isFocus = false; //是否聚焦
  bool isEye = true; //是否显示密码
  bool isFocus2 = false; //是否聚焦
  bool isFocus1 = false; //是否聚焦

  final TextEditingController _setPswtext = TextEditingController(); // 设置密码
  final FocusNode _setPswFocus = FocusNode(); // 密码焦点
  final TextEditingController _confirmPswtext = TextEditingController(); // 确认密码
  final FocusNode _confirmPswFocus = FocusNode(); // 确认密码焦点
  double strength = 0.0; //密码强度

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('重置密码',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w900)),
                    SizedBox(height: 20.h),
                    Text('请输入助记词以便重置密码',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff000000))),
                    SizedBox(height: 20.h),
                    // //*助记词输入框
                    TextField(
                      controller: wallet_text,
                      focusNode: wallet_focus,
                      maxLines:
                          5, // Set maxLines to null to enable multiple lines
                      keyboardType:
                          TextInputType.multiline, // Allow multiline input
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        // hintText: '请输入助记词', // Placeholder text
                        fillColor: AppTheme.themeColor2
                            .withOpacity(.5), // Set the background color
                        filled: true, // Make sure to set filled to true
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.themeColor, width: 1.0),
                        ), // Border style
                        enabledBorder: isFocus
                            ? const OutlineInputBorder(
                                borderSide: BorderSide(),
                              )
                            : const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 47.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                FocusScope.of(context)
                                    .requestFocus(_confirmPswFocus);
                              },
                              onChanged: (String value) {
                                strength = estimatePasswordStrength(value);
                                String trimmedText =
                                    value.replaceAll(' ', ''); // 去除空格
                                if (trimmedText != value) {
                                  final int cursorPosition =
                                      _setPswtext.selection.baseOffset - 1;
                                  final TextSelection newSelection =
                                      TextSelection.collapsed(
                                          offset: cursorPosition);
                                  setState(() {
                                    _setPswtext.value = TextEditingValue(
                                      text: trimmedText,
                                      selection: newSelection,
                                    );
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12), // 设置内容内边距
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
                                        borderRadius:
                                            BorderRadius.circular(2.w),
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
                                color: isFocus2
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
                              onFieldSubmitted: (value) { // 点击键盘完成按钮
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12), // 设置内容内边距
                              ),
                              buildCounter: (BuildContext context,
                                      {int? currentLength,
                                      int? maxLength,
                                      bool? isFocused}) =>
                                  null,
                            ),
                          ),
                        ),
                        if (isFocus2)
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
                                    isEye
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                //*下一步
                Opacity(
                  opacity: 1,
                  child: OpClick(
                    onTap: Next,
                    child: Container(
                      width: 325.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.circular(4.w),
                        boxShadow: [
                          if (isShow)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 1,
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '完成',
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

  //*错误提示
  Future<bool?> ErrorShow({String? msg = '助记词顺序错误'}) {
    return Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0.sp);
  }

  //~提示弹框
  Future<bool?> showSnackBar({String? msg}) {
    return Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT, // 消息框持续的时间
        gravity: ToastGravity.TOP, // 消息框弹出的位置
        timeInSecForIosWeb: 1, // ios
        backgroundColor: const Color(0xffF2F8F5).withOpacity(1),
        textColor: const Color(0xff000000),
        fontSize: 14.sp);
  }

  //* 检查剪贴板中的内容是否为12个助记词
  bool checkFor12Words(String clipboardContent) {
    // 使用正则表达式匹配多个连续空格作为分隔符，并拆分字符串
    List<String> words = clipboardContent
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    // 判断是否有且只有12个助记词
    if (words.length == 12) {
      // 在这里可以进一步验证助记词是否在助记词词库中
      // 你可以根据你的实际助记词词库来实现验证逻辑
      return true;
    } else {
      LLogger.e('助记词有误: $words');
      return false;
    }
  }

  Future<void> Next() async {
    //! 开启加载
    await EasyLoading.show();
    //* 未输入助记词
    if (wallet_text.text == '') {
      await EasyLoading.dismiss();
      ErrorShow(msg: '请输入助记词');
      return;
    }
    //* 助记词不足12个
    if (!checkFor12Words(wallet_text.text)) {
      // 检查剪贴板中的内容是否为12个助记词
      await EasyLoading.dismiss(); // 关闭加载
      ErrorShow(msg: '助记词有误');
      return;
    }
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
        checkFor12Words(wallet_text.text) &&
        wallet_text.text != '' &&
        strength > 0.3) {
      await EasyLoading.dismiss();
      Get.back();
    }
  }
}
