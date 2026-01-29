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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '月選択',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF843C0B),
            ),
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF843C0B), width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.calendar_month,
                        size: 30,
                        color: Color(0xFF843C0B),
                      ),
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
                  provider.loadData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF843C0B),
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
