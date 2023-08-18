// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/client.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/common/utils/index.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/components/qr_code_scanner.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/event/index.dart';
import 'package:wallet/widgets/mine/wallets.dart';
import 'package:wallet/widgets/wallet/top_up.dart';
import 'package:wallet/widgets/wallet/withdraw.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Future<void> _handleRefresh() async {
    HapticFeedback.selectionClick(); // 震动
    await C.getWL();
  }

  //~复制到剪切板
  void copyToClipboard({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBar(msg: '复制成功');
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

  bool isColdWallet = true; //是否冷钱包
  // bool isEye = false; //是否显示资产
  bool isEyeAssets = false; //是否显示资产单选框
  bool isFocus = false; //是否聚焦
  bool isFocus1 = false; //是否聚焦

  NumberFormat oCcy = NumberFormat("#,###.####", "en_US");
  NumberFormat oCcy1 = NumberFormat("#,###.##########", "en_US");
  NumberFormat oCcy2 = NumberFormat("#,###.##", "en_US");
  NumberFormat oCcy3 = NumberFormat("#,###.###", "en_US");
  String maskString(String originalString, String maskChar) {
    return originalString.replaceAll(RegExp('[0-9.]'), maskChar);
  }

  final TextEditingController _toController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _toFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  double usd = 0.00000000;
  double gasFee = 0.00000000;
  double gasPrice = 0.00000000;

  @override
  void initState() {
    super.initState();
    bus.on("login", (arg) {
      print(arg);
      print('登录成功');
    });
    // 监听输入框 设置isFocus
    _toFocusNode.addListener(() {
      setState(() {
        isFocus = _toFocusNode.hasFocus;
      });
    });
    _amountFocusNode.addListener(() {
      setState(() {
        isFocus1 = _amountFocusNode.hasFocus;
      });
    });
    getPrice();
    // 监听输入框
    _amountController.addListener(() {
      getPrice();
    });
    bus.on('updateTransactionList', (arg) {
      setState(() {});
    });
    // print(C.walletList);
    // print(C.currentWallet);
  }

  // *获取gas费用
  getPrice() {
    var data = CL.calculateGasFee(
        amount: num.parse(
            _amountController.text == '' ? '0' : _amountController.text));
    setState(() {
      gasFee = data['gasFeeWei'];
      usd = data['Usd'] < 0 ? 0 : data['Usd'];
      gasPrice = data['Eth'] < 0 ? 0 : data['Eth'];
    });
  }

  //销毁
  @override
  void dispose() {
    isColdWallet = true; //是否冷钱包
    _toFocusNode.dispose();
    _toController.dispose();
    _amountFocusNode.dispose();
    _amountController.dispose();
    bus.off("login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).requestFocus(FocusNode()), // 点击空白处隐藏键盘
      child: Scaffold(
        body: SizedBox(
          // color: Colors.white,
          height: 884.h,
          child: Stack(
            children: [
              //* double背景
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 200.h,
                child: SvgPicture.asset(
                  'assets/svgs/appbar_bgc.svg',
                  fit: BoxFit.cover,
                ),
              ),
              if (!isColdWallet)
                Positioned(
                  child: OpClick(
                    onTap: () {
                      _walletShowBottomSheet(context);
                    },
                    child: SizedBox(
                      height: getStatusBarHeight(context),
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(left: 15.w),
                          width: 50.w,
                          height: 30.w,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svgs/menu.svg',
                              fit: BoxFit.cover,
                              width: 25.w,
                              height: 14.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              //* 冷热钱包按钮
              Positioned(
                child: SizedBox(
                  height: getStatusBarHeight(context),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 46.w),
                      child: OpClick(
                        onTap: () {
                          // 震动
                          HapticFeedback.heavyImpact();
                          setState(() {
                            isColdWallet = !isColdWallet;
                          });
                        },
                        child: Container(
                          width: 160.w,
                          height: 30.w,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            color: Colors.white,
                            boxShadow: AppTheme.cardShow,
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: const Duration(
                                    milliseconds: 100), //动画时长500毫秒
                                alignment: isColdWallet
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft, //从左边滑出
                                child: SizedBox(
                                  width: 78.w,
                                  height: 26.w,
                                  child: Center(
                                    child: Text(
                                      isColdWallet ? '冷钱包' : '热钱包',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff7F8391)),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 100),
                                alignment: isColdWallet
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: OpClick(
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
                                        isColdWallet ? '热钱包' : '冷钱包',
                                        style: TextStyle(
                                            fontSize: 14.sp,
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
                      ),
                    ),
                  ),
                ),
              ),
              //* 主体部分
              Positioned(
                top: getStatusBarHeight(context),
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 13.h),
                  child: LiquidPullToRefresh(
                    height: 50.w, // 刷新控件高度
                    onRefresh: _handleRefresh,
                    color: Colors.transparent,
                    backgroundColor: AppTheme.themeColor,
                    springAnimationDurationInMilliseconds: 150,
                    showChildOpacityTransition: false,
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        //* 头部信息
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w), // 设置左右边距为20
                            // height: 372.w - getStatusBarHeight(context),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  height: 180.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 16.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.w),
                                    ),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/purse_bg.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: AppTheme.cardShow,
                                  ),
                                  child: isColdWallet

                                      //&热钱包
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 9.w),
                                                child: Text(
                                                  '我的余额',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.white),
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  'assets/images/coin_1.png',
                                                  height: 36.w,
                                                  width: 36.w,
                                                  fit: BoxFit.cover,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    child: Obx(() => Text(
                                                          overflow: TextOverflow
                                                              .ellipsis, // 超出部分显示省略号
                                                          maxLines:
                                                              1, // 限制文本显示为一行
                                                          oCcy.format(
                                                            double.parse(C
                                                                .balance.value
                                                                .toString()),
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 28.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                ),
                                                Text('USDT',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white))
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(top: 28.h),
                                              child: Text('资产估值',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white
                                                          .withOpacity(0.5))),
                                            ),
                                            Row(
                                              children: [
                                                Text('\$',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white
                                                            .withOpacity(0.5))),
                                                Obx(() => Text(
                                                    oCcy.format(
                                                        C.usdprice.value *
                                                            C.balance.value),
                                                    style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white
                                                            .withOpacity(
                                                                0.5)))),
                                              ],
                                            )
                                          ],
                                        )
                                      :
                                      //&冷钱包
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/svgs/bnb.svg',
                                                      height: 20.w,
                                                      width: 20.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.w),
                                                      child: Text(
                                                        'BNB Smart Chain',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                                0xffEDEFF5)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text('Wallet 1',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffEDEFF5))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 16.sp),
                                                  child: Text(
                                                    oCcy.format(2345866.0512),
                                                    style: TextStyle(
                                                        fontSize: 28.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xffEDEFF5)),
                                                  ),
                                                ),
                                                Text(
                                                  'USDT',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                          0xffEDEFF5)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                OpClick(
                                                  onTap: () {
                                                    copyToClipboard(
                                                        text:
                                                            '0xs12ehfkddjfh21fd4aj');
                                                  },
                                                  child: Container(
                                                    width: 168.w,
                                                    height: 34.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(18.w),
                                                      ),
                                                      color: const Color(
                                                              0xffF1F1F1)
                                                          .withOpacity(0.2),
                                                    ),
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            utils.formatText(
                                                                text: C.currentWallet[
                                                                    'address']),
                                                            style: TextStyle(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xff292D32)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6.w),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/copy.svg',
                                                              height: 16.w,
                                                              width: 16.w,
                                                              fit: BoxFit.cover,
                                                              color: const Color(
                                                                  0xffEDEFF5),
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                ),
                                isColdWallet
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.w, bottom: 9.w),
                                        child: SizedBox(
                                          height: 18.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      '${oCcy2.format(712.34888)}\u00A0USDT',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xFF111111))),
                                                  Text(
                                                      '\u00A0\u00A0\u2248\$${oCcy2.format(34623.65)}', //\u00A0添加非断行空格

                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xFF828895))),
                                                ],
                                              ),
                                              Text('+${oCcy3.format(0.1234)}%',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppTheme.themeColor)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.w, bottom: 9.w),
                                        child: SizedBox(
                                          height: 18.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('资产估值',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppTheme.themeColor)),
                                              Text(
                                                '\$${oCcy.format(2345866.0512)}',
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppTheme.themeColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                isColdWallet
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OpClick(
                                            onTap: () {
                                              _transferShowBottomSheet(
                                                context, //上下文
                                                iconurl:
                                                    'assets/svgs/shuffle.svg', //图标
                                                title: '转账', //标题
                                                oCcy: oCcy, //格式化
                                              );
                                            },
                                            child: Container(
                                              width: 65.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xFF9BAED2)
                                                    .withOpacity(0.35),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svgs/shuffle.svg',
                                                    width: 16.w,
                                                    height: 16.w,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.w),
                                                    child: Text(
                                                      '转账',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          OpClick(
                                            onTap: () {
                                              _receiveShowBottomSheet(
                                                context,
                                                iconurl:
                                                    'assets/svgs/upload.svg',
                                                title: '接收',
                                                oCcy: oCcy,
                                              );
                                            },
                                            child: Container(
                                              width: 65.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xFF5F9396)
                                                    .withOpacity(0.3),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svgs/upload.svg',
                                                    width: 16.w,
                                                    height: 16.w,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.w),
                                                    child: Text(
                                                      '接收',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          OpClick(
                                            onTap: () {
                                              Get.to(() => TopUp());
                                            },
                                            child: Container(
                                              width: 65.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xFF9BAED2)
                                                    .withOpacity(0.35),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .system_update_alt_outlined,
                                                    size: 18.sp,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.w),
                                                    child: Text(
                                                      '充值',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          OpClick(
                                            onTap: () {
                                              // WithdrawPage
                                              Get.to(() => WithdrawPage());
                                            },
                                            child: Container(
                                              width: 65.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xFF5F9396)
                                                    .withOpacity(0.3),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.input_outlined,
                                                    size: 18.sp,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.w),
                                                    child: Text(
                                                      '提现',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          OpClick(
                                            onTap: () {
                                              _transferShowBottomSheet(
                                                context, //上下文
                                                iconurl:
                                                    'assets/svgs/shuffle.svg', //图标
                                                title: '转账', //标题
                                                oCcy: oCcy, //格式化
                                              );
                                            },
                                            child: Container(
                                              width: 141.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.w),
                                                color: const Color(0xFF9BAED2)
                                                    .withOpacity(0.35),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svgs/shuffle.svg',
                                                    width: 22.w,
                                                    height: 22.w,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12.w),
                                                    child: Text(
                                                      '转账',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          OpClick(
                                            onTap: () {
                                              _receiveShowBottomSheet(
                                                context,
                                                iconurl:
                                                    'assets/svgs/upload.svg',
                                                title: '接收',
                                                oCcy: oCcy,
                                              );
                                            },
                                            child: Container(
                                              width: 141.w,
                                              height: 44.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.w),
                                                color: const Color(0xFF5F9396)
                                                    .withOpacity(0.3),
                                                boxShadow: AppTheme.cardShow,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svgs/upload.svg',
                                                    width: 22.w,
                                                    height: 22.w,
                                                    color:
                                                        const Color(0xFF292D32),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12.w),
                                                    child: Text(
                                                      '接收',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF292D32)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                              ],
                            )),

                        SizedBox(height: 14.h),
                        //* 操作信息
                        Container(
                          constraints: BoxConstraints(
                            minHeight:
                                860.h - 372.w - getStatusBarHeight(context),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              topRight: Radius.circular(20.w),
                            ),
                            boxShadow: AppTheme.cardShow,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 22.w, left: 20.w, right: 20.w),
                            child: Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Text(
                                        '账单',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF111111),
                                        ),
                                      ),
                                    ),
                                    //* 账单列表
                                    for (int i = 0;
                                        i < C.currentWalletTx.length;
                                        i++)
                                      Column(
                                        children: [
                                          if (C.currentWalletTx[i]['from']
                                                  .toLowerCase() !=
                                              CL.address.hex.toLowerCase())
                                            OpClick(
                                              onTap: () {
                                                showCustomDialog(
                                                    context,
                                                    '您收到一笔新的转账',
                                                    utils
                                                        .formatBalance(
                                                            C.currentWalletTx[i]
                                                                ['value'])
                                                        .toString(),
                                                    C.currentWalletTx[i]
                                                        ['from']);
                                              },
                                              child: Items(
                                                title: '接收',
                                                iconurl:
                                                    'assets/svgs/upload.svg',
                                                walletAddress: utils.formatText(
                                                    text: C.currentWalletTx[i]
                                                        ['from']),
                                                price: utils.formatBalance(
                                                    C.currentWalletTx[i]
                                                        ['value']),
                                                time: utils.formatTimestamp(C
                                                        .currentWalletTx[i]
                                                    ['confirmationTimestamp']),
                                                oCcy: oCcy,
                                                color: const Color(0xFF45AAAF),
                                                oCcy2: oCcy2,
                                              ),
                                            )
                                          else
                                            Items(
                                              title: '转账',
                                              iconurl:
                                                  'assets/svgs/shuffle.svg',
                                              walletAddress: utils.formatText(
                                                  text: C.currentWalletTx[i]
                                                      ['from']),
                                              price: utils.formatBalance(C
                                                  .currentWalletTx[i]['value']),
                                              time: utils.formatTimestamp(C
                                                      .currentWalletTx[i]
                                                  ['confirmationTimestamp']),
                                              oCcy: oCcy,
                                              color: const Color(0xFF0563B6),
                                              oCcy2: oCcy2,
                                            ),
                                        ],
                                      )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//~您收到一笔新的转账 确认弹窗
  void showCustomDialog(
    BuildContext context,
    String title,
    String price,
    String walletAddress,
  ) {
    showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: const Color(0xff909090).withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white, // ~设置背景色
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
          content: Container(
            color: Colors.white,
            height: 300.h,
            width: 354.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xff292D32),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.w, bottom: 43.w),
                  width: 354.w,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            '发送地址',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF333333)),
                          ),
                        ),
                        Container(
                          height: 48.h,
                          padding: EdgeInsets.fromLTRB(8.w, 12.w, 13.w, 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffF1F1F1),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Text(
                            walletAddress,
                            overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                            maxLines: 1, // 限制文本显示为一行
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xff212121), // 设置字体颜色
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 16.w),
                          child: Text(
                            '到账金额',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF333333)),
                          ),
                        ),
                        Container(
                          height: 48.h,
                          padding: EdgeInsets.fromLTRB(8.w, 12.w, 13.w, 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffF1F1F1),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Text(
                                  price,
                                  overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                  maxLines: 1, // 限制文本显示为一行
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff212121), // 设置字体颜色
                                  ),
                                ),
                              ),
                              Text(
                                'USDT',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff212121), // 设置字体颜色
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                OpClick(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: 146.w,
                    height: 47.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: AppTheme.themeColor),
                    child: Center(
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //* 转账底部弹窗 --- 热钱包  -------start
  void _transferShowBottomSheet(BuildContext context,
      {String? iconurl, String? title, NumberFormat? oCcy}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, //设置为true，此时将会跟随键盘的弹出而弹出
      elevation: 0,
      barrierColor: Colors.transparent, // 背景色设置为透明
      backgroundColor: Colors.transparent, // 设置透明背景
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode()); // 点击空白处收起键盘
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 470.h,
                      ),
                      padding: EdgeInsets.only(bottom: 26.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0.w), // 设置顶部圆角半径为 10.0
                        ),
                        boxShadow: AppTheme.cardShow,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: getScreenWidth(context, 1),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 17.w,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        iconurl!,
                                        width: 22.sp,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.w),
                                        child: Text(
                                          title!,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OpClick(
                                  onTap: () {
                                    setState(() {
                                      _amountController.clear(); // 清空输入框
                                      _toController.clear(); // 清空输入框
                                      Navigator.pop(context); // 关闭底部弹框
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.w, left: 10.w),
                                    child: SizedBox(
                                        width: 40.w,
                                        height: 40.w,
                                        child: const Icon(Icons.arrow_back)),
                                  ), // 使用内置的左箭头图标
                                ),
                              ],
                            ),
                          ),
                          //^^^^^^^^^^^转账
                          Container(
                            constraints: BoxConstraints(minHeight: 360.h),
                            padding: EdgeInsets.only(
                              top: 28.w,
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.h),
                                  child: Text(
                                    '发送到',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF333333)),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF1F1F1),
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        border: Border.all(
                                            color: isFocus
                                                ? AppTheme.themeColor
                                                : Colors.transparent,
                                            width: 1.w),
                                      ),
                                    ),
                                    Container(
                                      height: 52.w,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 46.w),
                                      child: Center(
                                        child: TextFormField(
                                          controller: _toController, // 设置控制器
                                          focusNode: _toFocusNode, // 设置焦点
                                          keyboardType:
                                              TextInputType.text, // 设置键盘类型
                                          onChanged: (value) {
                                            String trimmedText = value
                                                .replaceAll(' ', ''); // 去除空格
                                            if (trimmedText != value) {
                                              final int cursorPosition =
                                                  _toController.selection
                                                          .baseOffset -
                                                      1; // 获取当前光标位置
                                              final TextSelection newSelection =
                                                  TextSelection.collapsed(
                                                      offset:
                                                          cursorPosition); // 生成新的光标位置
                                              setState(() {
                                                _toController.value =
                                                    TextEditingValue(
                                                  text: trimmedText,
                                                  selection: newSelection,
                                                ); // 更新内容
                                              });
                                            }
                                            setState(() {});
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_amountFocusNode);
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12), // 设置内容内边距
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 3.w,
                                      child: OpClick(
                                        onTap: () {
                                          Get.to(const MyQRScannerWidget());
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 40.w,
                                          padding: EdgeInsets.all(3.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/scan.svg',
                                            color: const Color(0xff999999),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.h, top: 16.w),
                                  child: Text(
                                    '发送金额',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF333333)),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF1F1F1),
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        border: Border.all(
                                            color: isFocus1
                                                ? AppTheme.themeColor
                                                : Colors.transparent,
                                            width: 1.w),
                                      ),
                                    ),
                                    Container(
                                      height: 52.w,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 46.w),
                                      child: Center(
                                        child: TextFormField(
                                          controller: _amountController,
                                          focusNode: _amountFocusNode,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          // 添加"完成"按钮
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context).unfocus(),
                                          onChanged: (value) {
                                            String trimmedText = value
                                                .replaceAll(' ', ''); // 去除空格
                                            if (trimmedText != value) {
                                              final int cursorPosition =
                                                  _amountController.selection
                                                          .baseOffset -
                                                      1; // 获取当前光标位置
                                              final TextSelection newSelection =
                                                  TextSelection.collapsed(
                                                      offset:
                                                          cursorPosition); // 生成新的光标位置
                                              setState(() {
                                                _amountController.value =
                                                    TextEditingValue(
                                                  text: trimmedText,
                                                  selection: newSelection,
                                                ); // 更新内容
                                              });
                                            }
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12), // 设置内容内边距
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(3.w),
                                          child: Text(
                                            'USDT',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(
                                                  0xff212121), // 设置字体颜色
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() => Text(
                                          '可用：${oCcy!.format(C.balance.value)}\u00A0USDT',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF333333)
                                                  .withOpacity(0.5)))),
                                      Text(
                                        '全部',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppTheme.themeColor),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 24.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('手续费',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF333333))),
                                      Text(
                                        gasFee.toString(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 55, 129, 44)),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.w, bottom: 53.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('实际到账',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF333333))),
                                      Text(
                                        '$gasPrice\u00A0UDST',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF333333)),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.w), // 设置左右边距为7
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OpClick(
                                        onTap: () async {
                                          if (_amountController.text.isEmpty) {
                                            return;
                                          }
                                          String? password;
                                          if (CL.isEBV) {
                                            password = await swi.getpassword();
                                          } else {
                                            password = '';
                                          }
                                          bool res = await dapp.transfer(
                                              _toController.text,
                                              num.parse(_amountController.text),
                                              password: password);
                                          if (res) {
                                            Navigator.pop(context);
                                            _amountController.clear();
                                            _toController.clear();
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 146.w,
                                          height: 47.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.w),
                                              color: AppTheme.themeColor),
                                          child: Center(
                                            child: Text(
                                              '确认',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      OpClick(
                                        onTap: () {
                                          setState(() {
                                            _amountController.clear(); // 清空输入框
                                            _toController.clear(); // 清空输入框
                                            Navigator.pop(context); // 关闭底部弹框
                                          });
                                        },
                                        child: Container(
                                          width: 146.w,
                                          height: 47.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: AppTheme.themeColor,
                                              width: 1.w,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '取消',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.themeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  //* 转账底部弹窗 ---热钱包 -------end

  // ~接收底部弹窗  -------start
  void _receiveShowBottomSheet(BuildContext context,
      {required String iconurl,
      required String title,
      required NumberFormat oCcy}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: Colors.white,
      barrierColor: const Color(0xff909090).withOpacity(0.5), // 背景色设置为透明
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0.w), // 设置顶部圆角半径为 10.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 19.w, right: 19.w, top: 17.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w), // 设置顶部圆角半径为 10.0
            ),
          ),
          height: 504.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OpClick(
                    onTap: () {
                      Navigator.pop(context); // 关闭底部弹框
                    },
                    child: const Icon(Icons.arrow_back), // 使用内置的左箭头图标
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        iconurl,
                        width: 22.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 1.w)
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 50.w),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: '1234567890', // 二维码数据
                        version: QrVersions.auto, // 二维码版本
                        size: 175.438.w, // 二维码大小
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 35.w), // 设置上下边距为35
                    child: Container(
                      height: 61.h,
                      width: 345.w,
                      padding:
                          EdgeInsets.only(left: 30.w, top: 7.w, bottom: 7.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet address',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff292D32)
                                  .withOpacity(0.5), // 设置字体颜色
                            ),
                          ),
                          SizedBox(
                            width: 270.w,
                            child: Text(
                              '0xs12tgyuguh877665676uhgddssadCEA',
                              overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                              maxLines: 1, // 限制文本显示为一行
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff212121), // 设置字体颜色
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w), // 设置左右边距为7
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 146.w,
                      height: 47.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppTheme.themeColor),
                      child: Center(
                        child: Text(
                          '分享',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 146.w,
                      height: 47.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: Colors.white,
                        border: Border.all(
                          color: AppTheme.themeColor,
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '保存',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // ~接收底部弹窗  -------end
}

//~钱包列表底部弹框 -------start
// wallet
void _walletShowBottomSheet(
  BuildContext context,
) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: Colors.white,
      barrierColor: const Color(0xff909090).withOpacity(0.5), // 背景色设置为透明
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(23.0.w), // 设置顶部圆角半径为 10.0
        ),
      ),
      builder: (
        BuildContext context,
      ) {
        return LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23.0.w), // 设置顶部圆角半径为 10.0
                    ),
                  ),
                  height: 474.h,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 14.w, right: 24.w, top: 17.w, bottom: 30.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('管理全部',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.themeColor,
                                )),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Text(
                                    '钱包列表',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            OpClick(
                              onTap: () {
                                Navigator.pop(context); // 关闭底部弹框
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/guanbi.svg',
                                width: 22.sp,
                                color: AppTheme.themeColor,
                              ),
                            ),
                            // mine_page
                          ],
                        ),
                      ),
                      const Expanded(child: WalletBody()),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      });
}
//~钱包列表底部弹框 -------end

