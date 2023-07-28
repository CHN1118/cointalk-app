// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/biometricauthentication.dart';
import 'package:wallet/components/op_click.dart';
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
        padding: EdgeInsets.only(bottom: 60.h),
        width: 390.w,
        height: 844.h,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OpClick(
                    onTap: () {
                      //删除缓存数据
                      DB.box.remove('WalletList');
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/logo.svg',
                      width: 208.947.w,
                      height: 206.4.w,
                    ),
                  ),
                  SizedBox(height: 78.h),
                  Text(
                    "欢迎",
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            //* 创建钱包
            OpClick(
              onTap: () async {
                Get.to(() => CreatPsw());
              },
              child: Container(
                width: 325.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppTheme.themeColor,
                  borderRadius: BorderRadius.circular(4.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                    ),
                  ],
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
            OpClick(
              onTap: () async {
                Get.to(() => CreatPsw(
                      title: '创建钱包密码',
                    ));
              },
              child: Container(
                width: 325.w,
                height: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: AppTheme.themeColor, width: 1.w),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                    ),
                  ],
                ),
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
