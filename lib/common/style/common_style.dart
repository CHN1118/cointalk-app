import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_color.dart';

class CommonStyle {
  /// primary
  /// E67D00

  static const TextStyle text_17_orange_w700 =
      TextStyle(color: Color(0xFFE67D00), fontSize: 17, fontWeight: FontWeight.w700);
  static const TextStyle text_20_orange_w700 =
      TextStyle(color: Color(0xFFE67D00), fontSize: 20, fontWeight: FontWeight.w700);
  static const TextStyle text_22_color212121_w500 =
      TextStyle(color: Color(0xFF212121), fontSize: 22, fontWeight: FontWeight.w500);
  static const TextStyle text_32_orange_w700 = TextStyle(
    color: Color(0xFFE67D00),
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  /// grey
  static const TextStyle text_10_grey = TextStyle(color: Colors.grey, fontSize: 10);
  static const TextStyle text_10_grey_underLine =
      TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.underline);
  static const TextStyle text_12_grey = TextStyle(color: Colors.grey, fontSize: 12);
  static const TextStyle text_15_grey =
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_15_grey_w700 = TextStyle(
      color: Color.fromRGBO(23, 25, 48, 0.75),
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_15_black_w700 =
      TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_15_black_w500 =
      TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'FangZhengHeiTiFanTi');

