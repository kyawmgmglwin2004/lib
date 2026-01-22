import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/history_controller.dart';

Future<void> showYearPicker(BuildContext context) async {
  final provider = context.read<HistoryProvider>();

  int tempYear = provider.startYear;
  int tempMonth = provider.startMonthForYear;
  int? tempEndMonth = provider.endMonthForYear;

  final now = DateTime.now();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left),
                            onPressed: () {
                              if (tempYear > 1980) {
                                setDialogState(() {
                                  tempYear--;
                                  if (tempYear == now.year &&
                                      tempMonth > now.month) {
                                    tempMonth = now.month;
                                  }
                                });
                              }
                            },
                          ),

                          DropdownButton2<int>(
                            value: tempYear,
                            // isExpanded: true,
                            // isExpanded: true,
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            // dropdownMaxHeight: 200,
                            // dropdownMaxHeight:  200,
                            items: List.generate(46, (i) {
                              final y = now.year - i;
                              final isFutureYear = y > now.year;
                              return DropdownMenuItem(
                                value: y,
                                enabled: !isFutureYear,
                                child: Text(
                                  '$y',
                                  style: TextStyle(
                                    color: isFutureYear
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null && value <= now.year) {
                                setDialogState(() {
                                  tempYear = value;
                                  if (tempYear == now.year &&
                                      tempMonth > now.month) {
                                    tempMonth = now.month;
                                  }
                                });
                              }
                            },
                          ),

                          const Text("年"),
                        ],
                      ),

                      // MONTH SELECTOR
                      Row(
                        children: [
                          DropdownButton<int>(
                            value: tempMonth,
                            items: List.generate(12, (i) {
                              final m = i + 1;
                              final isFutureMonth = (tempYear > now.year) ||
                                  (tempYear == now.year && m > now.month);

                              return DropdownMenuItem(
                                value: m,
                                enabled: !isFutureMonth,
                                child: Text(
                                  '$m',
                                  style: TextStyle(
                                    color: isFutureMonth
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null &&
                                  !(tempYear == now.year &&
                                      value > now.month)) {
                                setDialogState(() => tempMonth = value);
                              }
                            },
                          ),

                          const Text("月"),

                          IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: () {
                              if (tempYear < now.year) {
                                setDialogState(() {
                                  tempYear++;
                                  if (tempYear == now.year &&
                                      tempMonth > now.month) {
                                    tempMonth = now.month;
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: 80,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.updateYearRang(startMonth: tempMonth, endMonth: tempEndMonth);
                        provider.setStartYear(tempYear);
                        provider.loadData();
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
