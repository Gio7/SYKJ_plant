import 'package:flutter/widgets.dart';
import 'package:plant/common/ui_color.dart';

class CustomSegmentedValue{
  final String value;
  final String label;
  CustomSegmentedValue(this.label, this.value);
}

class CustomSegmented extends StatelessWidget {
  const CustomSegmented({super.key, required this.selected, required this.data, required this.onChange});
  final CustomSegmentedValue selected;
  final List<CustomSegmentedValue> data;
  final Function(CustomSegmentedValue) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: UIColor.transparent40,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: data.map((e) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onChange(e),
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: e == selected ? UIColor.white : UIColor.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e.label,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}