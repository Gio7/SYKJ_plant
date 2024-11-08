import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  // static Future<Uint8List> xFileToList(XFile file) async {
  //   return await File(file.path).readAsBytes();
  // }

  static Future<Image?> xFileToImage(XFile file) async {
    final completeImage = await File(file.path).readAsBytes();
    return decodeImage(completeImage);
  }

  // static Future<Uint8List?> imageToList(Image image) async {
  //   final appDocDir = (await getApplicationCacheDirectory()).path;
  //   final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
  //   return encodeNamedImage(imgPath, image);
  // }

  static Future<File?> imageToFile(Image image) async {
    final appDocDir = (await getApplicationCacheDirectory()).path;
    final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
    final imageBytes = encodeJpg(image, quality: 60);
    // final Uint8List? imageBytes = encodeNamedImage(imgPath, image);
    // if (imageBytes == null) return null;
    final file = File(imgPath);
    return await file.writeAsBytes(imageBytes);
  }

  static Future<File?> listToFile(Uint8List list) async {
    final appDocDir = (await getApplicationCacheDirectory()).path;
    final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
    final file = File(imgPath);
    return await file.writeAsBytes(list);
  }
}
