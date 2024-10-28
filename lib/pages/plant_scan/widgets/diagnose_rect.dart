import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiagnoseRectPage extends StatefulWidget {
  const DiagnoseRectPage({super.key, required this.url, required this.regions});

  /// final url = 'https://plantidentifier.co/20241028-102230 (1).jpg';
  final String url;

  /// [0.31254568696022034, 0.23214402794837952, 0.734174370765686, 0.6409206390380859]
  /// l:[1],t:[0],r:[3],b:[2]
  final List<List<double>>? regions;

  @override
  State<DiagnoseRectPage> createState() => _DiagnoseRectPageState();
}

class _DiagnoseRectPageState extends State<DiagnoseRectPage> {
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    _getImageSize(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return width == null
        ? const SizedBox()
        : SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                if (widget.regions != null)
                  for (var i = 0; i < widget.regions!.length; i++)
                    CustomPaint(
                      size: const Size(double.infinity, double.infinity),
                      painter: RectPainter(relativeData: widget.regions![i]),
                    ),
              ],
            ),
          );
  }

  Future<void> _getImageSize(String url) async {
    final image = CachedNetworkImageProvider(url);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(ImageStreamListener((info, _) {
      final divisor = (Get.size.width / info.image.width);
      setState(() {
        width = info.image.width * divisor;
        height = info.image.height * divisor;
      });
    }));
  }
}

class RectPainter extends CustomPainter {
  final List<double> relativeData;

  RectPainter({required this.relativeData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // l:[1],t:[0],r:[3],b:[2]
    final data = [relativeData[1], relativeData[0], relativeData[3], relativeData[2]];
    // 将比例数据转换为具体像素位置,
    final rect = Rect.fromLTRB(
      data[0] * size.width,
      data[1] * size.height,
      data[2] * size.width,
      data[3] * size.height,
    );

    final roundedRect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // 绘制带圆角的矩形边框
    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
