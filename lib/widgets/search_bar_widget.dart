import 'package:flutter/material.dart';
import 'package:plant/common/common_util.dart';
import 'package:plant/common/ui_color.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, this.hintText, this.onSubmitted});
  final String? hintText;
  final Function(String)? onSubmitted;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final ctr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SearchBarTheme(
      data: SearchBarThemeData(
        backgroundColor: const WidgetStatePropertyAll(UIColor.white),
        elevation: const WidgetStatePropertyAll(0),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: UIColor.c15221D,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            color: UIColor.cB3B3B3,
            fontSize: 16,
            fontWeight: FontWeightExt.medium,
          ),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.fromLTRB(10, 4, 4, 4),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        constraints: const BoxConstraints(maxHeight: 40),
      ),
      child: SearchBar(
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        onChanged: (value) => setState(() {}),
        leading: Image.asset('images/icon/search.png', height: 18),
        hintText: widget.hintText,
        controller: ctr,
        trailing: <Widget>[
          if (ctr.text.isNotEmpty)
            IconButton(
              onPressed: () {
                ctr.clear();
                setState(() {});
              },
              icon: const ImageIcon(AssetImage('images/icon/close_clean.png'), color: UIColor.cBDBDBD),
              iconSize: 16,
            ),
          ElevatedButton(
            onPressed: Common.debounce(() {
              widget.onSubmitted?.call(ctr.text);
            }, 1000),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(UIColor.c40BD95),
              maximumSize: WidgetStatePropertyAll(Size(44, 32)),
              minimumSize: WidgetStatePropertyAll(Size(44, 32)),
              iconSize: WidgetStatePropertyAll(18),
              iconColor: WidgetStatePropertyAll(UIColor.white),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
            ),
            child: const ImageIcon(AssetImage('images/icon/search.png')),
          )
        ],
      ),
    );
  }
}
