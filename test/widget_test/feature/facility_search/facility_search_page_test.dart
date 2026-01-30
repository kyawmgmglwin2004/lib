// import 'package:EMS/feature/facility_search/controllers/search_controller.dart';
// import 'package:EMS/feature/facility_search/pages/facility_search.dart';
// import 'package:EMS/feature/facility_search/services/facility_service.dart';
// import 'package:EMS/mock/consumption_mock_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
//
//
// class FakeFacilityService extends FacilityService {
//   final ConsumptionData? response;
//   FakeFacilityService(this.response);
//
//   @override
//   Future<ConsumptionData?> findFacilityById(String id) async => response;
// }
//
// class FakeStorage extends FlutterSecureStorage {
//   final Map<String, String> mem = {};
//   @override
//   Future<void> write({
//     required String key,
//     required String? value,
//     IOSOptions? iOptions,
//     AndroidOptions? aOptions,
//     LinuxOptions? lOptions,
//     WebOptions? webOptions,
//     MacOsOptions? mOptions,
//     WindowsOptions? wOptions,
//   }) async {
//     if (value != null) mem[key] = value;
//   }
// }
//
// void main() {
//   testWidgets('Empty input shows error dialog', (tester) async {
//     final controller = FacilitySearchController(
//       service: FakeFacilityService(null),
//       storage: FakeStorage(),
//     );
//
//     await tester.pumpWidget(
//       MaterialApp(home: FacilitySearchPage(controller: controller)),
//     );
//
//     // Tap search without entering anything
//     await tester.tap(find.text('検索'));
//     await tester.pump(); // start dialog animation
//     await tester.pump(const Duration(milliseconds: 300));
//
//     expect(find.text('指定した施設IDが存在しません。'), findsOneWidget);
//
//     // Close dialog
//     await tester.tap(find.text('OK'));
//     await tester.pump();
//     await tester.pump(const Duration(milliseconds: 300));
//
//     expect(find.text('指定した施設IDが存在しません。'), findsNothing);
//   });
//
//   testWidgets('Not found facilityId shows error dialog', (tester) async {
//     final controller = FacilitySearchController(
//       service: FakeFacilityService(null),
//       storage: FakeStorage(),
//     );
//
//     await tester.pumpWidget(
//       MaterialApp(home: FacilitySearchPage(controller: controller)),
//     );
//
//     await tester.enterText(find.byType(TextFormField), '999999');
//     await tester.tap(find.text('検索'));
//
//     await tester.pump();
//     await tester.pump(const Duration(milliseconds: 300));
//
//     expect(find.text('指定した施設IDが存在しません。'), findsOneWidget);
//   });
// }
//
import 'package:EMS/core/route/app_route.dart';
import 'package:EMS/feature/facility_search/controllers/search_controller.dart';
import 'package:EMS/feature/facility_search/pages/facility_search.dart';
import 'package:EMS/feature/facility_search/services/facility_service.dart';
import 'package:EMS/mock/consumption_detail_mock_data.dart';
import 'package:EMS/mock/consumption_mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class FakeFacilityService extends FacilityService {
  final ConsumptionData? response;
  FakeFacilityService(this.response);

  @override
  Future<ConsumptionData?> findFacilityById(String id) async {
    return response;
  }
}


class FakeStorage extends FlutterSecureStorage {
  final Map<String, String> mem = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) mem[key] = value;
  }
}


class TestNavObserver extends NavigatorObserver {
  int replaceCount = 0;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replaceCount++;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FacilitySearchPage widget tests', () {
    testWidgets('1) Empty input -> shows error dialog', (tester) async {
      final controller = FacilitySearchController(
        service: FakeFacilityService(null),
        storage: FakeStorage(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FacilitySearchPage(controller: controller),
        ),
      );

      // Tap search without entering anything
      await tester.tap(find.text('検索'));

      // dialog animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Expect error dialog
      expect(find.text('指定した施設IDが存在しません。'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('指定した施設IDが存在しません。'), findsNothing);
    });

    testWidgets('2) Not found -> shows error dialog', (tester) async {
      final controller = FacilitySearchController(
        service: FakeFacilityService(null),
        storage: FakeStorage(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FacilitySearchPage(controller: controller),
        ),
      );

      // Enter facility id (not found)
      await tester.enterText(find.byType(TextFormField), '999999');

      // Tap search
      await tester.tap(find.text('検索'));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('指定した施設IDが存在しません。'), findsOneWidget);
    });

    testWidgets('3) Found -> navigates to consumption route', (tester) async {
      final fakeData = getMockData().first;

      final controller = FacilitySearchController(
        service: FakeFacilityService(fakeData),
        storage: FakeStorage(),
      );

      final observer = TestNavObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          routes: {
            AppRoute.consumption: (_) =>
            const Scaffold(body: Text('ConsumptionPage')),
          },
          home: FacilitySearchPage(controller: controller),
        ),
      );



      await tester.enterText(find.byType(TextFormField), fakeData.facilityId);

      await tester.tap(find.text('検索'));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Assert navigation happened
      expect(observer.replaceCount, 1);
      expect(find.text('ConsumptionPage'), findsOneWidget);
    });
    testWidgets('Uses default FacilityService when service is null', (tester) async {
      final controller = FacilitySearchController(
        // service is omitted → null
        storage: FakeStorage(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FacilitySearchPage(controller: controller),
        ),
      );

      // Trigger something that uses controller.service
      await tester.tap(find.text('検索'));
      await tester.pump();
    });

  });
}