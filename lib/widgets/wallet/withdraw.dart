import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  //定义一个controller
  final amountController = TextEditingController();
  final addressController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("提币",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.w,
            )),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.only(),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        // 标题居中
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // 充值 手续费
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: rechargeViewBuilder(),
                ),

                Container(
                  color: Color(0xFFF9FAFC),
                  height: 10,
                ),
                // 手续费
                Container(
                  margin: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 13.w, bottom: 13.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "手续费",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "0 USDT",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                // 实际到账
                Container(
                  margin: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 13.w, bottom: 13.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '实际到账',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "0 USDT",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 提币按钮
          Container(
              padding: EdgeInsets.only(bottom: 36.w),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40.w,
                  height: 48.w,
                  child: Container(
                    //      Color(0xFFDADFED)
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: Color(0xff0563B6),
                    ),

                    child: Center(
                      child: Text(
                        "提币",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }

  // !顶部UDST
  Widget balanceBuilder() {
    return Container(
      margin: EdgeInsets.only(bottom: 18.w),
      padding:
          EdgeInsets.only(left: 15.w, right: 20.w, top: 13.w, bottom: 13.w),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: InkWell(
        onTap: () {
          // 处理点击事件
          // showBalanceSelectModal(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Image.asset(
                    "assets/images/coin_1.png",
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "USDT©",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            )),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  // Chain  发送到
  Widget rechargeViewBuilder() {
    return Column(
      children: [
        // 提现金额
        balanceBuilder(),
        //Chain
        Row(
          children: [
            Text("Chain：",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF686C77),
                )),
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF1F4FF),
              ),
              child: Text(
                "BSC",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF686C77),
                ),
              ),
            )
          ],
        ),

        // 发送到
        Container(
          padding: EdgeInsets.only(top: 15),
          alignment: Alignment.centerLeft, // 设置文字居中对齐
          child: Text(
            '发送到',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF686C77),
            ),
          ),
        ),

        //输入框
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child:
                  // 左边
                  Container(
                child: TextField(
                  controller: addressController,
                  autofocus: true,
                  focusNode: addressFocusNode,
                  onChanged: (value) {
                    print("onChanged" + value);
                  },
                  //关联amountFocusNode
                  decoration: InputDecoration(
                    hintText: "请输入收款地址",
                    hintStyle:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),

        Divider(
          color: Color(0xFFD8D8D8),
          height: 0.5.w,
        ),

        // 主网
        Container(
          padding: EdgeInsets.only(top: 15.w),
          alignment: Alignment.centerLeft, // 设置文字居中对齐
          child: Text(
            "主网",
            style: TextStyle(fontSize: 14.sp, color: Color(0xff686C77)),
          ),
        ),

        //TRC20
        Padding(
            padding: EdgeInsets.only(top: 12.w, bottom: 12.w),
            child: InkWell(
              onTap: () {
                // // 处理点击事件
                // var mainList = mainNetworkList
                //     .map((SelectLabelValue item) => item.label)
                //     .toList();
                // showPicker(context, mainList);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child:
                        // 左边
                        Container(
                      child: Text(
                        'TRC20',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        // style: CommonStyle.text_16_black_w400,
                      ),
                    ),
                  ),

                  // 右边
                  Container(
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      onTap: () {
                        // 处理点击事件
                      },
                    ),
                  ),
                ],
              ),
            )),

        Divider(
          color: Color(0xFFD8D8D8),
          height: 0.5.w,
        ),
        //提现金额
        Padding(
          padding: EdgeInsets.only(top: 18.w),
          child: Container(
            alignment: Alignment.centerLeft, // 设置文字居中对齐
            child: Text(
              "提现金额",
              style: TextStyle(fontSize: 14.sp, color: Color(0xff686C77)),
              // style: CommonStyle.text_14_color686C77_w400,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child:
                  // 左边
                  Container(
                      child: TextField(
                controller: amountController,
                autofocus: true,
                focusNode: amountFocusNode,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == "") {
                    value = "0";
                  }
                  // calculateFee(value);
                },
                //关联amountFocusNode
                decoration: InputDecoration(
                  hintText: '限额 1 UDST～1000000 USDT',
                  hintStyle:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              )),
            ),
            // 右边
            Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 居中对齐
              children: [
                Container(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "USDT",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )),
              ],
            )),
          ],
        ),

        Divider(
          color: Color(0xFFD8D8D8),
          height: 0.5.w,
        ),

        Padding(
          padding: EdgeInsets.only(top: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 3, bottom: 10),
                  alignment: Alignment.centerLeft, // 设置文字居中对
                  child: Text(
                    '可用提现: 2 UDST',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  // amountController.text =
                  //     walletInfo.value.availableWithdrawBalance.toString();
                  // if (walletInfo.value.availableWithdrawBalance == 0) {
                  //   calculateFee("0");
                  // } else {
                  //   calculateFee(
                  //       walletInfo.value.availableWithdrawBalance.toString());
                  // }
                },
                child: Text(
                  'Max',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF0563B6)),
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 3),
              alignment: Alignment.centerLeft, // 设置文字居中对
              child: Text(
                '24小时后可提现余额: 0 USDT',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
