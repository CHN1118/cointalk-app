// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class OpClick extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double initialOpacity;
  final double tapOpacity;
  final Color tapColor;

  const OpClick({
    super.key,
    required this.child,
    this.onTap,
    this.initialOpacity = 1.0,
    this.tapOpacity = 0.5,
    this.tapColor = Colors.transparent,
  });

  @override
  _OpClickState createState() => _OpClickState();
}

class _OpClickState extends State<OpClick> {
  bool hasPanStarted = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      hasPanStarted = true; // 重置滑动标志
    });
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        hasPanStarted = false; // 重置滑动标志
      });
    });
    setState(() {});
    if (!hasPanStarted && widget.onTap != null) {
      // 如果滑动标志为false（即没有滑动），则触发事件
      widget.onTap!();
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      hasPanStarted = true; // 设置滑动标志为true
    });
  }

  Future<void> _onPanUpdate(DragUpdateDetails details) async {
    // 如果发生滑动，取消触发事件
    if (hasPanStarted) {
      await Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          hasPanStarted = false; // 重置滑动标志
        });
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, // 处理按下事件
      onTapUp: _onTapUp,
      onTapCancel: () {
        setState(() {
          hasPanStarted = false; // 重置滑动标志
        });
      },
      onPanStart: _onPanStart, // 处理滑动事件
      onPanUpdate: _onPanUpdate, // 处理滑动事件
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 0),
        opacity: hasPanStarted ? widget.tapOpacity : widget.initialOpacity,
        child: widget.child,
      ),
    );
  }
}
