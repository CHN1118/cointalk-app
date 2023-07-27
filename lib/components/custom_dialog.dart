// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/components/op_click.dart';

class CDialog {
  Future show(
    BuildContext context,
    String title, {
    bool isCancel = false,
    Function? cancel,
    Function? confirm,
  }) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return Custom_Dialog(
          title: title,
          isCancel: isCancel,
          cancel: () {
            cancel != null ? cancel() : '';
          },
          confirm: () {
            confirm != null ? confirm() : '';
          },
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 200),
    );
  }
}

class Custom_Dialog extends StatefulWidget {
  String title;
  Function cancel;
  Function confirm;
  bool isCancel;

  Custom_Dialog({
    Key? key,
    this.title = '提示内容',
    required this.cancel,
    required this.confirm,
    required this.isCancel,
  }) : super(key: key);

  @override
  State<Custom_Dialog> createState() => _Custom_DialogState();
}

class _Custom_DialogState extends State<Custom_Dialog> {
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
                child: Text(widget.title,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.isCancel)
                  Expanded(
                    child: OpClick(
                      onTap: () {
                        widget.cancel();
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        color: Colors.pink.withOpacity(0),
                        width: double.infinity,
                        height: 40.w,
                        child: Center(
                          child: Text('取消',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.themeColor)),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: OpClick(
                    onTap: () {
                      widget.confirm();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.pink.withOpacity(0),
                      width: double.infinity,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

var Cdog = CDialog();
