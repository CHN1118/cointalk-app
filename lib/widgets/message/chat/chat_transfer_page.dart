import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/global/global_key.dart';
import '../../../common/style/common_style.dart';
import '../../../common/utils/toast_print.dart';
import '../../../components/pay_pwd_controller.dart';
import '../../../spec/chat/consumer.dart';
import '../../../spec/chat/transfer_record.dart';
import '../../../spec/coin.dart';
import '../../../wallet/coin_select.dart';
import 'number_keyboard.dart';

class ChatTransferPage extends StatefulWidget {
  const ChatTransferPage({Key? key}) : super(key: key);

  @override
  State<ChatTransferPage> createState() => _ChatTransferPageState();
}

class _ChatTransferPageState extends State<ChatTransferPage> {
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

  final _transferAmountController = TextEditingController();
  final _remarkController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  Consumer consumer = Get.arguments["consumer"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.black,
          onPressed: () {
            // 处理关闭按钮的点击事件
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          'transfer'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff000000)),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       // 处理转账按钮的点击事件
        //     },
        //     child: Container(
        //       alignment: Alignment.center,
        //       padding: EdgeInsets.only(right: 15.w),
        //       child: TextButton(
        //         onPressed: () {
        //           Get.to(() => TransferRecord());
        //         },
        //         child: Text(
        //           'transfer_record'.tr,
        //           style: CommonStyle.text_15_color6B6B6B_w400,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 用户信息
          initUser(consumer),
          Container(
              margin: EdgeInsets.only(top: 15.h),
              child: Text("transfer_amount".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff828895))),
              width: double.infinity,
              padding: EdgeInsets.only(left: 20.w, bottom: 5.h)),
          // 转账金额
          initTransfer(),
          Padding(
            padding: EdgeInsets.only(
                top: 5.h, left: 20.w, right: 20.w), // 从左侧50.0处开始
            child: Divider(
              color: Color(0xFFEAEAEA),
              height: 0.5.h,
            ),
          ),
          //转账说明
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 20.h, left: 20.h),
              child: InkWell(
                onTap: () {
                  // 处理添加转账说明按钮的点击事件
                  showCustomKeyboard(
                      context, _transferAmountController, _remarkController);
                },
                child: Text(
                  _remarkController.text == ""
                      ? "add_transfer_info".tr
                      : _remarkController.text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0563B6),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  //  用户信息
  Widget initUser(Consumer consumer) {
    return Container(
      height: 70.h,
      child: Center(
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                image: DecorationImage(
                  image: NetworkImage(
                    consumer.avatar,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.w),
                    child: Text(
                      '${consumer.nickname}',

                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000)),
                    ),
                  ),
                  Container(
                    width: Get.width*0.7,
                    child: Text(
                      '${consumer.account}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff828895)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  转账金额
  Widget initTransfer() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左边
            Flexible(
              child:
                  // 左边
                  Container(
                margin: EdgeInsets.only(left: 20.w),
                child: TextField(
                  controller: _transferAmountController,
                  autofocus: true,
                  focusNode: focusNode,
                  readOnly: true,
                  onTap: () {
                    // 弹出自定义键盘
                    showCustomKeyboard(
                        context, _transferAmountController, _remarkController);
                    print("onTap");
                  },
                  onChanged: (value) {
                    print("onChanged" + value);
                  },
                  //关联focusNode1
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintStyle:
                        TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            // 右边
            Container(
                margin: EdgeInsets.only(right: 20.w, top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Image.asset(CoinList[coinIndex].image,
                          width: 26.w, height: 26.w),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // 选择框 选择币种
                    Container(
                        padding: EdgeInsets.only(top: 1.h),
                        child: CoinSelectWidget(
                          items: CoinList,
                          value: coinValue,
                          valueChanged: coinSelectChange,
                        ))
                  ],
                )),
          ],
        )
      ],
    );
  }

  // 自定义键盘
  void showCustomKeyboard(
      BuildContext context,
      TextEditingController _textEditingController,
      TextEditingController _remarkController) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: false,
      // isDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // height: 256, // 设置底部菜单的高度
          height: Get.height * 0.42, // 设置底部菜单的高度
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedPadding(
                padding:
                    MediaQuery.of(context).viewInsets, // 我们可以根据这个获取需要的padding
                duration: Duration(milliseconds: 100), // 设置动画的时长
                child: Container(
                  child: TextField(
                    controller: _remarkController,
                    keyboardType: TextInputType.text,
                    focusNode: remarkFocusNode,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w), // 设置内容内边距
                      hintText: '转账说明...',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _remarkController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _remarkController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: value.length),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
              Container(
                // height: 216,
                height: Get.height * 0.32,
                child: NumberKeyboard(
                  confirmText: '转账',
                  confirmColor: Color(0xFFE6E6E6),
                  confirmBgColor: Color(0xFF0563B6),
                  onTap: (value) {
                    final currentValue = _textEditingController.text;
                    String newValue = '$currentValue$value';
                    if (currentValue == "" && value == ".") {
                      newValue = '0$value';
                    }
                    print("onTap" + newValue);
                    setState(() {
                      _textEditingController.text = newValue;
                    });
                  },
                  onCommit: () {
                    // 处理回车按键的逻辑
                    print("点击了确认按钮");
                    // 处理回车按键的逻辑
                    if (_textEditingController.text.isEmpty) {
                      ToastPrint.show("please_input_transfer_amount".tr);
                      return;
                    }
                    // var backFunc = () {
                    //   // 关闭确认弹框
                    //   Get.back();
                    //   // 关闭底部弹框
                    //   Get.back();
                    //   // 返回聊天页面
                    //   Get.back(result: _textEditingController.text);
                    // };
                    // ConfirmDialog.confirm(context, "确定转账给\n${consumer.account}?", '确认后无法撤销', backFunc);
                    // PayPwdDialog.showPayPwdModel(context, consumer.account, _textEditingController.text);
                    Get.find<PayPwdBottomController>().openBottomSheet(
                      context,
                      consumer.account,
                      _textEditingController.text,
                      _remarkController.text,
                      GSourcePage.CHAT,
                    );
                  },
                  onDel: () {
                    // 处理删除按键的逻辑
                    if (_textEditingController.text.isNotEmpty) {
                      setState(() {
                        _textEditingController.text =
                            _textEditingController.text.substring(
                                0, _textEditingController.text.length - 1);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      // 收起键盘时清除转账说明
      setState(() {
        _textEditingController.clear();
        _remarkController.clear();
      });
    });
  }
}
