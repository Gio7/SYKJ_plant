import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/diagnose_history/diagnose_history_page.dart';
import 'package:plant/pages/diagnose_home/categorized_feed_model.dart';
import 'package:plant/pages/diagnose_home/diseases_case_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/pages/plant_scan/shoot_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/user_nav_bar.dart';
import 'package:plant/widgets/welcome_widget.dart';

class DiagnosePage extends StatelessWidget {
  const DiagnosePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCtr = Get.find<MainController>();
    mainCtr.getDiseaseHome();
    return SingleChildScrollView(
      child: Column(
        children: [
          const UserNavBar(needUser: true),
          const WelcomeWidget(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: DottedDecoration(
              shape: Shape.box,
              color: UIColor.cAEE9CD,
              strokeWidth: 1,
              dash: const <int>[2, 2],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Image.asset('images/icon/diagnose_demo.png', height: 70),
                      const SizedBox(height: 24),
                      Text(
                        'startDiagnose'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: UIColor.c15221D,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'diagnoseDiseases'.tr,
                        style: TextStyle(
                          color: UIColor.c9C9999,
                          fontSize: 12,
                          fontWeight: FontWeightExt.medium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      NormalButton(
                        paddingHorizontal: 26,
                        onTap: () {
                          // FireBaseUtil.logEvent(EventName.homeDianose);
                          Get.to(() => const ShootPage(shootType: ShootType.diagnose));
                        },
                        text: 'takeAPhoto'.tr,
                        textColor: UIColor.c00997A,
                        bgColor: UIColor.transparentPrimary40,
                      ),
                    ],
                  ),
                ),
                if (Get.find<UserController>().isLogin.value)
                  Positioned(
                    top: 16,
                    right: 16,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        FireBaseUtil.logEvent(EventName.diagnoseHistory);
                        Get.to(() => const DiagnoseHistoryPage());
                      },
                      child: Image.asset('images/icon/diagnose_history.png'),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Image.asset('images/icon/adress_book.png', width: 24),
              const SizedBox(width: 4),
              Text(
                'exploreDiseases'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(
            () => SizedBox(
              height: 156,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return _buildItem(mainCtr.categorizedFeedList[i]);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: mainCtr.categorizedFeedList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(CategorizedFeedModel model) {
    return GestureDetector(
      onTap: () {
        FireBaseUtil.didNormalDisease(model.categoryName);
        Get.to(
          () => DiseasesCasePage(
            title: model.categoryName,
            id: model.categoryId,
          ),
        );
      },
      child: Container(
        width: 230,
        height: 156,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(model.imageUrl),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 36,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: const ShapeDecoration(
            color: Color(0x99093427),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            model.categoryName,
            style: const TextStyle(
              color: UIColor.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ) /* Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.categoryName,
                style: TextStyle(
                  color: UIColor.transparentWhite50,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                model.categoryName,
                style: TextStyle(
                  color: UIColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ) */
          ,
        ),
      ),
    );
  }
}
