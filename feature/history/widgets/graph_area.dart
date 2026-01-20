import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../mock/history_mock_data.dart';

class GraphArea extends StatelessWidget {
  final List<PowerHistoryData> data;
  final int selectedIndex;
  final Function(int) onBarSelected;

  const GraphArea({
    super.key,
    required this.data,
    required this.selectedIndex,
    required this.onBarSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: data.length * 60.0, // width depends on data count
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
                  onBarSelected(response.spot!.touchedBarGroupIndex);
                }
              },
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final item = data[group.x.toInt()];
                  String label;
                  double value;

                  if (rodIndex == 0) {
                    label = 'Generated';
                    value = item.generatedEnergy;
                  } else if (rodIndex == 1) {
                    label = 'Self Cons.';
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
                    if (index >= 0 && index < data.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          data[index].label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selectedIndex == index
                                ? Colors.blue
                                : Colors.grey[600],
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
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 40,
                ),
              ),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
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
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = selectedIndex == index;
      const barWidth = 8.0;

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

  double _getMaxValue() {
    if (data.isEmpty) return 50.0;
    double max = 0;
    for (var item in data) {
      max = [
        max,
        item.generatedEnergy,
        item.selfConsumption,
        item.powerUsage
      ].reduce((a, b) => a > b ? a : b);
    }
    return max;
  }
}
