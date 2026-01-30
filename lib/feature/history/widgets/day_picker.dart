import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/history_controller.dart';

Widget buildHourlyDateSelection(BuildContext context) {
  final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
  final provider = context.watch<HistoryProvider>();

  return Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '日付選択',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF843C0B),
          ),
        ),

        Row(
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      size: 28,
                      color: Color(0xFF843C0B),
                    ),
                    onPressed: () {
                      provider.toggleCalendarPanel();
                    },
                  ),
                  SizedBox(width: 20),
                  Text(
                    dateFormat.format(provider.selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: provider.loading
                ? null
                : () => provider.loadData(),
              style: ButtonStyle(
                // backgroundColor: Color(),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return const Color(0xFF843C0B);
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return Colors.white;
                }),
                // padding: const EdgeInsets.symmetric(horizontal: 35),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric( horizontal: 35),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: const Text("検索", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    ),
  );
} //日付選択ビューの場合
