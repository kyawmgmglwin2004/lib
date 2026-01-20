import '../../../mock/consumption_detail_mock_data.dart';
import '../../../mock/consumption_mock_data.dart';

class FacilityService {
  Future<ConsumptionData?> findFacilityById(String id) async {
    await Future.delayed(const Duration(seconds: 2));
    final List<ConsumptionData> data = getMockData();

    try {
      return data.firstWhere((item) => item.facilityId == id);
    } catch (e) {
      return null;
    }
  }
}
