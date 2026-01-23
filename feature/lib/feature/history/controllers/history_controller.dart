// import 'package:flutter/cupertino.dart';
//
// import '../../../mock/history_mock_data.dart';
// import '../services/history_service.dart';
//
// class HistoryProvider extends ChangeNotifier{
//   final HistoryService  _historyService = HistoryService();
//
//   List<PowerHistoryData> _currentData = [];
//   DisplayType _selectedDisplayType = DisplayType.hourly;
//   DateTime _selectedDate = DateTime.now();
//   DateTime? _selectedMonth;
//
//   bool _showCalendarPanel = false;
//   int _startYear = DateTime.now().year;
//   int _endYear = DateTime.now().year;
//   int _startMonthForYear = DateTime.now().month;
//   int? _endMonthForYear = DateTime.now().month;
//
//   int _selectedBarIndex = -1;
//
//   List<PowerHistoryData> get currentData  => _currentData;
//   DisplayType get selectedDisplayType  => _selectedDisplayType;
//   DateTime get selectedDate => _selectedDate;
//   DateTime? get selectedMonth => _selectedMonth;
//   bool get showCalendarPanel => _showCalendarPanel;
//   int get selectedBarIndex => _selectedBarIndex;
//   int get startYear => _startYear;
//   int get endYear => _endYear;
//   int get startMonthForYear => _startMonthForYear;
//   int? get endMonthForYear => _endMonthForYear;
//
//   Future<void> init() async {
//     _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
//     await loadData();
//   }
//
//
//   void setSelectedMonth(DateTime month) {
//     _selectedMonth = month;
//     notifyListeners();
//   }
//
//
//   Future<void> loadData() async {
//     switch (_selectedDisplayType) {
//       case DisplayType.hourly:
//         _currentData = await _historyService.getHourlyData(
//           selectedDate.year,
//           selectedDate.month,
//           selectedDate.day,
//         );
//         break;
//
//       case DisplayType.daily:
//         if (selectedMonth != null) {
//           _currentData = await _historyService.getDailyData(
//             selectedMonth!.year,
//             selectedMonth!.month,
//           );
//         }
//         break;
//
//       case DisplayType.monthly:
//         _currentData = await _historyService.getMonthlyData(selectedDate.year);
//         break;
//     }
//     notifyListeners();
//   }
//
//   void setDisplayType (DisplayType type) {
//     print('=============================================$type');
//     _selectedDisplayType = type;
//     _selectedBarIndex = -1;
//     notifyListeners();
//     loadData();
//   }
//
//   void setDate(DateTime date, DateTime focusedDay) {
//     print("==================selectDay $selectedDate");
//     _selectedDate = date;
//     notifyListeners();
//   }
//
//   void toggleCalendarPanel() {
//     _showCalendarPanel = !_showCalendarPanel;
//     notifyListeners();
//   }
//
//   void closeCalendarPanel() {
//     _showCalendarPanel = false;
//     notifyListeners();
//   }
//   // void updateYearRang({int? startMonth, int? endMonth}) {
//   //   if(startMonth != null && endMonth != null) {
//   //     if(_startMonthForYear > endMonth){
//   //       if(_startMonthForYear == 12) {
//   //         _startMonthForYear = startMonth;
//   //         _endMonthForYear = 12;
//   //       }
//   //       _startMonthForYear = startMonth;
//   //       _endMonthForYear = startMonth + 1;
//   //     }
//   //   };
//   //   if(endMonth != null) _endMonthForYear = endMonth;
//   //   notifyListeners();
//   // }
//
//   void updateYearRang({int? startMonth, int? endMonth}) {
//     print("=========================================$endYear");
//     print("=========================================${DateTime.now().year}");
//
//     if (startMonth != null) {
//       _startMonthForYear = startMonth;
//     }
//
//     if (endMonth != null) {
//
//       if (_startMonthForYear >= endMonth) {
//         if (_startMonthForYear == 12) {
//           _endMonthForYear = 12;
//         } else {
//           _endMonthForYear = _startMonthForYear + 1;
//         }
//       } else {
//
//         if (endMonth > DateTime.now().month && endYear == DateTime.now().year) {
//           _endMonthForYear = DateTime.now().month;
//         } else {
//           _endMonthForYear = endMonth;
//         }
//       }
//     } else {
//
//       _endMonthForYear = _startMonthForYear;
//     }
//
//     notifyListeners();
//   }
//
//
//
//   void setStartYear(int year) {
//     if (_startYear != year) {
//       _startYear = year;
//       _endYear = year;
//       notifyListeners();
//     }
//   }
//   void setEndYear(int year) {
//     if (_startYear != year) {
//       _endYear = year;
//       _startYear = year;
//       notifyListeners();
//     }
//   }
//
//   void selectBar (int index) {
//     _selectedBarIndex = index;
//     notifyListeners();
//   }
//
//   double getMaxValue() {
//     if (_currentData.isEmpty) return 50.0;
//     double max = 0;
//     for (var item in _currentData) {
//       max = [max, item.generatedEnergy, item.selfConsumption, item.powerUsage]
//           .reduce((a,b) => a > b ? a : b);
//     }
//     return max;
//   }
//
// }

