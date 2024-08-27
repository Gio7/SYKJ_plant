import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

class InfoIdentifyDescription extends StatelessWidget {
  const InfoIdentifyDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final descriptionList = [
      {"item": "XXX", "content": "XXX"},
      {"item": "XXX", "content": "XXX"},
      {"item": "XXX", "content": "XXX"},
      {"item": "XXX", "content": "XXX"},
      {"item": "XXX", "content": "XXX"},
      {"item": "XXX", "content": "XXX"}
    ];
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: Image.asset(
                  'images/icon/detail_clipboard.png',
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
          const SizedBox(height: 16),
          for (int i = 0; i < descriptionList.length; i++) _buildItem(i, descriptionList[i]),
        ],
      ),
    );
  }

  Widget _buildItem(int i, Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        color: i % 2 == 1 ? UIColor.white : UIColor.transparentPrimary20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          Text(
            item['item'] ?? '',
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 12,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item['content'] ?? '',
              style: TextStyle(
                color: UIColor.c15221D,
                fontSize: 12,
                fontWeight: FontWeightExt.medium,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
