// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/components/op_click.dart';

class Walletname extends StatefulWidget {
  const Walletname({super.key});

  @override
  State<Walletname> createState() => WwalletnameState();
}

class WwalletnameState extends State<Walletname> {
  final TextEditingController _walletNametext = TextEditingController();
  final FocusNode _walletNameFocus = FocusNode();
  bool isFocus = false; //是否聚焦
  @override
  void initState() {
    super.initState();
    // 聚焦
    _walletNameFocus.requestFocus();
    _walletNameFocus.addListener(() {
      setState(() {
        isFocus = _walletNameFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _walletNametext.dispose();
    _walletNameFocus.dispose();
    super.dispose();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('设置钱包名称',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.w900)),
                SizedBox(height: 33.h),
                //*设置钱包名称
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
                    Container(
                      height: 52.w,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Center(
                        child: TextFormField(
                          controller: _walletNametext,
                          focusNode: _walletNameFocus,
                          onChanged: (value) {
                            String trimmedText =
                                value.replaceAll(' ', ''); // 去除空格
                            if (trimmedText != value) {
                              final int cursorPosition =
                                  _walletNametext.selection.baseOffset -
                                      1; // 获取当前光标位置
                              final TextSelection newSelection =
                                  TextSelection.collapsed(
                                      offset: cursorPosition); // 生成新的光标位置
                              setState(() {
                                _walletNametext.value = TextEditingValue(
                                  text: trimmedText,
                                  selection: newSelection,
                                ); // 更新内容
                              });
                            }
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(FocusNode());
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
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
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
                          '生成助记词',
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

  Next() async {
    //! 开启加载
    await EasyLoading.show();
    //* 请输入钱包名称
    if (_walletNametext.text == '') {
      await Future.delayed(const Duration(milliseconds: 500));
      await EasyLoading.dismiss();
      Cdog.show(context, '请输入钱包名称');
      return;
    } else {
      //* 符合条件
      await Future.delayed(const Duration(milliseconds: 500));
      await EasyLoading.dismiss();
      String walletName = _walletNametext.text; // 钱包名称
      String walletPassword = Get.arguments['walletPassword']; // 钱包密码
      bool isEBV = Get.arguments['isEBV']; // 是否是生物识别验证
      showSnackBar(msg: '钱包名称设置成功');
      Get.offNamed('/mnemonic', arguments: {
        'walletName': walletName,
        'walletPassword': walletPassword,
        'isEBV': isEBV,
        'import': Get.arguments['import']
      });
    }
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
}
