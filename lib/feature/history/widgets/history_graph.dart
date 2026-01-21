import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';

Widget buildGraphArea(BuildContext context) {
  final provider = context.watch<HistoryProvider>();

  if (provider.currentData.isEmpty) {
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
            width: provider.currentData.length * 60.0,
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: provider.getMaxValue() * 1.2,
                minY: 0,

                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (response != null &&
                        response.spot != null &&
                        event.isInterestedForInteractions) {
                      context
                          .read<HistoryProvider>()
                          .selectBar(response.spot!.touchedBarGroupIndex);
                    }
                  },

                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item =
                      provider.currentData[group.x.toInt()];

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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 ||
                            index >= provider.currentData.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            provider.currentData[index].label,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold

                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 10 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 50,
                    ),
                  ),
                  topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                gridData: FlGridData(
                    show: true, // inside lines
                    drawVerticalLine: false,
                    horizontalInterval: 10000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: provider.selectedDisplayType == DisplayType.hourly
                            ? Colors.green
                            :provider.selectedDisplayType == DisplayType.daily
                            ? Colors.red : Colors.blue,
                        strokeWidth: 1,
                        dashArray: null,
                      );
                    }
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: provider.selectedDisplayType == DisplayType.hourly
                      ? Colors.green
                      :provider.selectedDisplayType == DisplayType.daily
                      ? Colors.red : Colors.blue),
                ),

                barGroups: _buildBarGroups(provider),
              ),
            ),
          ),
        ),
      ),

    ],
  );
}


List<BarChartGroupData> _buildBarGroups(HistoryProvider provider) {
  return List.generate(provider.currentData.length, (index) {
    final item = provider.currentData[index];
    // final isSelected = provider.selectedBarIndex == index;

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
            toY: item.generatedEnergy,
            width: 11,
            color: Colors.green,
            borderRadius: BorderRadius.circular(1)
        ),
        BarChartRodData(
            toY: item.selfConsumption,
            width: 11,
            color: Colors.orange[800],
            borderRadius: BorderRadius.circular(1)
        ),
        BarChartRodData(
            toY: item.powerUsage,
            width: 11,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(1)
        ),
      ],
    );
  });
}