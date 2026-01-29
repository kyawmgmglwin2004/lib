import 'package:flutter/material.dart';

class LabelRow extends StatelessWidget {
  final String label;       // 左側に表示するラベル名
  final String value;       // 右側に表示する値
  final Color valueColor;   // 値の文字色（デフォルトは青色）

  const LabelRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.blue,   // ラベルは青色
              fontSize: 17,
            ),
          ), // 左側のラベル

          const SizedBox(width: 12), // ラベルと値の間のスペース

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,   // 値の色（外部指定可能）
                fontSize: 15,
                fontWeight: FontWeight.w600, // やや太めで読みやすい
              ),
            ),
          ), // 右側の値（長い場合でも折り返して表示できるよう Expanded を使用）
        ],
      ),
    );  // ラベル行ごとの上下の余白
  }
} // ラベルと値を横並びで表示するカスタムウィジェット