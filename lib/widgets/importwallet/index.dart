// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/biometricauthentication.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/widgets/importwallet/creat_psw.dart';

class Importwallet extends StatefulWidget {
  const Importwallet({super.key});

  @override
  State<Importwallet> createState() => IimportwalletState();
}

class IimportwalletState extends State<Importwallet> {
  @override
  void initState() {
    super.initState();
    detectionBio();
  }

  detectionBio() async {
    await DB.box.write('isEBV', false); //清除是否开启生物识别
    await DB.box.write('walletPassword', null); //清除登录密码
    await DB.box.write('walletName', null); //清除钱包名称
    try {
      bool isSupported = await Bio.isDeviceSupported(); //是否支持生物识别
      DB.box.write('isSupported', isSupported);
      if (!isSupported) return;
    } catch (e) {
      print(e);
      return;
    }
    try {
      String availableBiometrics =
          await Bio.getAvailableBiometrics(); //获取可用的生物识别技术
      DB.box.write('availableBiometrics', availableBiometrics);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 74.h),
        width: 390.w,
        height: 844.h,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "LinkWallet",
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            //* 创建钱包
            InkWell(
              onTap: () {
                Get.to(() => CreatPsw());
              },
              child: Container(
                width: 325.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppTheme.themeColor,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: Text(
                    '创建钱包',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 22.h),
            //* 导入钱包
            InkWell(
              onTap: () {
                Get.to(() => CreatPsw(
                      title: '创建钱包密码',
                    ));
              },
              child: Container(
                width: 325.w,
                height: 44.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(color: AppTheme.themeColor, width: 1.w)),
                child: Center(
                  child: Text(
                    '导入钱包',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.themeColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
