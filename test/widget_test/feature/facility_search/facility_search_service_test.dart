import 'package:EMS/feature/facility_search/services/facility_service.dart';
import 'package:EMS/mock/consumption_mock_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FacilityService facilityService;

  setUp(() {
    facilityService = FacilityService();
  });

  group('FacilityService.findFacilityById', () {
    test('returns ConsumptionData when facility ID exists', () async {
      // arrange
      const String validFacilityId = '123456'; // <-- use ID from your mock data

      // act
      final result =
      await facilityService.findFacilityById(validFacilityId);

      // assert
      expect(result, isNotNull);
      expect(result, isA<ConsumptionData>());
      expect(result!.facilityId, equals(validFacilityId));
    });

    test('returns null when facility ID does not exist', () async {
      // arrange
      const String invalidFacilityId = 'ajflfl';

      // act
      final result =
      await facilityService.findFacilityById(invalidFacilityId);

      // assert
      expect(result, isNull);
    });
  });
}
