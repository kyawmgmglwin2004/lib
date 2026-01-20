import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solar_meter_flutter/feature/history/widgets/custom_month_box.dart';
import 'package:solar_meter_flutter/feature/history/widgets/month_picker.dart';
import 'package:solar_meter_flutter/feature/history/widgets/year_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/route/app_route.dart';
import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';
import '../widgets/calendar_panel.dart';

enum DisplayType { hourly, daily, monthly }

class HistoryPage extends StatefulWidget {
  final String facilityName;
  final String facilityId;
  final List<PowerHistoryData> initialHourlyData;
  final List<PowerHistoryData> initialDailyData;
  final List<PowerHistoryData> initialMonthlyData;

  const HistoryPage({
    super.key,
    required this.facilityName,
    required this.facilityId,
    required this.initialHourlyData,
    required this.initialDailyData,
    required this.initialMonthlyData,
  });


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<PowerHistoryData> _currentData;
  DisplayType _selectedDisplayType = DisplayType.hourly;
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedMonth;
  DateTime? _startMonth;
  DateTime? _endMonth;
  int _selectedBarIndex = -1;
  bool _showTooltip = false;
  bool _showCalendarPanel = false;
  String _facilityId = "";
  int _selectedYear = DateTime.now().year;
  int _startMonthForyear = DateTime.now().month;
  int? _endMonthForYear ;
  bool _showYearMonthPicker = false;
  int? _startYear;
  int? _endYear;





  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');
  final DateFormat _monthFormat = DateFormat('yyyy/MM');


  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> showyearPicker(BuildContext context) async {
    // Create temporary variables for the dialog state
    int tempYear = _startYear ?? DateTime.now().year;
    int tempMonth = _startMonthForyear;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Year Dropdown
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_left),
                              onPressed: () {
                                setState(() {
                                  _selectedYear--;
                                });
                              },
                            ),
                            DropdownButton<int>(
                              value: tempYear,
                              items: List.generate(10, (index) {
                                final year = DateTime.now().year - 7 + index;
                                return DropdownMenuItem(value: year, child: Text('$year'));
                              }),
                              onChanged: (value) {
                                setDialogState(() {
                                  tempYear = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Text("年", style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        // Month Dropdown
                        Row(
                          children: [

                            DropdownButton<int>(
                              value: tempMonth,
                              items: List.generate(1, (index) {
                                final month = index + 1;
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text('$month'),
                                );
                              }),
                              onChanged: (value) {
                                setDialogState(() {
                                  tempMonth = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Text("月", style: TextStyle(color: Colors.grey[700])),
                            IconButton(
                              icon: const Icon(Icons.arrow_right),
                              onPressed: () {
                                setState(() {
                                  _selectedYear++;
                                });
                              },
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> showEndYearPicker(BuildContext context) async {
    // Handle nulls safely
    int tempYear = _endYear ?? DateTime.now().year;
    int tempMonth = _endMonthForYear ?? 12;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Year Dropdown
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: tempYear,
                              items: List.generate(10, (index) {
                                final year = DateTime.now().year - 7 + index;
                                return DropdownMenuItem(value: year, child: Text('$year'));
                              }),
                              onChanged: (value) {
                                setDialogState(() {
                                  tempYear = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Text("年", style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        // Month Dropdown
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: tempMonth,
                              // FIX: Generate 12 months instead of 1
                              items: List.generate(12, (index) {
                                final month = index + 1;
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text('$month'),
                                );
                              }),
                              onChanged: (value) {
                                setDialogState(() {
                                  tempMonth = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Text("月", style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _endYear = tempYear;
                          _endMonthForYear = tempMonth;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> getFacilityId() async {
    try {
      String? id = await storage.read(key: 'facilityId');
      print("========================================= $id");

      if (id != null && id.isNotEmpty) {
        setState(() {
          _facilityId = id;
        });
        print('FacilitySearch ID found: $id');
      } else {
        setState(() {
          _facilityId = widget.facilityId;
        });
        print('Using widget facility ID: ${widget.facilityId}');
      }
    } catch (e) {
      print('Error reading facilityId: $e');
      setState(() {
        _facilityId = widget.facilityId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFacilityId();
    _currentData = widget.initialHourlyData;
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _startMonth = DateTime(DateTime.now().year, 1);
    _endMonth = DateTime(DateTime.now().year, 12);

    _startYear = DateTime.now().year;
    _endYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    return Scaffold(

      body: Stack(
        children: [
          SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("施設名_電力量履歴",
                      style:TextStyle(
                          color: Colors.blue[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),),
                    Text("電力量履歴",
                      style: TextStyle(
                          color: Colors.blue[500]
                      ),)
                  ],
                ),
                _buildDisplayTypeSection(),

                _buildDateSelectionSection(),


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildGraphArea(),
                  ),
                ),

                _buildLegend(),

              ],
            ),
          ),
        ),
          if (provider.showCalendarPanel)
            Center(
              child: CalendarPanel(),
            ),
    ]
      ),
    );
  }

  Widget _buildDisplayTypeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item #2: Display type label
          Text(
            '表示種別',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              _buildDisplayTypeRadio(
                type: DisplayType.hourly,
                label: '時間帯別',
              ),
              const SizedBox(width: 5 ),


              _buildDisplayTypeRadio(
                type: DisplayType.daily,
                label: '日別',
              ),
              const SizedBox(width: 12),


              _buildDisplayTypeRadio(
                type: DisplayType.monthly,
                label: '月別',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayTypeRadio({
    required DisplayType type,
    required String label,

  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDisplayType = type;
          _selectedBarIndex = -1;
          _showTooltip = false;
          switch (type) {
            case DisplayType.hourly:
              _currentData = widget.initialHourlyData;
              break;
            case DisplayType.daily:
              _currentData = widget.initialDailyData;
              break;
            case DisplayType.monthly:
              _currentData = widget.initialMonthlyData;
              break;
          }
        });
      },
      child: Container(
        height: 30,
        width: 110,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedDisplayType == type ? Color(0xFF6D4C41) : Colors.grey[300]!,
            width: _selectedDisplayType == type ? 2 : 1,
          ),
          color: _selectedDisplayType == type ? Colors.white : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedDisplayType == type ? Color(0xFF6D4C41) : Colors.grey,
                  width: 2,
                ),
                color: _selectedDisplayType == type ? Colors.white : Colors.white,
              ),
              child: _selectedDisplayType == type
                  ? const Icon(Icons.circle, size: 8, color:  Color(0xFF6D4C41))
                  : null,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: _selectedDisplayType == type
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _selectedDisplayType == type ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection() {
    if (_selectedDisplayType == DisplayType.hourly) {
      return _buildHourlyDateSelection();
    } else if (_selectedDisplayType == DisplayType.daily) {
      return MonthPickerRow();
    } else {
      return YearPickerRow();
    }
  }

  Widget _buildHourlyDateSelection() {
    final provider = context.watch<HistoryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '日付選択',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 9),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.calendar_month,
                        size: 28, color: Colors.brown[600]),
                    onPressed: () {
                      provider.toggleCalendarPanel();
                    },
                  ),
                  Text(
                    _dateFormat.format(provider.selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedBarIndex = -1;
                  _showTooltip = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("検索", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildMonthlyRangeSelection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Column(
  //               children: [
  //                 Text("開始日", style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16
  //                 ),),
  //                 Container(
  //                   height: 40,
  //                   padding: EdgeInsets.only(right: 20,),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.grey!, width: 2),
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                   child: Row(
  //                       children: [ IconButton(
  //                         icon: const Icon(Icons.calendar_month, size: 20),
  //                         onPressed: () {
  //                           setState(() {
  //                             showyearPicker(context);
  //                           });
  //                         },
  //                       ),
  //                         Text(
  //                           _startYear != null && _startMonthForyear != null
  //                               ? '$_startYear/$_startMonthForyear'
  //                               : '${DateTime.now().year}/1',
  //                           style: const TextStyle(fontSize: 14),
  //                         ),
  //
  //                       ]
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Column(
  //               children: [
  //                 Text("開始日", style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16
  //                 ),),
  //                 Container(
  //                   height: 40,
  //                   padding: EdgeInsets.only(right: 20,),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.grey!, width: 2),
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                   child: Row(
  //                       children: [ IconButton(
  //                         icon: const Icon(Icons.calendar_month, size: 20),
  //                         onPressed: () {
  //                           showEndYearPicker(context);
  //                         },
  //                       ),
  //                         Text(
  //                           _endYear != null && _endMonthForYear != null
  //                               ? '$_endYear/$_endMonthForYear'
  //                               : '${DateTime.now().year}/12',
  //                           style: const TextStyle(fontSize: 14),
  //                         ),
  //
  //                       ]
  //                   ),
  //                 ),
  //
  //               ],
  //             ),
  //
  //           ],
  //         ),
  //         Column(
  //           children: [
  //             SizedBox(height: 20,),
  //             ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   foregroundColor: Colors.white,
  //                   backgroundColor: Colors.brown[600],
  //                   padding: const EdgeInsets.symmetric(
  //                     // vertical: 1,
  //                     horizontal: 30,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   setState(() {
  //                     _showYearMonthPicker = !_showYearMonthPicker;
  //                     _selectedBarIndex = -1;
  //                     _showTooltip = false;
  //                   });
  //                 },
  //                 child: Text("検索",
  //                   style: TextStyle(
  //                       fontSize: 14
  //                   ),
  //                 )),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget buildYearMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [


        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () {
            setState(() {
              _selectedYear--;
            });
          },
        ),

        /// Year Dropdown
        DropdownButton<int>(
          value: _selectedYear,
          items: List.generate(20, (index) {
            final year = DateTime.now().year - 10 + index;
            return DropdownMenuItem(
              value: year,
              child: Text('$year 年'),
            );
          }),
          onChanged: (value) {
            setState(() {
              _selectedYear = value!;
            });
          },
        ),

        const SizedBox(width: 8),

        /// Month Dropdown
        DropdownButton<int>(
          value: _startMonthForyear,
          items: List.generate(12, (index) {
            final month = index + 1;
            return DropdownMenuItem(
              value: month,
              child: Text('$month 月'),
            );
          }),
          onChanged: (value) {
            setState(() {
              _selectedMonth = value! as DateTime?;
            });
          },
        ),

        /// ▶ Next Year
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: () {
            setState(() {
              _selectedYear++;
            });
          },
        ),
      ],
    );
  }


  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {

            setState(() {
              _selectedBarIndex = -1;
              _showTooltip = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Search',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildGraphArea() {
    if (_currentData.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _currentData.length * 60.0,
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue() * 1.2,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      if (response != null && response.spot != null) {
                        setState(() {
                          _selectedBarIndex = response.spot!.touchedBarGroupIndex;
                          _showTooltip = true;
                        });
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final item = _currentData[group.x.toInt()];
                        String label;
                        double value;

                        if (rodIndex == 0) {
                          label = 'Generated';
                          value = item.generatedEnergy;
                        } else if (rodIndex == 1) {
                          label = 'Home Cons.';
                          value = item.selfConsumption;
                        } else {
                          label = 'Usage';
                          value = item.powerUsage;
                        }

                        return BarTooltipItem(
                          '$label: ${value.toStringAsFixed(1)} kWh\n${item.label}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _currentData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                _currentData[index].label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _selectedBarIndex == index
                                      ? Colors.blue
                                      : Colors.grey[600],
                                  fontWeight: _selectedBarIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 10 == 0) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[200],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _currentData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = _selectedBarIndex == index;
      final barWidth = 8.0;

      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: item.generatedEnergy,
            width: barWidth,
            color: isSelected ? Colors.green[400]! : Colors.green,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: item.selfConsumption,
            width: barWidth,
            color: isSelected ? Colors.orange[400]! : Colors.red,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: item.powerUsage,
            width: barWidth,
            color: isSelected ? Colors.blue[400]! : Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(Colors.green),
              const SizedBox(height: 6),
              _legendItem(Colors.red),
              const SizedBox(height: 6),
              _legendItem(Colors.blue),
            ],
          ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.consumption, arguments: _facilityId);
                },
                child: Text("電力量現在値確認")),
          ]
      ),
    );
  }

  Widget _legendItem(Color color) {
    return
        Container(
          width: 120,
          height: 10,
          color: color,
    );
  }

  double _getMaxValue() {
    if (_currentData.isEmpty) return 50.0;
    double max = 0;
    for (var item in _currentData) {
      max = [max, item.generatedEnergy, item.selfConsumption, item.powerUsage]
          .reduce((a, b) => a > b ? a : b);
    }
    return max;
  }
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

