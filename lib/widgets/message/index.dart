import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wallet/common/utils/index.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/widgets/message/chat/chat_transfer.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  ///给获取详细信息的widget设置一个key
  GlobalKey iconkey = GlobalKey();

  ///获取位置，给后续弹窗设置位置
  late Offset iconOffset;

  ///获取size 后续计算弹出位置
  late Size iconSize;

  ///接受弹窗类构造成功传递来的关闭参数
  late Function closeModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox? box = iconkey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        iconSize = box.size;
        iconOffset = box.localToGlobal(Offset.zero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 点击空白处隐藏键盘
      },
      child: Scaffold(
          body: Stack(
        children: [
          //* double背景
          SvgPicture.asset(
            width: MediaQuery.of(context).size.width, //设置宽度 适配
            height: 490.h,
            'assets/svgs/appbar_bgc.svg',
            fit: BoxFit.cover,
          ),

          //* 顶部导航栏
          Container(
              width: MediaQuery.of(context).size.width,
              height: 170.h,
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 78.h, bottom: 10.h),
              child: Column(
                children: [
                  //? 消息和加号图标
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('消息(6)',
                          style: TextStyle(
                              fontSize: 18.sp, color: const Color(0XFF232832))),
                      //? 加号图标
                      OpClick(
                        key: iconkey,
                        onTap: () {
                          showModel(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.w),
                          child: SvgPicture.asset(
                            width: 23.w,
                            height: 23.w,
                            'assets/svgs/add.svg',
                            // ignore: deprecated_member_use
                            color: const Color(0xff232832),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          Container(
            // color: Colors.white,
            margin: EdgeInsets.only(top: 123.h),
            child: ListView.builder(
                itemCount: 1,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      //? 搜索框
                      Container(
                        width: 355.w,
                        height: 34.h,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.only(left: 16.w),
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(25.w)),
                        //^搜索框
                        child: TextField(
                          cursorColor: Colors.green, //设置光标颜色
                          strutStyle: StrutStyle.fromTextStyle(
                              TextStyle(fontSize: 25.0.w, height: 0.6.w)),
                          style: TextStyle(fontSize: 14.0.w), //设置字体大小
                          cursorHeight: 18.sp, //设置光标高度
                          cursorRadius: const Radius.circular(10), // 设置光标圆角半径
                          textAlignVertical: TextAlignVertical.center, // 将光标居中

                          decoration: InputDecoration(
                            hintText: '搜索好友、最近转账',
                            suffixIcon: Container(
                              margin: EdgeInsets.only(right: 22.w),
                              padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                              decoration: const BoxDecoration(),
                              child: SvgPicture.asset(
                                'assets/svgs/klm_search.svg', // 设置SVG图标的路径
                                width: 16.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff7e7e7e),
                                // height: 14.w,
                              ),
                            ),
                            isCollapsed: true, //去除内边距
                            contentPadding: EdgeInsets.all(0.w), //*去除内边距
                            border: InputBorder.none,
                          ),
                          // 添加 onSubmitted 回调处理用户按下键盘上的搜索按钮的事件
                          onSubmitted: (value) {},
                          // 添加 onChanged 回调处理搜索文本的更新
                          onChanged: (value) {
                            setState(() {});
                          }, // 添加 onChanged 回调处理搜索文本的更新
                        ),
                      ),
                      //* 账单收益到账啦
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 72.h,
                        color: Colors.white,
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 20.w), // 设置左右边距为20
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // bell
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff0563B6),
                                      borderRadius: BorderRadius.circular(5.w)),
                                  child: SvgPicture.asset(
                                    'assets/svgs/bell.svg', // 设置SVG图标的路径
                                    // height: 14.w,
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 13.w, left: 12.w),
                                  child: Column(
                                    children: [
                                      Text(
                                        '账单收益到账啦',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: const Color(0xff333333),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5.w),
                                        child: const Row(
                                          children: [
                                            Text(
                                              '消息盒子',
                                              style: TextStyle(
                                                  color: Color(0xff828895)),
                                            ), // 消息盒子
                                            Text(
                                              '｜',
                                              style: TextStyle(
                                                  color: Color(0xff828895)),
                                            ), // |
                                            Text(
                                              '账户余额',
                                              style: TextStyle(
                                                  color: Color(0xff828895)),
                                            ), // | 账户余额
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(bottom: 28.w),
                                child: const Text(
                                  '昨天',
                                  style: TextStyle(color: Color(0xff828895)),
                                ))
                          ],
                        ),
                      ),
                      //中间的灰色盒子
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 15.h,
                        color: const Color(0xffF3F5F9),
                      ),
                      //* 朋友的名片
                      Container(
                        color: Colors.white,
                        constraints: BoxConstraints(
                          minHeight: 844.h -
                              getStatusBarHeight(context) -
                              72.h -
                              15.h -
                              34.h, // 设置最小高度为200像素
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < 1; i++)
                              GestureDetector(
                                onTap: () {
                                  //跳转到  ChatPage 页面

                                  Get.to(const ChatTransfer());
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 72.h,
                                  color: Colors.white,
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 20.w), // 设置左右边距为20
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: 40.w,
                                          height: 40.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                            child: const Image(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  'https://wx2.sinaimg.cn/mw690/007TYxG2ly1hbwxeuuambj328k3m0u12.jpg',
                                                )),
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                84.w,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 1.w,
                                              color: const Color(0xffeaeaea),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 12.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '小王子最帅',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: const Color(
                                                          0xff333333),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5.w),
                                                    child: Text(
                                                      '保存朋友的名片，转账更方便',
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: const Color(
                                                              0xff828895)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 28.w),
                                                child: Text(
                                                  '23/03/12',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: const Color(
                                                          0xff828895)),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          )
        ],
      )),
    );
  }

