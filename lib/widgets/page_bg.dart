import 'package:flutter/cupertino.dart';
import 'package:plant/common/ui_color.dart';

class PageBG extends StatelessWidget {
  const PageBG({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0, 0.28],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UIColor.cD9F0E5, UIColor.cF3F4F3],
        ),
      ),
      child: child,
    );
  }
}
