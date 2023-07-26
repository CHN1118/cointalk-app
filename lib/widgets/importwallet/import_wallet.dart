// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/database/index.dart';

class ImportW extends StatefulWidget {
  const ImportW({super.key});

  @override
  State<ImportW> createState() => WImportWState();
}

class WImportWState extends State<ImportW> {
  final TextEditingController wallet_text = TextEditingController();
  final FocusNode wallet_focus = FocusNode();
  bool isFocus = false; //是否聚焦
  bool isWalletShow = true; //是否显示助记词

  @override
  void initState() {
    super.initState();
    wallet_focus.addListener(() {
      setState(() {
        isFocus = wallet_focus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    wallet_text.dispose();
    wallet_focus.dispose();
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
          title: const Text('导入钱包'),
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 60.h),
          width: 390.w,
          height: 844.h,
          child: Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: InkWell(
                  onTap: () {
                    // 震动
                    HapticFeedback.heavyImpact();
                    setState(() {
                      wallet_text.text = '';
                      isWalletShow = !isWalletShow;
                    });
                  },
                  child: Container(
                    width: 160.w,
                    height: 30.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ]),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 100),
                          alignment: isWalletShow
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: SizedBox(
                            width: 78.w,
                            height: 26.w,
                            child: Center(
                              child: Text(
                                isWalletShow ? '密钥' : '助记词',
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff7F8391)),
                              ),
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 100),
                          alignment: isWalletShow
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: 78.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.w),
                                color: const Color(0xff0C666B),
                              ),
                              child: Center(
                                child: Text(
                                  isWalletShow ? '助记词' : '密钥',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(height: 18.h),
                Text(isWalletShow ? '请输入助记词' : '请在离线环境使用冷钱包',
                    style: TextStyle(
                        fontSize: 17.sp, fontWeight: FontWeight.w400)),
                SizedBox(height: 10.h),
                TextField(
                  controller: wallet_text,
                  focusNode: wallet_focus,
                  maxLines: 5, // Set maxLines to null to enable multiple lines
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
                      borderSide:
                          BorderSide(color: AppTheme.themeColor, width: 1.0),
                    ), // Border style
                    enabledBorder: isFocus
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(),
                          )
                        : const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
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
                        isWalletShow ? '提交助记词' : '提交密钥',
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
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

  //* 检查剪贴板中的内容是否为12个助记词
  bool checkFor12Words(String clipboardContent) {
    // 使用正则表达式匹配多个连续空格作为分隔符，并拆分字符串
    List<String> words = clipboardContent
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    print(words);
    print(words.length);
    // 判断是否有且只有12个助记词
    if (words.length == 12) {
      // 在这里可以进一步验证助记词是否在助记词词库中
      // 你可以根据你的实际助记词词库来实现验证逻辑
      return true;
    } else {
      return false;
    }
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

  void Next() {
    dapp.importKetystore(wallet_text.text, '123456', 'Chn1023.');
    return;
    if (isWalletShow) {
      if (wallet_text.text == '') {
        ErrorShow(msg: '请输入助记词');
      } else {
        if (checkFor12Words(wallet_text.text)) {
        } else {
          ErrorShow(msg: '助记词有误');
        }
      }
    } else {
      if (wallet_text.text == '') {
        ErrorShow(msg: '请输入密钥');
      } else {
        print('5e7d9d40baa5a6cc7d28771cdf8c39f30ad32e3a3bae230339aca43fc34502e2'
            .length);
        if (wallet_text.text.length == 64 ||
            wallet_text.text.substring(0, 2) == '0x') {
          String mprivate = wallet_text.text;
          String password = DB.box.read('walletPassword');
          String walletname = DB.box.read('walletName') ?? '';
          dapp.importPrivate(mprivate, walletname, password);
        } else {
          ErrorShow(msg: '密钥有误');
        }
      }
    }
  }
}
