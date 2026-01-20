import 'package:flutter/foundation.dart';
import '../../feature/consumption/controllers/consumption_controller.dart';
import '../../mock/consumption_mock_data.dart';

class ConsumptionProvider extends ChangeNotifier {
  final ConsumptionController controller;
  ConsumptionProvider({required this.controller});

  bool _loading = false;
  String? _error;
  ConsumptionData? _data;

  bool get loading => _loading;
  String? get error => _error;
  ConsumptionData? get data => _data;

  Future<void> load(String facilityId) async {
    _setLoading(true);
    _error = null;
    try {
      _data = await controller.loadConsumption(facilityId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh(String facilityId) async {
    try {
      _data = await controller.loadConsumption(facilityId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }


  void hydrate(ConsumptionData initialData) {
    _data = initialData;
    _error = null;
    _loading = false;
    notifyListeners();
  }


  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
