// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/common/style/app_theme.dart';

class ImportW extends StatefulWidget {
  const ImportW({super.key});

  @override
  State<ImportW> createState() => WImportWState();
}

class WImportWState extends State<ImportW> {
  String mnemonic = ''; //助记词
  List<String> mnemonicArr = List.generate(12, (index) => '');

  bool isFocus = false; //是否聚焦

  @override
  void initState() {
    super.initState();
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
        body: Container(
          padding: EdgeInsets.only(bottom: 60.h),
          width: 390.w,
          height: 844.h,
          child: Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 56.w),
                Center(
                  child: Text('导入钱包',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w900)),
                ),
                SizedBox(height: 18.w),
                //*设置钱包名称
                Wrap(
                  spacing: 12.h,
                  runSpacing: 12.h,
                  children: mnemonicArr.asMap().entries.map((entry) {
                    int index = entry.key;
                    String item = entry.value;
                    return InkWell(
                      onTap: () {
                        showBottomSheet();
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
                                item,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
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
                    ),
                    child: Center(
                      child: Text(
                        '提交助记词',
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

  // 从系统剪贴板中获取内容，并处理粘贴操作
  void pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      // 这里可以处理粘贴的文本内容，比如将其显示在界面上
      if (checkFor12Words(data.text!)) {
        mnemonic = data.text!;
        mnemonicArr = mnemonic
            .split(RegExp(r'\s+'))
            .where((word) => word.isNotEmpty)
            .toList();
      } else {
        ErrorShow(msg: '助记词有误');
      }
      setState(() {});
    }
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
        backgroundColor: Colors.red.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 14.0.sp);
  }

  //显示底部弹框的功能
  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return MyWidget();
        },
        context: context);
  }

  void Next() {}
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      color: Colors.pink,
    );
  }
}
