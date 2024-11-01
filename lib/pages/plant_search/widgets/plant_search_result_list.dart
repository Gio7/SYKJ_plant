import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/highlight_text.dart';

class PlantSearchResultList extends StatelessWidget {
  const PlantSearchResultList({super.key, required this.searchText});
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemBuilder: (_, i) => _buildItem(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: 11,
    );
  }

  Widget _buildItem() {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: ShapeDecoration(
        color: UIColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://p0.ssl.qhimgs1.com/t03ba55714bfa2dcb64.jpg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: HighlightText(text: '----12-------2342342-----123阿萨德疯狂哈萨克东方航空升级换代分2123', keyword: searchText)),
          const SizedBox(width: 12),
          Image.asset(
            'images/icon/arrow_right.png',
            width: 24,
          ),
        ],
      ),
    );
  }
}
