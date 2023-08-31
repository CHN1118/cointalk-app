// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/event/index.dart';
import 'package:wallet/widgets/importwallet/creat_psw.dart';

// ignore: must_be_immutable
class WalletMan extends StatefulWidget {
  bool? hasAppBar;
  WalletMan({super.key, this.hasAppBar = true});

  @override
  State<WalletMan> createState() => _WalletManState();
}

//钱包数据
// class ListItem {
//   String text;
//   bool active;

//   ListItem({required this.text, this.active = false});
// }

//&钱包管理
class _WalletManState extends State<WalletMan> {
  //初始化
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 标题居中
        title: Text('钱包管理', style: TextStyle(fontSize: 20.sp)),
      ),
      body: const WalletBody(),
    );
  }
}

class WalletBody extends StatefulWidget {
  const WalletBody({super.key});

  @override
  State<WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  //初始化
  @override
  void initState() {
    super.initState();
    bus.on('updateWalletList', (arg) {
      // setState(() {});
      //1秒后刷新
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {});
      });
    });
  }

//~删除钱包的 底部弹窗
  void _delBottomSheet1(
    BuildContext context,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfF5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0.w), // 设置顶部圆角半径为 16.0
        ),
      ),
      barrierColor: const Color(0xff909090).withOpacity(0.5), // 背景色设置为透明

      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xffF2FfF5),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w), // 设置顶部圆角半径为 10.0
            ),
          ),
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 11.w),
          height: 369.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '添加钱包',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900),
                  ),
                  OpClick(
                    onTap: () {
                      // 执行选项 2 的操作
                      Navigator.pop(context); // 关闭底部弹框
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/Off1.svg', // 设置SVG图标的路径
                      width: 16.w,
                      height: 16.w,
                      // ignore: deprecated_member_use
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 35.w),
                    child: Text(
                      '您确认要删除这个钱包吗？',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000)),
                    ),
                  ),
                  Container(
                    width: 245.w,
                    margin: EdgeInsets.only(top: 12.w),
                    child: Text(
                      '您将停止对此钱包的查看与使用，但钱包内的资产不会受到影响',
                      textAlign: TextAlign.center, // 从中间开始显示
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff000000).withOpacity(0.5)),
                    ),
                  ),
                  Container(
                      width: 272.w,
                      height: 67.h,
                      margin: EdgeInsets.only(top: 18.w, bottom: 27.w),
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatText(
                                    text: C.walletList[index]['walletname']),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OpClick(
                                  onTap: () {
                                    //&复制到剪切板
                                    copyToClipboard(
                                        text: C.walletList[index]['address']);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 15.w),
                                        child: Text(
                                          //&只显示前五位和后六位
                                          formatText(
                                              text: C.walletList[index]
                                                  ['address']),
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/copy.svg', // 设置SVG图标的路径
                                        width: 16.w,
                                        height: 16.w,
                                        // ignore: deprecated_member_use
                                        color: AppTheme.themeColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  C.walletList[index]['balance'] == null
                                      ? '0 BNB'
                                      : C.walletList[index]['balance']
                                              .toStringAsFixed(3) +
                                          ' BNB',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ])
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OpClick(
                        onTap: () {
                          setState(() {
                            //&删除钱包
                            //todo 删除钱包
                            if (index != 0) {
                              //删除C.walletList的数据
                              C.walletList.removeAt(index);
                              DB.box.write('WalletList',
                                  C.walletList.value); // *存储钱包信息数组
                              C.getWL();
                              showSnackBar(msg: '删除成功');
                              Navigator.pop(context); // 关闭底部弹框
                              if (C.walletList.isEmpty) {
                                //跳转到创建钱包页面
                                setState(() {
                                  Get.offNamed(
                                    '/importwallet',
                                  );
                                });
                              }
                            } else {
                              showSnackBar(msg: '不能删除默认钱包', color: 0XFF0000);
                              Navigator.pop(context); // 关闭底部弹框
                            }
                          });
                        },
                        child: Container(
                            width: 146.w,
                            height: 47.w,
                            decoration: BoxDecoration(
                              color: AppTheme.themeColor,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Center(
                              child: Text('确认',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600)),
                            )),
                      ),
                      OpClick(
                        onTap: () {
                          // 执行选项 2 的操作
                          Navigator.pop(context); // 关闭底部弹框
                        },
                        child: Container(
                            width: 146.w,
                            height: 47.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: AppTheme.themeColor, width: 1.w),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Center(
                              child: Text('取消',
                                  style: TextStyle(
                                      color: AppTheme.themeColor,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600)),
                            )),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //~创建钱包，导入钱包 的底部弹窗
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfF5),
      barrierColor: const Color(0xff909090).withOpacity(0.5), // 背景色设置为透明
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xffF2FfF5),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w), // 设置顶部圆角半径为 10.0
            ),
          ),
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 11.w),
          height: 369.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '添加钱包',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900),
                  ),
                  OpClick(
                    onTap: () {
                      // 执行选项 2 的操作
                      Navigator.pop(context); // 关闭底部弹框
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/Off1.svg', // 设置SVG图标的路径
                      width: 16.w,
                      height: 16.w,
                      // ignore: deprecated_member_use
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 42.w),
                child: Column(
                  children: [
                    OpClick(
                      onTap: () {
                        //关闭
                        Navigator.pop(context); // 关闭底部弹框
                        Get.to(
                          () => CreatPsw(
                            import: true,
                          ),
                        );
                      },
                      child: Container(
                          width: 325.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: AppTheme.themeColor,
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Center(
                            child: Text('创建钱包',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600)),
                          )),
                    ),
                    OpClick(
                      onTap: () {
                        //关闭
                        Navigator.pop(context); // 关闭底部弹框
                        Get.to(
                          () => CreatPsw(
                            title: '创建钱包密码',
                            import: true,
                          ),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 22.w),
                          width: 325.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            // color: AppTheme.themeColor,
                            border: Border.all(
                                color: AppTheme.themeColor, width: 1.w),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Center(
                            child: Text('导入钱包',
                                style: TextStyle(
                                    color: AppTheme.themeColor,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600)),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  double isBtns = 0; //是否选中
  //~左侧的四个图标
  List<String> btns = [
    'assets/svgs/purse_icon1.svg',
    'assets/svgs/purse_icon2.svg',
    'assets/svgs/purse_icon3.svg',
    'assets/svgs/purse_icon4.svg',
  ];
  //~钱包数据
  // List C.walletList = [1, 2, 3];
  //~判断点击选择了哪个钱包
  handleItemClick(int index) {
    setState(() {
      for (int i = 0; i < C.walletList.length; i++) {
        if (i == index) {
          if (C.walletList[i]['active'] == true) {
            return;
          }
          C.walletList[i]['active'] = true;
        } else {
          C.walletList[i]['active'] = false;
        }
      }
      DB.box.write('WalletList', C.walletList.value); // *存储钱包信息数组
      C.getWL();
    });
  }

  //~只显示前五位和后六位
  String formatText({required String text}) {
    if (text.length <= 11) {
      return text;
    } else {
      String abbreviatedText =
          "${text.substring(0, 4)}...${text.substring(text.length - 5, text.length)}";
      return abbreviatedText;
    }
  }

//~复制到剪切板
  void copyToClipboard({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBar(msg: '复制成功');
  }

  //~提示弹框
  Future<bool?> showSnackBar({String? msg, color = 0xffF2F8F5}) {
    return Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT, // 消息框持续的时间
        gravity: ToastGravity.TOP, // 消息框弹出的位置
        timeInSecForIosWeb: 1, // ios
        backgroundColor: Color(color!).withOpacity(1),
        textColor: const Color(0xff000000),
        fontSize: 14.sp);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        children: [
          Container(
            color: AppTheme.purseTheme,
            width: 70.w,
            child: Column(
              children: [
                for (String i in btns)
                  Container(
                    width: double.infinity,
                    height: 54.w,
                    color: isBtns == btns.indexOf(i).toDouble()
                        ? Colors.white
                        : AppTheme.purseTheme,
                    child: OpClick(
                      onTap: () {
                        setState(() {
                          isBtns = btns.indexOf(i).toDouble();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
                        child: SvgPicture.asset(
                          i, // 设置SVG图标的路径
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
              child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 25.w, right: 20.w, bottom: 20.w),
                    height: 48.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BNB Chain',
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w900),
                        ),
                        OpClick(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Container(
                            width: 35.w,
                            height: 35.w,
                            color: Colors.transparent,
                            padding: EdgeInsets.all(4.w),
                            child: SvgPicture.asset(
                              'assets/svgs/add.svg', // 设置SVG图标的路径

                              // ignore: deprecated_member_use
                              color: const Color(0xff45AAAF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (int index = 0; index < C.walletList.length; index++)
                    ClipRect(
                      child: GestureDetector(
                        onTap: () {
                          handleItemClick(index);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 272.w,
                              height: 67.w,
                              margin: EdgeInsets.only(bottom: 10.w),
                              child: Slidable(
                                key: Key(index.toString()),
                                endActionPane: ActionPane(
                                  extentRatio: C.walletList[index]['active'] ||
                                          index == 0
                                      ? 0.00001
                                      : 0.35, // 控制滑动项widget的大小
                                  motion: const ScrollMotion(), //滑动动画
                                  dragDismissible: false, //是否可以通过拖动将操作取消
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        setState(() {
                                          //~删除钱包
                                          _delBottomSheet1(context, index);
                                        });
                                      },
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.w),
                                          bottomRight: Radius.circular(8.w)),
                                      backgroundColor: const Color(0xff45AAAF),
                                      foregroundColor: Colors.white,
                                      label: '删除',
                                    )
                                  ],
                                ),
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 15.w),
                                    decoration: BoxDecoration(
                                      color: C.walletList[index]['active']
                                          ? AppTheme.purseTheme
                                          : const Color(0xffF1F1F1),
                                      borderRadius: BorderRadius.circular(8.w),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formatText(
                                                  text: C.walletList[index]
                                                      ['walletname']),
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            if (C.walletList[index]['active'])
                                              SvgPicture.asset(
                                                'assets/svgs/markers.svg', // 设置SVG图标的路径
                                                width: 18.w,
                                                height: 18.w,
                                                // ignore: deprecated_member_use
                                                color: AppTheme.themeColor,
                                              ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OpClick(
                                                onTap: () {
                                                  //&复制到剪切板
                                                  copyToClipboard(
                                                      text: C.walletList[index]
                                                          ['address']);
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 15.w),
                                                      child: Text(
                                                        //&只显示前五位和后六位
                                                        formatText(
                                                          text: C.walletList[
                                                              index]['address'],
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/svgs/copy.svg', // 设置SVG图标的路径
                                                      width: 16.w,
                                                      height: 16.w,
                                                      // ignore: deprecated_member_use
                                                      color:
                                                          AppTheme.themeColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Obx(() => Text(
                                                    C.walletList[index]
                                                                ['balance'] ==
                                                            null
                                                        ? '0 BNB'
                                                        : C.walletList[index]
                                                                    ['balance']
                                                                .toStringAsFixed(
                                                                    3) +
                                                            ' BNB',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                            ])
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
