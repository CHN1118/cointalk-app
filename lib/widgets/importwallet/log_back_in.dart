// ignore_for_file: non_constant_identifier_names, avoid_print, dead_code, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/biometricauthentication.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/widgets/importwallet/reset_password.dart';

// LogBackIn
class LogBackIn extends StatefulWidget {
  const LogBackIn({super.key});

  @override
  State<LogBackIn> createState() => ILogBackInState();
}

class ILogBackInState extends State<LogBackIn> {
  final TextEditingController _walletNametext = TextEditingController();
  final FocusNode _walletNameFocus = FocusNode();
  bool isFocus = false; //是否聚焦
  bool isEye = true; //是否显示密码
  @override
  void dispose() {
    _walletNametext.dispose();
    _walletNameFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _walletNameFocus.addListener(() {
      setState(() {
        isFocus = _walletNameFocus.hasFocus; //是否聚焦
      });
    });
    // DB.box.remove('WalletList');
    // DB.box.remove('isAgree');
    // DB.box.remove('token');
    // DB.box.remove('im_token');
    // DB.box.remove('userId');
    Biometric(); //检测生物识别
  }

  Biometric() async {
    await C.getWL();
    print('C.currentWallet  ${C.currentWallet['isEBV']}');
    if (C.currentWallet['isEBV'] == true) {
      await Bio.authenticate(); //生物识别
      //生物识别成功
      if (Bio.authorized == 'Authorized') {
        //! 开启加载
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        Get.offAllNamed('/');
        await EasyLoading.dismiss();
      }
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 点击空白处隐藏键盘
        isEye = true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(bottom: 75.h),
          width: 390.w,
          height: 844.h,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/logo.svg',
                      width: 208.947.w,
                      height: 206.4.w,
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      "欢迎回来",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 27.h),
                    Padding(
                      padding: EdgeInsets.only(left: 28.w),
                      child: Row(
                        children: [
                          Text('请输入密码',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 28.w, right: 28.w),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            height: 52.w,
                            width: 331.w,
                            decoration: BoxDecoration(
                              color: AppTheme.themeColor2.withOpacity(.5),
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(
                                  color: isFocus
                                      ? AppTheme.themeColor
                                      : Colors.transparent,
                                  width: 1.w),
                            ),
                            child: SizedBox(
                              height: 52.w,
                              child: Center(
                                child: TextFormField(
                                  controller: _walletNametext,
                                  focusNode: _walletNameFocus,
                                  obscureText: isEye, //隐藏输入内容
                                  obscuringCharacter: '*', //密码替换符号

                                  onChanged: (value) {
                                    String trimmedText =
                                        value.replaceAll(' ', ''); // 去除空格
                                    if (trimmedText != value) {
                                      final int cursorPosition =
                                          _walletNametext.selection.baseOffset -
                                              1; // 获取当前光标位置
                                      final TextSelection newSelection =
                                          TextSelection.collapsed(
                                              offset:
                                                  cursorPosition); // 生成新的光标位置
                                      setState(() {
                                        _walletNametext.value =
                                            TextEditingValue(
                                          text: trimmedText,
                                          selection: newSelection,
                                        ); // 更新内容
                                      });
                                    }
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    isEye = true;
                                    setState(() {});
                                  },
                                  cursorHeight: 18.w, // 设置光标高度
                                  cursorWidth: 2.0, // 设置光标宽度
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none, // 移除边框
                                    hintStyle: TextStyle(
                                        color: Colors.grey), // 设置提示文本颜色
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12), // 设置内容内边距
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isFocus)
                          Positioned(
                              right: 20.w,
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
              ),

              SizedBox(
                height: 15.h,
              ),
              //* 开始
              OpClick(
                onTap: () async {
                  Next();
                },
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
                      '登录',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              //文字下划线
              OpClick(
                onTap: () {
                  Get.to(() => const ResetPassword());
                  //取消焦点
                  FocusScope.of(context).requestFocus(FocusNode());
                  //清空输入框
                  _walletNametext.clear();
                },
                child: Text(
                  '忘记密码',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff0162F8),
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                    decorationColor: const Color(0xff0162F8),
                    decorationThickness: .8.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> Next() async {
    await EasyLoading.show();
    if (_walletNametext.text.isEmpty) {
      await EasyLoading.dismiss();
      await Cdog.show(context, '请输入密码');
      return;
    }
    if (C.currentWallet['isEBV'] == true) {
      String password = await swi.getpassword();
      if (password != _walletNametext.text) {
        await EasyLoading.dismiss();
        await Cdog.show(context, '密码错误');
        return;
      }
      Get.offAllNamed('/');
      await EasyLoading.dismiss();
      return;
    } else {
      String password1 =
          dapp.decryptString(C.currentWallet['keystore'], _walletNametext.text);
      if (password1 == '') {
        await EasyLoading.dismiss();
        await Cdog.show(context, '密码错误');
        return;
      }
      Get.offAllNamed('/');
      await EasyLoading.dismiss();
    }
  }
}