//&账单列表
class Items extends StatelessWidget {
  const Items({
    super.key,
    required this.oCcy, // 格式化
    required this.color, // 样式
    required this.oCcy2, // 格式化
    required this.title, // 标题
    required this.iconurl, // 图标
    required this.walletAddress, // 钱包地址
    required this.price, // 价格
    required this.time, // 转账时间
  });

  final String title;
  final String iconurl;
  final String walletAddress;
  final NumberFormat oCcy;
  final Color color;
  final NumberFormat oCcy2;
  final double price;
  final String time;

  @override
  Widget build(BuildContext context) {
    String maskString(String originalString) {
      if (originalString.length <= 10) {
        return originalString;
      } else {
        String prefix = originalString.substring(0, 5);
        String suffix = originalString.substring(originalString.length - 5);
        String maskedString = '$prefix***$suffix';
        return maskedString;
      }
    }

    return Container(
      height: 72.h,
      margin: EdgeInsets.only(top: 10.w),
      padding: EdgeInsets.fromLTRB(15.w, 15.w, 15.w, 10.w),
      decoration: BoxDecoration(
        color: const Color(0xffF1F1F1),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    iconurl,
                    width: 20.w,
                    height: 20.w,
                    color: color,
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    title,
                    style: TextStyle(
                        color: color,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                maskString(walletAddress),
                style: TextStyle(
                    color: const Color(0xFF686C77),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  '\u00A5\u0020${oCcy.format(price)}',
                  style: TextStyle(
                      color: const Color(0xFF111111),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      time,
                      style: TextStyle(
                          color: const Color(0xFF686C77),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
