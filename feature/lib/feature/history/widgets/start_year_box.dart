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
print("==============================year $tempYear");

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
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.grey[400],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
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
                                  child: const Icon(Icons.arrow_left, color: Colors.white, size: 20),

                                ),
                            ),
                            SizedBox(width: 10,),

                            Container(
                              color: Colors.white,
                              height: 25,
                              child: DropdownButton2<int>(
                                value: tempYear,
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
                            ),
                            const SizedBox(width: 5,),
                            const Text("年", style:
                              TextStyle(
                                color: Colors.black
                              ),),
                          ],
                        ),

                        // MONTH SELECTOR
                        Row(
                          children: [
                            Container(
                              height: 25,
                              color: Colors.white,
                              child: DropdownButton2<int>(
                                value: tempMonth,
                                dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40
                                ),
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
                            ),

                            const SizedBox(width: 5,),
                            const Text("月", style: TextStyle(
                              color: Colors.black
                            ),),

                            const SizedBox(width: 10,),
                            Container(

                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle
                              ),
                              child: GestureDetector(
                                onTap: () {
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
                                child: const Icon(Icons.arrow_right, color: Colors.white, size: 20),

                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 16),
                  const Divider(color: Colors.grey,),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                              onPressed: () {
                            provider.updateYearRang(startMonth: DateTime.now().month, endMonth: tempEndMonth);
                            provider.setStartYear(DateTime.now().year);
                            Navigator.pop(context);
                          },
                              child: const Text("今日")),
                        ),
                        SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            provider.updateYearRang(startMonth: tempMonth, endMonth: tempEndMonth);
                            provider.setStartYear(tempYear);
                            // provider.loadData();
                            Navigator.pop(context);
                          },
                          child: const Text("閉じる"),
                        ),
                      ),
                      ]
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
