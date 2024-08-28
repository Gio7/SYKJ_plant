import 'dart:io';
import 'dart:ui';

class UIColor {
  /// 用于禁用遮罩
  static const Color transparentWhite20 = Color(0x33FFFFFF);
  static const Color transparent = Color(0x00FFFFFF);
  static const Color transparent40 = Color(0x66FFFFFF);
  static const Color transparent60 = Color(0x99FFFFFF);
  static const Color transparentPrimary40 = Color(0x66AEE9CD);
  static const Color transparentPrimary70 = Color(0xB240BD95);
  static const Color transparentPrimary20 = Color(0x33AEE9CD);
  static const Color transparentBlack70 = Color(0xB2000000);

  /// 默认
  static const Color primary = c40BD95;

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color cBDBDBD = Color(0xFFBDBDBD);

  static const Color cD9F0E5 = Color(0xFFD9F0E5);

  static const Color cF3F4F3 = Color(0xFFF3F4F3);

  static const Color c40BD95 = Color(0xFF40BD95);

  static const Color cAEE9CD = Color(0xFFAEE9CD);

  static const Color c15221D = Color(0xFF15221D);

  static const Color cB3B3B3 = Color(0xFFB3B3B3);

  static const Color cD1D1D1 = Color(0xFFD1D1D1);

  static const Color cFF3257 = Color(0xFFFF3257);

  static const Color cFD5050 = Color(0xFFFD5050);

  static const Color c8E8B8B = Color(0xFF8E8B8B);

  static const Color c00997A = Color(0xFF00997A);

  static const Color cD7FF38 = Color(0xFFD7FF38);

  static const Color cAAFFD6 = Color(0xFFAAFFD6);

  static const Color cEEEEEE = Color(0xFFEEEEEE);

  static const Color cF6A469 = Color(0xFFF6A469);

  static const Color cF7F7F7 = Color(0xFFF7F7F7);

  static const Color cE1E1E1 = Color(0xFFE1E1E1);

  static Color hexToColor(String s) {
    if (s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
      return primary;
    }

    return Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

extension FontWeightExt on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static FontWeight medium = Platform.isAndroid ? FontWeight.w600 : FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
