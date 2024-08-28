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
          const SizedBox(height: 16),
          _buildItem(_buildItem1()),
          const SizedBox(height: 10),
          _buildItem(_buildItem2()),
          const SizedBox(height: 10),
          _buildItem(_buildItem3()),
        ],
      ),
    );
  }

  List<Widget> _buildItem1() {
    return [
      _buildTitle('images/icon/detail_mature.png', 'maturePlant'.tr),
      const SizedBox(height: 16),
      _buildInteriorItem('plantHeight'.tr, characteristics?.maturePlant?.plantHeight ?? ''),
      const SizedBox(height: 10),
      _buildInteriorItem('spread'.tr, characteristics?.maturePlant?.spread ?? ''),
      const SizedBox(height: 10),
      _buildInteriorItem('leafColor'.tr, characteristics?.maturePlant?.leafColor ?? '', true),
    ];
  }

  List<Widget> _buildItem2() {
    return [
      _buildTitle('images/icon/detail_flower.png', 'flower'.tr),
      const SizedBox(height: 16),
      _buildInteriorItem('flowerSize'.tr, characteristics?.flower?.flowerSize ?? ''),
      const SizedBox(height: 10),
      _buildInteriorItem('flowerColor'.tr, characteristics?.flower?.flowerColor ?? '', true),
    ];
  }

  List<Widget> _buildItem3() {
    return [
      _buildTitle('images/icon/detail_fruit.png', 'fruit'.tr),
      const SizedBox(height: 16),
      _buildInteriorItem('harvestTime'.tr, characteristics?.fruit?.fruitRipeningTime ?? ''),
      const SizedBox(height: 10),
      _buildInteriorItem('fruitColor'.tr, characteristics?.fruit?.fruitColor ?? '', true),
    ];
  }

  Widget _buildItem(List<Widget> list) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: ShapeDecoration(
        color: UIColor.transparentPrimary20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Column(
        children: list,
      ),
    );
  }

  Row _buildTitle(String icon, String title) {
    return Row(
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
    );
  }

  Container _buildInteriorItem(String title, String content, [bool isColor = false]) {
    List<Color> colors = [];
    if (isColor && content.isNotEmpty) {
      colors = content.split(',').map((e) => UIColor.hexToColor(e)).toList();
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
            title,
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 12,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          if (isColor && colors.isNotEmpty)
            Row(
              children: colors
                  .map(
                    (e) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: ShapeDecoration(
                        color: e,
                        shape: const OvalBorder(),
                      ),
                    ),
                  )
                  .toList(),
            )
          else
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
    );
  }
}
