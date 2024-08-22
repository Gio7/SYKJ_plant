import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {

  static Future<Uint8List> xFileToList(XFile file) async {
    return await File(file.path).readAsBytes();
  }

  static Future<Image?> xFileToImage(XFile file) async {
    final completeImage = await File(file.path).readAsBytes();
    return decodeImage(completeImage);
  }

  static Future<Uint8List?> imageToList(Image image) async {
    final appDocDir = (await getApplicationCacheDirectory()).path;
    final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
    return encodeNamedImage(imgPath, image);
  }


}
