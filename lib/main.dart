import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/index.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/controller/precacheimg.dart';
import 'package:wallet/router/index.dart';
import 'package:wallet/translations/index.dart';

void main() async {
  WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized(); //*初始化
  await GetStorage.init(); //*初始化本地存储
  Get.put(Controller()).setLanguage(); //*初始化语言
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); //*启动图
  initialization(null); //*启动图延时移除
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

//启动图延时移除方法
void initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3)); //延迟3秒
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    precacheImg().getImg(context); //预加载图片
    isFullScreen(context); //判断是否全屏
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    EasyLoading.instance
      ..progressColor = AppTheme.themeColor.withOpacity(.8)
      ..backgroundColor = Colors.white
      ..indicatorColor = AppTheme.themeColor.withOpacity(.8)
      ..textColor = AppTheme.themeColor.withOpacity(.8)
      ..loadingStyle = EasyLoadingStyle.custom;
    return ScreenUtilInit(
      designSize: const Size(390, 844), //设计稿尺寸
      minTextAdapt: true, //字体缩放
      splitScreenMode: true, //分屏模式
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, //debug标签
          translations: Messages(), //翻译
          locale: utils.getLanguage(), //语言
          fallbackLocale: const Locale('en', 'US'), //默认语言
          builder: EasyLoading.init(),
          theme: ThemeData(
              highlightColor: Colors.transparent, //点击高亮颜色
              splashColor: Colors.transparent, //水波纹颜色
              buttonTheme: const ButtonThemeData(
                splashColor: Colors.transparent, // 按钮水波纹颜色
              ),
              primaryColor: Colors.white,
              useMaterial3: true, //使用Material3
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                foregroundColor: Colors.black,
                titleTextStyle: TextStyle(
                  fontFamily: 'MiSans',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black, //主题色
                primary: Colors.black, //主题色
              ).copyWith(background: Colors.white)),
          initialRoute: '/importwallet',
          routingCallback: (routing) {},
          getPages: AppPages.pages,
        );
      },
      // child: const HomePage(title: 'First Method'),
    );
  }
}
