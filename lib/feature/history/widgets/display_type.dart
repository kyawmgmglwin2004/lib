import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_meter_flutter/feature/history/widgets/radio_buttom.dart';

import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';
Widget buildDisplayTypeSection(BuildContext context) {
  final provider = context.watch<HistoryProvider>();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          '表示種別',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            DisplayTypeRadio(
              type: DisplayType.hourly,
              label: '時間帯別',
            ),
            const SizedBox(width: 5 ),


            DisplayTypeRadio(
              type: DisplayType.daily,
              label: '日別',
            ),
            const SizedBox(width: 12),


            DisplayTypeRadio(
              type: DisplayType.monthly,
              label: '月別',
            ),
          ],
        ),
      ],
    ),
  );
}