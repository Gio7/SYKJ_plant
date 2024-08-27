import 'package:flutter/widgets.dart';

class StringUtils {
  static double getTextContextSizeHeight(
    BuildContext context,
    String text,
    double fontSize,
    FontWeight fontWeight,
    double maxWidth, {
    double? height,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    TextPainter textPainter = TextPainter(
      locale: Localizations.localeOf(context),
      maxLines: maxLines,
      textDirection: textDirection,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          height: height,
        ),
      ),
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.height;
  }
}
