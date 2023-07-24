// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/widgets/browser/index.dart';

import 'package:wallet/widgets/mine/wallets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

//&我的
class Mymine extends StatefulWidget {
  const Mymine({super.key});

  @override
  State<Mymine> createState() => _MymineState();
}

class _MymineState extends State<Mymine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 62.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '我的',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 124.h),
              padding: EdgeInsets.only(left: 22.w, right: 25.w),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      //跳转到钱包管理 WalletMan
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WalletMan()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 18.w),
                              child: SvgPicture.asset(
                                'assets/svgs/24gf-wallet.svg', // 设置SVG图标的路径
                                width: 25.w,
                                // height: 22.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff7F8391),
                              ),
                            ),
                            Text(
                              '钱包管理',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xff000000)),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                          width: 18.w,
                          // height: 22.w,
                          // ignore: deprecated_member_use
                          color: const Color(0xff7F8391),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 16.h, bottom: 11.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.w,
                            color: const Color(0xffE5E5E5),
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      //跳转到个人资料 PersonalData
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PersonalData()));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 18.w),
                              child: SvgPicture.asset(
                                'assets/svgs/my-mine.svg', // 设置SVG图标的路径
                                width: 24.w,
                                // height: 22.w,
                                // ignore: deprecated_member_use
                                color: const Color(0xff7F8391),
                              ),
                            ),
                            Text(
                              '个人资料',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xff000000)),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                          width: 18.w,
                          // height: 22.w,
                          // ignore: deprecated_member_use
                          color: const Color(0xff7F8391),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 16.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.w,
                            color: const Color(0xffE5E5E5),
                          ),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}

//&个人资料 PersonalData
class PersonalData extends StatefulWidget {
  const PersonalData({
    super.key,
  });

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  @override
  void initState() {
    super.initState();
    // initCamera(); //初始化相机
  }

  @override
  void dispose() {
    _disposeVideoController(); //释放相机
    maxWidthController.dispose(); //释放控制器
    maxHeightController.dispose(); //释放控制器
    qualityController.dispose(); //释放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '个人资料',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //网络图片
                InkWell(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 35.h),
                      width: 45.w,
                      height: 45.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.w),
                        child: const Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://wx2.sinaimg.cn/mw690/007TYxG2ly1hbwxeuuambj328k3m0u12.jpg',
                            )),
                      )),
                ),
              ],
            ),
          ],
        ),
        //昵称
        Container(
          margin: EdgeInsets.only(top: 115.h, left: 22.w, right: 21.w),
          padding: EdgeInsets.only(bottom: 10.w, left: 9.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.w,
                color: const Color(0xffDCDCDC),
              ),
            ),
          ),
          child: InkWell(
            onTap: () {
              //  跳转到编辑名字 EditorPage
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EditorPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '名字',
                  style: TextStyle(fontSize: 16.sp),
                ),
                Row(
                  children: [
                    Text(
                      'dejavu',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 19.w, top: 6.w),
                      child: SvgPicture.asset(
                        'assets/svgs/arrow_right.svg', // 设置SVG图标的路径
                        width: 16.w,
                        // height: 22.w,
                        // ignore: deprecated_member_use
                        color: const Color(0xff7F8391),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 65.w,
          left: 212.w,
          child: InkWell(
            onTap: () {
              _showBottomSheet(context);
            },
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: SvgPicture.asset(
                'assets/svgs/paishe_A_Facet.svg', // 设置SVG图标的路径
                width: 25.w,
                // height: 22.w,
                // ignore: deprecated_member_use
                color: const Color(0xff7F8391),
              ),
            ),
          ),
        ),
      ]),
    );
  }

//&打开相册选择图片
  final picker = ImagePicker(); // 选择图片
  List<File> images = []; // 选择的图片
  Future getImage() async {
    // 从相册获取图片
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        images.add(File(pickedFile.path)); // 将选择的图片添加到 images 列表中
      }
    });
  }

  //&底部弹窗--------------------------------------------------------------------------------
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, //设置为true，此时将会跟随键盘的弹出而弹出
      backgroundColor: const Color(0xffF2FfFc),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0), // 设置顶部圆角半径为 16.0
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 11.w),
          height: 140.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  _picker.pickImage(source: ImageSource.camera);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 7.h),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('拍照', style: TextStyle(color: Color(0xff1C59F3)))
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 7.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.w,
                        color: const Color(0xff7F8391).withOpacity(0.5),
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  setState(() {
                    Navigator.pop(context); //关闭弹窗
                    getImage();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7.h, bottom: 7.h),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '相册',
                        style: TextStyle(color: Color(0xff1C59F3)),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 7.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.w,
                        color: const Color(0xff7F8391).withOpacity(0.5),
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7.h, bottom: 7.h),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '取消',
                        style: TextStyle(color: Color(0xffB4B4B4)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//&相机--------------------------------------------------------------------------------

  void _setImageFileListFromFile(XFile? value) {}

  bool isVideo = false; //是否是视频

  VideoPlayerController? _controller; //相机
  VideoPlayerController? _toBeDisposed; //释放相机

  final ImagePicker _picker = ImagePicker(); // 选择图片
  final TextEditingController maxWidthController =
      TextEditingController(); //图片宽度
  final TextEditingController maxHeightController =
      TextEditingController(); //图片高度
  final TextEditingController qualityController =
      TextEditingController(); //图片质量

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController(); //释放相机
      late VideoPlayerController controller; //相机
      if (kIsWeb) {
        // TODO(gabrielokura): remove the ignore once the following line can migrate to
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(file.path); //相机
      } else {
        controller = VideoPlayerController.file(File(file.path)); //相机
      }
      _controller = controller; //相机

      const double volume = kIsWeb ? 0.0 : 1.0; //设置音量
      await controller.setVolume(volume); //设置音量
      await controller.initialize(); //初始化相机
      await controller.setLooping(true); //设置循环
      await controller.play(); //播放相机
      setState(() {}); //刷新页面
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {}
        });
      }
    }
  }

//&选择图片弹窗
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {super.key});

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}

//&
//&
//&
//&编辑资料页面 Editor
class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // 在页面打开时自动获取焦点
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); //释放 focusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              showSnackBar(msg: '编辑成功');
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 22.w),
              child: Text(
                '保存',
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          ),
        ],
        title: Text(
          '编辑资料',
          style: TextStyle(fontSize: 20.sp),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 9.w),
            child: Center(
              child: Text(
                '取消',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xff000000).withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 7.w),
        margin: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1.w,
          color: const Color(0xffE5E5E5),
        ))),
        child: Container(
          padding: EdgeInsets.only(left: 17.w),
          child: TextField(
            focusNode: _focusNode, // 将输入框与焦点关联
            autofocus: true, // 自动获取焦点
            cursorColor: const Color(0xff000000).withOpacity(0.5), //设置光标颜色
            strutStyle: StrutStyle.fromTextStyle(
                TextStyle(fontSize: 25.0.w, height: 0.8.w)),
            style: TextStyle(fontSize: 14.0.w), //设置字体大小
            cursorHeight: 18.sp, //设置光标高度
            cursorRadius: const Radius.circular(10), // 设置光标圆角半径
            textAlignVertical: TextAlignVertical.center, // 将光标居中
            decoration: InputDecoration(
              isCollapsed: true, //去除内边距
              contentPadding: EdgeInsets.all(0.w), //*去除内边距
              border: InputBorder.none,
            ),
            // 添加 onSubmitted 回调处理用户按下键盘上的搜索按钮的事件
            onSubmitted: (value) {},
            // 添加 onChanged 回调处理用户输入的内容
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}