import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../../core/route/app_route.dart';
import '../controllers/history_controller.dart';
import '../widgets/calendar_panel.dart';
import '../widgets/date_selection.dart';
import '../widgets/display_type.dart';
import '../widgets/history_graph.dart';

class HistoryPage extends StatefulWidget {
  final String facilityId;

  const HistoryPage({super.key, required this.facilityId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _facilityId = "";

  // For get facilityId
  // facilityIdを取得する
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> getFacilityId() async {
    try {
      String? id = await storage.read(key: 'facilityId');
      print("========================================= $id");

      if (id != null && id.isNotEmpty) {
        setState(() {
          _facilityId = id;
        });
        print('FacilitySearch ID found: $id');
      } else {
        setState(() {
          _facilityId = widget.facilityId;
        });
        print('Using widget facility ID: ${widget.facilityId}');
      }
    } catch (e) {
      print('Error reading facilityId: $e');
      setState(() {
        _facilityId = widget.facilityId;
      });
    }
  }

  //For get History data
  //履歴データを取得する
  @override
  void initState() {
    super.initState();
    getFacilityId();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    //For landscape view
    //横向き表示の場合
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final graphHeight = isLandscape ? 260.0 : 420.0;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "施設名_電力量履歴",
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "電力量履歴",
                          style: TextStyle(color: Colors.blue[500]),
                        ),
                      ],
                    ),

                    //For DisplayType View
                    //DisplayType ビューの場合
                    buildDisplayTypeSection(context),

                    //For Display Selection view
                    // 表示選択ビューの場合
                    buildDateSelectionSection(context),
                    SizedBox(height: 50),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: graphHeight,
                        //For build Graph
                        //グラフ構築用
                        child: buildGraphArea(context),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC55A11),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 11,
                              horizontal: 30,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.consumption,
                              arguments: _facilityId,
                            );
                          },
                          child: Text("電力量現在値確認"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //For Day picker view
          //曜日選択ビューの場合
          if (provider.showCalendarPanel) const Center(child: CalendarPanel()),
        ],
      ),
    );
  }
}
