import 'dart:io';
import 'dart:ui';

class UIColor {
  /// 用于禁用遮罩
  static const Color transparentWhite20 = Color(0x33FFFFFF);
  
  static const Color transparent = Color(0x00FFFFFF);

  /// 默认
  static const Color primary = Color(0xFF40BD95);

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color cFFBDBDBD = Color(0xFFBDBDBD);
}

extension FontWeightExt on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static FontWeight medium = Platform.isAndroid ? FontWeight.w600 : FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
