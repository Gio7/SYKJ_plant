import 'package:flutter/widgets.dart';
import 'package:plant/common/ui_color.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final String keyword;
  final Color highlightColor;
  final Color textColor;
  final TextStyle style;
  final int maxLines;

  const HighlightText({
    super.key,
    required this.text,
    required this.keyword,
    this.highlightColor = UIColor.primary,
    this.textColor = UIColor.c15221D,
    this.style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: UIColor.c15221D),
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (keyword.isEmpty) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: TextStyle(color: textColor),
          ),
        ], style: style),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    // 分割文本，将包含关键词的部分高亮显示
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfKeyword = text.indexOf(keyword, start);

    while (indexOfKeyword != -1) {
      // 普通文本
      if (indexOfKeyword > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfKeyword),
          style: TextStyle(color: textColor),
        ));
      }

      // 高亮文本
      spans.add(TextSpan(
        text: keyword,
        style: TextStyle(color: highlightColor),
      ));

      // 更新起始位置并查找下一个关键词
      start = indexOfKeyword + keyword.length;
      indexOfKeyword = text.indexOf(keyword, start);
    }

    // 添加剩余文本
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: textColor),
      ));
    }

    return RichText(
      text: TextSpan(children: spans, style: style),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
