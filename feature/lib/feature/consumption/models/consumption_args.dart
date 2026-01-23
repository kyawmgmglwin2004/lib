import '../../../mock/consumption_mock_data.dart';

class ConsumptionArgs {
  final String facilityId;
  final ConsumptionData? data;

  const ConsumptionArgs({
    required this.facilityId,
    this.data,
  });
}
