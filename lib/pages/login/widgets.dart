import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:plant/common/common_util.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/common/ui_color.dart';

class AgreementTips extends StatelessWidget {
  const AgreementTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: 'agree1'.tr,
            style: TextStyle(
              fontSize: 12.0,
              color: UIColor.cB3B3B3,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          TextSpan(
            text: 'termsOfUse'.tr,
            style: TextStyle(
              fontSize: 12.0,
              color: UIColor.primary,
              fontWeight: FontWeightExt.medium,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Common.skipUrl(GlobalData.termsOfUseUrl),
          ),
          TextSpan(
            text: " ${'agree2'.tr} ",
            style: TextStyle(
              fontSize: 12.0,
              color: UIColor.cB3B3B3,
              fontWeight: FontWeightExt.medium,
            ),
          ),
          TextSpan(
            text: 'privacyPolicy'.tr,
            style: TextStyle(
              fontSize: 12.0,
              color: UIColor.primary,
              fontWeight: FontWeightExt.medium,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Common.skipUrl(GlobalData.privacyNoticeUrl),
          ),
        ]),
      ),
    );
  }
}
