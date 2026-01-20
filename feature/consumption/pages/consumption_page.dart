import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/consumption_provider.dart';
import '../../../core/route/app_route.dart';
import '../widgets/info_box.dart';
import '../widgets/label_row.dart';
import '../../../mock/history_mock_data.dart';
import '../../../mock/consumption_mock_data.dart';

class ConsumptionPage extends StatefulWidget {
  final String facilityId;
  final ConsumptionData? data;
  const ConsumptionPage({super.key, required this.facilityId, this.data});

  @override
  State<ConsumptionPage> createState() => _ConsumptionPageState();
}

class _ConsumptionPageState extends State<ConsumptionPage> {
  DateTime? _lastUpdated;
  bool _initialized = false;

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_initialized) {
  //     context.read<ConsumptionProvider>().load(widget.facilityId);
  //     _initialized = true;
  //   }
  // }


  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final provider = context.read<ConsumptionProvider>();

    if (widget.data != null) {

      provider.hydrate(widget.data!);
    } else {

      provider.load(widget.facilityId);
    }

    _initialized = true;
  }


  Future<void> _onRefresh() async {
    await context.read<ConsumptionProvider>().refresh(widget.facilityId);
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsumptionProvider>();
    final loading = provider.loading;
    final error = provider.error;
    final data = provider.data;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "${data?.imagePath}",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),

          ),

          SafeArea(
          child: RefreshIndicator(
            color: Colors.orange,
            onRefresh: _onRefresh,
            child: Builder(
              builder: (context) {

                if (loading) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    ),
                  );
                }



                // if (error != null) {
                //   return ListView(
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     padding: const EdgeInsets.all(16),
                //     children: [
                //       Center(child: Text('Error: $error')),
                //       const SizedBox(height: 16),
                //       ElevatedButton(
                //         onPressed: () {
                //           Navigator.pushReplacementNamed(context, AppRoute.search);
                //         },
                //         child: const Text('施設検索に戻る'),
                //       ),
                //     ],
                //   );
                // }

                // if (data == null) {
                //   return ListView(
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     padding: const EdgeInsets.all(16),
                //     children: [
                //       const Center(child: Text('データが見つかりませんでした')),
                //       const SizedBox(height: 16),
                //       ElevatedButton(
                //         onPressed: () {
                //           Navigator.pushReplacementNamed(context, AppRoute.search);
                //         },
                //         child: const Text('施設検索に戻る'),
                //       ),
                //     ],
                //   );
                // }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        "施設名",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${data!.facilityName}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                      // LabelRow(label: "施設名", value: data!.facilityName),
                      LabelRow(label: "所在地市の情報 :", value: data.cityInfo),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: LabelRow(
                          label: "計測対象時間帯 :",
                          value: data.measurementTimePeriod,
                          valueColor: Colors.red,
                        ),
                      ),

                      const Divider(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.grey[500],
                              child: const Text(
                                "累計発電電力量",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.grey[700],
                              child: Text(
                                "${data.cumulativePowerGeneration}kWh",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      _twoColumn(
                        data,
                        "現在の発電電力量",
                        data.currentPowerGeneration,
                        "本日の合計発電電力量",
                        data.todayTotalGeneration,
                      ),

                      const SizedBox(height: 24),

                      _twoColumn(
                        data,
                        "現在の自家消費量",
                        data.currentSelfConsumption,
                        "本日の合計自家消費量",
                        data.todayTotalSelfConsumption,
                      ),

                      const SizedBox(height: 24),

                      _twoColumn(
                        data,
                        "現在の使用電力量",
                        data.currentPowerUsage,
                        "本日の合計使用電力量",
                        data.todayTotalPowerUsage,
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRoute.search);
                              },
                              child: const Text("施設検索"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.history,
                                  arguments: getMockHistoryData(),
                                );
                              },
                              child: const Text("電力量履歴確認"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
    ],
      ),
    );
  }

  Widget _twoColumn(
      ConsumptionData data,
      String leftTitle,
      double leftValue,
      String rightTitle,
      double rightValue,
      ) {
    return Row(
      children: [
        Expanded(
          child: InfoBox(
            title: leftTitle,
            value: data.formatValue(leftValue),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InfoBox(
            title: rightTitle,
            value: data.formatValue(rightValue),
          ),
        ),
      ],
    );
  }
}