import 'package:flutter/cupertino.dart';

import '../../../mock/history_mock_data.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<PowerHistoryData> _currentData = [];
  DisplayType _selectedDisplayType = DisplayType.hourly;
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedMonth;

  bool _showCalendarPanel = false;
  int _startYear = DateTime.now().year;
  int _endYear = DateTime.now().year;
  int _startMonthForYear = DateTime.now().month;
  int? _endMonthForYear = DateTime.now().month;

  int _selectedBarIndex = -1;

  // Getters
  List<PowerHistoryData> get currentData => _currentData;
  DisplayType get selectedDisplayType => _selectedDisplayType;
  DateTime get selectedDate => _selectedDate;
  DateTime? get selectedMonth => _selectedMonth;
  bool get showCalendarPanel => _showCalendarPanel;
  int get selectedBarIndex => _selectedBarIndex;
  int get startYear => _startYear;
  int get endYear => _endYear;
  int get startMonthForYear => _startMonthForYear;
  int? get endMonthForYear => _endMonthForYear;

  // Init
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
        _currentData = await _historyService.getHourlyData(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        break;

      case DisplayType.daily:
        if (selectedMonth != null) {
          _currentData = await _historyService.getDailyData(
            selectedMonth!.year,
            selectedMonth!.month,
          );
        }
        break;

      case DisplayType.monthly:
        _currentData = await _historyService.getMonthlyData(selectedDate.year, startMonthForYear, endMonthForYear!);
        break;
    }
    notifyListeners();
  }

  void setDisplayType(DisplayType type) {
    _selectedDisplayType = type;
    _selectedBarIndex = -1;
    notifyListeners();
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


  void updateYearRang({int? startMonth, int? endMonth}) async {
    await Future.delayed(const Duration(microseconds: 200));

    print("===================================$_endYear");

    if (startMonth != null) {
      _startMonthForYear = startMonth;
    }

    if (endMonth != null) {
      int adjustedEnd = endMonth;


      if (_startMonthForYear >= adjustedEnd) {
        if (_startMonthForYear == 12) {
          adjustedEnd = 12;
        } else {
          adjustedEnd = 12;
        }
      }


      if (_endYear == DateTime.now().year && adjustedEnd > DateTime.now().month) {
        adjustedEnd = DateTime.now().month;
      }

      _endMonthForYear = adjustedEnd;
    } else {

      _endMonthForYear = _startMonthForYear;
    }

    notifyListeners();
  }

  void setStartYear(int year) {
    if (_startYear != year) {
      _startYear = year;
      _endYear = year;
      notifyListeners();
    }
  }

  void setEndYear(int year)  {
    if (_endYear != year) {
      _endYear = year;
      _startYear = year;
      notifyListeners();
    }
  }

  void selectBar(int index) {
    _selectedBarIndex = index;
    notifyListeners();
  }

  double getMaxValue() {
    if (_currentData.isEmpty) return 50.0;
    double max = 0;
    for (var item in _currentData) {
      max = [max, item.generatedEnergy, item.selfConsumption, item.powerUsage]
          .reduce((a, b) => a > b ? a : b);
    }
    return max;
  }
}
