import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/history_controller.dart';

class CalendarPanel extends StatelessWidget {
  const CalendarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Container(
      width: 320,
      height: 345,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calendar_month_outlined,
                            size: 30, color: Color(0xFF6D4C41)),
                        SizedBox(width: 6),
                        Text(
                          '日付選択',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D4C41),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        provider.closeCalendarPanel();
                      },
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF6D4C41)),
                    ),
                  ],
                ),
                TableCalendar(
                  firstDay:
                  DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now(),
                  focusedDay: provider.selectedDate,
                  selectedDayPredicate: (day) =>
                      isSameDay(day, provider.selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    provider.setDate(selectedDay, focusedDay);
                  },
                  rowHeight: 30,
                  daysOfWeekVisible: false,
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(1),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.brown[600],

                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,

                      border: Border.all(
                          color: const Color(0xFF6D4C41), width: 2),
                    ),
                    todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: Icon(Icons.arrow_back,
                        color: Colors.brown[600]),
                    rightChevronIcon: Icon(Icons.arrow_forward,
                        color: Colors.brown[600]),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),


          SizedBox(
            height: 30,
            width: 70,
            child: ElevatedButton(
              onPressed: () {
                provider.closeCalendarPanel();
                // provider.loadData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
