// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/widgets/browser/index.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('USD Wallet'),
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
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: 426.w,
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 40.w, bottom: 38.w),
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        //color: Colors.red,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color(0xffE7E7E7).withOpacity(0.6),
              offset: Offset(0, 4), //阴影xy轴偏移量
              spreadRadius: 0, //阴影扩散程度
              blurRadius: 14 //阴影模糊程度
              ),
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                "请使用 其他钱包 APP 扫码向我充值",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              alignment: Alignment.center,
            ),
            Center(
              child: SizedBox(
                width: 217.w,
                height: 206.w,
                child: QrImageView(
                  data: '1234567890', // 二维码数据
                  version: QrVersions.auto, // 二维码版本
                  size: 175.438.w, // 二维码大小
                ),
              ),
            ),
            Container(
                height: 44.w,
                width: MediaQuery.of(context).size.width - 80.w,
                decoration: BoxDecoration(
                  color: Color(0xffe8eef7),
                  borderRadius: BorderRadius.circular(6.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1, //阴影扩散程度
                      blurRadius: 5, //阴影模糊程度
                      offset: Offset(0, 3), // 阴影偏移量
                    ),
                  ],
                ),
                child: Container(
                    child: Center(
                  child: Text(
                    '保存充值地址二维码',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0563B6),
                    ),
                  ),
                ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth / 1.4,
                      padding: EdgeInsets.only(top: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TDbYp6xzC9goA7Mtrkfi5libu4dp7xZSck",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                OpClick(
                    onTap: () {
                      copyToClipboard(
                          text: 'TDbYp6xzC9goA7Mtrkfi5libu4dp7xZSck');
                    },
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      child: SvgPicture.asset(
                        'assets/svgs/copy.svg', // 设置SVG图标的路径),
                        color: Color(0xff333333).withOpacity(0.6),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  //~复制到剪切板
  void copyToClipboard({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBar(msg: '复制成功');
  }
}
