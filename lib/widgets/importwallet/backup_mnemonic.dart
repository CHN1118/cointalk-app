// ignore_for_file: non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/database/index.dart';

class BackupMnemonic extends StatefulWidget {
  const BackupMnemonic({super.key});

  @override
  State<BackupMnemonic> createState() => WBackupMnemonicState();
}

class WBackupMnemonicState extends State<BackupMnemonic> {
  String mnemonic = Get.arguments['mnemonic'];
  List<Map<dynamic, dynamic>> mnemonicArr = [];
  List<Map<dynamic, dynamic>> nullMnemonicArr = [];
  List<int> shuffledList = List.generate(12, (index) => index);
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    mnemonicArr = mnemonic.split(' ').asMap().entries.map((entry) {
      final int index = entry.key;
      final String item = entry.value;
      const bool isClick = false;
      return Map<dynamic, dynamic>.from(
          {'item': item, 'isClick': isClick, 'index': index});
    }).toList();
    nullMnemonicArr = mnemonic.split(' ').asMap().entries.map((entry) {
      final int index = entry.key;
      const bool isCorrect = false;
      return Map<dynamic, dynamic>.from(
          {'item': '', 'isCorrect': isCorrect, 'index': index});
    }).toList();
    shuffledList.shuffle();
  }

  @override
  void dispose() {
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
                Text('验证助记词',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.w900)),
                Text('请按顺序点击助记词，以确认您备份的助记词正确',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.6))),
                SizedBox(height: 20.h),
                //*助记词内容
                Wrap(
                  spacing: 12.h,
                  runSpacing: 12.h,
                  children: nullMnemonicArr.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<dynamic, dynamic> item = entry.value;
                    return InkWell(
                      onTap: () {
                        removeItem(item, index);
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 2) -
                            6.h -
                            26.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                              color: AppTheme.themeColor, width: 1.w),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 40.w,
                              height: 40.w,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.w, top: 5.w),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.themeColor),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                item['item'],
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            item['isCorrect']
                                ? Positioned(
                                    top: 2.h,
                                    right: 2.h,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20.w,
                                    ),
                                  )
                                : (item['item'] != '')
                                    ? Positioned(
                                        top: 2.h,
                                        right: 2.h,
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20.w,
                                        ),
                                      )
                                    : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                //*助记词输入框
                Wrap(
                  spacing: 8.h,
                  runSpacing: 8.h,
                  children: shuffledList.asMap().entries.map((entry) {
                    final int item = entry.value;
                    return InkWell(
                      onTap: () {
                        addItem(item);
                      },
                      child: Opacity(
                        opacity: mnemonicArr[item]['isClick'] ? 0.2 : 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.h, 10.h, 15.h, 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            border: Border.all(
                                color: AppTheme.themeColor2, width: 1.w),
                          ),
                          child: Text(
                            mnemonicArr[item]['item'],
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Expanded(child: SizedBox()),
                //*下一步
                Opacity(
                  opacity: isShow ? 1 : .3,
                  child: InkWell(
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

  //*检索nullMnemonicArr中是否有错误的助记词
  bool isNullMnemonicArrError() {
    bool isNullMnemonicArrError = false;
    for (var i = 0; i < nullMnemonicArr.length; i++) {
      if (nullMnemonicArr[i]['isCorrect'] == false) {
        isNullMnemonicArrError = true;
        break;
      }
    }
    return isNullMnemonicArrError;
  }

  //*点击填入助记词
  void addItem(int item) {
    return setState(() {
      //?已经点击过的助记词不能再点击
      if (mnemonicArr[item]['isClick'] == true) {
        return;
      }
      //?把点击的助记词的点击状态改为true
      mnemonicArr[item]['isClick'] = true;
      //?找到第一个空的助记词在助记词列表中的下标
      int index =
          nullMnemonicArr.indexWhere((element) => element['item'] == '');
      //?把点击的助记词放到空的助记词中
      nullMnemonicArr[index]['item'] = mnemonicArr[item]['item'];
      //?判断已经填入的是否有错误
      bool isCorrect = false;
      for (var i = 0; i < index; i++) {
        //?如果已经填入的助记词有错误，就把isCorrect改为false,并跳出循环
        if (nullMnemonicArr[i]['isCorrect'] == false) {
          isCorrect = false;
          break;
        } else {
          isCorrect = true;
        }
      }
      //?如果已经填入的助记词没有错误，就判断当前填入的助记词是否正确,上面设置了初始值为false,所以index==0时和isCorrect为true时都会执行
      if (isCorrect || index == 0) {
        nullMnemonicArr[index]['isCorrect'] =
            nullMnemonicArr[index]['item'] == mnemonic.split(' ')[index];
        //?如果不正确就提示错误
        if (nullMnemonicArr[index]['item'] != mnemonic.split(' ')[index]) {
          ErrorShow();
        }
      } else {
        //?如果已经填入的助记词有错误，就把当前填入的助记词的isCorrect改为false
        nullMnemonicArr[index]['isCorrect'] = false;
        ErrorShow();
      }
      isShow = !isNullMnemonicArrError();
    });
  }

  //*点击删除助记词
  void removeItem(Map<dynamic, dynamic> item, int index) {
    return setState(() {
      //?如果点击的助记词是空的，就不做任何操作
      if (item['item'] != '') {
        //?记录当前点击的助记词的状态
        //?声明一个变量，用来判断前面的助记词是否都是正确的
        bool isCorrect = false;
        for (var i = 0; i < index; i++) {
          if (nullMnemonicArr[i]['item'] == mnemonic.split(' ')[i] &&
              nullMnemonicArr[i]['item'] != '') {
            isCorrect = true;
          } else {
            isCorrect = false;
            break; //?只要有一个不正确就跳出循环
          }
        }
        //?如果前面的助记词都是正确的
        if (isCorrect || index == 0) {
          //?如果点击去掉的这个助记词是正确的
          if (item['isCorrect']) {
            //?判断点击的该助记词是不是最后一个，不是就先报错，再把从当前往后的助记词的isCorrect改为fals
            if (index != 11) {
              if (nullMnemonicArr[index + 1]['item'] != '') {
                ErrorShow();
                for (var i = index; i < nullMnemonicArr.length; i++) {
                  nullMnemonicArr[i]['isCorrect'] = false;
                }
              }
            }
          } else {
            for (var i = index + 1; i < nullMnemonicArr.length; i++) {
              if (nullMnemonicArr[i]['item'] == mnemonic.split(' ')[i - 1] &&
                  nullMnemonicArr[i]['item'] != '') {
                //?如果后面的不为空并且连续的助记词都是正确的，就把isCorrect改为true
                nullMnemonicArr[i]['isCorrect'] = true;
              } else {
                if (nullMnemonicArr[i]['item'] != '') {
                  ErrorShow();
                }
                nullMnemonicArr[i]['isCorrect'] = false;
                break;
              }
            }
          }
        } else {
          ErrorShow();
          //?如果前面的助记词有错误的，就把后面的助记词的isCorrect改为false
          for (var i = index; i < nullMnemonicArr.length; i++) {
            nullMnemonicArr[i]['isCorrect'] = false;
          }
        }
        //?找到点击的助记词在助记词列表中的下标
        int i = mnemonicArr
            .indexWhere((element) => element['item'] == item['item']);
        //?把点击的助记词的点击状态改为false
        mnemonicArr[i]['isClick'] = false;
        //?把点击的助记词的内容改为空
        item['item'] = '';
        //?把点击的助记词是否正确改为false
        item['isCorrect'] = false;
        //?点击删除了中间的助记词，就把后面的助记词向前移动
        nullMnemonicArr.sort((a, b) {
          if (a['item'] == '') {
            return 1;
          } else {
            return -1;
          }
        });
      }
      isShow = !isNullMnemonicArrError();
    });
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

  Future<void> Next() async {
    if (!isShow) {
      return;
    }
    String walletName = Get.arguments['walletName']; // 钱包名称
    String walletPassword = Get.arguments['walletPassword']; // 钱包密码
    bool isEBV = Get.arguments['isEBV'];
    var walletInfo =
        await dapp.importMnemonic(mnemonic, walletName, walletPassword, isEBV);
    swi.addWalletInfo(walletInfo);
  }
}
