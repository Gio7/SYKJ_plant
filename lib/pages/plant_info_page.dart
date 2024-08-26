import 'package:flutter/material.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/nav_bar.dart';

class PlantInfoPage extends StatefulWidget {
  const PlantInfoPage({super.key});

  @override
  State<PlantInfoPage> createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: UIColor.white,
      child: Column(
        children: [
          NavBar(),
        ],
      ),
    );
  }
}