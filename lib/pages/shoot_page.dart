import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShootPage extends StatelessWidget {
  const ShootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('shoot'),leading: IconButton(onPressed: () {Get.back();}, icon: Icon(Icons.arrow_back)),),
      body: const Placeholder(),
    );
  }
}