  static final TextStyle text_12_grey_opacity40 = TextStyle(
      color: Color(0xFF171930).withOpacity(0.4),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_12_grey_opacity40_underline = TextStyle(
      color: Color(0xFF171930).withOpacity(0.4),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.underline);
  static final TextStyle text_16_grey_opacity40_underline = TextStyle(
      color: Color(0xFF171930).withOpacity(0.4),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.underline);
  static final TextStyle text_16_color212121_w400 = TextStyle(
      color: Color(0xFF212121),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);
  static final TextStyle text_16_color232832_w400 = TextStyle(
      color: Color(0xFF232832),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);
  static final TextStyle text_14_color212121_w400 = TextStyle(
      color: Color(0xFF212121),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);

  static final TextStyle text_14_colorE88E0F_w400 = TextStyle(
      color: Color(0xFFE88E0F),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);

  static final TextStyle text_14_color333333_w400 = TextStyle(
      color: Color(0xFF333333),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);

  static final TextStyle text_12_color333333_w400 = TextStyle(
      color: Color(0xFF333333),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);
  static final TextStyle text_16_color212121_w500 = TextStyle(
      color: Color(0xFF212121),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);
  static final TextStyle text_12_color828895_w400 = TextStyle(
      color: Color(0xFF828895),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);

  static final TextStyle text_12_color272727_w400 = TextStyle(
      color: Color(0xFF272727),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);

  static final TextStyle text_14_color828895_w400 = TextStyle(
      color: Color(0xFF828895),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.none);
  static final TextStyle text_12_grey_opacity60 = TextStyle(
      color: Color(0xFF171930).withOpacity(0.6),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi');

  /// black
  static final TextStyle text_10_black = TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w400);
  static final TextStyle text_10_black_underLine =
      TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.underline);
  static final TextStyle text_10_black_opacity50_underLine =
      TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 10, decoration: TextDecoration.underline);
  static const TextStyle text_12_black = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
  static const TextStyle text_12_black_w700 = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700);
  static const TextStyle text_16_black = TextStyle(color: Colors.black, fontSize: 16);
  static const TextStyle text_16_black_w500 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle text_14_black = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle text_14_black_underline =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400, decoration: TextDecoration.underline);
  static const TextStyle text_16_black_w400 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle text_16_black_w700 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700);

  static const TextStyle text_15_black = TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400);
  static const TextStyle text_15_black_underLine =
      TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.underline);
  static const TextStyle text_17_black = TextStyle(color: Colors.black, fontSize: 17);
  static const TextStyle text_18_color212121_w700 =
      TextStyle(color: Color(0xff212121), fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle text_17_black_w700 = TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700);
  static final TextStyle text_24_black_opacity70 = TextStyle(
      color: Color(0x000000).withOpacity(0.6),
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_24_black_w700 = TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700);
  static final TextStyle text_24_black_w600 = TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600);

  static const TextStyle text_25_black = TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400);

  static const TextStyle text_25_black_w700 = TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700);
  static const TextStyle text_32_black = TextStyle(color: Colors.black, fontSize: 32);
  static const TextStyle text_32_black_w700 = TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700);
  static const TextStyle text_32_black_w500 = TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500);
  static const TextStyle text_12_colorB4B4B4_w400 =
      TextStyle(color: Color(0xFFB4B4B4), fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_15_black_opacity60 = TextStyle(
      color: Color(0xFF171930).withOpacity(0.6),
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_15_black_opacity50 = TextStyle(
      color: Color(0xFF171930).withOpacity(0.5),
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_34_black_w700 =
      TextStyle(color: Color(0xFF171930), fontSize: 34, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  /// white

  static final TextStyle text_10_white = TextStyle(color: Colors.white, fontSize: 10);
  static final TextStyle text_10_gray_opacity60 = TextStyle(
      color: Color(0x8000000).withOpacity(0.6),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_12_white =
      TextStyle(color: Color(0xFFffffff), fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_white = TextStyle(color: Color(0xFFffffff), fontSize: 14);
  static const TextStyle text_14_white_w600 =
      TextStyle(color: Color(0xFFffffff), fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle text_14_white_op_06 = TextStyle(color: Color(0xFFffffff).withOpacity(0.5), fontSize: 14.sp);
  static const TextStyle text_14_white_w400 =
      TextStyle(color: Color(0xFFffffff), fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle text_15_white = TextStyle(color: Color(0xFFffffff), fontSize: 15);
  static const TextStyle text_15_white_w400 =
      TextStyle(color: Color(0xFFffffff), fontSize: 15, fontWeight: FontWeight.w400);

  static const TextStyle text_16_white_w500 =
      TextStyle(color: Color(0xFFffffff), fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle text_16_white_w700 =
      TextStyle(color: Color(0xFFffffff), fontSize: 16, fontWeight: FontWeight.w700);
  static const TextStyle text_25_white = TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700);
  static const TextStyle text_18_white_w700 =
      TextStyle(color: Color(0xFFffffff), fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_18_white_w400 =
      TextStyle(color: Color(0xFFffffff), fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_20_white_w700 =
      TextStyle(color: Color(0xFFffffff), fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_16_white_w400 = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);

  static const TextStyle text_20_black_w400 =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_20_black_w600 =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_20_black_w700 =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_20_colorDCB06E_w600 =
      TextStyle(color: Color(0xffDCB06E), fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_colorCACDDA_w400 =
      TextStyle(color: Color(0xffCACDDA), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_colorCFC7BC_w400 =
      TextStyle(color: Color(0xffCFC7BC), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

//
  static const TextStyle text_14_color686C77_w400 =
      TextStyle(color: Color(0xff686C77), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_12_color686C77_w400 =
      TextStyle(color: Color(0xff686C77), fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_color0563B6_w400 =
      TextStyle(color: Color(0xff0563B6), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_color0563B6_w500 =
      TextStyle(color: Color(0xff0563B6), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_color0563B6_w600 =
      TextStyle(color: Color(0xff0563B6), fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_12_color0563B6_w400 =
      TextStyle(color: Color(0xff0563B6), fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_colorFFCD88_w400 =
      TextStyle(color: Color(0xffFFCD88), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  //
  static const TextStyle text_18_blue_w700 =
      TextStyle(color: Color(0xFF1C5AB8), fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_18_dark_green_w700 =
      TextStyle(color: Color(0xff378f78), fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_blue_w400 =
      TextStyle(color: Color(0xFF1C5AB8), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_18_grey_w700 =
      TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_grey =
      TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_grey_w400_underline = TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'FangZhengHeiTiFanTi',
      decoration: TextDecoration.underline);

  static const TextStyle text_14_dark_green_w700 =
      TextStyle(color: Color(0xff378f78), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_grey_w700 =
      TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_16_grey = TextStyle(color: Colors.grey, fontSize: 16);
  static const TextStyle text_18_black_w700 =
      TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_18_black_w600 =
      TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_18_black_w500 =
      TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_18_black_w400 =
      TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_18_black =
      TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_12_black_opacity50 =
      TextStyle(color: Color(0xFF000000).withOpacity(0.5), fontSize: 12, fontFamily: 'FangZhengHeiTiFanTi');
  static final TextStyle text_12_black_w400 =
      TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_black_w400 =
      TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_black_w500 =
      TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'FangZhengHeiTiFanTi');
  static const TextStyle text_14_black_w600 =
      TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_14_black_w700 =
      TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_28_black_w700 =
      TextStyle(color: Color(0xFF000000), fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'FangZhengHeiTiFanTi');

  static const TextStyle text_12_grey_w700 = TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700);

  /// green

  static const TextStyle text_15_green = TextStyle(color: Colors.green, fontSize: 15);

  /// green #008B70
  static const TextStyle text_15_green_008B70 = TextStyle(color: Color(0xFF008B70), fontSize: 15);
  static const TextStyle text_32_green_w700_008B70 =
      TextStyle(color: Color(0xFF008B70), fontSize: 32, fontWeight: FontWeight.w700);

  /// grey #A4AEB7
  static const TextStyle text_12_grey_A4AEB7 = TextStyle(color: Color(0xFFA4AEB7), fontSize: 12);
  static const TextStyle text_15_grey_A4AEB7 = TextStyle(color: Color(0xFFA4AEB7), fontSize: 15);
  static const TextStyle text_17_grey_A4AEB7 = TextStyle(color: Color(0xFFA4AEB7), fontSize: 17);
  static const TextStyle text_18_grey_A4AEB7 = TextStyle(color: Color(0xFFA4AEB7), fontSize: 18);
  static const TextStyle text_20_grey_A4AEB7_w700 =
      TextStyle(color: Color(0xFFA4AEB7), fontSize: 18, fontWeight: FontWeight.w700);

  static const TextStyle text_16_w400 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle text_20_w500 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  static const TextStyle text_24_orange_w700 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFFF9226));

  static const TextStyle text_15_color6B6B6B_w400 =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF6B6B6B));

  static const TextStyle text_16_colorB0B8C9_w500 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFB0B8C9));

  static final TextStyle text_16_color04B374_w500 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF04B374));
  static final TextStyle text_16_colorF44336_w500 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFF44336));
  static final TextStyle text_16_primary_w500 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CommonColor.primary);
}
