import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:plant/common/ui_color.dart';

import 'loading_dialog.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.isLoading,
    this.icon = 'images/icon/no_data.png',
  });
  final bool isLoading;
  final String icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingDialog();
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/icon/no_data.png', height: 70),
          const SizedBox(height: 16),
          Text(
            'noData'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
