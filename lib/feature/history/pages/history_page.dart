import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/route/app_route.dart';
import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';
import '../widgets/calendar_panel.dart';
import '../widgets/date_selection.dart';
import '../widgets/day_picker.dart';
import '../widgets/display_type.dart';
import '../widgets/history_graph.dart';
import '../widgets/month_picker.dart';
import '../widgets/year_picker.dart';


class HistoryPage extends StatefulWidget {
  // final String facilityName;
  final String facilityId;
  // final List<PowerHistoryData> initialHourlyData;
  // final List<PowerHistoryData> initialDailyData;
  // final List<PowerHistoryData> initialMonthlyData;

  const HistoryPage({
    super.key,
    // required this.facilityName,
    required this.facilityId,
    // required this.initialHourlyData,
    // required this.initialDailyData,
    // required this.initialMonthlyData,
  });


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<PowerHistoryData> _currentData;
  // DisplayType _selectedDisplayType = DisplayType.hourly;
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
    // _currentData = widget.initialHourlyData;
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
                buildDisplayTypeSection(context),

                buildDateSelectionSection(context),


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: buildGraphArea(context)
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

  // Widget _buildGraphArea(BuildContext context) {
  //   final provider = context.watch<HistoryProvider>();
  //
  //   if (provider.currentData.isEmpty) {
  //     return const Center(
  //       child: Text('No data available'),
  //     );
  //   }
  //
  //   return Column(
  //     children: [
  //       const SizedBox(height: 16),
  //
  //       Expanded(
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: SizedBox(
  //             width: provider.currentData.length * 60.0,
  //             height: 300,
  //             child: BarChart(
  //               BarChartData(
  //                 alignment: BarChartAlignment.spaceAround,
  //                 maxY: provider.getMaxValue() * 1.2,
  //                 minY: 0,
  //
  //                 barTouchData: BarTouchData(
  //                   enabled: true,
  //                   touchCallback: (event, response) {
  //                     if (response != null &&
  //                         response.spot != null &&
  //                         event.isInterestedForInteractions) {
  //                       context
  //                           .read<HistoryProvider>()
  //                           .selectBar(response.spot!.touchedBarGroupIndex);
  //                     }
  //                   },
  //
  //                   touchTooltipData: BarTouchTooltipData(
  //                     tooltipPadding: const EdgeInsets.all(8),
  //                     tooltipMargin: 8,
  //                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
  //                       final item =
  //                       provider.currentData[group.x.toInt()];
  //
  //                       String label;
  //                       double value;
  //
  //                       if (rodIndex == 0) {
  //                         label = 'Generated';
  //                         value = item.generatedEnergy;
  //                       } else if (rodIndex == 1) {
  //                         label = 'Home Cons.';
  //                         value = item.selfConsumption;
  //                       } else {
  //                         label = 'Usage';
  //                         value = item.powerUsage;
  //                       }
  //
  //                       return BarTooltipItem(
  //                         '$label: ${value.toStringAsFixed(1)} kWh\n${item.label}',
  //                         const TextStyle(color: Colors.white),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //
  //
  //                 titlesData: FlTitlesData(
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget: (value, meta) {
  //                         final index = value.toInt();
  //                         if (index < 0 ||
  //                             index >= provider.currentData.length) {
  //                           return const SizedBox();
  //                         }
  //
  //                         return Padding(
  //                           padding: const EdgeInsets.only(top: 4),
  //                           child: Text(
  //                             provider.currentData[index].label,
  //                             style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold
  //
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       reservedSize: 100,
  //                     ),
  //                   ),
  //                   leftTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget: (value, meta) {
  //                         if (value % 10 == 0) {
  //                           return Text(
  //                             value.toInt().toString(),
  //                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //                           );
  //                         }
  //                         return const SizedBox();
  //                       },
  //                       reservedSize: 40,
  //                     ),
  //                   ),
  //                   topTitles:
  //                   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //                   rightTitles:
  //                   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //                 ),
  //
  //                 gridData: FlGridData(
  //                     show: true, // inside lines
  //                     drawVerticalLine: false,
  //                     horizontalInterval: 10000,
  //                     getDrawingHorizontalLine: (value) {
  //                       return FlLine(
  //                         color: provider.selectedDisplayType == DisplayType.hourly
  //                             ? Colors.green
  //                             :provider.selectedDisplayType == DisplayType.daily
  //                             ? Colors.red : Colors.blue,
  //                         strokeWidth: 1,
  //                         dashArray: null,
  //                       );
  //                     }
  //                 ),
  //
  //                 borderData: FlBorderData(
  //                   show: true,
  //                   border: Border.all(color: provider.selectedDisplayType == DisplayType.hourly
  //                       ? Colors.green
  //                       :provider.selectedDisplayType == DisplayType.daily
  //                       ? Colors.red : Colors.blue),
  //                 ),
  //
  //                 barGroups: _buildBarGroups(provider),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //
  //     ],
  //   );
  // }
  //
  //
  // List<BarChartGroupData> _buildBarGroups(HistoryProvider provider) {
  //   return List.generate(provider.currentData.length, (index) {
  //     final item = provider.currentData[index];
  //     // final isSelected = provider.selectedBarIndex == index;
  //
  //     return BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         BarChartRodData(
  //           toY: item.generatedEnergy,
  //           width: 11,
  //           color: Colors.green,
  //           borderRadius: BorderRadius.circular(1)
  //         ),
  //         BarChartRodData(
  //           toY: item.selfConsumption,
  //           width: 11,
  //           color: Colors.orange[800],
  //             borderRadius: BorderRadius.circular(1)
  //         ),
  //         BarChartRodData(
  //           toY: item.powerUsage,
  //           width: 11,
  //           color: Colors.blue,
  //             borderRadius: BorderRadius.circular(1)
  //         ),
  //       ],
  //     );
  //   });
  // }


  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          //   Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _legendItem(Colors.green),
          //     const SizedBox(height: 6),
          //     _legendItem(Colors.red),
          //     const SizedBox(height: 6),
          //     _legendItem(Colors.blue),
          //   ],
          // ),

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

  // double _getMaxValue() {
  //   if (_currentData.isEmpty) return 50.0;
  //   double max = 0;
  //   for (var item in _currentData) {
  //     max = [max, item.generatedEnergy, item.selfConsumption, item.powerUsage]
  //         .reduce((a, b) => a > b ? a : b);
  //   }
  //   return max;
  // }
}

// bool isSameDay(DateTime a, DateTime b) {
//   return a.year == b.year && a.month == b.month && a.day == b.day;
// }

