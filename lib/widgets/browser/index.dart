import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/common/style/app_theme.dart';

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  double isBtns = 0;
  bool isCollect = false; //是否收藏
  List<String> btns = [
    '推荐',
    '探索',
    '收藏',
  ];
  final FocusNode _focussearchNode = FocusNode(); //搜索框焦点控制
  bool isSearching = false; //是否正在搜索

  @override
  void initState() {
    super.initState();
    _focussearchNode.addListener(_focusChanged); //监听输入框是否失去焦点
  }

  @override
  void dispose() {
    _focussearchNode.removeListener(_focusChanged); //移除监听
    _focussearchNode.dispose(); //销毁焦点控制

    super.dispose();
  }

  //监听输入框是否失去焦点,书去焦点后3秒后设置isSearching为false
  void _focusChanged() {
    if (_focussearchNode.hasFocus) {
      setState(() {
        isSearching = true; //设置正在搜索
      });
    } else {
      setState(() {
        isSearching = false; //设置正在搜索
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          isSearching = false; //设置正在搜索
          _focussearchNode.unfocus(); //取消搜索框的焦点
          FocusScope.of(context).requestFocus(FocusNode()); // 点击空白处隐藏键盘
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              SvgPicture.asset(
                width: 390.w,
                height: 844.h,
                'assets/svgs/appbar_bgc.svg',
                fit: BoxFit.cover,
              ),
              SvgPicture.asset(
                width: 390.w,
                height: 844.h,
                'assets/svgs/appbar_bgc.svg',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 135.h,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSearching = true; //设置正在搜索
                          _focussearchNode.requestFocus(); // 获取焦点
                        });
                      },
                      child: Container(
                        width: 319.w,
                        height: 30.h,
                        margin: EdgeInsets.only(top: 70.h, left: 19.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.w)),
                        child: TextField(
                          focusNode: _focussearchNode, // 将搜索框和FocusNode关联
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.only(top: 3.w, bottom: 3.w),
                              child: SvgPicture.asset(
                                'assets/svgs/sousuo.svg', // 设置SVG图标的路径
                                width: 15.w,
                                height: 17.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff0162F8),
                              ),
                            ),
                            isCollapsed: true, //*去除内边距
                            contentPadding: const EdgeInsets.all(0), //*去除内边距
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 70.h, left: 8.w),
                      child: InkWell(
                        onTap: () {
                          isSearching = false; //设置正在搜索
                          _focussearchNode.unfocus(); //取消搜索框的焦点
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: const Color(0xff0162F8).withOpacity(0.5),
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _focussearchNode.hasFocus
                  ? Container()
                  : Positioned(
                      top: 135.h,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 15.w, right: 21.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 140.w,
                                height: 22.w,
                                margin: EdgeInsets.only(
                                    top: 18.h, bottom: 15.h, left: 5.w),
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
                                        child: Center(
                                            child: Text(
                                          i,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: isBtns == btns.indexOf(i)
                                                ? Colors.black
                                                : AppTheme.browserColor,
                                          ),
                                        )),
                                      )
                                  ],
                                ),
                              ),
                              const Image(
                                  image: AssetImage(
                                      'assets/images/Shopping_Online.png')),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 23.h, bottom: 15.h, left: 5.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w)),
                                child: Text(
                                  '立即体验',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ))),
              _focussearchNode.hasFocus
                  ? const HistoricalRecord()
                  : Positioned(
                      top: 405.h,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15.w, right: 21.w),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 10.w),
                          itemCount: 10, // 列表项数
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14.w),
                              child: Column(
                                  children: List.generate(1, (index) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 60.w,
                                      height: 60.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/colt.png'),
                                      ),
                                    ),
                                    Container(
                                      width: 240.w,
                                      margin: EdgeInsets.only(left: 20.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Uniswap',
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xff000000)),
                                          ),
                                          Text(
                                            // maxLines: null, // 设置为null或者大于1的整数，表示不限制行数
                                            softWrap: true,
                                            'A protocol for trading and automated liquidity provision on Ethereum',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppTheme.browserColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3.w),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isCollect = !isCollect;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/svgs/xingxing.svg', // 设置SVG图标的路径
                                          width: 24.w,
                                          height: 24.w,
                                          // ignore: deprecated_member_use
                                          color: isCollect
                                              ? const Color(0xffF3D11C)
                                              : const Color(0xffEDEFF5),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              })),
                            );
                          },
                        ),
                      ))
            ])));
  }
}

//历史记录
class HistoricalRecord extends StatefulWidget {
  const HistoricalRecord({super.key});

  @override
  State<HistoricalRecord> createState() => _HistoricalRecordState();
}

class _HistoricalRecordState extends State<HistoricalRecord> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 135.h,
        left: 0,
        bottom: 0,
        right: 0,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15.w, right: 21.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 23.h, bottom: 15.h, left: 5.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w)),
                    child: Text(
                      '历史记录',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 23.h, bottom: 15.h, left: 5.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w)),
                    child: SvgPicture.asset(
                      'assets/svgs/a-12Fshanchu.svg', // 设置SVG图标的路径
                      width: 24.w,
                      height: 24.w,
                      // ignore: deprecated_member_use
                      color: AppTheme.browserColor,
                    ),
                  ),
                ],
              )
            ])));
  }
}

class CustomListItem extends StatefulWidget {
  final String svgPath; //SVG路径
  final String imagePath; //图片路径
  final String title; //标题
  final String content; //内容
  final GestureTapCallback? onTapIncident; //点击事件

  const CustomListItem(
      {super.key,
      required this.svgPath,
      this.imagePath = 'assets/images/colt.png',
      this.onTapIncident,
      this.title = 'Uniswap',
      this.content =
          'A protocol for trading and automated liquidity provision on Ethereum'});

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(1, (index) {
      return Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
            child: Image(
              image: AssetImage(widget.imagePath),
            ),
          ),
          Container(
            width: 240.w,
            margin: EdgeInsets.only(left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff000000)),
                ),
                Text(
                  // maxLines: null, // 设置为null或者大于1的整数，表示不限制行数
                  softWrap: true,
                  widget.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.browserColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 3.w),
            child: InkWell(
              onTap: () {
                widget.onTapIncident;
              },
              child: SvgPicture.asset(
                widget.svgPath, // 设置SVG图标的路径
                width: 24.w,
                height: 24.w,
                // ignore: deprecated_member_use
              ),
            ),
          )
        ],
      );
    }));
  }
}
