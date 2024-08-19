import 'dart:io';
import 'dart:ui';

class UIColor {
  /// 用于禁用遮罩
  static const Color transparentWhite20 = Color(0x33FFFFFF);
  static const Color transparent = Color(0x66FFFFFF);
  static const Color transparent40 = Color(0x00FFFFFF);
  static const Color transparentPrimary40 = Color(0x66AEE9CD);

  /// 默认
  static const Color primary = Color(0xFF40BD95);

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color cBDBDBD = Color(0xFFBDBDBD);

  static const Color cD9F0E5 = Color(0xFFD9F0E5);

  static const Color cF3F4F3 = Color(0xFFF3F4F3);

  static const Color c40BD95 = Color(0xFF40BD95);

  static const Color cAEE9CD = Color(0xFFAEE9CD);

  static const Color c15221D = Color(0xFF15221D);
}

extension FontWeightExt on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static FontWeight medium = Platform.isAndroid ? FontWeight.w600 : FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
