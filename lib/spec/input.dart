import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// 输入
class InputItem {
  final int id;
  final String title;
  final String? key;
  final String hintText;
  final TextEditingController controller;
  final FocusNode node;
  final bool isMultiline; //属性来决定是否要创建一个多行输入框
  String? errText;
  final ValidatorType? validatorType;
  final bool isRequired; // 是否必填
  bool isVisible; // 是否可见
  bool isObscureText; // 是否密文
  final TextInputType keyboardType; // 键盘类型
  InputItem({
    required this.id,
    required this.title,
    this.key,
    required this.hintText,
    required this.controller,
    required this.node,
    this.isMultiline = false,
    this.validatorType,
    this.errText = null,
    this.isRequired = false,
    this.isVisible = true,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text,
  });
}

class SelectLabelValue {
  final String label;
  final String value;

  SelectLabelValue({required this.label, required this.value});
}

// 选择
class SelectItem {
  final int id;
  final String title;
  final String? key;
  final String hintText;
  final String? icon;
  final List<SelectLabelValue>? list;
  final int checkedType; // 0:单选 1:多选
  String? selectValue; //更新选中值
  String? selectLabel; //更新选中标签
  final String? selectType; // 选择类型
  final bool isRequired; // 是否必填
  SelectItem({
    required this.id,
    required this.title,
    this.icon,
    required this.hintText,
    this.list,
    this.key,
    this.checkedType = 0,
    this.selectValue,
    this.selectLabel,
    this.selectType = "",
    this.isRequired = false,
  });
}

// 护照 + 人脸照片
class PhotoItem {
  final int id;
  final String title;
  final String icon;
  final String? key;
  final String iconTitle;
  final String detailTitle;
  String path = "";
  final bool isRequired; // 是否必填

  PhotoItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.key,
    required this.iconTitle,
    required this.detailTitle,
    this.path = "",
    this.isRequired = false,
  });
}

// 证件类型
final List<SelectLabelValue> keyTypeList = [
  SelectLabelValue(
    value: "01",
    label: "mainland_chinese_identity_card",
  ),
  SelectLabelValue(
    value: "03",
    label: "certificate_military_officer",
  ),
  SelectLabelValue(
    value: "04",
    label: "permit_taiwan_residents",
  ),
  SelectLabelValue(
    value: "05",
    label: "reentry_permit",
  ),
  SelectLabelValue(
    value: "06",
    label: "hong_kong_macao_passport",
  ),
  SelectLabelValue(
    value: "20",
    label: "other",
  ),
  SelectLabelValue(
    value: "90",
    label: "hong_kong_macao_resident_permit",
  ),
  SelectLabelValue(
    value: "91",
    label: "taiwan_resident_permit",
  ),
  SelectLabelValue(
    value: "92",
    label: "hong_kong_resident_permit",
  ),
  SelectLabelValue(
    value: "93",
    label: "macao_resident_permit",
  ),
  SelectLabelValue(
    value: "AA",
    label: "hong_kong_identity_card",
  ),
];

// 自己系统的证件类型
final List<SelectLabelValue> certificateTypeList = [
  SelectLabelValue(
    value: "1",
    label: "mainland_identity_card",
  ),
  SelectLabelValue(
    value: "2",
    label: "hong_kong_identity_card",
  ),
  SelectLabelValue(
    value: "3",
    label: "mainland_passport",
  ),
  SelectLabelValue(
    value: "4",
    label: "hong_kong_macao_taiwan_passport",
  ),
];
// 地址1_地址类型 、 账单递送地址
final List<SelectLabelValue> addr1TypeList = [
  SelectLabelValue(
    value: "B",
    label: "company_address",
  ),
  SelectLabelValue(
    value: "F",
    label: "domicile_address",
  ),
  SelectLabelValue(
    value: "H",
    label: "home_address",
  ),
  SelectLabelValue(
    value: "W",
    label: "property_address",
  ),
];

// 卡递送方式
final List<SelectLabelValue> cdespmtdList = [
  SelectLabelValue(
    value: "KJZJ",
    label: "card_middleman",
  ),
  SelectLabelValue(
    value: "POST",
    label: "hong_kong_post_office_mail_card",
  ),
  SelectLabelValue(
    value: "COUR",
    label: "express_card",
  ),
];

// 账单方式
final List<SelectLabelValue> stmCodeList = [
  SelectLabelValue(
    value: "EM",
    label: "email_the_bill",
  ),
  SelectLabelValue(
    value: "IE",
    label: "email_pdf_delivery",
  ),
  SelectLabelValue(
    value: "LE",
    label: "mail_email_send_bill",
  ),
  SelectLabelValue(
    value: "LI",
    label: "mail_email_pdf_delivery",
  ),
  SelectLabelValue(
    value: "LT",
    label: "mail_billing",
  ),
];

// 婚姻状况
final List<SelectLabelValue> marStatusList = [
  SelectLabelValue(
    value: "S",
    label: "spinster",
  ),
  SelectLabelValue(
    value: "M",
    label: "married",
  ),
  SelectLabelValue(
    value: "O",
    label: "other",
  ),
];

// 性别
final List<SelectLabelValue> sexList = [
  SelectLabelValue(
    value: "M",
    label: "male",
  ),
  SelectLabelValue(
    value: "F",
    label: "female",
  ),
];

// 教育程度
final List<SelectLabelValue> educationList = [
  SelectLabelValue(
    value: "1",
    label: "junior_high_school_below",
  ),
  SelectLabelValue(
    value: "2",
    label: "high_technical_secondary_school",
  ),
  SelectLabelValue(
    value: "3",
    label: "junior_college",
  ),
  SelectLabelValue(
    value: "4",
    label: "university",
  ),
  SelectLabelValue(
    value: "5",
    label: "master",
  ),
  SelectLabelValue(
    value: "6",
    label: "doctor"
  ),
];
// 国籍
final List<SelectLabelValue> nationCdList = [
  SelectLabelValue(
    value: "CHN",
    label: "china",
  ),
  SelectLabelValue(
    value: "HKG",
    label: "hong_kong",
  ),
  SelectLabelValue(
    value: "USA",
    label: "america",
  ),
];

// ValidatorType 枚举 用于校验
enum ValidatorType {
  email,
  phone,
  isNull,
  password,
  idCard,
}
