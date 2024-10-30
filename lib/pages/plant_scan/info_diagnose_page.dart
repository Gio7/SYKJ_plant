import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';

import 'widgets/diagnose_rect.dart';

class InfoDiagnosePage extends StatelessWidget {
  InfoDiagnosePage({super.key, this.hideBottom = false});
  final bool hideBottom;

  final ctr = Get.find<PlantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.cF3F4F3,
      body: Stack(
        children: [
          _buildHeadImage(),
          _buildBody(),
          if (!hideBottom) _buildBottomBtn(),
          _buildNav(),
        ],
      ),
    );
  }

  Positioned _buildNav() {
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

  Positioned _buildBottomBtn() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 64 + Get.mediaQuery.padding.bottom,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + Get.mediaQuery.padding.bottom),
        color: UIColor.white,
        child: Row(
          children: [
            Expanded(
              child: NormalButton(
                onTap: () async {
                  if (ctr.repository.plantInfo == null) {
                    if (ctr.repository.diagnoseInfo?.scanRecordId == null) {
                      return;
                    }
                    FireBaseUtil.logEvent(EventName.dianoseInfoPlantinfo);
                    Get.dialog(const LoadingDialog(), barrierDismissible: false);
                    await ctr.scanByScientificName(ctr.repository.diagnoseInfo!.scanRecordId!);
                    Get.back();
                  }
                  Get.to(() => InfoIdentifyPage());
                },
                icon: 'images/icon/detail_conditions.png',
                text: 'plantInfo'.tr,
                textColor: UIColor.white,
                bgColor: UIColor.c40BD95,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: NormalButton(
                onTap: () {
                  FireBaseUtil.logEvent(EventName.dianoseInfoRetake);
                  Get.until((route) => Get.currentRoute == '/ShootPage');
                },
                icon: 'images/icon/detail_camera.png',
                text: 'retake'.tr,
                textColor: UIColor.white,
                bgColor: UIColor.cF6A469,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildBody() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 245 /* 256 */, bottom: 70 + Get.mediaQuery.padding.bottom),
          padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 60,
                      left: 20,
                      right: 20,
                      bottom: 24,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'yourPlantIs'.tr,
                                style: const TextStyle(
                                  color: UIColor.c15221D,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: ' ${(ctr.repository.diagnoseInfo?.plant?.healthy ?? false) ? 'healthy'.tr : 'notHealthy'.tr}',
                                style: TextStyle(
                                  color: (ctr.repository.diagnoseInfo?.plant?.healthy ?? false) ? UIColor.primary : UIColor.cFD5050,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'diagnosisTips'.tr,
                          style: TextStyle(
                            color: UIColor.c8E8B8B,
                            fontSize: 12,
                            fontWeight: FontWeightExt.medium,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -45,
                    height: 90,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/icon/detail_head.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              for (final item in ctr.repository.diagnoseInfo?.plant?.diseaseDetail ?? []) ...[
                Text(
                  item.displayTitle,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.treatmentPlan,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
                ..._buildArticle(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildArticle() {
    final article = ctr.repository.diagnoseInfo?.plant?.article ?? [];
    final List<Widget> widgets = [];
    for (int i = 0; i < article.length; i++) {
      final item = article[i];
      // widgets.add(const SizedBox(height: 24));
      if (item.title.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              item.title,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      }
      if (item.contents != null) {
        for (int j = 0; j < item.contents!.length; j++) {
          final content = item.contents![j];
          if (content.type == 0) {
            widgets.add(Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Markdown(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                data: content.content ?? '',
                // style: TextStyle(
                //   color: UIColor.c8E8B8B,
                //   fontSize: 12,
                //   fontWeight: FontWeightExt.medium,
                //   decoration: TextDecoration.none,
                // ),
              ),
            ));
          } else if (content.type == 1) {
            widgets.add(Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                content.contentPart?.title ?? '',
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ));
            widgets.add(Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Markdown(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                data: content.contentPart?.content ?? '',
                // style: TextStyle(
                //   color: UIColor.c8E8B8B,
                //   fontSize: 12,
                //   fontWeight: FontWeightExt.medium,
                //   decoration: TextDecoration.none,
                // ),
              ),
            ));
          } else if (content.type == 2) {
            if (content.imageUrl != null && content.imageUrl!.isNotEmpty) {
              widgets.add(Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: CachedNetworkImage(imageUrl: content.imageUrl!, fit: BoxFit.cover),
              ));
            }
          }
        }
      }
    }
    return widgets;
  }

  Widget _buildHeadImage() {
    final url = ctr.repository.diagnoseInfo?.plant?.diagnoseImage ?? '';
    final reginos = ctr.repository.diagnoseInfo?.plant?.diagnoseDetect?.regions ?? [];
    if (url.isEmpty) {
      return const SizedBox();
    }
    return DiagnoseRectPage(
      url: url,
      regions: reginos,
    );
  }
}
