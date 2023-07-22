// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/event/index.dart';

List<String> coinName = ['USDT', 'BTC', 'USDC', 'ETH', 'BCH'];

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Future<void> _handleRefresh() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  bool isColdWallet = false; //是否冷钱包
  bool isEye = false; //是否显示资产
  bool isEyeAssets = false; //是否显示资产单选框

  double balance = 2345855.0512;
  double balance1 = 0.16088439;
  double isBtns = 0;

  List<String> btns = ['购买', '兑换', '接收', '发送'];

  final oCcy = NumberFormat("#,###.####", "en_US");
  final oCcy1 = NumberFormat("#,###.##########", "en_US");
  final oCcy2 = NumberFormat("#,###.##", "en_US");
  String maskString(String originalString, String maskChar) {
    return originalString.replaceAll(RegExp('[0-9.]'), maskChar);
  }

  @override
  void initState() {
    super.initState();
    bus.on("login", (arg) {
      print(arg);
      print('登录成功');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: const Color(0xFF828895),
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    );
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).requestFocus(FocusNode()), // 点击空白处隐藏键盘
      child: Scaffold(
        body: Stack(
          children: [
            //* double背景
            SvgPicture.asset(
              width: 390.w,
              height: 844.h,
              'assets/svgs/appbar_bgc.svg',
              fit: BoxFit.cover,
            ),
            //* 头部按钮
            SizedBox(
              height: 366.h,
              width: double.infinity,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: AppTheme.themeColor2),
                  width: 228.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isColdWallet = false;
                          });
                        },
                        child: Container(
                          height: 37.w,
                          width: 114.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: isColdWallet
                                ? Colors.transparent
                                : AppTheme.themeColor,
                          ),
                          child: Center(
                              child: Text(
                            '热钱包',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: isColdWallet
                                  ? AppTheme.themeColor
                                  : Colors.white,
                            ),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isColdWallet = true;
                          });
                        },
                        child: Container(
                          height: 37.w,
                          width: 114.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: isColdWallet
                                ? AppTheme.themeColor
                                : Colors.transparent,
                          ),
                          child: Center(
                              child: Text(
                            '冷钱包',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: isColdWallet
                                  ? Colors.white
                                  : AppTheme.themeColor,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //* 主体部分
            Positioned(
              top: 366.h,
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.1),
                      spreadRadius: 1,
                      blurRadius: 20.w,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                  ),
                  child: LiquidPullToRefresh(
                    height: 50.w,
                    onRefresh: _handleRefresh,
                    color: Colors.grey.withOpacity(.05),
                    backgroundColor: AppTheme.themeColor,
                    springAnimationDurationInMilliseconds: 150,
                    showChildOpacityTransition: false,
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        //* 头部信息
                        Container(
                          height: 181.w,
                          padding: EdgeInsets.fromLTRB(20.w, 14.w, 20.w, 16.w),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 91.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 20.w,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '资产估值',
                                            style: TextStyle(
                                                color: const Color(0xFF7F8391),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(width: 4.w),
                                          Icon(
                                            color: const Color(0xFF7F8391),
                                            size: 14.sp,
                                            isEye
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          SizedBox(width: 10.w),
                                          Container(
                                            width: 91.w,
                                            height: 20.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppTheme.themeColor,
                                                  width: 1.w,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.w)),
                                            child: Center(
                                              child: Text(
                                                '观察者模式',
                                                style: TextStyle(
                                                    color: AppTheme.themeColor,
                                                    fontSize: 13.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 36.w,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.w),
                                            child: Center(
                                              child: Text(
                                                isEye ? '' : '\u0024',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF212121),
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEye = !isEye;
                                              });
                                            },
                                            child: SizedBox(
                                              height: 36.w,
                                              width: double.infinity,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  isEye
                                                      ? maskString(
                                                          balance.toString(),
                                                          '*')
                                                      : oCcy.format(balance),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF212121),
                                                    fontSize: 28.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.w,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.w),
                                            child: Text(
                                              isEye ? '' : '\u2248',
                                              style: TextStyle(
                                                color: const Color(0xFF686C77),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              isEye
                                                  ? maskString(
                                                      balance1.toString(), '*')
                                                  : oCcy1.format(balance1),
                                              style: TextStyle(
                                                color: const Color(0xFF686C77),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.w),
                                            child: Text(
                                              isEye ? '' : 'BTC',
                                              style: TextStyle(
                                                color: const Color(0xFF686C77),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.w),
                              SizedBox(
                                height: 36.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (String i in btns)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isBtns = btns.indexOf(i).toDouble();
                                          });
                                        },
                                        child: Container(
                                          width: 72.w,
                                          decoration: BoxDecoration(
                                            color: isBtns == btns.indexOf(i)
                                                ? AppTheme.themeColor
                                                : AppTheme.themeColor2,
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                          ),
                                          child: Center(
                                              child: Text(
                                            i,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: isBtns == btns.indexOf(i)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isEyeAssets = !isEyeAssets;
                              });
                            },
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  width: 16.w,
                                  height: 16.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: isEyeAssets
                                          ? AppTheme.themeColor
                                          : const Color(0xFF828895),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                        width: 16.w,
                                        height: 16.w,
                                        decoration: BoxDecoration(
                                          color: isEyeAssets
                                              ? AppTheme.themeColor
                                              : Colors.transparent,
                                        ),
                                        child: isEyeAssets
                                            ? Icon(
                                                Icons.check_rounded,
                                                size: 12.sp,
                                                color: Colors.white,
                                                weight: 700,
                                              )
                                            : null),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '隐藏 ${0} 资产',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF585E68),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.w),
                        for (var i in coinName)
                          Item(
                            title: i,
                            imgurl:
                                'assets/images/coin_${coinName.indexOf(i) + 1}.png',
                            oCcy: oCcy,
                            textStyle: textStyle,
                            oCcy2: oCcy2,
                            balance: 712.34,
                            balance1: 34623.65,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.title,
    required this.oCcy,
    required this.textStyle,
    required this.oCcy2,
    required this.balance,
    required this.balance1,
    required this.imgurl,
  });

  final String title;
  final String imgurl;
  final NumberFormat oCcy;
  final TextStyle textStyle;
  final NumberFormat oCcy2;
  final double balance;
  final double balance1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 0.w, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 20.w),
            height: 70.w,
            child: Row(
              children: [
                Image.asset(
                  imgurl,
                  height: 36.w,
                  width: 36.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 7.w),
                Text(
                  title,
                  style: TextStyle(
                      color: const Color(0xFF111111),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 24.w,
                      child: Text(
                        oCcy.format(balance),
                        style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: Text(
                            '\u2248',
                            style: textStyle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: Text(
                            '\u0024',
                            style: textStyle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            oCcy2.format(balance1),
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 36.w),
            child: Divider(
              height: 1.w,
              color: const Color(0xFFEDEFF5).withOpacity(.8),
            ),
          )
        ],
      ),
    );
  }
}
