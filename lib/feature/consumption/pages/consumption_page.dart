import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/route/app_route.dart';
import '../controllers/consumption_controller.dart';
import '../widgets/info_box.dart';
import '../widgets/label_row.dart';
import '../../../mock/consumption_mock_data.dart';

class ConsumptionPage extends StatefulWidget {

  final String facilityId;  // 検索元から渡される施設ID

  final ConsumptionData? data;  // 前画面からデータが渡される場合（API再取得せず即表示したいとき）

  const ConsumptionPage({super.key, required this.facilityId, this.data});

  @override
  State<ConsumptionPage> createState() => _ConsumptionPageState();
}

class _ConsumptionPageState extends State<ConsumptionPage> {

  DateTime? _lastUpdated;  // 最終更新時刻（リフレッシュ時に更新する）

  bool _initialized = false;  // didChangeDependencies 内での重複実行を防ぐフラグ

  String _previousCompletedHourRange({DateTime? now}) {

    final t = now ?? DateTime.now(); // now が指定されていればそれを使用、未指定なら現在時刻を使用

    final currentHour = DateTime(t.year, t.month, t.day, t.hour); // 現在時刻の「時」単位に丸める（分・秒を 0 にする）


    final start = currentHour.subtract(const Duration(hours: 1));  // 直近1時間の開始と終了
    final end = currentHour;  // 直近1時間の開始と終了

    String two(int n) => n.toString().padLeft(2, '0'); // 2桁ゼロ埋め（例：1 -> "01"）

    final date = "${start.year}/${two(start.month)}/${two(start.day)}"; // 表示用フォーマット
    final startTime = "${two(start.hour)}:00";
    final endTime = "${two(end.hour)}:00";

    return "$date $startTime~$endTime";
  } // 測定対象時間帯（直近1時間分）を文字列で作成する

  @override

  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;  // すでに初期化済みなら何もしない（重複呼び出し防止）

    final provider = context.read<ConsumptionProvider>(); // Provider を取得（listen=false）


    if (widget.data != null) {  // 前画面からデータが渡されている場合は Provider に注入（API不要）

      provider.hydrate(widget.data!);

    } else {

      provider.load(widget.facilityId);  // データがない場合は施設IDで取得（API/モック呼び出し）

    }


    _initialized = true; // 初期化済みにする

  }  // APIの繰り返し呼び出しを防ぐために didChangeDependencies を利用


  Future<void> _onRefresh() async {
    await context.read<ConsumptionProvider>().refresh(widget.facilityId);
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }  // 画面を下に引っ張って更新する（RefreshIndicator 用） // データを再取得し、最終更新時刻も更新する


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsumptionProvider>(); // Provider を監視（状態変化時に画面が再描画される）
    final loading = provider.loading;
    final error = provider.error; // ※必要ならエラー表示に使用
    final data = provider.data;

    return Scaffold(
      extendBody: true,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("${data?.imagePath}"),
            fit: BoxFit.cover,
          ),
        ),  // 背景画像（施設ごとの画像パスを想定）

        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFFC55A11),
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
                            color: Color(0xFFC55A11),
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    ),
                  ); // RefreshIndicator を有効にするため、常にスクロール可能にする
                }  // ローディング中は中央にローディング表示



                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // RefreshIndicator を有効にするため AlwaysScrollable を設定
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Text(
                              "施設名",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "${data!.facilityName}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      LabelRow(label: "所在地市の情報 :", value: data.cityInfo),  // 所在地情報


                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: LabelRow(
                          label: "計測対象時間帯 :",
                          value: _previousCompletedHourRange(now: _lastUpdated),
                          valueColor: Colors.red,
                        ),
                      ), // 測定対象時間帯（直近1時間）をインデントして表示

                      const Divider(height: 32),  // 区切り線（下線）


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
                      ), // 累計発電電力量（2カラム風の見せ方）

                      const SizedBox(height: 32),

                      _twoColumn(
                        data,
                        "現在の発電電力量",
                        data.currentPowerGeneration,
                        "本日の合計発電電力量",
                        data.todayTotalGeneration,
                      ), // 2列表示：現在の発電 / 本日の合計発電

                      const SizedBox(height: 24),

                      _twoColumn(
                        data,
                        "現在の自家消費量",
                        data.currentSelfConsumption,
                        "本日の合計自家消費量",
                        data.todayTotalSelfConsumption,
                      ), // 2列表示：現在の自家消費 / 本日の合計自家消費

                      const SizedBox(height: 24),

                      _twoColumn(
                        data,
                        "現在の使用電力量",
                        data.currentPowerUsage,
                        "本日の合計使用電力量",
                        data.todayTotalPowerUsage,
                      ), // 2列表示：現在の使用電力量 / 本日の合計使用電力量

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC55A11),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoute.search,
                                );
                              },   // 現在画面を置き換えて検索画面へ戻る
                              child: const Text("施設検索"),
                            ),  // 施設検索画面に戻るボタン（置換ナビゲーション）
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC55A11),
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
                                  arguments: "123123",
                                );
                              },  // 履歴画面へ遷移（arguments で値を渡す）
                              child: const Text("電力量履歴確認"),
                            ),  // 履歴ページへ移動するボタン
                          ),
                        ],
                      ),
                    ],
                  ),
                );  // スクロール表示（データ表示）
              },
            ),
          ),  // Pull-to-refresh のスピナー色
        ),
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
  } // InfoBox を左右2列で表示する共通ウィジェット
}