import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';

Widget buildGraphArea(BuildContext context) {
  final provider = context.watch<HistoryProvider>();

  if (provider.currentData.isEmpty) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFC55A11),
        strokeWidth: 5,
      ),
    );
  }

  final maxY = provider.getMaxValue() * 1.5;
  const chartHeight = 350.0;
  const yAxisWidth = 45.0;

  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Legend row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '(kWh)',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: const [
                      _LegendItem(color: Colors.green, text: "発電電力量"),
                      SizedBox(width: 7),
                      _LegendItem(color: Color(0xFFC55A11), text: "自家消費量"),
                      SizedBox(width: 7),
                      _LegendItem(color: Colors.blue, text: "使用電力量"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Chart row
              SizedBox(
                height: chartHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: yAxisWidth,
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: maxY,
                          barGroups: const [],
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            horizontalInterval: 10000,
                            drawHorizontalLine: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color:
                                    provider.selectedDisplayType ==
                                        DisplayType.hourly
                                    ? Colors.green
                                    : provider.selectedDisplayType ==
                                          DisplayType.daily
                                    ? Colors.red
                                    : Colors.blue,
                                strokeWidth: 2,

                                // dashArray: [8,4 ],
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10000,
                                reservedSize: 45,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: provider.currentData.length * 60,
                            height: chartHeight,
                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: maxY,
                                alignment: BarChartAlignment.spaceAround,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipPadding: const EdgeInsets.all(8),

                                    // tooltipMargin: 8,
                                    tooltipBorder: BorderSide(
                                      color: Colors.red.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    tooltipMargin: 12,
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: true,
                                    maxContentWidth: 220,

                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                          final item = provider
                                              .currentData[group.x.toInt()];

                                          late String label;
                                          late double value;

                                          if (rodIndex == 0) {
                                            label = '発電電力量(kWh)';
                                            value = item.generatedEnergy;
                                          } else if (rodIndex == 1) {
                                            label = '自家消費量(kWh)';
                                            value = item.selfConsumption;
                                          } else {
                                            label = '使用電力量(kWh)';
                                            value = item.powerUsage;
                                          }

                                          return BarTooltipItem(
                                            '$label: ${value.toStringAsFixed(1)} ',
                                            const TextStyle(
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 ||
                                            index >=
                                                provider.currentData.length) {
                                          return const SizedBox();
                                        }
                                        String label =
                                            provider.currentData[index].label;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            '$label',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                gridData: FlGridData(
                                  drawVerticalLine: false,
                                  horizontalInterval: 10000,
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color:
                                        provider.selectedDisplayType ==
                                            DisplayType.hourly
                                        ? Colors.green
                                        : provider.selectedDisplayType ==
                                              DisplayType.daily
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                barGroups: _buildBarGroups(provider),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 320),
                        Text(
                          provider.selectedDisplayType == DisplayType.hourly
                              ? '( 時 )'
                              : provider.selectedDisplayType ==
                                    DisplayType.daily
                              ? '( 日 )'
                              : '( 月 )',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 9, width: 9, color: color),
        const SizedBox(width: 3),
        Text(text, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}

List<BarChartGroupData> _buildBarGroups(HistoryProvider provider) {
  return List.generate(provider.currentData.length, (index) {
    final item = provider.currentData[index];

    return BarChartGroupData(
      x: index,
      barsSpace: 3,
      barRods: [
        BarChartRodData(
          toY: item.generatedEnergy,
          width: 7,
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: item.selfConsumption,
          width: 7,
          color: Color(0xFFC55A11),
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: item.powerUsage,
          width: 7,
          color: Colors.blue[800],
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  });
}
