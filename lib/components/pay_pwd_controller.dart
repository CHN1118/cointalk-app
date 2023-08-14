import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../api/account_api.dart';
import '../common/global/global_key.dart';
import '../common/style/common_style.dart';
import '../common/utils/loading_animation.dart';
import '../common/utils/modal_util.dart';
import '../common/utils/toast_print.dart';
import '../wallet/numeric_keyboard.dart';

class PayPwdBottomController extends GetxController {
  RxString sourcePage = ''.obs;
  RxString amountValue = ''.obs;
  RxString remarkValue = ''.obs;

  void openBottomSheet(BuildContext context, String account, String amount, String remark, String page) {
    TextEditingController _payPwdEditingController = TextEditingController();
    FocusNode payPwdFocusNode = FocusNode();
    sourcePage.value = page;
    amountValue.value = amount;
    remarkValue.value = remark;
    Get.bottomSheet(
      Container(
          height: Get.height * 0.6,
          padding: EdgeInsets.only(top: 20, left: 25, right: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              showCircularModalTitle(context, 'please_input_payment_password'.tr, () {
                Get.back();
              }),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  '${'towards'.tr} ${account} ${'transfer'.tr}',
                  style: CommonStyle.text_14_black_w400,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20, top: 12),
                child: Text(
                  '${amount} USDT',
                  style: CommonStyle.text_28_black_w700,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                //color: Colors.red,
                alignment: Alignment.center,
                child: Center(
                  child: SizedBox(
                    height: 52,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: true,
                          obscuringCharacter: '*',
                          autoFocus: false,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 3) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            selectedColor: Colors.white,
                            // 输入框选中时边框颜色
                            //disabledColor: Colors.orange,
                            inactiveColor: Colors.white,
                            selectedFillColor: Colors.white,
                            // 选中输入框时背景颜色
                            inactiveFillColor: Colors.white,
                            // 未选中时输入框背景颜色
                            activeFillColor: Colors.white,
                            activeColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 45,
                            fieldWidth: 45,
                          ),
                          cursorColor: Colors.black,
                          readOnly: true,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          // errorAnimationController: pinErrorController,
                          controller: _payPwdEditingController,
                          focusNode: payPwdFocusNode,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              color: Color(0xFFD0D5E0),
                              blurRadius: 1,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("密码输入完成");
                            submit(
                              context,
                              account,
                              amount,
                              v,
                              remarkValue.value,
                              sourcePage.value,
                            );
                            _payPwdEditingController.clear();
                          },
                          onChanged: (value) {
                            // setState(() {
                            //   //password = value;
                            // });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("允许粘贴 $text");
                            return false;
                          },
                        )),
                  ),
                ),
              ),
              NumericKeyboard(
                  onKeyboardTap: (value) {
                    // setState(() {
                    _payPwdEditingController.text = _payPwdEditingController.text + value;
                    // payPwd = _payPwdEditingController.text;
                    // });
                  },
                  textStyle: CommonStyle.text_20_black_w700,
                  rightButtonFn: () {
                    if (_payPwdEditingController.text.length > 0) {
                      _payPwdEditingController.text =
                          _payPwdEditingController.text.substring(0, _payPwdEditingController.text.length - 1);
                      // payPwd = _payPwdEditingController.text;
                    }
                  },
                  rightIcon: Image.asset(
                    "assets/image/pay_keyboard_delete.png",
                    width: 30,
                    height: 20,
                  ),
                  leftButtonFn: () {
                    print('left button clicked');
                  },
                  // leftIcon: Icon(
                  //   Icons.check,
                  //   color: Colors.red,
                  // ),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            ],
          )),
    );
  }

  // 提交支付
  static submit(
      BuildContext context, String account, String amount, String payPwd, String remark, String source) async {
    LoadingAnimation.show(context);
    try {
      var res = await AccountApi().transfer(account, double.parse(amount), "USDT", payPwd);
      if (res.data['code'] == 0) {
        // ToastPrint.show("转账成功");
        Future.delayed(Duration(milliseconds: 250), () {
          if(source == GSourcePage.CHAT){
            // Get.to(() => PaySuccessPage(), arguments: {'source': source});
          }else if(source == GSourcePage.CHAT_RED){
            Get.back(result: GKey.SUCCESS);
            Get.back();
          }
        });
      }
    } catch (error) {
      ToastPrint.show("payment_failed_please_try_again".tr);
    } finally {
      LoadingAnimation.hide();
      // 以编程方式关闭对话框
      Get.back();
    }
  }
}
