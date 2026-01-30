import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/route/app_route.dart';
import '../../../mock/consumption_mock_data.dart';
import '../../consumption/models/consumption_args.dart';
import '../services/facility_service.dart';
import '../widgets/error_dialog.dart';

class FacilitySearchController extends ChangeNotifier {
  // final TextEditingController facilityController = TextEditingController();
  final TextEditingController facilityController ;
  // final FlutterSecureStorage storage = FlutterSecureStorage();
  final FlutterSecureStorage storage ;
  // final FacilityService service = FacilityService();
  final FacilityService service ;

  bool isLoading = false; //状態をロードするため

  FacilitySearchController({
    TextEditingController? facilityController,
    FlutterSecureStorage? storage,
    FacilityService? service,
}) :
        facilityController = facilityController ?? TextEditingController(),
        storage = storage ?? const FlutterSecureStorage(),
        service = service ?? FacilityService();


  Future<void> search(BuildContext context) async {
    final facilityId = facilityController.text;
    if(facilityId.length == 0) {
      showErrorDialog(context);
      return;
    }
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    ConsumptionData? result = await service.findFacilityById(facilityId);

    isLoading = false;
    notifyListeners();

    if (result == null) {

      showErrorDialog(context); // facilityIdが見つからない場合のエラーダイアログ
    } else {
      await storage.write(key: 'facilityId', value: facilityId);
      Navigator.pushReplacementNamed(
        context,
        AppRoute.consumption,
        arguments: ConsumptionArgs(facilityId: facilityId, data: result),
      );
    }
  }  // facilityId を含む検索データの場合

  @override
  void dispose() {
    facilityController.dispose();
    super.dispose();
  } //メモリリークを防ぐため

} //UI状態管理用
