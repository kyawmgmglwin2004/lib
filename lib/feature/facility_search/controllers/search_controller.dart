import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/route/app_route.dart';
import '../../../mock/consumption_mock_data.dart';
import '../../consumption/models/consumption_args.dart';
import '../services/facility_service.dart';
import '../widgets/error_dialog.dart';

class FacilitySearchController extends ChangeNotifier {
  final TextEditingController facilityController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final FacilityService service = FacilityService();

  bool isLoading = false;

  Future<void> search(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    final id = facilityController.text;
    ConsumptionData? result = await service.findFacilityById(id);

    isLoading = false;
    notifyListeners();

    if (result == null) {
      showErrorDialog(context);
    } else {
      await storage.write(key: 'facilityId', value: id);
      Navigator.pushReplacementNamed(
        context,
        AppRoute.consumption,
          arguments: ConsumptionArgs(facilityId: id, data: result)
      );
    }
  }

  @override
  void dispose() {
    facilityController.dispose();
    super.dispose();
  }
}
