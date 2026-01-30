import 'package:flutter/cupertino.dart';

import '../../../mock/history_mock_data.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {

  final HistoryService _historyService = HistoryService();  // 履歴データ取得用サービス

  List<PowerHistoryData> _currentData = []; // 現在の表示用データ（グラフに渡すデータ）

  DisplayType _selectedDisplayType = DisplayType.hourly;  // 表示タイプ（時間別/日別/月別）

  DateTime _selectedDate = DateTime.now();  // 時間別・月別などで参照する「選択日」

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month); // 日別表示などで参照する「選択月」

  bool _showCalendarPanel = false; // カレンダーパネルを表示するかどうか

  int _startYear = DateTime.now().year;  // 年範囲（開始年・終了年）
  int _endYear = DateTime.now().year;  // 年範囲（開始年・終了年）

  int _startMonthForYear = 1; // 年の中での月範囲（開始月・終了月）

  int? _endMonthForYear = DateTime.now().month;  // 終了月（現在月を初期値にする。将来的に null の可能性も考慮）

  DateTime _focusedDate = DateTime.now();  // カレンダーのフォーカス日（表示中の月をコントロールする用途）


  int _selectedBarIndex = -1;  // グラフで選択されたバーのインデックス（-1 は未選択）

  bool _isLoading = false;

  // Getter（外部から参照するため）
  List<PowerHistoryData> get currentData => _currentData;
  DisplayType get selectedDisplayType => _selectedDisplayType;
  DateTime get selectedDate => _selectedDate;

  // 選択月は null にならない設計でも、UI側で nullable にしておくと安全
  DateTime? get selectedMonth => _selectedMonth;

  bool get showCalendarPanel => _showCalendarPanel;
  int get selectedBarIndex => _selectedBarIndex;

  int get startYear => _startYear;
  int get endYear => _endYear;
  int get startMonthForYear => _startMonthForYear;
  int? get endMonthForYear => _endMonthForYear;
  DateTime? get focusedDate => _focusedDate;
  bool   get loading  =>_isLoading;

  Future<void> init() async {
    await loadData();
  }// 初期化処理


  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }



  DateTime get startYearMonth => DateTime(_startYear, _startMonthForYear, 1); // 年・月範囲の開始年月（例：2025/01/01）


  DateTime get endYearMonth =>
      DateTime(_endYear, (_endMonthForYear ?? _startMonthForYear), 1);  // 年・月範囲の終了年月（例：2025/12/01）
                                                                        // ※ endMonthForYear が null のときは startMonth を代用


  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  } // 選択月を更新（UIから呼ばれる）


  Future<void> loadData() async {

    if(_isLoading) return;

    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      switch (_selectedDisplayType) {

        case DisplayType.hourly:  // 時間別：選択日の時間別データを取得
          _currentData = await _historyService.getHourlyData(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          break;


        case DisplayType.daily:  // 日別：選択月の1ヶ月分の日別データを取得
          if (selectedMonth != null) {
            _currentData = await _historyService.getDailyData(
              selectedMonth!.year,
              selectedMonth!.month,
            );
          }
          break;


        case DisplayType.monthly: // 月別：年＋開始月〜終了月の範囲で月次データを取得
          _currentData = await _historyService.getMonthlyData(
            selectedDate.year,
            startMonthForYear,
            endMonthForYear!,
          );
          break;
      }
    } catch(e) {
      _setLoading(false);
    } finally {
      _setLoading(false);
    }

    notifyListeners();  // データ更新をUIへ通知

  } // 履歴ページのデータ取得  // ・表示タイプに応じて service の呼び出し先を切り替える



  void setDisplayType(DisplayType type) {
    _selectedDisplayType = type;
    _selectedBarIndex = -1; // バー選択を解除
    notifyListeners();
    loadData();  // 表示タイプ変更後にデータ再取得

  } // 表示タイプを変更（時間別/日別/月別）
  // ・選択バーをリセット
  // ・UI更新後、データを再読み込み


  void setDate(DateTime date, DateTime focused) {
    _selectedDate = date;
    _focusedDate = focused;
    notifyListeners();
  } // 選択日を更新（カレンダー選択時など）
    // focused も同時に更新（カレンダー表示位置を維持する）


  void setFocusedDate(DateTime focused) {
    _focusedDate = focused;
    notifyListeners();
  }  // カレンダーのフォーカス日だけ更新したい場合

  void toggleCalendarPanel() {
    _showCalendarPanel = !_showCalendarPanel;
    notifyListeners();
  }  // カレンダーパネルの表示/非表示を切り替える

  void closeCalendarPanel() {
    _showCalendarPanel = false;
    notifyListeners();
  }  // カレンダーパネルを閉じる


  void updateYearRang({int? startMonth, int? endMonth}) async {

    await Future.delayed(const Duration(microseconds: 200)); // UI連携のため、ごく短い遅延を入れている

    print("===================================$_endYear");


    if (startMonth != null) {
      _startMonthForYear = startMonth;
    }   // 開始月の更新


    if (endMonth != null) {
      int adjustedEnd = endMonth;


      if (_startMonthForYear >= adjustedEnd) {
        if (_startMonthForYear == 12) {
          adjustedEnd = 12;
        } else {
          adjustedEnd = 12; // ここは設計意図により変更可能
        }
      } // 開始月 >= 終了月 になっている場合は調整する
        // ※ 現状のロジックだと 12 に寄せている



      if (_endYear == DateTime.now().year && adjustedEnd > DateTime.now().month) {
        adjustedEnd = DateTime.now().month;
      } // 現在年の場合、終了月が現在月より未来にならないようにする

      _endMonthForYear = adjustedEnd;
    } else {

      _endMonthForYear = _startMonthForYear;  // 終了月が指定されていない場合は開始月と同じ月にする
    }  // 終了月の更新

    notifyListeners();
  } // 年内の月範囲（開始月/終了月）を更新
    // ・終了月が開始月より前にならないよう調整
    // ・現在年の場合、終了月が「現在月」を超えないよう制限

  void setStartYear(int year) {
    if (_startYear != year) {
      _startYear = year;
      _endYear = year; // 同一年に揃える
      notifyListeners();
    }
  } // 開始年を設定（開始年を変えたら終了年も同じにする）


  void setEndYear(int year) {
    if (_endYear != year) {
      _endYear = year;
      _startYear = year; // 同一年に揃える
      notifyListeners();
    }
  } // 終了年を設定（終了年を変えたら開始年も同じにする）


  void selectBar(int index) {
    _selectedBarIndex = index;
    notifyListeners();
  } // グラフのバー選択（タップされた棒の index を保持）


  double getMaxValue() {
    if (_currentData.isEmpty) return 50.0;

    double max = 0;
    for (var item in _currentData) {
      max = [
        max,
        item.generatedEnergy,
        item.selfConsumption,
        item.powerUsage,
      ].reduce((a, b) => a > b ? a : b);
    }
    return max;
  } // グラフのY軸の最大値を計算する
  // ・データが空ならデフォルト値（50.0）を返す
  // ・generatedEnergy / selfConsumption / powerUsage の最大値を探す


} // 履歴画面用の状態管理クラス（ChangeNotifier）
// ・表示タイプ（時間別/日別/月別）
// ・選択日/選択月
// ・グラフ表示データ
// ・カレンダーパネルの開閉
// ・年・月範囲
// ・選択中の棒グラフインデックス
// などを管理する
