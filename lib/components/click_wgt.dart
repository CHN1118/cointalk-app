//* 1.点击事件防抖
//* 2.点击事件节流
//* 3.点击事件节流并设置时间
//* 4.点击事件不做处理
//* 5.点击事件不做处理并设置时间
// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClickWidget extends StatefulWidget {
  final Widget child;
  final Function? onTap;
  final ClickType type;
  final int timeout;

  const ClickWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.type = ClickType.throttle, //*默认节流
    this.timeout = 500, //*默认500毫秒
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClickWidgetState createState() => _ClickWidgetState();
}

class _ClickWidgetState extends State<ClickWidget> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); //* 清除定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, //* 解决点击空白处无效问题
      onTap: _getOnTap(),
      child: widget.child,
    );
  }

  VoidCallback? _getOnTap() {
    if (widget.type == ClickType.throttle) {
      return widget.onTap != null ? widget.onTap!.throttle() : null;
    } else if (widget.type == ClickType.throttleWithTimeout) {
      return widget.onTap != null
          ? widget.onTap!.throttleWithTimeout(timeout: widget.timeout)
          : null;
    } else if (widget.type == ClickType.debounce) {
      return widget.onTap != null
          ? widget.onTap!.debounce(timeout: widget.timeout)
          : null;
    }
    return widget.onTap as VoidCallback?;
  }
}

enum ClickType { none, throttle, throttleWithTimeout, debounce }

extension FunctionExt on Function {
  VoidCallback throttle() {
    return FunctionProxy(this).throttle;
  }

  VoidCallback throttleWithTimeout({int timeout = 500}) {
    return FunctionProxy(this, timeout: timeout).throttleWithTimeout;
  }

  VoidCallback debounce({int timeout = 500}) {
    return FunctionProxy(this, timeout: timeout).debounce;
  }
}

class FunctionProxy {
  static final Map<String, bool> _funcThrottle = {}; //* 节流
  static final Map<String, Timer> _funcDebounce = {}; //* 防抖
  final Function? target; //* 目标函数
  final int timeout; //* 节流时间

  FunctionProxy(this.target, {this.timeout = 500}); //* 默认500毫秒

  void throttle() async {
    //* 节流
    if (target == null) return; //* 目标函数为空，直接返回
    String key = target.hashCode.toString(); //* 获取目标函数的哈希值
    bool enable = _funcThrottle[key] ?? true; //* 获取节流状态
    if (enable) {
      _funcThrottle[key] = false;
      try {
        await target!();
      } catch (e) {
        rethrow;
      } finally {
        _funcThrottle.remove(key);
      }
    }
  }

  void throttleWithTimeout() {
    if (target == null) return;
    String key = target.hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle.remove(key);
      });
      target!();
    }
  }

  void debounce() {
    //* 防抖
    if (target == null) return; //* 目标函数为空，直接返回
    String key = target.hashCode.toString(); //* 获取目标函数的哈希值
    Timer? timer = _funcDebounce[key]; //* 获取防抖定时器
    timer?.cancel(); //* 取消定时器
    timer = Timer(Duration(milliseconds: timeout), () {
      //* 重新设置定时器
      Timer? t = _funcDebounce.remove(key); //* 定时器执行完毕，删除定时器
      t?.cancel(); //* 取消定时器
      target!(); //* 执行目标函数
    });
    _funcDebounce[key] = timer; //* 保存定时器
  }
}

class Mbl extends StatelessWidget {
  final double opacity;
  final double sigmaXY;
  Color color;
  Mbl({super.key, this.sigmaXY = 0, this.opacity = 0, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaXY, sigmaY: sigmaXY),
        child: Opacity(
          opacity: opacity,
          child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: color,
              )),
        ),
      ),
    );
  }
}
