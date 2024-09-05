import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class Rsa {
  static Future<String> encodeString(String? content) async {
    if (content == null) return '';
    final publicPem = await rootBundle.loadString('keys/public_key.pem');
    dynamic publicKey = RSAKeyParser().parse(publicPem);

    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(content).base64;
  }
  
  static Future<String> decodeString(String? content) async {
    if (content == null) return '';
    final private = await rootBundle.loadString('keys/buy_private_key.pem');
    dynamic privateKey = RSAKeyParser().parse(private);

    final encrypter = Encrypter(RSA(privateKey: privateKey));

    return encrypter.decrypt(Encrypted.fromBase64(content)).toString();
  }
}
