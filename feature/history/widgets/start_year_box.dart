
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/history_controller.dart';

Future<void> showYearPicker(BuildContext context) async {
  final provider = context.read<HistoryProvider>();

  int tempYear = provider.startYear;
  int tempMonth = provider.startMonthForYear;

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
                              setDialogState(() {
                                tempYear--;
                              });
                            },
                          ),

                          DropdownButton<int>(
                            value: tempYear,
                            items: List.generate(10, (i) {
                              final y = DateTime.now().year - 7 + i;
                              return DropdownMenuItem(
                                value: y,
                                child: Text('$y'),
                              );
                            }),
                            onChanged: (value) {
                              setDialogState(() => tempYear = value!);
                            },
                          ),

                          const Text("年"),
                        ],
                      ),

                      // MONTH Picker
                      Row(
                        children: [

                          DropdownButton<int>(
                            value: tempMonth,
                            items: List.generate(12, (i) {
                              final m = i + 1;
                              return DropdownMenuItem(
                                value: m,
                                child: Text('$m'),
                              );
                            }),
                            onChanged: (value) {
                              setDialogState(() => tempMonth = value!);
                            },
                          ),

                          const Text("月"),

                          IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: () {
                              setDialogState(() {
                                tempYear++;
                              });
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
                        provider.updateYearRang(
                          startMonth: tempMonth,
                        );
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
