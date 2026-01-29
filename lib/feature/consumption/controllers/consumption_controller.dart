import 'package:flutter/foundation.dart';

import '../../../mock/consumption_mock_data.dart';
import '../services/consumption_service.dart';

// UI の状態管理（State Management）を行う Provider

class ConsumptionProvider extends ChangeNotifier {

  final ConsumptionService service;  // データ取得処理（API/モック）を担当する Service


  ConsumptionProvider({required this.service});  // コンストラクタ：service を注入（DI: Dependency Injection）


  bool _loading = false; // ローディング中かどうか（true: 読み込み中）


  String? _error; // エラーメッセージ（エラーがない場合は null）


  ConsumptionData? _data; // 取得した消費データ（未取得の場合は null）


  bool get loading => _loading;  // 外部から参照するための getter（読み取り専用）
  String? get error => _error;  // 外部から参照するための getter（読み取り専用）
  ConsumptionData? get data => _data;  // 外部から参照するための getter（読み取り専用）


  Future<void> load(String facilityId) async {
    // ローディング開始
    _setLoading(true);

    // 直前のエラーをクリア
    _error = null;

    try {
      // Service を通してデータ取得
      _data = await service.getByFacilityId(facilityId);
    } catch (e) {
      // 例外発生時はエラーメッセージを保持
      _error = e.toString();
    } finally {
      // 成功・失敗に関わらずローディング終了
      _setLoading(false);
    }
  }  // 施設IDを指定してデータを取得する（初回ロード想定）

  Future<void> refresh(String facilityId) async {

    _setLoading(true);  // ローディング開始

    _error = null;  // 直前のエラーをクリア

    try {

      _data = await service.getByFacilityId(facilityId); // Service を通してデータ再取得

    } catch (e) {

      _error = e.toString(); // 例外発生時はエラーメッセージを保持

    } finally {

      _setLoading(false); // 成功・失敗に関わらずローディング終了
    }
  } // データを再取得する（リフレッシュ用）

  void hydrate(ConsumptionData initialData) {
    _data = initialData; // 初期データを設定
    _error = null;       // エラーをクリア
    _loading = false;    // ローディング状態を解除
    notifyListeners();   // UI 更新通知
  } // すでに取得済みのデータを Provider に注入して初期化する（画面遷移などで利用）

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners(); // 状態変化を通知して UI を再描画させる
  }  // ローディング状態を更新し、UI に反映させる内部関数
} // ChangeNotifier を継承し、状態変化時に notifyListeners() で UI を更新する