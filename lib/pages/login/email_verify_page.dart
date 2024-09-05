import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/common_util.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/page_bg.dart';
import 'package:plant/controllers/login_controller.dart';
import 'package:plant/components/nav_bar.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key, required this.email});
  final String email;

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  bool _isSubmit = false;
  Timer? _timer;
  int _duration = 59;

  final LoginController loginCtr = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      if (mounted) {
        setState(() {
          _duration--;
          if (_duration <= 0) {
            _timer?.cancel();
            _timer = null;
            _isSubmit = true;
          }
          if (_duration % 5 == 0) {
            loginCtr.emailVerifiedReload();
          }
        });
      }
    });
  }

  String _formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const NavBar(),
        body: Column(
          children: [
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'images/icon/email.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'emailVerification'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'confirmEmailAddress'.tr + widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: UIColor.c8E8B8B,
                  fontSize: 12,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'didNotReceive'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: NormalButton(
                text: _isSubmit ? 'resendEmail'.tr : '${'resendEmail'.tr} ${_formatTime(_duration)}',
                bgColor: _isSubmit ? UIColor.primary : UIColor.cD1D1D1,
                textColor: UIColor.white,
                onTap: _isSubmit
                    ? () {
                        loginCtr.emailSend();
                        _duration = 59;
                        _isSubmit = false;
                        setState(() {});
                        _startTimer();
                      }
                    : null,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.only(top: 16, bottom: Get.mediaQuery.viewPadding.bottom + 16, left: 20, right: 20),
              color: UIColor.transparentPrimary40,
              alignment: Alignment.center,
              width: double.infinity,
              // height: 68 + Get.mediaQuery.viewPadding.bottom,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'refreshTips'.tr,
                      style: TextStyle(
                        color: UIColor.c40BD95,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: NormalButton(
                      text: 'refresh'.tr,
                      bgColor: UIColor.primary,
                      textColor: UIColor.white,
                      onTap: Common.debounce(() async {
                        FireBaseUtil.logEvent(EventName.resendVerification);
                        await loginCtr.emailVerifiedReload();
                        // Get.until((route) => Get.currentRoute == '/login_page');
                      }, 3000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
