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
            color: Color(0xFF6D4C41),
          ),
        ),
    
        Row(
          children: [
            Container(
                width: 200,
                // padding: const EdgeInsets.only(bott ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown, width: 2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_month,
                          size: 28, color: Colors.brown[600]),
                      onPressed: () {
                        provider.toggleCalendarPanel();
                      },
                    ),
                    SizedBox(width: 20,),
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
              onPressed: () {
                provider.loadData();
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