import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/widgets/btn.dart';

class ReminderEditPage extends StatelessWidget {
  const ReminderEditPage({super.key, required this.plantModel});
  final PlantModel plantModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.cF3F4F3,
      body: Stack(
        children: [
          _buildHeadImage,
          _buildBody,
          _buildBottom,
          _buildNav,
        ],
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 16,
        left: 10,
        right: 4,
        bottom: 16,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Image.asset(
            'images/icon/fertilizer.png',
            width: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'fertilizer'.tr,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Image.asset(
                'images/icon/fertilizer.png',
                width: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'fertilizer'.tr,
                style: const TextStyle(
                  color: UIColor.c8E8B8B,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 24, color: UIColor.cBDBDBD),
        ],
      ),
    );
  }

  Widget get _buildBody {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 245, bottom: 108 + Get.mediaQuery.padding.bottom),
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          decoration: const ShapeDecoration(
            color: UIColor.cF3F4F3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  plantModel.plantName ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'scientificName'.tr,
                        style: const TextStyle(
                          color: UIColor.c00997A,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: plantModel.scientificName ?? '',
                        style: const TextStyle(
                          color: UIColor.c15221D,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildItem(),
              _buildItem(),
              _buildItem(),
              _buildItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildHeadImage {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: 290,
      child: CachedNetworkImage(
        imageUrl: plantModel.thumbnail ?? '',
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget get _buildNav {
    return Positioned(
      left: 10,
      top: 0,
      right: 0,
      height: 56 + Get.mediaQuery.padding.top,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              'images/icon/detail_arrow_right.png',
              width: 32,
            ),
          ),
        ),
      ),
    );
  }

  Positioned get _buildBottom {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: UIColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text.rich(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                TextSpan(
                  children: [
                    TextSpan(text: 'Next Watering  '),
                    TextSpan(
                      text: '07/25/2024',
                      style: TextStyle(color: UIColor.c40BD95),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: NormalButton(
                text: 'confirm'.tr,
                textColor: UIColor.white,
                bgColor: UIColor.primary,
              ),
            ),
            SizedBox(height: Get.mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
