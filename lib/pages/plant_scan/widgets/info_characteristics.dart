import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_info_model.dart';

class InfoCharacteristics extends StatelessWidget {
  const InfoCharacteristics({super.key, required this.characteristics});

  final Characteristics? characteristics;

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
                  'images/icon/detail_characteristics.png',
                  width: 24,
                ),
              ),
              Text(
                'characteristics'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          if (characteristics?.maturePlant?.details != null)
            _buildCharacteristicsListView(
              'images/icon/detail_mature.png',
              'maturePlant'.tr,
              characteristics?.maturePlant?.details,
              top: 16,
            ),
          if (characteristics?.flower?.details != null)
            _buildCharacteristicsListView(
              'images/icon/detail_flower.png',
              'flower'.tr,
              characteristics?.flower?.details,
              top: 10,
            ),
          if (characteristics?.fruit?.details != null)
            _buildCharacteristicsListView(
              'images/icon/detail_fruit.png',
              'fruit'.tr,
              characteristics?.fruit?.details,
              top: 10,
            ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicsListView(String icon, String title, List<Detail>? details, {required double top}) {
    return Container(
      margin: EdgeInsets.only(top: top),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: ShapeDecoration(
        color: UIColor.transparentPrimary20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Image.asset(
                  icon,
                  width: 20,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: UIColor.c00997A,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ListView.separated(
            padding: const EdgeInsets.only(top: 16),
            itemBuilder: (_, i) {
              Detail detail = details![i];
              return _buildInteriorItem(detail);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: details?.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Container _buildInteriorItem(Detail detail) {
    final isColor = detail.type == 'Colors' && detail.colors != null && detail.colors != '';
    List<Color> colors = [];
    if (isColor) {
      colors = detail.colors!.split(',').map((e) => UIColor.hexToColor(e)).toList();
    }
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            detail.title ?? '',
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 14,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          if (colors.isNotEmpty)
            Row(
              children: colors
                  .map(
                    (e) => Container(
                      width: 10,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: ShapeDecoration(
                        color: e,
                        shape: Border.all(
                          width: 0.5,
                          color: UIColor.cE1E1E1,
                        )
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              "${detail.value ?? ''}",
              style: TextStyle(
                color: UIColor.c15221D,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
              ),
            ),
        ],
      ),
    );
  }
}