//& 下拉框 ------start
  ///播放动画
  void showModel(BuildContext context) {
    /// 设置传入弹窗的高宽
    double width = 158.w;
    double height = 80.w;

    Navigator.push(
      context,
      Popup(
        child: Model(
          left: iconOffset.dx - width + iconSize.width + 18.w / 1.2,
          top: iconOffset.dy + iconSize.height + 2.w / 1.3,
          offset: Offset(width / 2, -height / 2),
          child: SizedBox(
            width: width,
            height: height,
            child: buildMenu(),
          ),
          fun: (close) {
            closeModel = close;
          },
        ),
      ),
    );
  }

  ///构造传入的widget
  Widget buildMenu() {
    ///构造List
    // List list = ['发起对话'];

    return SizedBox(
      height: 164.h,
      width: 230.w,
      child: Stack(
        children: [
          Positioned(
            right: 10.w,
            top: 4.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              transform: Matrix4.rotationZ(45.w * 3.14 / 180.w),
              decoration: BoxDecoration(
                //渐变色
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff9FDADE),
                    Color(0xff92ADDF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(5.w),
              ),
            ),
          ),

          ///菜单内容
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 20.h,
                bottom: 19.h,
                left: 41.w,
                right: 43.w,
              ),
              width: 156.w,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                //渐变色
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff9FDADE),
                    Color(0xff92ADDF),
                  ],
                ),
              ),
              child: Text(
                '发起对话',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //& 下拉框 ------end
}

//&下拉框 ------start

class Popup extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;

  Popup({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class Model extends StatefulWidget {
  final double left; //距离左边位置 弹窗的x轴定位
  final double top; //距离上面位置 弹窗的y轴定位
  final bool otherClose; //点击背景关闭页面
  final Widget child; //传入弹窗的样式
  final Function fun; // 把关闭的函数返回给父组件 参考vue的$emit
  final Offset offset; // 弹窗动画的起点

  const Model({
    super.key,
    required this.child,
    this.left = 0,
    this.top = 0,
    this.otherClose = false,
    required this.fun,
    required this.offset,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ModelState createState() => _ModelState();
}

class _ModelState extends State<Model> {
  late AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              onTap: () async {
                if (widget.otherClose) {
                } else {
                  closeModel();
                }
              },
            ),
          ),
          Positioned(
            /// 这个是弹窗动画 在下方，我把他分离 防止太长
            left: widget.left,
            top: widget.top,
            child: ZoomInOffset(
              duration: const Duration(milliseconds: 180),
              offset: widget.offset,
              controller: (controller) {
                animateController = controller;
                widget.fun(closeModel);
              },
              key: UniqueKey(),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  ///关闭页面动画
  Future closeModel() async {
    await animateController.reverse();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

class ZoomInOffset extends StatefulWidget {
  // ignore: annotate_overrides, overridden_fields
  final Key key;
  final Widget child;
  final Duration duration;
  final Duration delay;

  ///把控制器通过函数传递出去，可以在父组件进行控制
  final Function(AnimationController) controller;
  final bool manualTrigger;
  final bool animate;
  final double from;

  ///这是我自己写的 起点
  final Offset offset;

  ZoomInOffset(
      {required this.key,
      required this.child,
      this.duration = const Duration(milliseconds: 500),
      this.delay = const Duration(milliseconds: 0),
      required this.controller,
      this.manualTrigger = false,
      this.animate = true,
      required this.offset,
      this.from = 1.0})
      : super(key: key) {
    // ignore: unnecessary_null_comparison
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  // ignore: library_private_types_in_public_api
  _ZoomInState createState() => _ZoomInState();
}

/// State class, where the magic happens
class _ZoomInState extends State<ZoomInOffset>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool disposed = false;
  late Animation<double> fade;
  late Animation<double> opacity;

  @override
  void dispose() async {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);
    fade = Tween(begin: 0.0, end: widget.from)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: controller));

    opacity = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0, 0.65)));

    if (!widget.manualTrigger && widget.animate) {
      Future.delayed(widget.delay, () {
        if (!disposed) {
          controller.forward();
        }
      });
    }

    widget.controller(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller.forward();
    }

    return AnimatedBuilder(
      animation: fade,
      builder: (context, child) {
        ///  这个transform有origin的可选构造参数，我们可以手动添加
        return Transform.scale(
          origin: widget.offset,
          scale: fade.value,
          child: Opacity(
            opacity: opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
//&下拉框 ------end

//&发起对话 ------start  InitiateADialogue
class InitiateADialogue extends StatefulWidget {
  const InitiateADialogue({super.key});

  @override
  State<InitiateADialogue> createState() => _InitiateADialogueState();
}

class _InitiateADialogueState extends State<InitiateADialogue> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
