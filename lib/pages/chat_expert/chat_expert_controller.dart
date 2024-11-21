import 'package:get/get.dart';
import 'package:plant/api/db_server.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/firebase_util.dart';

class ChatExpertController extends GetxController {
  RxList<Map<String, dynamic>> chatList = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    getChatList();
  }

  Future<void> getChatList() async {
    try {
      final res = await DbServer.getChatList();
      chatList.value = res.toList();
      if (chatList.isEmpty) {
        final Map<String, dynamic> map = {
          'isSelf': 0,
          'createTime': DateTime.now().millisecondsSinceEpoch,
          'content': 'assistantMessage'.tr,
          'id': 0,
        };
        chatList.add(map);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> insertChat(String content, bool isSelf) async {
    FireBaseUtil.logEvent(EventName.textSendBtn);
    try {
      final map = await DbServer.insertChatData(content, isSelf: isSelf);
      chatList.insert(0, map);
      if (isSelf) {
        plantPlantQuestion(content);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> insertEmptyChat() async {
    final Map<String, dynamic> map = {
      'isSelf': 0,
      'createTime': DateTime.now().millisecondsSinceEpoch,
      'content': '',
      'id': 0,
    };
    chatList.insert(0, map);
  }

  Future<void> plantPlantQuestion(String text) async {
    try {
      isLoading.value = true;
      insertEmptyChat();
      final data = await Request.plantPlantQuestion(text);
      chatList.removeAt(0);
      isLoading.value = false;
      insertChat(data, false);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
