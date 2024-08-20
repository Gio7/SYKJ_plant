import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/show_dialog.dart';

import 'shoot_page.dart';
import '../controllers/user_nav_bar.dart';

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  void _onMore() {
    Get.bottomSheet(
      BottomPopOptions(
        children: [
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () {
                // TODO 重命名
                Get.back();
                Get.dialog(
                  TextFieldDialog(
                    title: 'setYourPlantName'.tr,
                    confirmText: 'save'.tr,
                    cancelText: 'cancel'.tr,
                    onConfirm: (String v) {
                      print(v);
                    },
                  ),
                );
              },
              text: 'rename'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/edit.png', width: 28),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () {
                // TODO 删除
              },
              text: 'removeBtn'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/delete_red.png', width: 28),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserNavBar(needUser: true),
        Container(
          margin: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            'myPlants'.tr,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: DottedDecoration(shape: Shape.box, color: UIColor.cAEE9CD, strokeWidth: 1, dash: const <int>[2, 2], borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/icon/plants.png', height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'youHaveNoPlants'.tr,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              NormalButton(
                onTap: () {
                  Get.to(() => const ShootPage());
                },
                bgColor: UIColor.transparentPrimary40,
                text: 'addPlant'.tr,
                textColor: UIColor.primary,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: ShapeDecoration(
                  color: UIColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://cdn.mos.cms.futurecdn.net/FCY9PcBrhN3pfoNV7FfFTQ.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Australian Tree Fern',
                            style: TextStyle(
                              color: UIColor.c15221D,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'added at 07/04/2024',
                            style: TextStyle(
                              color: UIColor.c8E8B8B,
                              fontSize: 12,
                              fontWeight: FontWeightExt.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onMore();
                      },
                      child: Image.asset(
                        'images/icon/more.png',
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
