// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ntt/feature/history/controllers/history_controller.dart';
// import 'package:provider/provider.dart';
//
// class HistoryChart extends StatelessWidget {
//   const HistoryChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HistoryProvider>(
//       builder: (context, provider, child) {
//         final data = provider.currentData;
//
//         if (data.isEmpty) {
//           return const Center(child: Text('No data available'));
//         }
//
//         return SizedBox(
//           height: 300,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: provider.getMaxValue() * 1.2,
//               minY: 0,
//               barTouchData: BarTouchData(
//                 touchCallback: (event, response) {
//                   if (response != null && response.spot != null) {
//                     provider.selectBar(response.spot!.touchedBarGroupIndex);
//                   }
//                 },
//                 touchTooltipData: BarTouchTooltipData(
//                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                     final item = data[group.x.toInt()];
//                     String label;
//                     double value;
//                     if (rodIndex == 0) { label = 'Generated'; value = item.generatedEnergy; }
//                     else if (rodIndex == 1) { label = 'Home'; value = item.selfConsumption; }
//                     else { label = 'Usage'; value = item.powerUsage; }
//
//                     return BarTooltipItem(
//                       '$label: ${value.toStringAsFixed(1)} kWh\n${item.label}',
//                       const TextStyle(color: Colors.white),
//                     );
//                   },
//                 ),
//               ),
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       final index = value.toInt();
//                       if (index >= 0 && index < data.length) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             data[index].label,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: provider.selectedBarIndex == index ? Colors.blue : Colors.grey[600],
//                             ),
//                           ),
//                         );
//                       }
//                       return const Text('');
//                     },
//                     reservedSize: 30,
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       if (value % 10 == 0) return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
//                       return const Text('');
//                     },
//                     reservedSize: 40,
//                   ),
//                 ),
//                 topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               ),
//               borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[300]!)),
//               barGroups: data.asMap().entries.map((entry) {
//                 final isSelected = provider.selectedBarIndex == entry.key;
//                 return BarChartGroupData(
//                   x: entry.key,
//                   barRods: [
//                     BarChartRodData(toY: entry.value.generatedEnergy, color: isSelected ? Colors.green[400] : Colors.green, width: 8),
//                     BarChartRodData(toY: entry.value.selfConsumption, color: isSelected ? Colors.orange[400] : Colors.red, width: 8),
//                     BarChartRodData(toY: entry.value.powerUsage, color: isSelected ? Colors.blue[400] : Colors.blue, width: 8),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }