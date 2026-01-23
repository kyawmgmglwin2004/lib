import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:solar_meter_flutter/feature/history/widgets/year_picker.dart';


import '../../../mock/history_mock_data.dart';
import '../controllers/history_controller.dart';
import 'day_picker.dart';
import 'month_picker.dart';

Widget buildDateSelectionSection(BuildContext context) {
  final provider = context.watch<HistoryProvider>();

  switch (provider.selectedDisplayType) {
    case DisplayType.hourly:
      return buildHourlyDateSelection(context);
    case DisplayType.daily:
      return const MonthPickerRow();
    case DisplayType.monthly:
      return const YearPickerRow();
  }
}