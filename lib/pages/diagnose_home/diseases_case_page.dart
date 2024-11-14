import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/db_server.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/common_webview.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';

import 'categorized_feed_model.dart';

class DiseasesCasePage extends StatefulWidget {
  const DiseasesCasePage({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<DiseasesCasePage> createState() => _DiseasesCasePageState();
}

class _DiseasesCasePageState extends State<DiseasesCasePage> {
  List<CategorizedItem>? categorizedItemList;

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    final res = await DbServer.getCategoryItemByDB(widget.id);
    setState(() {
      categorizedItemList = res.map((e) => CategorizedItem.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: widget.title),
        body: SafeArea(
          child: categorizedItemList == null
              ? const SizedBox.shrink()
              : categorizedItemList!.isEmpty
                  ? const EmptyWidget(isLoading: false)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemBuilder: (_, i) {
                        final p = categorizedItemList![i];
                        return _buildItem(p);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: categorizedItemList!.length,
                    ),
        ),
      ),
    );
  }

  Widget _buildItem(CategorizedItem model) {
    return GestureDetector(
      onTap: () {
        if (model.resourceUrl == null || model.resourceUrl!.isEmpty) {
          return;
        }
        Get.to(
          () => CommonWebview(
            url: model.resourceUrl!,
            title: 'symptomDetails'.tr,
            thumbnail: model.thumbnailUrl,
          ),
        );
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                  imageUrl: model.thumbnailUrl ?? '',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  errorWidget: (_, __, ___) => Image.asset('images/icon/error_image.png')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  model.description ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: UIColor.c8E8B8B,
                    fontSize: 12,
                    fontWeight: FontWeightExt.medium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
