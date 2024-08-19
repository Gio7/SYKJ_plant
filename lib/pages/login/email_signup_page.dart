import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/page_bg.dart';
import 'package:plant/controllers/nav_bar.dart';

import 'widgets.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({super.key});

  @override
  State<EmailSignupPage> createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: SafeArea(
        child: Column(
          children: [
            NavBar(title: 'createAnAccount'.tr),
            SizedBox(
              width: double.infinity,
              child: NormalButton(
                bgColor: UIColor.cD1D1D1,
                text: 'signUp'.tr,
                textColor: UIColor.white,
                onTap: () {},
              ),
            ),
            const Spacer(),
            const AgreementTips(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
