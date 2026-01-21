
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';
import 'custom_month_box.dart';

class MonthPickerRow extends StatelessWidget {
  const MonthPickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final monthFormat = DateFormat("yyyy/MM");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '月選択',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              // ▼ Month Selector Box
              Container(
                padding: const EdgeInsets.only(right: 30, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_month,
                          size: 30, color: Colors.brown[600]),
                      onPressed: () {
                        showCustomMonthPicker(context);
                      },
                    ),

                    const SizedBox(width: 30),

                    Text(
                      provider.selectedMonth != null
                          ? monthFormat.format(provider.selectedMonth!)
                          : 'Select month',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              ElevatedButton(
                onPressed: () {
                  provider.loadData();  // monthly reload
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
      ),
    );
  }
}
