import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/widgets.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/user_nav_bar.dart';
import 'package:plant/widgets/welcome_widget.dart';

class DiagnosePage extends StatelessWidget {
  const DiagnosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserNavBar(needUser: true),
        const WelcomeWidget(),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      'Start Diagnose',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: UIColor.c15221D,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diagnose plant diseases and learn',
                      style: TextStyle(
                        color: UIColor.c9C9999,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    NormalButton(
                      text: 'Take a Photo',
                      textColor: UIColor.c00997A,
                      bgColor: UIColor.transparentPrimary40,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                width: 40,
                height: 40,
                child: Image.asset('images/icon/diagnose_history.png'),
              )
            ],
          ),
        )
      ],
    );
  }
}
