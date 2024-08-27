import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_info_model.dart';

class InfoConditions extends StatelessWidget {
  const InfoConditions({super.key, this.conditions});

  final Conditions? conditions;

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
                  'images/icon/detail_conditions.png',
                  width: 24,
                ),
              ),
              Text(
                'conditions'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildItem(
                  'images/icon/detail_temperature.png',
                  'temperature'.tr,
                  conditions?.temperatureRange ?? '',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildItem(
                  'images/icon/detail_hardness.png',
                  'hardnessZones'.tr,
                  conditions?.plantingSeason ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildItem(
            'images/icon/detail_sunlight.png',
            'sunlight'.tr,
            conditions?.sunlight ?? '',
          ),
          const SizedBox(height: 8),
          _buildItem(
            'images/icon/detail_location.png',
            'location'.tr,
            conditions?.location ?? '',
          ),
        ],
      ),
    );
  }

  Container _buildItem(String icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: ShapeDecoration(
        color: UIColor.cF7F7F7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: UIColor.c8E8B8B,
                  fontSize: 12,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 12,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
