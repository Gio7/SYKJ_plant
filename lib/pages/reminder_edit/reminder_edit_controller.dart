import 'package:get/get.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/reminder_model.dart';

part 'reminder_edit_repository.dart';

class ReminderEditController extends GetxController {
  final ReminderEditRepository repository = ReminderEditRepository();

  void didSelectRemindType(Map<String, dynamic> remindType) {
    if (repository.currentRemindType == {}) {
print('object');
    } else {
      print('object11');
    }
    repository.currentRemindType.value = remindType;
    print(repository.currentRemindType);
  }
}
