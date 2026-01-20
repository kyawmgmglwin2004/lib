import '../../../mock/consumption_detail_mock_data.dart';
import '../../../mock/consumption_mock_data.dart';

class ConsumptionService {
  Future<ConsumptionData?> getByFacilityId(String facilityId) async {
    await Future.delayed(const Duration(seconds: 2));
    final data = await getMockData();
    print("======================================API");

    try {
      return data.firstWhere((item) => item.facilityId == facilityId);
    } catch (e) {
      return null;
    }
  }
}
