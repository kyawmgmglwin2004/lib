import '../../../mock/consumption_detail_mock_data.dart';
import '../../../mock/consumption_mock_data.dart';


class ConsumptionService {


  Future<ConsumptionData?> getByFacilityId(String facilityId) async {

    await Future.delayed(const Duration(seconds: 2));  // 本来の API 通信を想定した遅延（2秒待つ）

    final data = await getMockData();  // モックデータ（ダミーの API 応答データ）を取得

    print("======================================API");

    try {
      return data.firstWhere((item) => item.facilityId == facilityId); // モックデータから facilityId が一致するデータを検索

    } catch (e) {
      return null; // 該当データが存在しない場合は null を返す
    }
  }  // 施設IDを指定して消費データを取得する関数
} // API 呼び出し用サービスクラス