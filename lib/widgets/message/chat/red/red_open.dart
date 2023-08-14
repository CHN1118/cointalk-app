import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/common_color.dart';
import '../../../../common/style/common_style.dart';
import '../../../index.dart';

class RedOpen extends StatefulWidget {
  const RedOpen({Key? key}) : super(key: key);

  @override
  State<RedOpen> createState() => _RedOpenState();
}

class _RedOpenState extends State<RedOpen> {
  String amount = Get.arguments["num"];
  String name = Get.arguments["name"];
  String openFlag = Get.arguments["openFlag"];
  String remark = Get.arguments["remark"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColor.redPackColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            openFlag == "1" ? '${name} 的红包' : '发给 ${name}',
            style: CommonStyle.text_18_white_w400,
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF2F2F2),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFF2F2F2),
            child: Column(
              children: [
                // 顶部头部背景
                initHeadView(),
                // 最终确定按钮
                redPackConfirm(),
              ],
            ),
          ),
        ));
  }

  // 顶部头部背景
  Widget initHeadView() {
    return Stack(
      children: [
        CustomPaint(
          painter: TopOvalPainter(Colors.white, 0),
          child: Container(
            height: 0,
          ),
        ),
        // Smaller red arc
        CustomPaint(
          painter: TopOvalPainter(CommonColor.redPackColor, 60),
          child: Container(
            height: 0,
          ),
        ),
      ],
    );
  }

  //  红包确认
  Widget redPackConfirm() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: Get.height * 0.15),
          alignment: Alignment.center,
          child: Text(remark, style: CommonStyle.text_16_grey),
        ),
        Container(
          height: 56,
          margin: EdgeInsets.only(top: 86),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text(
                      amount,
                      style: CommonStyle.text_32_black_w500,
                    ),
                  ),
                  Text(
                    "USDT",
                    style: CommonStyle.text_16_black_w500,
                  ),
                ],
              )),
        ),
        openFlag == "1"
            ? InkWell(
                onTap: () {
                  Get.offAll(Index(), arguments: 1);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "已存入余额，可直接消费",
                      style: CommonStyle.text_14_grey,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                      size: 14,
                    ),
                  ],
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.only(top: Get.height * 0.3),
          width: double.infinity,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CommonColor.redPackColor),
                    ),
                    child: Text(
                      "确定",
                      style: CommonStyle.text_16_white_w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TopOvalPainter extends CustomPainter {
  final Color color;
  final double arcHeight;

  TopOvalPainter(this.color, this.arcHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, arcHeight);
    path.quadraticBezierTo(size.width / 2, arcHeight + 50, size.width, arcHeight);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
