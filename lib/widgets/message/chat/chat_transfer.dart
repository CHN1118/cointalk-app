import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatTransfer extends StatefulWidget {
  const ChatTransfer({super.key});

  @override
  State<ChatTransfer> createState() => _ChatTransferState();
}

class _ChatTransferState extends State<ChatTransfer> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // 在页面打开时自动获取焦点
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); //释放 focusNode
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '转账',
            style: TextStyle(fontSize: 18.w),
          ),
          centerTitle: true, // 标题居中
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20.w),
              child: Text(
                '转账记录',
                style: TextStyle(fontSize: 15.sp, color: Color(0xff6B6B6B)),
              ),
            ),
          ],
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 12.w),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/del2.svg', // 设置SVG图标的路径
                  width: 18.w,
                  // height: 22.w,
                  // ignore: deprecated_member_use
                  color: const Color(0xff7F8391),
                ),
              ),
            ),
          ),
        ),
        body: Stack(children: [
          Container(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 20.w), // 设置左右边距为20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.w, bottom: 39.w),
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.w),
                            child: const Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'https://wx2.sinaimg.cn/mw690/007TYxG2ly1hbwxeuuambj328k3m0u12.jpg',
                                )),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '小王子最帅',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xff212121),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.w),
                              child: Text(
                                '138*****2334',
                                style: TextStyle(
                                    color: const Color(0xff828895),
                                    fontSize: 14.sp),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '转账金额',
                  style: TextStyle(
                      fontSize: 14.sp, color: const Color(0xff828895)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 7.w),
                  margin: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    width: 1.w,
                    color: const Color(0xffE5E5E5),
                  ))),
                  child: Container(
                    padding: EdgeInsets.only(left: 17.w),
                    child: TextField(
                      focusNode: _focusNode, // 将输入框与焦点关联
                      autofocus: true, // 自动获取焦点
                      cursorColor:
                          const Color(0xff000000).withOpacity(0.5), //设置光标颜色
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
                      // 添加 onChanged 回调处理用户输入的内容
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
