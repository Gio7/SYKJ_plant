import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/string_utils.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';

class InfoDescriptionText extends StatefulWidget {
  const InfoDescriptionText({super.key, required this.text});

  final String text;

  @override
  State<InfoDescriptionText> createState() => _InfoDescriptionTextState();
}

class _InfoDescriptionTextState extends State<InfoDescriptionText> {
  bool _showMore = false;
  final _textStyle = TextStyle(
    color: UIColor.c8E8B8B,
    fontSize: 12,
    fontWeight: FontWeightExt.medium,
  );
  bool _isTextHeightExceed = false;

  @override
  void initState() {
    final textHeight = StringUtils.getTextContextSizeHeight(
      Get.context!,
      widget.text,
      _textStyle.fontSize!,
      _textStyle.fontWeight!,
      Get.width - 72,
    );
    _isTextHeightExceed = textHeight > 140;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: Image.asset(
                  'images/icon/detail_description.png',
                  width: 24,
                ),
              ),
              Text(
                'description'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (_isTextHeightExceed && !_showMore) ? 140 : double.infinity,
              ),
              child: Text(
                widget.text,
                style: _textStyle,
              ),
            ),
          ),
          if (_isTextHeightExceed)
            Container(
              padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
              width: double.infinity,
              child: NormalButton(
                onTap: () {
                  setState(() {
                    _showMore = !_showMore;
                  });
                },
                text: _showMore ? 'showLess'.tr : 'showMore'.tr,
                iconRight: _showMore ? 'images/icon/detail_arrow_up.png' : 'images/icon/detail_arrow_down.png',
                textColor: UIColor.primary,
                bgColor: UIColor.transparentPrimary40,
                borderRadius: 4.0,
              ),
            ),
        ],
      ),
    );
  }
}
