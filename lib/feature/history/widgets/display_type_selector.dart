// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../mock/history_mock_data.dart';
//
// class DisplayTypeSelector extends StatelessWidget {
//   final DisplayType selectedType;
//   final Function(DisplayType) onChanged;
//
//   const DisplayTypeSelector({
//     super.key,
//     required this.selectedType,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _buildRadio(DisplayType.hourly, '時間帯別'),
//         _buildRadio(DisplayType.daily, '日別'),
//         _buildRadio(DisplayType.monthly, '月別'),
//       ],
//     );
//   }
//
//   Widget _buildRadio(DisplayType type, String label) {
//     final isSelected = selectedType == type;
//     return GestureDetector(
//       onTap: () => onChanged(type),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           border: Border.all(color: isSelected ? Colors.brown : Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(label,
//             style: TextStyle(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
//       ),
//     );
//   }
// }
