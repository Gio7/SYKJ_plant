import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';

class HelpExample extends StatelessWidget {
  const HelpExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF474848),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'snapTips'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: UIColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 24),
          Image.asset('images/icon/tips0.png', height: 160),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Image.asset('images/icon/tips1.png', height: 80),
                    const SizedBox(height: 10),
                    Text(
                      'tooClose'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: UIColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image.asset('images/icon/tips2.png', height: 80),
                    const SizedBox(height: 10),
                    Text(
                      'tooFar'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: UIColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image.asset('images/icon/tips3.png', height: 80),
                    const SizedBox(height: 10),
                    Text(
                      'multiSpecies'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: UIColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          SizedBox(width: double.infinity,child: NormalButton(text: 'continue'.tr, textColor: UIColor.white, bgColor: UIColor.primary, onTap: () => Get.back())),
        ],
      ),
    );
  }
}
