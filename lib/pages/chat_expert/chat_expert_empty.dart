import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/router/app_pages.dart';

class ChatExpertEmpty extends StatelessWidget {
  const ChatExpertEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 140, 20, 0),
      // height: 306,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: ShapeDecoration(
        color: UIColor.transparent40,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -96,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/icon/chat_expert.png',
                width: 200,
                height: 160,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Spacer(),
              const SizedBox(height: 90),
              Text(
                'chatAdvice'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "chatAdviceTips".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: UIColor.c9C9999,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.chatExpertContent);
                },
                child: Container(
                  height: 44,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const ImageIcon(
                        AssetImage('images/icon/edit2.png'),
                        size: 20,
                        color: UIColor.cBDBDBD,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'typeHere'.tr,
                        style: TextStyle(
                          color: UIColor.cB3B3B3,
                          fontSize: 14,
                          fontWeight: FontWeightExt.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
