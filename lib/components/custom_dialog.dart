// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/common/style/app_theme.dart';

class CDialog {
  show(BuildContext context, String title) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return Custom_Dialog(
          title: title,
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 200),
    );
  }
}

class Custom_Dialog extends StatelessWidget {
  String title;

  Custom_Dialog({
    this.title = '提示内容',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1.w, //阴影模糊程度
              spreadRadius: .1.w, //阴影扩散程度
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ),
            ),
            Divider(
              height: 1.w,
              color: Colors.black.withOpacity(.1),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                height: 40.w,
                child: Center(
                  child: Text('确定',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.themeColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var Cdog = CDialog();
