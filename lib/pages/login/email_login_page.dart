import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/page_bg.dart';
import 'package:plant/controllers/nav_bar.dart';
import 'package:plant/pages/login/reset_pwd_page.dart';

import 'widgets.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailError = false;
  bool _isEmailShowIcon = false;

  bool _isPwdError = false;
  bool _isShowPwd = false;
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdFocusNode = FocusNode();

  bool _isSubmit = false;

  void _submit() {
    // TODO 提交
    // Get.until((route) => Get.currentRoute == '/');
    Get.back(closeOverlays: true);
    Get.back();
  }

  bool _verSubmit() {
    if (_emailController.text.isEmpty) {
      return false;
    }
    if (_pwdController.text.isEmpty) {
      return false;
    }

    if (!GetUtils.isEmail(_emailController.text)) {
      return false;
    }

    if (_pwdController.text.length < 6 || _pwdController.text.length > 12) {
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() {
          _isEmailError = !GetUtils.isEmail(_emailController.text);
          _isEmailShowIcon = _emailController.text.isNotEmpty && !_isEmailError;
        });
      }
    });
    _pwdFocusNode.addListener(() {
      if (!_pwdFocusNode.hasFocus) {
        setState(() {
          _isPwdError = _pwdController.text.length < 6 || _pwdController.text.length > 12;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'logIn'.tr),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  children: [
                    textField(
                      title: 'email'.tr,
                      errorText: 'emailError'.tr,
                      hintText: 'emailInputTips'.tr,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      icon: Image.asset('images/icon/successful.png', width: 20),
                      isShowError: _isEmailError,
                      isShowIcon: _isEmailShowIcon,
                      borderColor: _isEmailShowIcon ? UIColor.c40BD95 : UIColor.transparent,
                      onChanged: (p0) {
                        bool error = !GetUtils.isEmail(_emailController.text);
                        setState(() {
                          _isSubmit = _verSubmit();
                          if (!error) {
                            _isEmailError = false;
                            _isEmailShowIcon = _emailController.text.isNotEmpty && !_isEmailError;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    textField(
                      title: 'password'.tr,
                      errorText: 'pwdError'.tr,
                      hintText: 'passwordTips'.tr,
                      controller: _pwdController,
                      focusNode: _pwdFocusNode,
                      icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isShowPwd = !_isShowPwd;
                          });
                        },
                        child: Image.asset(
                          _isShowPwd ? 'images/icon/pwd_show.png' : 'images/icon/pwd_hide.png',
                          width: 20,
                        ),
                      ),
                      isShowError: _isPwdError,
                      isShowIcon: true,
                      obscureText: !_isShowPwd,
                      onChanged: (p0) {
                        bool error = _pwdController.text.length < 6 || _pwdController.text.length > 12;
                        setState(() {
                          _isSubmit = _verSubmit();
                          if (!error) {
                            _isPwdError = false;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ResetPwdPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16, left: 10),
                        child: Text(
                          'forgotPassword'.tr,
                          style: const TextStyle(
                            color: UIColor.c40BD95,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: UIColor.c40BD95,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: NormalButton(
                        text: 'logIn'.tr,
                        bgColor: _isSubmit ? UIColor.primary : UIColor.cD1D1D1,
                        textColor: UIColor.white,
                        onTap: _isSubmit ? () => _submit() : null,
                      ),
                    ),
                  ],
                ),
              ),
              const AgreementTips(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Column textField({
    required String title,
    required String errorText,
    required bool isShowError,
    required TextEditingController controller,
    required Widget icon,
    required bool isShowIcon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    required String hintText,
    bool obscureText = false,
    FocusNode? focusNode,
    Color borderColor = UIColor.transparent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isShowError)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorText,
              style: TextStyle(
                color: UIColor.cFF3257,
                fontSize: 12,
                fontWeight: FontWeightExt.medium,
              ),
            ),
          ),
        SizedBox(
          height: 50,
          child: TextField(
            maxLines: 1,
            maxLength: 250,
            controller: controller,
            obscureText: obscureText,
            focusNode: focusNode,
            style: TextStyle(fontSize: 14, color: UIColor.c15221D, fontWeight: FontWeightExt.medium),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: isShowError ? UIColor.cFF3257 : borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(26),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isShowError ? UIColor.cFF3257 : borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(26),
              ),
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14, color: UIColor.cD1D1D1, fontWeight: FontWeightExt.medium),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              counterText: '',
              fillColor: UIColor.white,
              filled: true,
              suffixIcon: isShowIcon ? UnconstrainedBox(child: icon) : null,
            ),
            // cursorColor: UIColor.cAEE9CD,
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
