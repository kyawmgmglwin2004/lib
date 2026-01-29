import 'package:flutter/material.dart';


class InfoBox extends StatelessWidget {

  final String title; // 表示するタイトル（例：施設ID）

  final String value; // 表示する値（例：123456）

  const InfoBox({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          height: 60,                               // 高さ
          alignment: Alignment.center,              // テキストを中央揃え
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.90),   // 背景色（濃いグレー）
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,            // テキスト中央寄せ
            style: const TextStyle(
              color: Colors.white,                  // 白文字
              fontWeight: FontWeight.bold,          // 太字
            ),
          ),
        ), // タイトル部分（上側）

        Container(
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.80),  // 背景色（薄めの白）
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.red,                    // 赤文字で強調
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), // 値の表示部分（下側）
      ],
    );
  }
} // 情報表示用のボックス（タイトル＋値）をまとめたカスタムウィジェット