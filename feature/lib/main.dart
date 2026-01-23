import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solar_meter_flutter/core/provider/consumption_provider.dart';
import 'package:solar_meter_flutter/feature/consumption/services/consumption_service.dart';

import 'core/route/app_route.dart';
import 'core/theme/app_theme.dart';
import 'feature/consumption/controllers/consumption_controller.dart';
import 'feature/consumption/models/consumption_args.dart';
import 'feature/consumption/pages/consumption_page.dart';
import 'feature/facility_search/pages/facility_search.dart';
import 'feature/history/controllers/history_controller.dart';
import 'feature/history/pages/history_page.dart';
import 'mock/history_mock_data.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ConsumptionService()),
        Provider(
          create: (ctx) =>
              ConsumptionController(service: ctx.read<ConsumptionService>()),
        ),

        ChangeNotifierProvider(
          create: (ctx) => ConsumptionProvider(
            controller: ctx.read<ConsumptionController>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Energy Management System',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoute.root,
        routes: {
          AppRoute.root: (context) => const FacilitySearchPage(),
          AppRoute.search: (context) => const FacilitySearchPage(),
        },
        onGenerateRoute: (settings) {

          if(settings.name == AppRoute.history) {
            final args = settings.arguments;
            if (args is String) {
              // Old way: Just data list (for backward compatibility)
              return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => HistoryProvider()..init(),
                  child: HistoryPage(
                    // facilityName: 'Power history',
                    // facilityId: 'HIST001',
                    // initialHourlyData: args, initialDailyData: [], initialMonthlyData: [], // Use the passed data
                    // initialDailyData: getMockDailyData(),
                    // initialMonthlyData: getMockMonthlyData(),
                    facilityId: args,
                  ),
                ),
              );
            }
          }
          if (settings.name == AppRoute.consumption) {
            final args = settings.arguments;


            if (args is ConsumptionArgs) {
              return MaterialPageRoute(
                builder: (_) => ConsumptionPage(
                  facilityId: args.facilityId,
                  data: args.data, // optional
                ),
              );
            }

            if (args is String) {
              return MaterialPageRoute(
                builder: (_) => ConsumptionPage(facilityId: args),
              );
            }

          }

          return null;
        },
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
