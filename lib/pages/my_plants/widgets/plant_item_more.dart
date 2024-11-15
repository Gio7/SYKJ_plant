import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_model.dart';

class PlantItemMore extends StatelessWidget {
  const PlantItemMore({super.key, this.onTap, this.onMore, required this.model, this.hasCreateTime = false});

  final Function()? onTap;
  final Function()? onMore;
  final bool hasCreateTime;
  final PlantModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                imageUrl: model.thumbnail ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.plantName ?? '',
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${model.scientificName}',
                      style: TextStyle(
                        color: UIColor.c8E8B8B,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium,
                      ),
                    ),
                  ),
                  if (hasCreateTime)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${'addedAt'.tr} ${model.createTimeLocal}',
                        style: TextStyle(
                          color: UIColor.c8E8B8B,
                          fontSize: 12,
                          fontWeight: FontWeightExt.medium,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onMore != null)
              GestureDetector(
                onTap: onMore,
                child: Image.asset(
                  'images/icon/more.png',
                  width: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
