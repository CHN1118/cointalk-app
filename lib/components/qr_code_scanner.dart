// ignore_for_file: library_private_types_in_public_api, must_be_immutable, use_key_in_widget_constructors, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
// import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:redleaf/api/contact_api.dart';
// import 'package:redleaf/centre/centre.dart';
// import 'package:redleaf/common/global/global_url.dart';

// import 'package:redleaf/common/style/common_color.dart';
// import 'package:redleaf/common/utils/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet/components/click_wgt.dart';
// import 'package:redleaf/event/notify_event.dart';
// import 'package:redleaf/pages/Components/click_wgt.dart';
// import 'package:redleaf/pages/Components/toast_wgt.dart';
// import 'package:redleaf/pages/chat/chat_detail.dart';

class MyQRScannerWidget extends StatefulWidget {
  const MyQRScannerWidget({super.key});

  @override
  _MyQRScannerWidgetState createState() => _MyQRScannerWidgetState();
}

class _MyQRScannerWidgetState extends State<MyQRScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // final ubox = GetStorage(globalCentre.centreDB.box.read("userId").toString());
  AudioPlayer player = AudioPlayer();
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal, // 扫码速度
  );
  final picker = ImagePicker(); // 选择图片
  late File images; // 选择的图片

  Future getImage() async {
    // 从相册获取图片
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      images = File(pickedFile.path);
      final String data = await FlutterQrReader.imgScan(pickedFile.path);
      if (data != '') {
        if (data.contains('HY')) {
          var str = data.split(':');
          addContactPeople(str[1]);
        }
      } else {
        showSnackBar(msg: '请扫正确的二维码');
      }
    }
  }

  Future<bool?> showSnackBar({String? msg}) {
    return Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT, // 消息框持续的时间
        gravity: ToastGravity.TOP, // 消息框弹出的位置
        timeInSecForIosWeb: 1, // ios
        backgroundColor: const Color(0xffF2F8F5).withOpacity(1),
        textColor: const Color(0xff000000),
        fontSize: 14.sp);
  }

  void playSoundEffect() async {
    await player.play(AssetSource('/sound_effects/qrcode_didididi.mp3'));
  }

  @override
  void initState() {
    super.initState();
  }

  void addContactPeople(data) async {
    var searchPeople;
    // searchPeople = await contactApi().addContact(data);
    if (searchPeople.data['code'] == 0) {
      var data = searchPeople.data['data'];
      print('object${data}');
      if (data != null && data.isNotEmpty) {
        setState(() {});
        // if (data[0]['cid'] == box.read('cid')) {
        //   RedShowToast().error(context, '请勿扫自己的二维码');
        //   _controller.stop();
        //   //倒计时
        //   Future.delayed(Duration(seconds: 1), () {
        //     _controller.start();
        //   });
        //   return;
        // }
        // 倒计时
        Future.delayed(const Duration(seconds: 1), () {
          createFriend(data[0], data[0]['nickname']);
        });
      } else {
        showSnackBar(msg: '查无此账号');
      }
    }
  }

  createFriend(data, name) async {
    // ubox.write('consumer_' + data['cid'].toString(), jsonEncode(data));
    // var foundGroupChat = await contactApi().addGroupChat(data['cid']);
    // print(foundGroupChat);
    // if (foundGroupChat.data['data'] != null &&
    //     foundGroupChat.data['data'].isNotEmpty) {
    //   var channelInfo = foundGroupChat.data['data']['channel'];
    //   // 写入消息角标
    //   ubox.write('channelInfo_' + channelInfo['id'].toString(), channelInfo);
    //   var relation_all = foundGroupChat.data['data']['relation_all'];
    //   ubox.write('relation_all', relation_all);
    //   // print(ubox.read('channelInfo_' + channelInfo['id'].toString()));
    //   print('调用刷新同通讯录-----》');
    //   final EventBus eventBus = globalBus;
    //   eventBus.fire(NotifyEvent(msg: NKey.refresh_chat));
    //   eventBus.fire(NotifyEvent(msg: NKey.refresh_contact));
    //   playSoundEffect();
    //   _controller.stop();
    //   RedShowToast().success(context, '添加成功');
    //   //倒计时
    //   Future.delayed(Duration(seconds: 1), () async {
    //     final res = await Get.off(() => ChatDefault(), arguments: {
    //       'name': name,
    //       'channelId': channelInfo['id'],
    //     });
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand, //充满父容器
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                // 扫描结果
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != '') {
                    if (barcode.rawValue!.contains('HY')) {
                      var str = barcode.rawValue!.split(':');
                      addContactPeople(str[1]);
                    } else {
                      showSnackBar(msg: '请扫正确的二维码');
                      _controller.stop();
                      //倒计时
                      Future.delayed(const Duration(seconds: 1), () {
                        _controller.start();
                      });
                    }
                  }
                }
              },
            ),
            CustomBox(
              270.w,
              270.w,
            ),
            // Positioned(
            //     top: 156.w,
            //     child: Container(
            //       // margin: EdgeInsets.only(
            //       //     left: (getScreenWidth(context, 1) - 292.w) / 2),
            //       height: 292.w,
            //       width: 292.w,
            //       child: Stack(
            //         children: [
            //           Positioned(
            //             top: 0,
            //             left: 0,
            //             child: SizedBox(
            //               width: 73.5.w,
            //               height: 73.5.w,
            //               child: Image.asset('assets/images/tl.png'),
            //             ),
            //           ),
            //           Positioned(
            //             top: 0,
            //             right: 0,
            //             child: SizedBox(
            //               width: 73.5.w,
            //               height: 73.5.w,
            //               child: Image.asset('assets/images/tr.png'),
            //             ),
            //           ),
            //           Positioned(
            //             bottom: 0,
            //             left: 0,
            //             child: SizedBox(
            //               width: 73.5.w,
            //               height: 73.5.w,
            //               child: Image.asset('assets/images/bl.png'),
            //             ),
            //           ),
            //           Positioned(
            //             bottom: 0,
            //             right: 0,
            //             child: SizedBox(
            //               width: 73.5.w,
            //               height: 73.5.w,
            //               child: Image.asset('assets/images/br.png'),
            //             ),
            //           ),
            //         ],
            //       ),
            //     )),
            Positioned(
              top: 167.w,
              child: Container(
                height: 270.w,
                width: 270.w,
                margin: EdgeInsets.only(
                  left: 60.w,
                ),
                decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(.01),
                    borderRadius: BorderRadius.all(Radius.circular(20.w))),
                child: SizedBox(
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                        child: QRCodeScannerAnimation())),
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white), //修改返回按钮颜色
            ),
            Positioned(
              top: 640.h,
              left: 150.w,
              child: ClickWidget(
                onTap: () {
                  getImage();
                },
                type: ClickType.debounce, //防抖
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12.w),
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff31302e).withOpacity(.8),
                        borderRadius: BorderRadius.all(Radius.circular(35.w)),
                      ),
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        color: Colors.transparent,
                        child: Center(
                            child: SvgPicture.asset(
                          'assets/svgs/a-Instagramline.svg',
                          width: 30.w,
                        )),
                      ),
                    ),
                    Text(
                      '从相册中选择',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 镂空组件
class CustomBox extends SingleChildRenderObjectWidget {
  const CustomBox(this.cutWidth, this.cutHeight, {super.child, super.key});

  final double cutWidth; // 镂空宽度
  final double cutHeight; // 镂空高度

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCustomBox(cutWidth: cutWidth, cutHeight: cutHeight);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderCustomBox)
      ..cutWidth = cutWidth // 更新镂空宽度
      ..cutHeight = cutHeight; // 更新镂空高度
  }
}

