import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_info_model.dart';

class PlantCrareRequirements extends StatelessWidget {
  const PlantCrareRequirements({
    super.key,
    this.conditions,
    this.howTos,
  });

  final Conditions? conditions;
  final HowTos? howTos;

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
                'plantCrareRequirements'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildInteriorItem(
                'images/icon/detail_temperature.png',
                'temperature'.tr,
                conditions?.temperatureRange ?? '',
                const Color(0xFFFBEFEF),
              ),
              _buildInteriorItem(
                'images/icon/detail_hardness.png',
                'hardnessZones'.tr,
                conditions?.hardiness ?? '',
                const Color(0xFFEFF3FB),
              ),
              _buildInteriorItem(
                'images/icon/detail_sunlight.png',
                'sunlight'.tr,
                conditions?.sunlight ?? '',
                const Color(0xFFFBF6EF),
              ),
              _buildInteriorItem(
                'images/icon/detail_pruning.png',
                'pruning'.tr,
                howTos?.pruning ?? '',
                const Color(0xFFEFF8FB),
              ),
              _buildInteriorItem(
                'images/icon/detail_location.png',
                conditions?.location != null ? 'location'.tr : 'soil'.tr,
                conditions?.location ?? conditions?.soilComposition ?? '',
                const Color(0xFFFBF9EF),
              ),
              _buildInteriorItem(
                'images/icon/detail_propagation.png',
                'propagation'.tr,
                howTos?.propagation ?? '',
                const Color(0xFFEFFBF2),
              ),
              _buildInteriorItem(
                'images/icon/detail_repotting.png',
                'repotting'.tr,
                howTos?.repotting ?? '',
                const Color(0xFFFBF9EF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildInteriorItem(String icon, String title, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 28),
          const SizedBox(width: 10),
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
