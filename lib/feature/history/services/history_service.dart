import '../../../mock/history_mock_data.dart';

class HistoryService {

  Future<List<PowerHistoryData>> getHourlyData(
      int year,
      int month,
      int day,
      ) async {
    await Future.delayed(const Duration(seconds: 1));  // API 通信を想定した 1 秒の遅延

    print("reach=================================${PowerHistoryData}");

    return getMockHourlyData(year, month, day);  // モックデータから時間別データを取得して返す
  } // 履歴ページの「時間別」データを取得する関数



  Future<List<PowerHistoryData>> getDailyData(int year, int month) async {

    await Future.delayed(const Duration(seconds: 1));  // API 通信を想定した遅延


    return getMockDailyData(year, month);  // モックデータから日別データを取得して返す
  }    // 履歴ページの「日別」データを取得する関数

  Future<List<PowerHistoryData>> getMonthlyData(
      int year,
      int startMonth,
      int endMonth,
      ) async {

    await Future.delayed(const Duration(seconds: 1)); // API 通信を想定した遅延

    return getMockMonthlyData(year, startMonth, endMonth);  // モックデータから月別データを取得して返す
  } // 履歴ページの「月別」データを取得する関数
}