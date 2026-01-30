import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/history_controller.dart';

class CalendarPanel extends StatelessWidget {
  const CalendarPanel({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<HistoryProvider>(); // HistoryProvider を監視して状態（選択日・フォーカス日など）を取得

    final focusedMonth = DateTime(
      provider.focusedDate!.year,
      provider.focusedDate!.month,
    ); // 現在カレンダーが表示している「月」（年・月だけに丸める）

    final lastMonth = DateTime(DateTime.now().year, DateTime.now().month);  // 今月（未来の月へ進めない制御に使う）

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
      ),  // パネルの見た目（白背景、角丸、影）

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
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                          color: Color(0xFF843C0B),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '日付選択',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF843C0B),
                          ),
                        ),
                      ],
                    ),

                    // ×ボタン：カレンダーパネルを閉じる
                    IconButton(
                      onPressed: () {
                        provider.closeCalendarPanel();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF843C0B),
                      ),
                    ),
                  ],
                ), // タイトル行（アイコン＋タイトル＋閉じるボタン）

                TableCalendar(
                  // 表示可能な最初の日（過去365日まで）
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),

                  // 表示可能な最後の日（今日まで）
                  lastDay: DateTime.now(),

                  // 現在フォーカス中の日（表示中の月を決める）
                  focusedDay: provider.focusedDate!,

                  // 選択中の日を判定（選択日には装飾が付く）
                  selectedDayPredicate: (day) =>
                      isSameDay(day, provider.selectedDate),

                  // 日付選択時：選択日とフォーカス日を更新
                  onDaySelected: (selectedDay, focusedDay) {
                    provider.setDate(selectedDay, focusedDay);
                  },

                  // 月移動時：フォーカス日を更新
                  onPageChanged: (focusedDay) {
                    provider.setFocusedDate(focusedDay);
                  },

                  // 行の高さ
                  rowHeight: 30,

                  // 曜日行を非表示
                  daysOfWeekVisible: false,

                  // カレンダーの見た目（選択日・今日など）
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(1),

                    // 選択日の背景
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFF843C0B),
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),

                    // 今日の日付の装飾
                    todayDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: const Color(0xFF843C0B),
                        width: 2,
                      ),
                    ),
                    todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ヘッダー（年月表示・矢印など）
                  headerStyle: HeaderStyle(
                    // 表示形式切り替えボタンを非表示
                    formatButtonVisible: false,

                    // タイトル（年月）を中央寄せ
                    titleCentered: true,

                    // 左矢印
                    leftChevronIcon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF843C0B),
                    ),

                    // 右矢印：今月以降はグレー表示（未来に進ませない見せ方）
                    rightChevronIcon: Icon(
                      Icons.arrow_forward,
                      color: focusedMonth.isAfter(lastMonth) ||
                          focusedMonth.isAtSameMomentAs(lastMonth)
                          ? Colors.grey
                          : Colors.brown[600],
                    ),
                  ),
                ), // カレンダー本体
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF843C0B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(fontSize: 14)),
            ),
          ), // OK ボタン：カレンダーパネルを閉じる

          const SizedBox(height: 10),
        ],
      ),
    );
  }
} // カレンダーパネル（履歴画面で日付選択するためのUI）