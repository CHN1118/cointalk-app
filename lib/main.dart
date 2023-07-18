import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallet/common/utils/index.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/controller/precacheimg.dart';
import 'package:wallet/router/index.dart';
import 'package:wallet/translations/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //*初始化
  await GetStorage.init(); //*初始化本地存储
  Get.put(Controller()).setLanguage(); //*初始化语言
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
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
    return ScreenUtilInit(
      designSize: const Size(390, 844), //设计稿尺寸
      minTextAdapt: true, //字体缩放
      splitScreenMode: true, //分屏模式
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, //debug标签
          translations: Messages(), //翻译
          locale: Utils().getLanguage(), //语言
          fallbackLocale: const Locale('en', 'US'), //默认语言
          theme: ThemeData(
              highlightColor: Colors.transparent, //点击高亮颜色
              splashColor: Colors.transparent, //水波纹颜色
              buttonTheme: const ButtonThemeData(
                splashColor: Colors.transparent, // 按钮水波纹颜色
              ),
              primaryColor: Colors.black, //主题色
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black, //主题色
                primary: Colors.black, //主题色
              ),
              useMaterial3: true, //使用Material3
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                foregroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontFamily: 'MiSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )),
          initialRoute: '/startup',
          routingCallback: (routing) {},
          getPages: AppPages.pages,
        );
      },
      // child: const HomePage(title: 'First Method'),
    );
  }
}
