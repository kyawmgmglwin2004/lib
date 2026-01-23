import 'package:flutter/material.dart';

class ConsumptionData {
  final String facilityId;
  final String facilityName;
  final String cityInfo;
  final String measurementTimePeriod;
  final int cumulativePowerGeneration;
  final double currentPowerGeneration;
  final double currentSelfConsumption;
  final double currentPowerUsage;
  final double todayTotalGeneration;
  final double todayTotalSelfConsumption;
  final double todayTotalPowerUsage;
  final String imagePath;

  ConsumptionData({
    required this.facilityId,
    required this.facilityName,
    required this.cityInfo,
    required this.measurementTimePeriod,
    required this.cumulativePowerGeneration,
    required this.currentPowerGeneration,
    required this.currentSelfConsumption,
    required this.currentPowerUsage,
    required this.todayTotalGeneration,
    required this.todayTotalSelfConsumption,
    required this.todayTotalPowerUsage,
    required this.imagePath
});

  String formatValue(double value) {
    return value.toStringAsFixed(3);
  }

  factory ConsumptionData.fromJson(Map<String, dynamic> json) {
    return ConsumptionData(
        facilityId: json['facilityId'],
        facilityName: json['facilityName'],
        cityInfo: json['cityInfo'],
        measurementTimePeriod: json['measurementTimePeriod'],
        cumulativePowerGeneration: (json['cumulativePowerGeneration'] as num).toInt(),
        currentPowerGeneration: json['currentPowerGeneration'],
        currentSelfConsumption: json['currentSelfConsumption'],
        currentPowerUsage: json['currentPowerUsage'],
        todayTotalGeneration: json['todayTotalGeneration'],
        todayTotalSelfConsumption: json['todayTotalSelfConsumption'],
        todayTotalPowerUsage: json['todayTotalPowerUsage'],
        imagePath: json['imagePath']
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'facilityId': facilityId,
      'facilityName': facilityName,
      'cityInfo': cityInfo,
      'measurementTimePeriod': measurementTimePeriod,
      'cumulativePowerGeneration': cumulativePowerGeneration,
      'currentPowerGeneration': currentPowerGeneration,
      'currentSelfConsumption': currentSelfConsumption,
      'currentPowerUsage': currentPowerUsage,
      'todayTotalGeneration': todayTotalGeneration,
      'todayTotalSelfConsumption': todayTotalSelfConsumption,
      'todayTotalPowerUsage': todayTotalPowerUsage,
      'imagePath' : imagePath,
    };
  }

// Future<FacilitySearch?> fetchFacility(String id) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   try {
  //     return mockFacilities.firstWhere((f) => f.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }


}