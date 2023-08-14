import 'package:get/get.dart';

import '../../spec/input.dart';

class TextVerify {
  // 正则校验手机号
  static String? validatePhoneNumber(String value) {
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return 'phone_number_cannot_empty'.tr;
    } else if (!exp.hasMatch(value)) {
      return 'please_input_correct_phone_number'.tr;
    }
    return null;
  }

  // 正则校验手机号bool
  static bool validatePhoneNumberBool(String input) {
    RegExp exp = RegExp(r"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\d{8}$");
    if (input.isEmpty || !exp.hasMatch(input)) {
      return false;
    }
    return true;
  }

  // 正则校验邮箱
  static String? validateMail(String value) {
    RegExp exp = RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
    if (value.isEmpty) {
      return 'email_num_cannot_empty'.tr;
    } else if (!exp.hasMatch(value)) {
      return 'please_enter_correct_email'.tr;
    }
    return null;
  }

  // 正则校验密码
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'pwd_num_cannot_empty'.tr;
    } else if (value.trim().length < 6) {
      return 'pwd_cannot_less_than_6'.tr;
    } else if (value.trim().length > 18) {
      return 'pwd_cannot_more_than_18'.tr;
    }
    return null;
  }

  // 正则校验密码bool
  static bool validatePasswordBool(String value) {
    if (value.isEmpty || value.trim().length < 6 || value.trim().length > 18) {
      return false;
    }
    return true;
  }

  // 正则校验验证码
  static String? validateCheckCode(String value) {
    if (value.isEmpty) {
      return 'code_cannot_empty'.tr;
    } else if (value.trim().length != 6) {
      return 'code_is_6'.tr;
    }
    return null;
  }

  // 正则校验验证码bool
  static bool validateCheckCodeBool(String value) {
    if (value.isEmpty || value.trim().length < 6 || value.trim().length > 18) {
      return false;
    }
    return true;
  }

  // 正则校验是否为空
  static String? validateIsEmpty(String key, value) {
    if (value.isEmpty) {
      return '$key${'not_be_empty'.tr}';
    }
    return null;
  }

  // 校验18位身份证号码 中国的
  static bool validateCheckIdCardBool(String value) {
    String regex = r"^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}(\d|X|x)$";
    return RegExp(regex).hasMatch(value);
  }

  // 正则校验身份证号码 中国的
  static String? validateCheckIdCard(String value) {
    if (value.isEmpty) {
      return 'id_number_cannot_empty'.tr;
    } else if (!validateCheckIdCardBool(value)) {
      return 'please_input_correct_id_number'.tr;
    }
    return null;
  }

  // 正则校验小数位
  static bool validateDoubleDigit6(String value) {
    if(value.contains(".")){
      var parts = value.split(".");
      print(parts[1]);
      if (parts[1].length <= 6) {
        return true;
      }
      return false;
    }
    return true;
  }
}

String validateTextField(type, key, value) {
  if (type == ValidatorType.phone) {
    return TextVerify.validatePhoneNumber(value.toString()) ?? '';
  } else if (type == ValidatorType.isNull) {
    return TextVerify.validateIsEmpty(key, value.toString()) ?? '';
  } else if (type == ValidatorType.email) {
    return TextVerify.validateMail(value.toString()) ?? '';
  } else if (type == ValidatorType.password) {
    return TextVerify.validatePassword(value.toString()) ?? '';
  } else if (type == ValidatorType.idCard) {
    return TextVerify.validateCheckIdCard(value.toString()) ?? '';
  }
  return "";
}
