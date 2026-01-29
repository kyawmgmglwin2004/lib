import 'package:flutter/material.dart';

// 施設IDが見つからなかった場合に表示するエラーダイアログ
Future<void> showErrorDialog(BuildContext context) {
  return showDialog(
    context: context,

    // ダイアログ外をタップしても閉じないようにする（誤操作防止）
    barrierDismissible: false,

    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),           // ダイアログの角丸
          side: const BorderSide(color: Colors.black, width: 1), // 黒枠の線
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 必要な分だけ高さを確保
            children: [
              // メッセージ文言
              const Text(
                "指定した施設IDが存在しません。",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // 上部の内容とボタンを仕切る線
              const Divider(height: 1),

              // OK ボタン（ダイアログ下部分）
              SizedBox(
                width: double.infinity, // 横幅いっぱい
                height: 60,
                child: TextButton(
                  // OK ボタン押下 → ダイアログ閉じる
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}