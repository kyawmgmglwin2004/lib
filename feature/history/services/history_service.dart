import '../../../mock/history_mock_data.dart';

class HistoryService {
  Future<List<PowerHistoryData>> getHourlyData () async {
    await Future.delayed(const Duration(seconds: 1));
    return getHourlyData();
  }

  Future<List<PowerHistoryData>> getDailyData() async {
    await Future.delayed(const Duration(seconds: 1));
    return getDailyData();
  }

  Future<List<PowerHistoryData>> getMonthlyData() async {
    await Future.delayed(const Duration(seconds: 1));
    return getMonthlyData();
  }
}