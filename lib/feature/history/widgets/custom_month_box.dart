
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/history_controller.dart';

Future<void> showCustomMonthPicker(BuildContext context) async {
  final provider = context.read<HistoryProvider>();

  int tempYear = provider.selectedMonth?.year ?? DateTime.now().year;
  int? tempMonth = provider.selectedMonth?.month;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Colors.brown, size: 40),
                      const SizedBox(width: 8),
                      const Text(
                        '月を選択',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF6D4C41),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Color(0xFF6D4C41), size: 35),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),

                  const SizedBox(height: 2),

                  // YEAR SELECTOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_sharp,
                            size: 25, color: Color(0xFF6D4C41)),
                        onPressed: () {
                          setDialogState(() => tempYear--);
                        },
                      ),
                      Text(
                        '$tempYear',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D4C41)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_sharp,
                            size: 25, color: Color(0xFF6D4C41)),
                        onPressed: () {
                          setDialogState(() => tempYear++);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // MONTH GRID
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected = tempMonth == month;

                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            tempMonth = month;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.brown[600]
                                : Colors.brown[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$month月',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF6D4C41),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // OK BUTTON
                  SizedBox(
                    width: 70,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: tempMonth == null
                          ? null
                          : () {
                        provider.setSelectedMonth(
                            DateTime(tempYear, tempMonth!));
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
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
