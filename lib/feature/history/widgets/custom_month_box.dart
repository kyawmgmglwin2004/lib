// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/history_controller.dart';
//
// Future<void> showCustomMonthPicker(BuildContext context) async {
//   final provider = context.read<HistoryProvider>();
//
//   int tempYear = provider.selectedMonth?.year ?? DateTime.now().year;
//   int? tempMonth = provider.selectedMonth?.month;
//
//   final now = DateTime.now();
//
//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setDialogState) {
//           final bool disableColor = tempYear >= DateTime.now().year;
//           return Dialog(
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_month,
//                         color: Color(0xFF843C0B),
//                         size: 40,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         '月を選択',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Color(0xFF843C0B),
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.close,
//                           color: Color(0xFF843C0B),
//                           size: 35,
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 2),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_sharp,
//                           size: 25,
//                           color: Color(0xFF843C0B),
//                         ),
//                         onPressed: () {
//                           if (tempYear > 2000) {
//                             setDialogState(() {
//                               tempYear--;
//                               tempMonth = null;
//                             });
//                           }
//                         },
//                       ),
//                       Text(
//                         '$tempYear',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF843C0B),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.arrow_forward_sharp,
//                           size: 25,
//                           color: disableColor
//                               ? Colors.grey
//                               : const Color(0xFF843C0B),
//                         ),
//                         onPressed: () {
//                           if (tempYear < now.year) {
//                             setDialogState(() {
//                               tempYear++;
//                               tempMonth = null;
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 5),
//
//                   // MONTH GRID
//                   GridView.builder(
//                     shrinkWrap: true,
//                     itemCount: 12,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 6,
//                           mainAxisSpacing: 5,
//                           crossAxisSpacing: 5,
//                           childAspectRatio: 1.5,
//                         ),
//                     itemBuilder: (context, index) {
//                       final month = index + 1;
//
//                       final isFutureMonth =
//                           (tempYear > now.year) ||
//                           (tempYear == now.year && month > now.month);
//
//                       final isSelected = tempMonth == month;
//
//                       return GestureDetector(
//                         onTap: isFutureMonth
//                             ? null
//                             : () {
//                                 setDialogState(() {
//                                   tempMonth = month;
//                                 });
//                               },
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: isFutureMonth
//                                 ? Colors.grey[300]
//                                 : isSelected
//                                 ? Color(0xFF843C0B)
//                                 : Colors.brown[100],
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             '$month月',
//                             style: TextStyle(
//                               color: isFutureMonth
//                                   ? Colors.grey
//                                   : isSelected
//                                   ? Colors.white
//                                   : const Color(0xFF843C0B),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   SizedBox(
//                     width: 70,
//                     height: 30,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF843C0B),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       onPressed: () {
//                               provider.setSelectedMonth(
//                                 DateTime(tempYear, tempMonth!),
//                               );
//                               Navigator.pop(context);
//                             },
//                       child: const Text('OK'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

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
                  // HEADER
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

                  // MONTH GRID
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
                  ),

                  const SizedBox(height: 12),

                  // OK BUTTON
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
  );
}
