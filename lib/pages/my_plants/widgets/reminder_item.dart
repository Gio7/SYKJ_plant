import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/reminder_model.dart';

class ReminderItem extends StatelessWidget {
  const ReminderItem({super.key, required this.model, this.onTap, this.onPlant});

  final Record model;
  final Function()? onTap;
  final Function(TimedPlan)? onPlant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              color: UIColor.transparent,
              child: Row(
                children: [
                  Image.asset(
                    model.getTypeIcon,
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model.getTypeText,
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    model.getItemsCount,
                    style: const TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    model.isExpanded ? 'images/icon/arrow_up.png' : 'images/icon/arrow_down.png',
                    width: 24,
                  ),
                ],
              ),
            ),
          ),
          if (model.isExpanded)
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: model.items
                  .map(
                    (e) => GestureDetector(
                      onTap: () => onPlant?.call(e),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: ShapeDecoration(
                          color: UIColor.cF4F5F4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: e.thumbnail ?? '',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                placeholder: (context, url) => const CircularProgressIndicator(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.plantName ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: UIColor.c15221D,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    e.getCycleText,
                                    style: TextStyle(
                                      color: UIColor.c8E8B8B,
                                      fontSize: 12,
                                      fontWeight: FontWeightExt.medium,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
