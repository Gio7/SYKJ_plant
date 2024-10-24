import 'package:encrypt/encrypt.dart';

class Rsa {
  static Future<String> encodeString(String? content) async {
    if (content == null) return '';
    // final publicPem = await rootBundle.loadString('keys/public_key.pem');
    const public = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/r+7I6i18ZYfuqGFEij9IaxMN/P4jFM+Iswz24VJy5JigG5F4x8xyTs0JdIcrfYgo38mCEN1PN+v2S8lnuknVkAvzTYP+LjBcqqQTwKBnlVcl4SzyEsdjtoEy6Yt5IbWzrPdvUlpIl0sOG3ZMwNcmPO45jPvmS+SUvC5614uEcwIDAQAB
-----END PUBLIC KEY-----
''';
    dynamic publicKey = RSAKeyParser().parse(public);

    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(content).base64;
  }
  
  static Future<String> decodeString(String? content) async {
    if (content == null) return '';
    // final private = await rootBundle.loadString('keys/buy_private_key.pem');
    const private  = '''
-----BEGIN PRIVATE KEY-----
MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIA3So5iLUkyakI8L0ZQA7CeXODT9qBxx33Rv2a8jc2qy+UHBxeb87cl/lm1DufnAA0DGXUTL7iGdjT7NCguUTXuxHRHSOHszccKyDzabNZ87sxZ7TkbA5gdGkFSDmUpHgMxauh1nplAnUi+29O/QGaezHrdveIQbdyOp8XlhN+ZAgMBAAECgYAMbE8PCLg2lWnyTP6Po4UYAeAh8Ke+2AdqS35uJ+rdeKUU5d9sDDJLFqVUb9Sn55v7psc6rsc669xcOdLN6d74ZVwOZ2yI/6mk+oDsxt0nASNLW/DQm54WRgmmJnUEcUDO4JiCBY2bXkeZKhYK6VRxzoMewolsQ9Ae/uY7QiAQAQJBANBnnN8ruDsM6wtIUNfFhXZifviW5ggUi5xc0I8VRQAeNwhuynKEOUhf7o1Zk0RLHQ4DhzGvTcykVxXuii1sapkCQQCdf3Dyb99D1C9IZJ4MvDR4i/Wviozy5UwIxAtn0HOujXWByH07zQN94pXfTFnSykQLThnnjfEuZ5qi1/Jpgj0BAkAK86b2w2FnGQKxERfOfv7IfdyWS7fC7PF5QhdjrYZ2vx+9PbU911z7RK9Qlkh66keYmO7d2YyJGInLCUIRqQThAkBzJXtEJDpM8tJm0PkkQmzyPREwd9E4vB9swTe9fI827MEeU6ALmoWVAZWlHcMF807wHPefbQ0JakGKEOtv7AIBAkBpikI69QPsVB6YcH8AaJM8DGIHx32gDV0fquUykhpMa64cFWlr/907N5AEQZrxruziCZvwJpQM0AMOAuG05unV
-----END PRIVATE KEY-----
''';
    dynamic privateKey = RSAKeyParser().parse(private);

    final encrypter = Encrypter(RSA(privateKey: privateKey));

    return encrypter.decrypt(Encrypted.fromBase64(content)).toString();
  }
}
