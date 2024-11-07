import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_info_model.dart';

class ImportantInformation extends StatelessWidget {
  const ImportantInformation({super.key, required this.scientificClassification});

  final ScientificClassification? scientificClassification;

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
                'scientificClassification'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: ShapeDecoration(
              color: UIColor.transparentPrimary20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Column(
              children: [
                _buildInteriorItem("phylum".tr, scientificClassification?.phylum ?? ''),
                _buildInteriorItem("class".tr, scientificClassification?.classType ?? ''),
                _buildInteriorItem("order".tr, scientificClassification?.order ?? ''),
                _buildInteriorItem("family".tr, scientificClassification?.family ?? ''),
                _buildInteriorItem("genus".tr, scientificClassification?.genus ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildInteriorItem(String title, String value) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              title,
              style: TextStyle(
                color: UIColor.c8E8B8B,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: UIColor.c15221D,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
