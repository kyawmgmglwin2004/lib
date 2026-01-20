import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/route/app_route.dart';

class LegendWidget extends StatelessWidget {
  final String facilityId;

  const LegendWidget({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 30, height: 10, color: Colors.green),
            Container(width: 30, height: 10, color: Colors.red),
            Container(width: 30, height: 10, color: Colors.blue),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.consumption, arguments: facilityId);
          },
          child: const Text('電力量現在値確認'),
        ),
      ],
    );
  }
}
