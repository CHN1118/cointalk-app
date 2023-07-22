// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet/widgets/importwallet/backup_mnemonic.dart';

class Mnemonic extends StatefulWidget {
  const Mnemonic({super.key});

  @override
  State<Mnemonic> createState() => MMnemonicState();
}

class MMnemonicState extends State<Mnemonic> {
  String mnemonic = '';
  List<String> mnemonicArr = [];

  @override
  void initState() {
    super.initState();
    generateMnemonic();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void generateMnemonic() {
    mnemonic = bip39.generateMnemonic(); // 生成助记词
    setState(() {
      mnemonicArr = mnemonic.split(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.only(bottom: 60.h),
          width: 390.w,
          height: 844.h,
          child: Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('备份助记词',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.w900)),
                SizedBox(height: 38.h),
                //*助记词内容
                Wrap(
                  spacing: 12.h,
                  runSpacing: 12.h,
                  children: mnemonicArr.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String item = entry.value;
                    return Container(
                      width:
                          (MediaQuery.of(context).size.width / 2) - 6.h - 26.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        border:
                            Border.all(color: AppTheme.themeColor, width: 1.w),
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w, top: 5.w),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.themeColor),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 42.h),
                Text('助记词是恢复钱包的凭证，请务必做好备份',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(height: 14.h),
                SizedBox(
                  width: 232.w,
                  child: Text('使用纸和笔，按正确的顺序记录助记词将助记词保存在安全的地方不可将助记词进行网络存储与传输',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(.5))),
                ),
                const Expanded(child: SizedBox()),
                Center(
                  child: InkWell(
                    onTap: Next,
                    child: Container(
                      width: 325.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Center(
                        child: Text(
                          '验证备份',
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Next() {
    Get.to(() => const BackupMnemonic(),
        arguments: mnemonic, transition: Transition.topLevel);
  }
}
