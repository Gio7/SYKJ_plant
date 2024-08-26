import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/page_bg.dart';
import 'package:plant/controllers/login_controller.dart';
import 'package:plant/components/nav_bar.dart';

class ResetPwdPage extends StatefulWidget {
  const ResetPwdPage({super.key});

  @override
  State<ResetPwdPage> createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailError = false;
  bool _isEmailShowIcon = false;

  bool _isSubmit = false;

  bool _isSend = false;

  Future<void> _submit() async {
    await Get.find<LoginController>().sendPasswordResetEmail(_emailController.text);
    setState(() {
      _isSend = true;
    });
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
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool _verSubmit() {
    if (_emailController.text.isEmpty) {
      return false;
    }

    if (!GetUtils.isEmail(_emailController.text)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'resetPassword'.tr),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
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
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: NormalButton(
                  text: 'done'.tr,
                  bgColor: (_isSubmit && !_isSend) ? UIColor.primary : UIColor.cD1D1D1,
                  textColor: UIColor.white,
                  onTap: _isSubmit && !_isSend ? () => _submit() : null,
                ),
              ),
              if (_isSend)
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 8),
                  child: Row(
                    children: [
                      Image.asset('images/icon/successful.png', width: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'resetPasswordDone'.tr,
                          style: TextStyle(
                            color: UIColor.c40BD95,
                            fontSize: 12,
                            fontWeight: FontWeightExt.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            'resetPasswordTips'.tr,
            style: TextStyle(
              color: UIColor.c8E8B8B,
              fontSize: 12,
              fontWeight: FontWeightExt.medium,
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
