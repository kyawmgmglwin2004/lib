import 'package:EMS/feature/history/widgets/radio_buttom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../mock/history_mock_data.dart';



Widget buildDisplayTypeSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '表示種別',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF843C0B),
          ),
        ),
        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DisplayTypeRadio(type: DisplayType.hourly, label: '時間帯別'),
            const SizedBox(width: 5),

            DisplayTypeRadio(type: DisplayType.daily, label: '日別'),
            const SizedBox(width: 12),

            DisplayTypeRadio(type: DisplayType.monthly, label: '月別'),
          ],
        ),
      ],
    ),
  );
} //表示タイプビュー
