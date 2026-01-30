import 'package:EMS/mock/consumption_mock_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConsumptionData Model Test', () {
    late ConsumptionData mockData;

    setUp(() {
      mockData = ConsumptionData(
        facilityId: 'FAC_001',
        facilityName: 'Solar Plant A',
        cityInfo: 'Yangon',
        measurementTimePeriod: '2024-01',
        cumulativePowerGeneration: 1000,
        currentPowerGeneration: 12.34567,
        currentSelfConsumption: 5.4321,
        currentPowerUsage: 6.789,
        todayTotalGeneration: 50.123,
        todayTotalSelfConsumption: 20.456,
        todayTotalPowerUsage: 29.667,
        imagePath: 'assets/images/solar.png',
      );
    });

    test('Constructor assigns values correctly', () {
      expect(mockData.facilityId, 'FAC_001');
      expect(mockData.facilityName, 'Solar Plant A');
      expect(mockData.cityInfo, 'Yangon');
      expect(mockData.cumulativePowerGeneration, 1000);
    });

    test('formatValue returns value with 3 decimal places', () {
      final formatted = mockData.formatValue(12.34567);
      expect(formatted, '12.346');
    });

    test('fromJson creates ConsumptionData correctly', () {
      final json = {
        'facilityId': 'FAC_002',
        'facilityName': 'Solar Plant B',
        'cityInfo': 'Mandalay',
        'measurementTimePeriod': '2024-02',
        'cumulativePowerGeneration': 2000,
        'currentPowerGeneration': 10.123,
        'currentSelfConsumption': 4.321,
        'currentPowerUsage': 5.802,
        'todayTotalGeneration': 40.5,
        'todayTotalSelfConsumption': 18.2,
        'todayTotalPowerUsage': 22.3,
        'imagePath': 'assets/images/solar_b.png',
      };

      final data = ConsumptionData.fromJson(json);

      expect(data.facilityId, 'FAC_002');
      expect(data.facilityName, 'Solar Plant B');
      expect(data.cityInfo, 'Mandalay');
      expect(data.cumulativePowerGeneration, 2000);
    });

    test('toJson converts ConsumptionData to json correctly', () {
      final json = mockData.toJson();

      expect(json['facilityId'], 'FAC_001');
      expect(json['facilityName'], 'Solar Plant A');
      expect(json['cityInfo'], 'Yangon');
      expect(json['cumulativePowerGeneration'], 1000);
    });

    test('toJson and fromJson work together correctly', () {
      final json = mockData.toJson();
      final dataFromJson = ConsumptionData.fromJson(json);

      expect(dataFromJson.facilityId, mockData.facilityId);
      expect(dataFromJson.todayTotalPowerUsage,
          mockData.todayTotalPowerUsage);
    });
  });
}