class _RenderCustomBox extends RenderProxyBoxWithHitTestBehavior {
  _RenderCustomBox({required double cutWidth, required double cutHeight})
      : _cutWidth = cutWidth, // 镂空宽度
        _cutHeight = cutHeight, // 镂空高度
        super(behavior: HitTestBehavior.opaque); // 设置点击透传

  double get cutWidth => _cutWidth; // 获取镂空宽度

  double _cutWidth; // 镂空宽度

  set cutWidth(double value) {
    // 设置镂空宽度
    if (value == _cutWidth) {
      return;
    }
    _cutWidth = value;
    markNeedsPaint();
  }

  double get cutHeight => _cutHeight;
  double _cutHeight;

  set cutHeight(double value) {
    if (value == _cutHeight) {
      return;
    }
    _cutHeight = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    super.performLayout();
    //size 为全屏
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final inner = Size(_cutWidth, _cutHeight); //* 镂空区域大小

    final innerOffset = Offset((size.width - _cutWidth) / 2, 167.h); //* 镂空区域偏移

    final borderRadius = BorderRadius.circular(20.w); //* 镂空区域的圆角半径

    final rrect = RRect.fromRectAndCorners(innerOffset & inner, //* 镂空区域大小
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight);

    context.canvas.saveLayer(null, Paint()); // 暂存当前画布
    context.canvas.drawRect(
        offset & size, // 绘制全屏
        Paint()..color = Colors.black.withOpacity(0.85) // 设置为透明颜色
        );

    context.canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.black.withOpacity(1) // 画笔颜色，可根据需要调整透明度
        ..blendMode = BlendMode.dstOut, // 设置为dstOut模式，目的是抠出镂空区域
    );
    context.canvas.restore();

    if (child != null) {
      context.paintChild(child!, innerOffset); // 绘制子组件
    }
  }
}

//* 扫描动画
class QRCodeScannerAnimation extends StatefulWidget {
  @override
  _QRCodeScannerAnimationState createState() => _QRCodeScannerAnimationState();
}

class _QRCodeScannerAnimationState extends State<QRCodeScannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween(begin: -0.1, end: 1.1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: false); //重复执行动画
    //结束动画
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; //屏幕宽度
    double lineHeight = 80.w; //扫描线高度

    return CustomPaint(
      painter: QRCodeScannerPainter(
        animationValue: _animation.value,
        lineWidth: lineHeight,
      ),
      child: SizedBox(
        width: screenWidth,
        height: lineHeight,
      ),
    );
  }
}

class QRCodeScannerPainter extends CustomPainter {
  final double animationValue;
  final double lineWidth;

  QRCodeScannerPainter({
    required this.animationValue,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height * animationValue;

    // 定义渐变色
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.decal,
      colors: [
        const Color(0xffFC86AB).withOpacity(0),
        const Color(0xffFC86AB).withOpacity(0.2),
      ],
    );

    // 创建渐变色画笔
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, centerY - lineWidth / 2, size.width, lineWidth / 2),
      )
      ..strokeWidth = lineWidth;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(QRCodeScannerPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
