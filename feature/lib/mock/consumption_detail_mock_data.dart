import 'consumption_mock_data.dart';

List<ConsumptionData> getMockData() {
  return [
    ConsumptionData(
      facilityId: "123123",
      facilityName: "Tokyo Main Office",
      cityInfo: "Shinjuku-ku, Tokyo",
      measurementTimePeriod: "2026/01/08 14:00~15:00",
      cumulativePowerGeneration: 12540,
      currentPowerGeneration: 0.456,
      currentSelfConsumption: 1.45,
      currentPowerUsage: 2.4,
      todayTotalGeneration: 0.789,
      todayTotalSelfConsumption: 1.78,
      todayTotalPowerUsage: 2.7,
      imagePath: "assets/images/image.png",
    ),
    ConsumptionData(
      facilityId: "112233",
      facilityName: "Osaka Branch",
      cityInfo: "Chuo-ku, Osaka",
      measurementTimePeriod: "2026/01/08 14:00~15:00",
      cumulativePowerGeneration: 8430,
      currentPowerGeneration: 1.200,
      currentSelfConsumption: 0.950,
      currentPowerUsage: 1.500,
      todayTotalGeneration: 5.430,
      todayTotalSelfConsumption: 4.100,
      todayTotalPowerUsage: 6.200,
      imagePath: "assets/images/image (1).png"
    ),
    ConsumptionData(
      facilityId: "123456",
      facilityName: "Fukuoka Logistics Center",
      cityInfo: "Hakata-ku, Fukuoka",
      measurementTimePeriod: "2026/01/08 13:00~14:00",
      cumulativePowerGeneration: 45210,
      currentPowerGeneration: 3.500,
      currentSelfConsumption: 2.100,
      currentPowerUsage: 5.600,
      todayTotalGeneration: 15.234,
      todayTotalSelfConsumption: 12.560,
      todayTotalPowerUsage: 18.900,
        imagePath: "assets/images/image (5).png"
    ),
    ConsumptionData(
        facilityId: "111111",
        facilityName: "Fukuoka Logistics Center",
        cityInfo: "Hakata-ku, Fukuoka",
        measurementTimePeriod: "2026/01/08 13:00~14:00",
        cumulativePowerGeneration: 45210,
        currentPowerGeneration: 3.500,
        currentSelfConsumption: 2.100,
        currentPowerUsage: 5.600,
        todayTotalGeneration: 15.234,
        todayTotalSelfConsumption: 12.560,
        todayTotalPowerUsage: 18.900,
        imagePath: "assets/images/image (7).png"
    ),
    ConsumptionData(
        facilityId: "222222",
        facilityName: "Fukuoka Logistics Center",
        cityInfo: "Hakata-ku, Fukuoka",
        measurementTimePeriod: "2026/01/08 13:00~14:00",
        cumulativePowerGeneration: 45210,
        currentPowerGeneration: 3.500,
        currentSelfConsumption: 2.100,
        currentPowerUsage: 5.600,
        todayTotalGeneration: 15.234,
        todayTotalSelfConsumption: 12.560,
        todayTotalPowerUsage: 18.900,
        imagePath: "assets/images/image (6).png"
    ),
  ];
}