import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_meter_flutter/feature/history/widgets/start_year_box.dart';


import '../controllers/history_controller.dart';
import 'end_year_box.dart';

class YearPickerRow extends StatelessWidget {
  const YearPickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text("開始日", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(right: 20,),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey!, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                          children: [ IconButton(
                            icon: const Icon(Icons.calendar_month, size: 20),
                            onPressed: () {
                             showYearPicker(context);
                            },
                          ),
                            Text(
                              provider.startYear != null && provider.startMonthForYear != null
                                  ? '${provider.startYear}/${provider.startMonthForYear}'
                                  : '${DateTime.now().year}/1',
                              style: const TextStyle(fontSize: 14),
                            ),

                          ]
                      ),
                    ),
                  ],
                ),

              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text("開始日", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(right: 20,),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey!, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                          children: [ IconButton(
                            icon: const Icon(Icons.calendar_month, size: 20),
                            onPressed: () {
                              showEndYearPicker(context);
                            },
                          ),
                            Text(
                              provider.endYear != null && provider.endMonthForYear != null
                                  ? '${provider.endYear}/${provider.endMonthForYear}'
                                  : '${DateTime.now().year}/12',
                              style: const TextStyle(fontSize: 14),
                            ),

                          ]
                      ),
                    ),

                  ],
                ),

              ],
            ),
            Column(
              children: [
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.brown[600],
                      padding: const EdgeInsets.symmetric(
                        // vertical: 1,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // setState(() {
                      //   _showYearMonthPicker = !_showYearMonthPicker;
                      //   _selectedBarIndex = -1;
                      //   _showTooltip = false;
                      // });

                    },
                    child: Text("検索",
                      style: TextStyle(
                          fontSize: 14
                      ),
                    )),
              ],
            )
          ],
        ),
      );
    }
  }

