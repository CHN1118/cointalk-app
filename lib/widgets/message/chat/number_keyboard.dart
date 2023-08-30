import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumberKeyboard extends StatefulWidget {
  final Function(String) onTap;
  final Function()? onCommit;
  final Function()? onDel;
  final String confirmText;
  final Color confirmBgColor;
  final Color confirmColor;

  NumberKeyboard({
    required this.onTap,
    this.onCommit,
    this.onDel,
    this.confirmText = "转账",
    this.confirmBgColor = const Color(0xFFE6E6E6),
    this.confirmColor = const Color(0xFF0563B6),
  });

  @override
  _NumberKeyboardState createState() => _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> {
  final itemHeight = Get.height * 0.08;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          // curve: Curves.easeInOut,
          curve: Cubic(0.160, 0.265, 0.125, 0.995),
          duration: Duration(milliseconds: 360),
          child: Positioned(
            bottom: 0,
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Colors.grey[200],
                child: Container(
                  // padding: EdgeInsets.only(bottom: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            NumberButton(
                              value: '1',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '2',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '3',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '4',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '5',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '6',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '7',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '8',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '9',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '0',
                              onTap: widget.onTap,
                            ),
                            NumberButton(
                              value: '.',
                              onTap: widget.onTap,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 75.w,
                            height: itemHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey, width: 0.25.w),
                              ),
                              child: MaterialButton(
                                color: Color(0xFFE6E6E6),
                                onPressed: widget.onDel,
                                child: Image.asset(
                                  "assets/images/keyboard_delete.png",
                                  width: 29.w,
                                  height: 19.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 75.w,
                            height: itemHeight * 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey, width: 0.25.w),
                              ),
                              child: MaterialButton(
                                onPressed: widget.onCommit,
                                child: Text(
                                  widget.confirmText,
                                  style: TextStyle(
                                    color: widget.confirmColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: widget.confirmBgColor,
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  final String value;
  final Function(String) onTap;

  const NumberButton({
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (value == "0") {
      return Material(
        color: Color(0xFFE6E6E6),
        child: Ink(
          child: InkWell(
            onTap: () => onTap(value),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.25.w),
              ),
              alignment: Alignment.center,
              height: Get.height * 0.08,
              width: (MediaQuery.of(context).size.width - 75.w) / 1.5,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Color(0xFFE6E6E6),
        child: Ink(
          child: InkWell(
            onTap: () => onTap(value),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.25.w),
              ),
              alignment: Alignment.center,
              height: Get.height * 0.08,
              width: (MediaQuery.of(context).size.width - 75.w) / 3,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

// class CustomKeyboardPage extends StatefulWidget {
//   @override
//   _CustomKeyboardPageState createState() => _CustomKeyboardPageState();
// }
//
// class _CustomKeyboardPageState extends State<CustomKeyboardPage> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Keyboard'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _textEditingController,
//             focusNode: _focusNode,
//             decoration: InputDecoration(
//               hintText: 'Enter text',
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Container(
//                       height: 268, // 设置底部菜单的高度
//                       child: NumberKeyboard(
//                         confirmText: '转账',
//                         confirmColor: Color(0xFFE6E6E6),
//                         confirmBgColor: Color(0xFF0563B6),
//                         onTap: (value) {
//                           final currentValue = _textEditingController.text;
//                           final newValue = '$currentValue$value';
//                           setState(() {
//                             _textEditingController.text = newValue;
//                           });
//                         },
//                         onCommit: () {
//                           // 处理回车按键的逻辑
//                         },
//                         onDel: () {
//                           // 处理删除按键的逻辑
//                         },
//                       ));
//                 },
//               );
//             },
//             child: Text('Open Keyboard'),
//           ),
//         ],
//       ),
//     );
//   }
// }
