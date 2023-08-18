import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../style/common_color.dart';

class LoadingAnimation {
  static OverlayEntry? _overlayEntry;
  static int _showCount = 0; // 计数器，记录show调用次数

  static void show(BuildContext context, {Duration duration = const Duration(seconds: 5)}) {
    if (_showCount == 0) {
      // 只有当计数器为0时才创建OverlayEntry并插入Overlay
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          // bottom: MediaQuery.of(context).padding.bottom + 76,
          // child: Container(
          //   color: Colors.transparent,
            child: Center(
              child: SpinKitCircle(
                color: CommonColor.primary,
              ),
            ),
          // ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }

    _showCount++; // 增加计数器

    Future.delayed(duration, hide);
  }

  static void hide() {
    _showCount--; // 减少计数器

    if (_showCount <= 0) {
      // 当计数器小于等于0时执行隐藏操作
      _overlayEntry?.remove();
      _overlayEntry = null;
      _showCount = 0; // 重置计数器
    }
  }
}
