import 'package:flutter/cupertino.dart';

import '../../../mock/history_mock_data.dart';
import '../pages/history_page.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier{
  final HistoryService  _historyService = HistoryService();

  List<PowerHistoryData> _currentData = [];
  DisplayType _selectedDisplayType = DisplayType.hourly;
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedMonth;

  bool _showCalendarPanel = false;
  int _startYear = DateTime.now().year;
  int _endYear = DateTime.now().year;
  int _startMonthForYear = DateTime.now().year;
  int? _endMonthForYear;

  int _selectedBarIndex = -1;

  List<PowerHistoryData> get currentData  => _currentData;
  DisplayType get selectedDisplayType  => _selectedDisplayType;
  DateTime get selectedDate => _selectedDate;
  DateTime? get selectedMonth => _selectedMonth;
  bool get showCalendarPanel => _showCalendarPanel;
  int get selectedBarIndex => _selectedBarIndex;
  int get startYear => _startYear;
  int get endYear => _endYear;
  int get startMonthForYear => _startMonthForYear;
  int? get endMonthForYear => _endMonthForYear;

  Future<void> init() async {
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    await loadData();
  }


  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }


  Future<void> loadData() async {
    switch (_selectedDisplayType) {
      case DisplayType.hourly:
        _currentData = await _historyService.getHourlyData();
        break;
      case DisplayType.daily:
        _currentData = await _historyService.getDailyData();
        break;
      case DisplayType.monthly:
        _currentData = await _historyService.getMonthlyData();
        break;
    }
    notifyListeners();
  }
  void setDisplayType (DisplayType type) {
    _selectedDisplayType = type;
    _selectedBarIndex = -1;
    loadData();
  }

  void setDate(DateTime date, DateTime focusedDay) {
    _selectedDate = date;
    notifyListeners();
  }

  void toggleCalendarPanel() {
    _showCalendarPanel = !_showCalendarPanel;
    notifyListeners();
  }

  void closeCalendarPanel() {
    _showCalendarPanel = false;
    notifyListeners();
  }
  void updateYearRang({int? startMonth, int? endMonth}) {
    if(startMonth != null) _startMonthForYear = startMonth;
    if(endMonth != null) _endMonthForYear = endMonth;
    notifyListeners();
  }


  void setStartYear(int year) {
    if (_startYear != year) {
      _startYear = year;
      notifyListeners();
    }
  }
  void setEndYear(int year) {
    if (_startYear != year) {
      _startYear = year;
      notifyListeners();
    }
  }

  void selectBar (int index) {
    _selectedBarIndex = index;
    notifyListeners();
  }

  double getMaxValue() {
    if (_currentData.isEmpty) return 50.0;
    double max = 0;
    for (var item in _currentData) {
      max = [max, item.generatedEnergy, item.selfConsumption, item.powerUsage]
          .reduce((a,b) => a > b ? a : b);
    }
    return max;
  }

}