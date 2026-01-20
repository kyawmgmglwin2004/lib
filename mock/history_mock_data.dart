// class PowerHistoryData {
//   final String label;
//   final double generatedEnergy;
//   final double selfConsumption;
//   final double powerUsage;
//
//   PowerHistoryData({
//     required this.label,
//     required this.generatedEnergy,
//     required this.selfConsumption,
//     required this.powerUsage,
//   });
// }
//
//
// List<PowerHistoryData> getMockHistoryData() {
//   return [
//     PowerHistoryData(label: "10:00", generatedEnergy: 0.5, selfConsumption: 0.4, powerUsage: 0.6),
//     PowerHistoryData(label: "11:00", generatedEnergy: 0.8, selfConsumption: 0.6, powerUsage: 0.9),
//     PowerHistoryData(label: "12:00", generatedEnergy: 1.2, selfConsumption: 0.8, powerUsage: 1.1),
//     PowerHistoryData(label: "13:00", generatedEnergy: 1.5, selfConsumption: 1.0, powerUsage: 1.4),
//     PowerHistoryData(label: "14:00", generatedEnergy: 0.9, selfConsumption: 0.7, powerUsage: 1.0),
//     PowerHistoryData(label: "15:00", generatedEnergy: 0.6, selfConsumption: 0.5, powerUsage: 0.8),
//   ];
// }

// PowerHistoryData Model Class
class PowerHistoryData {
  final String label;
  final double generatedEnergy;
  final double selfConsumption;
  final double powerUsage;

  PowerHistoryData({
    required this.label,
    required this.generatedEnergy,
    required this.selfConsumption,
    required this.powerUsage,
  });

  @override
  String toString() {
    return 'PowerHistoryData{label: $label, generated: $generatedEnergy, self: $selfConsumption, usage: $powerUsage}';
  }
}

// Mock Data for Hourly View (12-18 time)
List<PowerHistoryData> getMockHourlyData() {
  return [
    PowerHistoryData(label: "12", generatedEnergy: 40.0, selfConsumption: 30.0, powerUsage: 70.0),
    PowerHistoryData(label: "13", generatedEnergy: 45.0, selfConsumption: 35.0, powerUsage: 80.0),
    PowerHistoryData(label: "14", generatedEnergy: 50.0, selfConsumption: 40.0, powerUsage: 90.0),
    PowerHistoryData(label: "15", generatedEnergy: 55.0, selfConsumption: 45.0, powerUsage: 100.0),
    PowerHistoryData(label: "16", generatedEnergy: 60.0, selfConsumption: 50.0, powerUsage: 110.0),
    PowerHistoryData(label: "17", generatedEnergy: 65.0, selfConsumption: 55.0, powerUsage: 120.0),
    PowerHistoryData(label: "18", generatedEnergy: 70.0, selfConsumption: 60.0, powerUsage: 130.0),
  ];
}

List<PowerHistoryData> getMockDailyData() {
  return List.generate(31, (index) {
    final day = index + 1;
    final baseValue = 100.0 + (day * 10.0);
    return PowerHistoryData(
      label: day.toString(),
      generatedEnergy: baseValue * 0.6,
      selfConsumption: baseValue * 0.4,
      powerUsage: baseValue,
    );
  });
}

List<PowerHistoryData> getMockMonthlyData() {
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  return List.generate(12, (index) {
    final monthName = months[index];
    final baseValue = 1000.0 + (index * 500.0);
    return PowerHistoryData(
      label: monthName,
      generatedEnergy: baseValue * 0.6,
      selfConsumption: baseValue * 0.45,
      powerUsage: baseValue,
    );
  });
}

class Facility {
  final String id;
  final String name;
  final String location;

  Facility({
    required this.id,
    required this.name,
    required this.location,
  });
}

List<Facility> getMockFacilities() {
  return [
    Facility(id: 'F001', name: 'Factory A', location: 'Yangon'),
    Facility(id: 'F002', name: 'Factory B', location: 'Mandalay'),
    Facility(id: 'F003', name: 'Warehouse C', location: 'Naypyidaw'),
    Facility(id: 'F004', name: 'Office Building D', location: 'Bago'),
    Facility(id: 'F005', name: 'Shopping Mall E', location: 'Mawlamyine'),
  ];
}
List<PowerHistoryData> getMockHistoryData() {
  return [
    PowerHistoryData(label: "10:00", generatedEnergy: 0.5, selfConsumption: 0.4, powerUsage: 0.6),
    PowerHistoryData(label: "11:00", generatedEnergy: 0.8, selfConsumption: 0.6, powerUsage: 0.9),
    PowerHistoryData(label: "12:00", generatedEnergy: 1.2, selfConsumption: 0.8, powerUsage: 1.1),
    PowerHistoryData(label: "13:00", generatedEnergy: 1.5, selfConsumption: 1.0, powerUsage: 1.4),
    PowerHistoryData(label: "14:00", generatedEnergy: 0.9, selfConsumption: 0.7, powerUsage: 1.0),
    PowerHistoryData(label: "15:00", generatedEnergy: 0.6, selfConsumption: 0.5, powerUsage: 0.8),
  ];
}