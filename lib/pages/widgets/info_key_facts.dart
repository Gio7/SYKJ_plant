import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_info_model.dart';

class InfoKeyFacts extends StatelessWidget {
  const InfoKeyFacts({super.key, required this.descriptionList});
  final List<Description>? descriptionList;

  @override
  Widget build(BuildContext context) {
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
                'keyFacts'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < (descriptionList?.length ?? 0); i++) _buildItem(i, descriptionList![i]),
        ],
      ),
    );
  }

  Widget _buildItem(int i, Description item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        color: i % 2 == 1 ? UIColor.white : UIColor.transparentPrimary20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          Text(
            item.item ?? '',
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 12,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.content ?? '',
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
