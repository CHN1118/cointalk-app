// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/components/op_click.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => ISuccessState();
}

class ISuccessState extends State<Success> {
  bool isAgree = false; //是否同意协议

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: 44.h),
                  Text(
                    "验证成功!",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    "开始使用区块链钱包",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(8.w, 0),
                  child: OpClick(
                    onTap: () {
                      //震动
                      HapticFeedback.mediumImpact();
                      setState(() {
                        isAgree = !isAgree;
                      });
                    },
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      color: Colors.white,
                      child: Container(
                          margin: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: isAgree ? AppTheme.themeColor : Colors.white,
                            borderRadius: BorderRadius.circular(20.w),
                            border: Border.all(
                              color:
                                  isAgree ? AppTheme.themeColor : Colors.grey,
                              width: 1.w,
                            ),
                          ),
                          child: isAgree
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 8.w,
                                  color: Colors.white,
                                )
                              : null),
                    ),
                  ),
                ),
                Text('我已阅读并同意',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    )),
                //文字下划线
                OpClick(
                  child: Text(
                    '服务及隐私条款',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.themeColor,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed,
                      decorationColor: AppTheme.themeColor,
                      decorationThickness: .8.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            //* 开始
            OpClick(
              onTap: () async {
                Get.offAllNamed('/');
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
                    '开始',
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
    );
  }
}
