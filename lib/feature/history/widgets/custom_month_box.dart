import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/history_controller.dart';

Future<void> showCustomMonthPicker(BuildContext context) async {
  final provider = context.read<HistoryProvider>();
  final now = DateTime.now();

  DateTime? selectedDate = provider.selectedMonth;

  int? displayYear = provider.selectedMonth?.year;

  await showDialog(
    context: context,
    barrierDismissible: false,
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
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Color(0xFF843C0B), size: 36),
                      const SizedBox(width: 8),
                      const Text(
                        '月を選択',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF843C0B),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Color(0xFF843C0B)),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),

                  const SizedBox(height: 8),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_sharp,
                            color: Color(0xFF843C0B)),
                        onPressed: () {
                          if (displayYear! > 2000) {
                            setDialogState(() {
                              displayYear = displayYear! - 1;
                            });
                          }
                        },
                      ),
                      Text(
                        '$displayYear',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF843C0B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_sharp,
                            color: Color(0xFF843C0B)),
                        onPressed: () {
                          if (displayYear! < now.year) {
                            setDialogState(() {
                              displayYear = displayYear! + 1;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),


                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1.6,
                    ),
                    itemBuilder: (context, index) {
                      final month = index + 1;

                      final isFutureMonth =
                          (displayYear! > now.year) ||
                              (displayYear == now.year && month > now.month);

                      final isSelected = selectedDate != null &&
                          selectedDate?.year == displayYear &&
                          selectedDate?.month == month;

                      return GestureDetector(
                        onTap: isFutureMonth
                            ? null
                            : () {
                          setDialogState(() {
                            selectedDate = DateTime(displayYear!, month);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFutureMonth
                                ? Colors.grey[300]
                                : isSelected
                                ? const Color(0xFF843C0B)
                                : Colors.brown[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$month月',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isFutureMonth
                                  ? Colors.grey
                                  : isSelected
                                  ? Colors.white
                                  : const Color(0xFF843C0B),
                            ),
                          ),
                        ),
                      );
                    },
                  ), //日別リストビューの場合

                  const SizedBox(height: 12),

                  SizedBox(
                    width: 80,
                    height: 34,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF843C0B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        provider.setSelectedMonth(selectedDate!);
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
  ); //ダイアログ関数
} // 月選択用のカスタムダイアログを表示する関数
