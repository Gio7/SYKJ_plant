part of 'diagnose_history_controller.dart';

class DiagnoseHistoryRepository {
  RxList<DiagnosisHistoryModel> dataList = <DiagnosisHistoryModel>[].obs;
  int pageNum = 1;
  RxBool isLoading = false.obs;
  bool isLastPage = false;

  int total = 0;
}
