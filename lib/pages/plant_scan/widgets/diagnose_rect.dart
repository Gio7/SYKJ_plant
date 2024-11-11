import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/loading_dialog.dart';

class DiagnoseRectPage extends StatefulWidget {
  const DiagnoseRectPage({super.key, required this.url, required this.regions});

  final String url;

  final List<List<double>> regions;

  @override
  State<DiagnoseRectPage> createState() => _DiagnoseRectPageState();
}

class _DiagnoseRectPageState extends State<DiagnoseRectPage> {
  double? _imageWidth;
  double? _imageHeight;
  final GlobalKey _repaintBoundaryKey = GlobalKey(); // RepaintBoundary的Key
  Uint8List? _croppedImageData;

  double _widgetWidth = Get.width;
  final double _widgetHeight = 290;

  @override
  void initState() {
    super.initState();
    _widgetWidth = MediaQuery.of(context).size.width;
    _getImageSize(widget.url);
  }

  Widget get _buildImage {
    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
      placeholder: (context, url) => const LoadingDialog(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.regions.isEmpty) {
      return Positioned(
        left: 0,
        top: 0,
        right: 0,
        height: _widgetHeight,
        child: _buildImage,
      );
    }
    if (_croppedImageData != null) {
      return Positioned(
        left: 0,
        top: 0,
        right: 0,
        child: Image.memory(_croppedImageData!),
      );
    }

    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: _imageWidth == null
          ? const SizedBox()
          : Stack(
              children: [
                RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: SizedBox(
                    width: _imageWidth,
                    height: _imageHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(child: _buildImage),
                        if (widget.regions.isNotEmpty)
                          for (var i = 0; i < widget.regions.length; i++)
                            CustomPaint(
                              size: const Size(double.infinity, double.infinity),
                              painter: RectPainter(relativeData: widget.regions[i]),
                            ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _imageWidth,
                  height: _imageHeight,
                  color: UIColor.cF3F4F3,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _widgetWidth,
                    height: _widgetHeight,
                    child: const LoadingDialog(),
                  ),
                ),
              ],
            ),
    );
  }

  void _getImageSize(String url) {
    final image = CachedNetworkImageProvider(url);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(ImageStreamListener((info, _) {
      final divisor = (_widgetWidth / info.image.width);
      setState(() {
        _imageWidth = info.image.width * divisor;
        _imageHeight = info.image.height * divisor;
      });
      if (widget.regions.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _captureImage();
          });
        });
      }
    }));
  }

  // 获取最终图像
  Future<void> _captureImage() async {
    try {
      // 获取RepaintBoundary的RenderRepaintBoundary
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // 转换为ui.Image
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      // 转换为字节数据
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      // 你可以在这里处理生成的图片，例如上传、保存等
      // print("Image captured!${image.width}/${image.height}");
      if (pngBytes != null) {
        final Rect cropRect = _computeCropRect(
          image.width.toDouble(),
          image.height.toDouble(),
        ); // 调用_computeCropRect方法计算裁剪区域的宽高, 744);
        Uint8List croppedImage = await cropImage(
          pngBytes,
          cropRect.left.toInt(),
          cropRect.top.toInt(),
          cropRect.width.toInt(),
          cropRect.height.toInt(),
        );
        setState(() {
          _croppedImageData = croppedImage; // 存储裁剪后的图片数据
        });
      }
      // return pngBytes;
    } catch (e) {
      Get.log("Error capturing image: $e");
      rethrow;
    }
  }

  // 使用image包裁剪图片
  Future<Uint8List> cropImage(Uint8List imageData, int x, int y, int width, int height) async {
    // 解码Uint8List为image.Image
    img.Image originalImage = img.decodeImage(imageData)!;
    // 裁剪
    img.Image croppedImage = img.copyCrop(originalImage, x: x, y: y, width: width, height: height);
    // 编码回Uint8List
    return Uint8List.fromList(img.encodePng(croppedImage));
  }

  Rect _computeCropRect(double imageWidth, double imageHeight) {
    // 示例数据
    double screenWidth = _widgetWidth; // 设备的屏幕宽度
    double targetHeight = _widgetHeight; // 目标裁剪区域的高度
    final region = widget.regions.first;
    final data = [region[1], region[0], region[3], region[2]];
    // final rect = Rect.fromLTRB(data[0], data[1], data[2], data[3]);
    final rect = Rect.fromLTRB(
      data[0] * imageWidth,
      data[1] * imageHeight,
      data[2] * imageWidth,
      data[3] * imageHeight,
    );
    // print('rect----: $rect');
    // 计算矩形的中心点
    double rectCenterX = rect.center.dx;
    double rectCenterY = rect.center.dy;

    // 计算裁剪区域的左上角坐标，尽量将矩形放在中心
    double cropLeft = rectCenterX - screenWidth / 2;
    double cropTop = rectCenterY - targetHeight / 2;

    // 边界检查，如果超出原图边界则进行调整
    if (cropLeft < 0) cropLeft = 0;
    if (cropTop < 0) cropTop = 0;
    if (cropLeft + screenWidth > imageWidth) cropLeft = imageWidth - screenWidth;
    if (cropTop + targetHeight > imageHeight) cropTop = imageHeight - targetHeight;

    // 最终裁剪区域
    return Rect.fromLTWH(cropLeft, cropTop, screenWidth, targetHeight);
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

    final data = [relativeData[1], relativeData[0], relativeData[3], relativeData[2]];
    final rect = Rect.fromLTRB(
      data[0] * size.width,
      data[1] * size.height,
      data[2] * size.width,
      data[3] * size.height,
    );
    // print(rect);
    final roundedRect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
