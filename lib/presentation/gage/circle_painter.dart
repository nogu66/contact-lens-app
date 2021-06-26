import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleLevelPainter extends CustomPainter {
  final double percentage;
  final double textCircleRadius;

  CircleLevelPainter({this.percentage, this.textCircleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < (360 * percentage); i += 5) {
      final per = i / 360.0;
      // 割合（0~1.0）からグラデーション色に変換
      final color = ColorTween(
        begin: Colors.blue.shade200,
        // end: Colors.grey.shade200,
        end: Colors.blue.shade200,
      ).lerp(per);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

      final spaceLen = 0; // 円とゲージ間の長さ
      final lineLen = 15; // ゲージの長さ
      // final angle = (2 * pi * per) - (pi / 2); // 0時方向から開始するため-90度ずらす
      final angle = (2 * pi * per) - (pi / 2);

      // 円の中心座標
      final offset0 = Offset(size.width * 0.5, size.height * 0.5);
      // 線の内側部分の座標
      final offset1 = offset0.translate(
        (textCircleRadius + spaceLen) * cos(angle),
        (textCircleRadius + spaceLen) * sin(angle),
      );
      // 線の外側部分の座標
      final offset2 = offset1.translate(
        lineLen * cos(angle),
        lineLen * sin(angle),
      );

      canvas.drawLine(offset1, offset2, paint);
    }
  }

  void paintInner(Canvas canvas, Size size) {
    for (int i = 1; i < (360); i += 5) {
      final per = i / 360.0;
      // 割合（0~1.0）からグラデーション色に変換
      final color = ColorTween(
        begin: Colors.blue.shade200,
        // end: Colors.grey.shade200,
        end: Colors.grey.shade200,
      ).lerp(per);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

      final spaceLen = 16; // 円とゲージ間の長さ
      final lineLen = 15; // ゲージの長さ
      // final angle = (2 * pi * per) - (pi / 2); // 0時方向から開始するため-90度ずらす
      final angle = (2 * pi * per) - (pi / 2);

      // 円の中心座標
      final offset0 = Offset(size.width * 0.5, size.height * 0.5);
      // 線の内側部分の座標
      final offset1 = offset0.translate(
        (textCircleRadius + spaceLen) * cos(angle),
        (textCircleRadius + spaceLen) * sin(angle),
      );
      // 線の外側部分の座標
      final offset2 = offset1.translate(
        lineLen * cos(angle),
        lineLen * sin(angle),
      );

      canvas.drawLine(offset1, offset2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// class CirclePaint extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..strokeWidth = 10
//       ..color = Colors.blue.shade200
//       ..style = PaintingStyle.stroke;
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height);
//     canvas.drawCircle(center, radius, paint);
//   }
//
//   // 再描画する必要なし
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class CirclePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     /// 線は黒色を指定する
//     Paint outerCircle = Paint()
//       ..strokeWidth = 5
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke;
//
//     Offset center = Offset(size.width / 2, size.height / 2);
//     double radius = min(size.width / 2, size.height / 2) - 7;
//
//     canvas.drawCircle(center, radius, outerCircle);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
