import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/controllers/login_controller.dart';
import 'package:plant/components/nav_bar.dart';
import 'package:plant/pages/login/email_signup_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'email_login_page.dart';
import 'widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<AuthorizationCredentialAppleID> signInWithApple() async {
    try {
      return await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginCtr = Get.put(LoginController());
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
        appBar: NavBar(
          leftWidget: IconButton(
            onPressed: () => Get.back(),
            icon: const ImageIcon(
              AssetImage('images/icon/close.png'),
              size: 32,
              color: UIColor.c15221D,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/icon/login_bg.png', height: 174),
              const SizedBox(height: 6),
              const Text(
                'Plant Identifier',
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
              ...loginBtns(loginCtr),
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

  List<Widget> loginBtns(LoginController loginCtr) {
    return [
      if (GetPlatform.isIOS)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: NormalButton(
            onTap: () async {
              final aca = await signInWithApple();
              if (aca.userIdentifier != null) {
                await loginCtr.login(aca.userIdentifier!, aca.email);
                Get.back(closeOverlays: true);
              }
            },
            bgColor: UIColor.transparentPrimary70,
            text: 'continueWithApple'.tr,
            textColor: UIColor.white,
            icon: 'images/icon/apple.png',
          ),
        )
      else ...[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: NormalButton(
            onTap: () async {
              final userCredential = await signInWithGoogle();
              final uid = userCredential.user?.uid;
              if (uid != null) {
                await loginCtr.login(uid, userCredential.user?.email);
                Get.back(closeOverlays: true);
              }
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
      ],
    ];
  }
}
