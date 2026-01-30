import 'package:flutter/material.dart';
import '../controllers/search_controller.dart';

class FacilitySearchPage extends StatefulWidget {

  final FacilitySearchController? controller;

  // const FacilitySearchPage({super.key});

  const FacilitySearchPage({super.key, this.controller});

  @override
  State<FacilitySearchPage> createState() => _FacilitySearchPageState();
}

class _FacilitySearchPageState extends State<FacilitySearchPage> {
  late FacilitySearchController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? FacilitySearchController(); // コントローラー生成
    controller.addListener(() {
      setState(() {});
    });// controller 側で notifyListeners() が呼ばれたら画面を再描画する
      // （isLoading の変更などを UI に反映するため）

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }     // メモリリーク防止：画面破棄時に controller も破棄する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "施設ID",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),   // ラベル表示
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: controller.facilityController,
                          maxLength: 6, // 施設IDの最大入力桁数（例：6桁）
                          readOnly: controller.isLoading, // ローディング中は編集不可にする
                          showCursor: !controller.isLoading, // ローディング中はカーソル非表示
                          decoration: InputDecoration(
                            counterText: "", // maxLength のカウンター文字を非表示
                            isDense: true, // 高さをコンパクトにする
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: const EdgeInsets.only(
                              right: 12,
                              bottom: 28,
                              left: 12,
                              top: 2,
                            ), // 入力欄内の余白

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ), // 通常時の枠線
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),  // フォーカス時の枠線
                          ),
                        ),  // 施設ID入力欄
                      ),
                      const SizedBox(width: 10),


                      ElevatedButton(
                        onPressed: controller.isLoading //が true のとき onPressed を null にすると「ボタンが無効化」される
                            ? null
                            : () => controller.search(context),

                        clipBehavior: controller.isLoading ? Clip.none :Clip.antiAlias, // ローディング中だけ Clip.none、それ以外はアンチエイリアス（見た目の角をきれいに）

                        style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                            return const Color(0xFFC55A11);
                          }), // 無効化されても背景色を固定（通常は灰色になるが、それを防ぐ）

                          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                            return Colors.white;
                          }),  // 無効化されても文字色を固定

                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          ),   // ボタン内の余白

                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),  // ボタンの角丸
                        ),

                        child: controller.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ) // ローディング中はスピナー、それ以外は「検索」テキスト
                            : const Text("検索"),
                      ),  // 検索ボタン
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
