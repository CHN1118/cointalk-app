// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/common/style/app_theme.dart';

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
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.only(bottom: 60.h),
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
                SizedBox(height: 33.w),
                //*设置钱包名称
                Stack(
                  children: [
                    Container(
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor2.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4.w),
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
                                  _walletNametext.selection.baseOffset - 1;
                              final TextSelection newSelection =
                                  TextSelection.collapsed(
                                      offset: cursorPosition);
                              setState(() {
                                _walletNametext.value = TextEditingValue(
                                  text: trimmedText,
                                  selection: newSelection,
                                );
                              });
                            }
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            isFocus = true;
                            setState(() {});
                          },
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
                  ],
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
                        '生成助记词',
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

  void Next() {}
}
