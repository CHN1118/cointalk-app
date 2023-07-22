import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:wallet/controller/index.dart';

class Splash extends StatelessWidget {
  Splash({super.key});
  final Controller c = Get.find(); //*获取控制器

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove(); //*移除启动页
    return Scaffold(
      body: Container(
        color: Colors.pink,
        child: Center(
            child: InkWell(
                onTap: () {
                  c.changeLanguage();
                },
                child: Text('login_nation'.tr,
                    style: const TextStyle(color: Colors.black)))),
      ),
    );
  }
}
