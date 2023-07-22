// Share
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/common/style/app_theme.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  SharePageState createState() => SharePageState();
}

class SharePageState extends State<SharePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context); // 在页面加载完成后调用弹框函数
    });
  }

//~分享弹框
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffEDEFF5).withOpacity(1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 198.h,
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(left: 22.w, right: 21.w, top: 8.h, bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 14.w),
                margin: EdgeInsets.only(bottom: 14.w),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1.w, color: const Color(0xffDCDCDC)))),
                child: Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w)),
                      child: const Image(
                        image: AssetImage('assets/images/colt.png'),
                      ),
                    ),
                    Container(
                      width: 245.w,
                      margin: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uniswap',
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff000000)),
                          ),
                          Text(
                            // maxLines: null, // 设置为null或者大于1的整数，表示不限制行数
                            softWrap: true,
                            'https://app.uniswap.org/',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.browserColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 18.w, right: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.w),
                          width: 30.w,
                          height: 30.w,
                          child: const Image(
                            image: AssetImage('assets/images/WeChat.png'),
                          ),
                        ),
                        Text(
                          'WeChat',
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xff000000)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.w),
                          width: 30.w,
                          height: 30.w,
                          child: const Image(
                            image: AssetImage('assets/images/Twitter.png'),
                          ),
                        ),
                        Text(
                          'Twitter',
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xff000000)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.w),
                          width: 30.w,
                          height: 30.w,
                          child: const Image(
                            image: AssetImage('assets/images/Instagram.png'),
                          ),
                        ),
                        Text(
                          'Instagram',
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xff000000)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.w),
                          width: 30.w,
                          height: 30.w,
                          child: const Image(
                            image: AssetImage('assets/images/Telegram.png'),
                          ),
                        ),
                        Text(
                          'Telegram',
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xff000000)),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
