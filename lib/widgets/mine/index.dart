import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/widgets/mine/wallets.dart';

//&我的
class Mymine extends StatefulWidget {
  const Mymine({super.key});

  @override
  State<Mymine> createState() => _MymineState();
}

bool isPersonalData = false;

class _MymineState extends State<Mymine> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isPersonalData = false;
  }

  @override
  Widget build(BuildContext context) {
    return isPersonalData
        ? const PersonalData()
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 62.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '我的',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 124.h),
                    padding: EdgeInsets.only(left: 22.w, right: 25.w),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            //跳转到钱包管理 WalletMan
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WalletMan()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 18.w),
                                    child: SvgPicture.asset(
                                      'assets/svgs/24gf-wallet.svg', // 设置SVG图标的路径
                                      width: 25.w,
                                      // height: 22.w,
                                      // ignore: deprecated_member_use
                                      color: const Color(0xff7F8391),
                                    ),
                                  ),
                                  Text(
                                    '钱包管理',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: const Color(0xff000000)),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                                width: 18.w,
                                // height: 22.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff7F8391),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 16.h, bottom: 11.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.w,
                                  color: const Color(0xffE5E5E5),
                                ),
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            //跳转到个人资料 PersonalData
                            setState(() {
                              isPersonalData = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 18.w),
                                    child: SvgPicture.asset(
                                      'assets/svgs/my-mine.svg', // 设置SVG图标的路径
                                      width: 24.w,
                                      // height: 22.w,
                                      // ignore: deprecated_member_use
                                      color: const Color(0xff7F8391),
                                    ),
                                  ),
                                  Text(
                                    '个人资料',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: const Color(0xff000000)),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                                width: 18.w,
                                // height: 22.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff7F8391),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 16.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.w,
                                  color: const Color(0xffE5E5E5),
                                ),
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          );
  }
}

//&个人资料 PersonalData
class PersonalData extends StatefulWidget {
  const PersonalData({
    super.key,
  });

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isPersonalData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: 62.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isPersonalData = false;
                  });
                },
                child: Text(
                  '个人资料',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //网络图片
                Container(
                  margin: EdgeInsets.only(top: 115.h),
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.5.w))),
                  // https://wx2.sinaimg.cn/mw690/007TYxG2ly1hbwxeuuambj328k3m0u12.jpg
                  child: Image.network(
                    'https://wx2.sinaimg.cn/mw690/007TYxG2ly1hbwxeuuambj328k3m0u12.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
        //昵称
        InkWell(
          onTap: () {
            // EditorPage
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditorPage()));
          },
          child: Container(
            margin: EdgeInsets.only(top: 185.h, left: 22.w, right: 21.w),
            padding: EdgeInsets.only(bottom: 10.w, left: 9.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.w,
                  color: const Color(0xffDCDCDC),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 216.w),
                    child: Text(
                      '名字',
                      style: TextStyle(fontSize: 16.sp),
                    )),
                Text(
                  'dejavu',
                  style: TextStyle(fontSize: 16.sp),
                ),
                Container(
                  margin: EdgeInsets.only(left: 19.w),
                  child: SvgPicture.asset(
                    'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                    width: 16.w,
                    // height: 22.w,
                    // ignore: deprecated_member_use
                    color: const Color(0xff7F8391),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 145.w,
          left: 212.w,
          child: InkWell(
            onTap: () {
              _showBottomSheet(context);
            },
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: SvgPicture.asset(
                'assets/svgs/paishe_A_Facet.svg', // 设置SVG图标的路径
                width: 25.w,
                // height: 22.w,
                // ignore: deprecated_member_use
                color: const Color(0xff7F8391),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfFc),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 11.w),
          height: 125.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 7.h),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('拍照', style: TextStyle(color: Color(0xff1C59F3)))
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 7.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.w,
                        color: const Color(0xff7F8391).withOpacity(0.5),
                      ),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 7.h, bottom: 7.h),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '相册',
                      style: TextStyle(color: Color(0xff1C59F3)),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 7.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.w,
                        color: const Color(0xff7F8391).withOpacity(0.5),
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7.h, bottom: 7.h),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '取消',
                        style: TextStyle(color: Color(0xffB4B4B4)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//&编辑资料 Editor
class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 22.w),
              child: Text(
                '保存',
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          ),
        ],
        title: Text(
          '编辑资料',
          style: TextStyle(fontSize: 20.sp),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 9.w),
            child: Center(
              child: Text(
                '取消',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xff000000).withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 7.w),
        margin: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1.w,
          color: const Color(0xffE5E5E5),
        ))),
        child: TextField(
          cursorColor: const Color(0xff000000).withOpacity(0.5), //设置光标颜色
          strutStyle: StrutStyle.fromTextStyle(
              TextStyle(fontSize: 25.0.w, height: 0.8.w)),
          style: TextStyle(fontSize: 14.0.w), //设置字体大小
          cursorHeight: 18.sp, //设置光标高度
          cursorRadius: const Radius.circular(10), // 设置光标圆角半径
          textAlignVertical: TextAlignVertical.center, // 将光标居中
          decoration: InputDecoration(
            isCollapsed: true, //去除内边距

            contentPadding: EdgeInsets.all(0.w), //*去除内边距
            border: InputBorder.none,
          ),
          // 添加 onSubmitted 回调处理用户按下键盘上的搜索按钮的事件
          onSubmitted: (value) {},
        ),
      ),
    );
  }
}
