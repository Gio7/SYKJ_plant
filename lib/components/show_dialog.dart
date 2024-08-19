// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plant/components/button.dart';

// import '../common/ui_color.dart';

// class DialogUtil {
//   static Future<void> showTextField(String title, String value,{Function(String)? okTap, Function()? cancelTap, required String okText, String? cancelText}) async {
//     TextEditingController controller = TextEditingController();
//     controller.text = value;
//     await Get.dialog(
//       // barrierDismissible: false,
//       GestureDetector(
//         onTap: () => Get.back(),
//         child: Container(
//           color: Colors.black12,
//           child: Center(
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 36),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(24.0),
//                   color: UIColor.c1A1A1A,
//                   border: Border.all(color: UIColor.primary, width: 3.0, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignOutside),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       title,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: UIColor.cF9F9F9,
//                         fontSize: 14,
//                         decoration: TextDecoration.none,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Material(
//                       color: Colors.transparent,
//                       child: SizedBox(
//                         height: 42,
//                         child: TextField(
//                           maxLines: 1,
//                           maxLength: 20,
//                           controller: controller,
//                           style: const TextStyle(fontSize: 14, color: UIColor.white),
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderSide: const BorderSide(color: UIColor.c4D4D4D, width: 1.0),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             hintText: value.isNotEmpty ? value : 'newDraft'.tr,
//                             hintStyle: const TextStyle(fontSize: 14, color: UIColor.c848484),
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 6),
//                             counterText: '',
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: NormalButton(
//                             height: 42,
//                             text: okText,
//                             primary: true,
//                             onPressed: () {
//                               okTap!(controller.text);
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: NormalButton(
//                             height: 42,
//                             text: cancelText ?? 'cancel'.tr,
//                             onPressed: cancelTap ?? () => Get.back(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
