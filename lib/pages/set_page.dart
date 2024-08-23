import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/show_dialog.dart';
import 'package:plant/controllers/nav_bar.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/login/login_page.dart';

class SetPage extends StatelessWidget {
  const SetPage({super.key});

  void _onContact() {
    Get.dialog(
      DialogContainer(
        child: Column(
          children: [
            Text(
              'contactUs'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // TODO 打开网页
              },
              child: Container(
                height: 36,
                color: UIColor.transparent,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Image.asset('images/icon/telegram.png', width: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Telegram',
                        style: TextStyle(
                          color: UIColor.c8E8B8B,
                          fontSize: 14,
                          fontWeight: FontWeightExt.medium,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Image.asset('images/icon/arrow_right.png', width: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                // TODO 调邮箱
              },
              child: Container(
                height: 36,
                color: UIColor.transparent,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Image.asset('images/icon/mail.png', width: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        // TODO 邮箱确认
                        'support@aicover.ai',
                        style: TextStyle(
                          color: UIColor.c8E8B8B,
                          fontSize: 14,
                          fontWeight: FontWeightExt.medium,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Image.asset('images/icon/arrow_right.png', width: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccount() async {
    await Get.dialog(
      NormalDialog(
        title: 'warning'.tr,
        confirmText: 'delete'.tr,
        cancelText: 'cancel'.tr,
        subText: 'deleteAccountTips'.tr,
        icon: Image.asset('images/icon/delete_account_dialog.png', height: 70),
        onConfirm: () async {
          Get.find<UserController>().userDelete();
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userCtr = Get.find<UserController>();

    return Scaffold(
      appBar: NavBar(title: 'settings'.tr),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      stops: [-0.54, 1.09],
                      begin: FractionalOffset(1, 0.5),
                      end: FractionalOffset(0, 0.5),
                      colors: [UIColor.cAEE9CD, UIColor.c40BD95],
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: UIColor.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${'hi'.tr}${userCtr.isLogin.value ? userCtr.userInfo.value.nickname : 'plantLover'.tr}',
                            style: const TextStyle(
                              color: UIColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (userCtr.isLogin.value)
                            GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  TextFieldDialog(
                                    value: userCtr.userInfo.value.nickname,
                                    title: 'setYourName'.tr,
                                    confirmText: 'save'.tr,
                                    cancelText: 'cancel'.tr,
                                    onConfirm: (String v) {
                                      userCtr.userEdit(v);
                                      Get.back();
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Image.asset('images/icon/edit2.png', width: 20),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getWelcomeText(userCtr),
                        style: const TextStyle(
                          color: UIColor.transparent60,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 30,
                        child: _buildBtn(userCtr),
                      )
                    ],
                  ),
                ),
                _buildImage(userCtr),
              ],
            ),
            const SizedBox(height: 16),
            if (userCtr.isLogin.value)
              _buildListItem(
                () {},
                'images/icon/set_code.png',
                'activationCode'.tr,
              ),
            _buildListItem(
              () {
                _onContact();
              },
              'images/icon/set_contact.png',
              'contactUs'.tr,
            ),
            _buildListItem(
              () {},
              'images/icon/set_share.png',
              'shareWithFriends'.tr,
            ),
            _buildListItem(
              () {},
              'images/icon/set_terms.png',
              'termsOfService'.tr,
            ),
            _buildListItem(
              () {},
              'images/icon/set_privacy.png',
              'privacyPolicy'.tr,
            ),
            if (userCtr.isLogin.value)
              _buildListItem(
                () {
                  // Get.defaultDialog(title: '123',content: Text('data'));
                  // DialogUtil.showDialog();
                  _onDeleteAccount();
                },
                'images/icon/set_delete_account.png',
                'deleteAccoun'.tr,
              ),
            _buildListItem(
              () {},
              'images/icon/set_version.png',
              'appVersion'.tr,
              rightText: "V${GlobalData.versionName}"//userCtr.version.value,
            ),
            const SizedBox(height: 54),
            if (userCtr.isLogin.value)
              NormalButton(
                onTap: () => userCtr.logout(),
                text: 'logOut'.tr,
                textColor: UIColor.c00997A,
                bgColor: UIColor.transparentPrimary40,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(Function()? onTap, String liftIcon, String title, {String rightIcon = 'images/icon/arrow_right.png', String? rightText}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: UIColor.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Image.asset(liftIcon, width: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ),
            if (rightText != null)
              Text(
                rightText,
                style: TextStyle(
                  color: UIColor.cB3B3B3,
                  fontSize: 12,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            const SizedBox(width: 8),
            Image.asset(rightIcon, width: 24),
          ],
        ),
      ),
    );
  }

  String _getWelcomeText(UserController userController) {
    if (userController.userInfo.value.memberType == 1) {
      return 'getProTips'.tr;
    }
    if (userController.userInfo.value.memberType == 2) {
      return 'weeklyMembership'.tr;
    }
    if (userController.userInfo.value.memberType == 4) {
      return 'yearsMembership'.tr;
    }
    return 'welcome'.tr;
  }

  Positioned _buildImage(UserController userController) {
    if (userController.userInfo.value.memberType == 1) {
      return Positioned(
        right: -6,
        bottom: 12,
        child: Image.asset('images/icon/have_logged_in.png', height: 142),
      );
    }
    if (userController.userInfo.value.memberType == 2) {
      return Positioned(
        right: 5,
        bottom: 15,
        child: Image.asset('images/icon/week_vip.png', height: 120),
      );
    }
    if (userController.userInfo.value.memberType == 4) {
      return Positioned(
        right: 5,
        bottom: 15,
        child: Image.asset('images/icon/week_vip.png', height: 120),
      );
    }
    return Positioned(
      right: -6,
      bottom: 12,
      child: Image.asset('images/icon/not_logged_in.png', height: 142),
    );
  }

  NormalButton _buildBtn(UserController userController) {
    if (userController.userInfo.value.memberType == 1) {
      return NormalButton(
        onTap: () {
          // TODO 订阅
        },
        text: 'getPro'.tr,
        textColor: UIColor.c00997A,
        bgColors: const [UIColor.cD7FF38, UIColor.cAAFFD6],
        bgColor: UIColor.cAAFFD6,
      );
    }

    if (userController.userInfo.value.memberType == 2) {
      return NormalButton(
        onTap: () {
          // TODO 复制
        },
        text: '${'no.'.tr}${userController.userInfo.value.userid}',
        textColor: UIColor.c00997A,
        bgColor: UIColor.cAEE9CD,
      );
    }

    if (userController.userInfo.value.memberType == 4) {
      return NormalButton(
        onTap: () {
          // TODO 复制
        },
        text: '${'no.'.tr}${userController.userInfo.value.userid}',
        textColor: UIColor.c00997A,
        bgColor: UIColor.cAEE9CD,
      );
    }
    return NormalButton(
      onTap: () {
        Get.to(() => const LoginPage(), fullscreenDialog: true);
      },
      text: 'logIn'.tr,
      textColor: UIColor.c00997A,
      bgColor: UIColor.cAEE9CD,
    );
  }
}
