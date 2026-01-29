import '../../../mock/consumption_detail_mock_data.dart';
import '../../../mock/consumption_mock_data.dart';

class FacilityService {
  Future<ConsumptionData?> findFacilityById(String id) async {
    await Future.delayed(const Duration(seconds: 2)); // 本来は API の待ち時間を想定したディレイ
    print("Calllllll========================================================================================search api");
    final List<ConsumptionData> data = getMockData();   // モックデータ（ダミーデータ）を取得

    try {
      return data.firstWhere((item) => item.facilityId == id);  // facilityId が一致する最初のデータを返す
    } catch (e) {
      return null;  // 該当データが見つからなかった場合 → null を返す
    }

    // try {
    //   if(data.statusCode == 200) {
    //     return data.firstWhere((item) => item.facilityId == id);
    //
    //   }else if ( data.statusCode == 404) { //
    //     not found aleert()
    //   } else {
    //     server error alert()
    //   }
    // } catch (e) {
    //   server time error ();
    //   return null;
    // }
  }
} // 施設IDで検索する関数
