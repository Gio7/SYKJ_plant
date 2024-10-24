import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

class InfoFunFacts extends StatelessWidget {
  const InfoFunFacts({super.key, required this.littleStory});
  final String littleStory;

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
                  'images/icon/detail_facts.png',
                  width: 24,
                ),
              ),
              Text(
                'funFacts'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: ShapeDecoration(
              color: UIColor.cF7F7F7,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('images/icon/detail_story.png', width: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    littleStory,
                    style: TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 14,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
