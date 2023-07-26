import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/common/style/app_theme.dart';

class WalletMan extends StatefulWidget {
  const WalletMan({super.key});

  @override
  State<WalletMan> createState() => _WalletManState();
}

//钱包数据
class ListItem {
  String text;
  bool isMarkers;

  ListItem({required this.text, this.isMarkers = false});
}

//&钱包管理
class _WalletManState extends State<WalletMan> {
  double isBtns = 0; //是否选中
//~左侧的四个图标
  List<String> btns = [
    'assets/svgs/purse_icon1.svg',
    'assets/svgs/purse_icon2.svg',
    'assets/svgs/purse_icon3.svg',
    'assets/svgs/purse_icon4.svg',
  ];
  //~钱包数据
  List<ListItem> items = [
    for (int i = 0; i < 5; i++) ListItem(text: '项1'),
  ];
  //~判断点击选择了哪个钱包
  void handleItemClick(int index) {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        if (i == index) {
          items[i].isMarkers = true;
        } else {
          items[i].isMarkers = false;
        }
      }
    });
  }

  //~只显示前五位和后六位
  String formatText({required String text}) {
    if (text.length <= 11) {
      return text;
    } else {
      String abbreviatedText =
          "${text.substring(0, 5)}...${text.substring(text.length - 6, text.length)}";
      return abbreviatedText;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 标题居中
        title: Text('钱包管理', style: TextStyle(fontSize: 20.sp)),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width, // 设置容器宽度为屏幕宽度
        child: Row(
          children: [
            Container(
              color: AppTheme.purseTheme,
              width: 70.w,
              height: MediaQuery.of(context).size.height, // 设置容器高度为屏幕高度
              child: Column(
                children: [
                  for (String i in btns)
                    //& 推荐探索收藏列表
                    Container(
                      // width: 70.w,
                      // height: 54.w,
                      color: isBtns == btns.indexOf(i).toDouble()
                          ? Colors.white
                          : AppTheme.purseTheme,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isBtns = btns.indexOf(i).toDouble();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(16.w),
                          child: SvgPicture.asset(
                            i, // 设置SVG图标的路径
                            width: 38.w,
                            height: 38.w,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 30.w),
              width: 320.w,
              height: MediaQuery.of(context).size.height, // 设置容器高度为屏幕高度
              child: Stack(children: [
                SizedBox(
                  height: 48.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BNB Chain',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w900),
                      ),
                      InkWell(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/add.svg', // 设置SVG图标的路径
                          width: 20.w,
                          height: 20.w,
                          // ignore: deprecated_member_use
                          color: const Color(0xff45AAAF),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 56.w),
                  child: SizedBox(
                    width: 320.w,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ClipRect(
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
                                    key: Key(items[index].text),
                                    endActionPane: ActionPane(
                                      extentRatio: 0.35, // 控制滑动项widget的大小
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
                                              bottomRight:
                                                  Radius.circular(8.w)),
                                          backgroundColor:
                                              const Color(0xff45AAAF),
                                          foregroundColor: Colors.white,
                                          label: '删除',
                                        )
                                      ],
                                    ),
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 15.w),
                                        decoration: BoxDecoration(
                                          color: items[index].isMarkers
                                              ? AppTheme.purseTheme
                                              : const Color(0xffF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '钱包1号',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                if (items[index].isMarkers)
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      //&复制到剪切板
                                                      copyToClipboard(
                                                          text:
                                                              '0xwarashiuggfjkfiddijsc9DP');
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15.w),
                                                          child: Text(
                                                            //&只显示前五位和后六位
                                                            formatText(
                                                                text:
                                                                    '0xwarashiuggfjkfiddijsc9DP'),
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
                                                          color: AppTheme
                                                              .themeColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    '0 BNB',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ])
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  //~删除钱包底部弹窗
  void _delBottomSheet1(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfF5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
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
                  InkWell(
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
                                '钱包1号',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //&复制到剪切板
                                    copyToClipboard(
                                        text: '0xwarashiuggfjkfiddijsc9DP');
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 15.w),
                                        child: Text(
                                          //&只显示前五位和后六位
                                          formatText(
                                              text:
                                                  '0xwarashiuggfjkfiddijsc9DP'),
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
                                  '0 BNB',
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            //删除items的数据
                            items.removeAt(index);
                            showSnackBar(msg: '删除成功');
                            Navigator.pop(context); // 关闭底部弹框
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
                      InkWell(
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

  //~创建钱包，导入钱包底部弹窗
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfF5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
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
                  InkWell(
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
                    Container(
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
                    Container(
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
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
