import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/global/global_key.dart';
import '../../../common/style/common_color.dart';
import '../../../common/style/common_style.dart';
import '../../../common/utils/text_verify.dart';
import '../../../common/utils/toast_print.dart';
import '../../../components/pay_pwd_controller.dart';
import '../../../spec/chat/consumer.dart';
import '../../../spec/coin.dart';
import '../../../wallet/coin_select.dart';
import 'number_keyboard.dart';

class SendRedPack extends StatefulWidget {
  const SendRedPack({Key? key}) : super(key: key);

  @override
  State<SendRedPack> createState() => _SendRedPackState();
}

class _SendRedPackState extends State<SendRedPack> {
  Consumer consumer = Get.arguments["consumer"];

  // 币种列表
  String coinValue = "1";
  int coinIndex = 0;

  /// 币种下拉选择值改变
  coinSelectChange(value) {
    print("值改变了：$value");
    setState(() {
      coinValue = value;
      CoinList.map((item) => {
            if (item.value == value) {coinIndex = CoinList.indexOf(item)}
          }).toList();
      // receivedIndex =int.parse(value);
    });
  }

  final amountController = TextEditingController();
  final remarkController = TextEditingController(); // 红包描述
  FocusNode amountFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();

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
              // 处理关闭按钮的点击事件
              Get.back();
            },
          ),
          title: Text('send_red_envelope'.tr, textAlign: TextAlign.center, style: CommonStyle.text_18_white_w400),
          centerTitle: true,
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     // 处理红包记录文字的点击事件
            //     Get.to(() => RedPackRecord());
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     padding: EdgeInsets.only(right: 15),
            //     child: Text(
            //       '红包记录',
            //       style: CommonStyle.text_15_white_w400,
            //     ),
            //   ),
            // ),
          ],
        ),
        backgroundColor: Color(0xFFF2F2F2),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // 顶部头部背景
                initHeadView(),
                // 红包金额
                redPackAmount(),
                // 红包描述 或者红包说明备注
                redPackDesc(),
                // 红包封面
                // redPackCover(),
                // 最终确定按钮
                redPackConfirm()
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
        Container(
          alignment: Alignment.center,
          child: Text("${'give'.tr} ${consumer.nickname}", style: CommonStyle.text_14_white_w400),
        )
      ],
    );
  }

  //  红包金额
  Widget redPackAmount() {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: 19, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左边
          Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "amount".tr,
                style: CommonStyle.text_16_black_w400,
              )),

          // 右边
          Flexible(
            child: Container(
                margin: EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.only(right: 11.5),
                      child: TextField(
                        textAlign: TextAlign.right,
                        // 文本从右边开始输入
                        autofocus: true,
                        focusNode: amountFocusNode,
                        controller: amountController,
                        readOnly: true,
                        maxLength: 6,
                        onTap: () {
                          // 弹出自定义键盘
                          showCustomKeyboard(context, amountController);
                          print("onTap");
                        },
                        onChanged: (value) {
                          print("onChanged" + value);
                          if (value.length > 6) {
                            ToastPrint.show("amount_up_to_6_digits".tr);
                            return;
                          }
                          setState(() {
                            amountController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        style: CommonStyle.text_20_w500,
                      ),
                    )),
                    Container(
                      padding: EdgeInsets.only(right: 5, left: 11.5, top: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFFBFC0C7),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Image.asset(CoinList[coinIndex].image, width: 26, height: 26),
                    ),

                    SizedBox(
                      height: 1,
                    ),
                    // 选择框 选择币种
                    Container(
                        padding: EdgeInsets.only(top: 1),
                        child: CoinSelectWidget(
                          items: CoinList,
                          value: coinValue,
                          valueChanged: coinSelectChange,
                          currentValueSize: 16,
                        ))
                  ],
                )),
          ),
        ],
      ),
    );
  }

  //  红包封面
  Widget redPackCover() {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
          margin: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "red_envelope_cover".tr,
                style: CommonStyle.text_16_w400,
              ),
              IconButton(
                onPressed: () {
                  print("点击了红包封面的下一步（跳转)");
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF999999),
                ),
              )
            ],
          )),
    );
  }

  // 红包描述 或者红包说明备注
  Widget redPackDesc() {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
          margin: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  // 文本从右边开始输入
                  autofocus: true,
                  controller: remarkController,
                  focusNode: remarkFocusNode,
                  maxLength: 10,
                  // onTap: () {
                  //   print("onTap");
                  // },
                  onChanged: (value) {
                    if (value.length > 10) {
                      ToastPrint.show("note_up_to_10_characters".tr);
                    }
                  },
                  //关联focusNode1
                  decoration: InputDecoration(
                    hintText: "red_envelope_remarks_hint".tr,
                    hintStyle: CommonStyle.text_16_w400,
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  style: CommonStyle.text_20_w500,
                ),
              ),
            ],
          )),
    );
  }

  //  红包确认
  Widget redPackConfirm() {
    return Column(
      children: [
        Container(
          height: 56,
          margin: EdgeInsets.only(top: Get.height * 0.15),
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
                      amountController.text.isEmpty ? '0' : amountController.text,
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
        // 塞钱进红包按钮
        Container(
          width: double.infinity,
          //color: Colors.red,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: Get.width * 0.9,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      if (amountController.text.isEmpty) {
                        ToastPrint.show("please_input_red_envelope_amount".tr);
                        return;
                      }
                      if (remarkController.text.length > 10) {
                        ToastPrint.show("note_up_to_10_characters".tr);
                        return;
                      }
                      print("点击了塞钱进红包" + amountController.text);
                      Get.find<PayPwdBottomController>().openBottomSheet(
                        context,
                        consumer.account,
                        amountController.text,
                        remarkController.text,
                        GSourcePage.CHAT_RED,
                      );
                      // Get.back(result: amountController.text);
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.redPackColor)),
                    child: Text(
                      "stuff_money_into_red_envelope".tr,
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

  // 自定义键盘
  void showCustomKeyboard(BuildContext context, TextEditingController _textEditingController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 256, // 设置底部菜单的高度
            child: NumberKeyboard(
              confirmText: 'confirm'.tr,
              confirmColor: Color(0xFFE6E6E6),
              confirmBgColor: CommonColor.redPackColor,
              onTap: (value) {
                final currentValue = _textEditingController.text;
                String newValue = '$currentValue$value';
                if (currentValue == "" && value == ".") {
                  newValue = '0$value';
                }
                if (!TextVerify.validateDoubleDigit6(newValue)) {
                  ToastPrint.show("cannot_exceed_6_decimal_places".tr);
                  return;
                }
                if (double.parse(newValue) > 200) {
                  ToastPrint.show("amount_cannot_exceed_200".tr);
                  return;
                }
                setState(() {
                  _textEditingController.text = newValue;
                });
              },
              onCommit: () {
                print("点击了确认按钮");
                // 处理回车按键的逻辑
                Get.back();
              },
              onDel: () {
                // 处理删除按键的逻辑
                if (_textEditingController.text.isNotEmpty) {
                  setState(() {
                    _textEditingController.text =
                        _textEditingController.text.substring(0, _textEditingController.text.length - 1);
                  });
                }
              },
            ));
      },
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
