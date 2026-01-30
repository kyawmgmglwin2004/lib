import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';

class DisplayTypeRadio extends StatelessWidget {
  final DisplayType type;
  final String label;

  const DisplayTypeRadio({required this.type, required this.label});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final isSelected = provider.selectedDisplayType == type;

    return GestureDetector(
      onTap: () {
        provider.closeCalendarPanel();
        provider.setDisplayType(type);
      },
      child: Container(
        height: 30,
        width: 100,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF843C0B) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: Colors.white,
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
                  color: isSelected ? const Color(0xFF843C0B) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 8, color: Color(0xFF843C0B))
                  : null,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Color(0xFF843C0B) : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
} //選択されたラジオボタンの場合
