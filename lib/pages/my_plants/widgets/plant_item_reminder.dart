import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_model.dart';

class PlantItemReminder extends StatelessWidget {
  const PlantItemReminder({super.key, this.onTap, this.onMore, required this.model, this.onSetReminder});

  final Function()? onTap;
  final Function()? onMore;
  final Function(int?)? onSetReminder;
  final PlantModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: UIColor.white,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.plantName ?? '',
                          style: const TextStyle(
                            color: UIColor.c15221D,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Text(
                          model.scientificName ?? '',
                          style: TextStyle(
                            color: UIColor.c7BBAA6,
                            fontSize: 12,
                            fontWeight: FontWeightExt.medium,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Text(
                          model.getReminderSetText,
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
                    onTap: onMore,
                    child: Image.asset(
                      'images/icon/more.png',
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: UIColor.transparent60,
            child: _buildReminder(model),
          ),
        ],
      ),
    );
  }

  Widget _buildReminder(PlantModel model) {
    if (model.timedPlans == null || model.timedPlans!.isEmpty) {
      return _buildEmptyReminder();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: model.timedPlans!
          .map((e) => GestureDetector(
                onTap: () => onSetReminder?.call(e.type),
                child: Container(
                  height: 32,
                  width: 32,
                  margin: const EdgeInsets.only(left: 24),
                  decoration: ShapeDecoration(
                    color: UIColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    e.getTypeIcon,
                    width: 22,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyReminder() {
    return GestureDetector(
      onTap: () {
        onSetReminder?.call(null);
        FireBaseUtil.logEvent(EventName.plantAddReminder);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'addReminder'.tr,
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 12,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          Container(width: 10, height: 22, color: UIColor.transparent),
          Image.asset('images/icon/add.png', width: 22),
        ],
      ),
    );
  }
}
