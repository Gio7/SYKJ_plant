import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/pages/login/email_signup_page.dart';

import 'email_login_page.dart';
import 'widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.28, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UIColor.cD9F0E5, UIColor.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56,
                width: double.infinity,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const ImageIcon(
                        AssetImage('images/icon/close.png'),
                        size: 32,
                        color: UIColor.c15221D,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('images/icon/login_bg.png', height: 174),
              const SizedBox(height: 6),
              const Text(
                'XXX',
                style: TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'loginTips'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              ...loginBtns,
              const Spacer(),
              const AgreementTips(),
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: EdgeInsets.only(top: 16, bottom: Get.mediaQuery.viewPadding.bottom + 16),
                color: UIColor.transparentPrimary40,
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'haveAnAccount'.tr,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: UIColor.cB3B3B3,
                        fontWeight: FontWeightExt.medium,
                      ),
                    ),
                    TextSpan(
                      text: 'logIn'.tr,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: UIColor.primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => const EmailLoginPage());
                        },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get loginBtns {
    return [
      if (GetPlatform.isIOS)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: NormalButton(
            onTap: () {
              // TODO: 跳转到Apple登录
            },
            bgColor: UIColor.transparentPrimary70,
            text: 'continueWithApple'.tr,
            textColor: UIColor.white,
            icon: 'images/icon/apple.png',
          ),
        )
      else
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: NormalButton(
            onTap: () {
              // TODO: 跳转到Google登录
            },
            bgColor: UIColor.transparentPrimary70,
            text: 'continueWithGoogle'.tr,
            textColor: UIColor.white,
            iconWidget: Image.asset('images/icon/google.png', width: 24),
          ),
        ),
      const SizedBox(height: 24),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: NormalButton(
          onTap: () => Get.to(() => const EmailSignupPage()),
          bgColor: UIColor.c40BD95,
          text: 'signUpWithEmail'.tr,
          textColor: UIColor.white,
          iconWidget: Image.asset('images/icon/mail.png', width: 24),
        ),
      ),
    ];
  }
}
