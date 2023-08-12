import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';

import '../../common/utils/toast_print.dart';
import '../../common/utils/log_view.dart';

/// 拦截器发送访问令牌
class HttpLongInterceptor extends Interceptor {
  HttpLongInterceptor();
  static final box = GetStorage();
  // static final box = globalCentre.centreDB.box;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 创建一个路径列表，这些不需要token
    final listOfPaths = <String>['/xxx', '/yyy'];
    // 检查如果请求端点匹配
    if (listOfPaths.contains(options.path.toString())) {
      // 如果端点匹配然后跳到追加令牌
      return handler.next(options);
    }

    // 加载IM token 到header
    var imtoken = box.read('im_token') ?? "";
    options.headers.addAll({"im_token": imtoken});

    // 加载令牌到 header
    var token = box.read('token') ?? "";
    options.headers.addAll({"token": token});
    print("当前用户的token:${token}");
    print("当前用户的imtoken:${imtoken}");
    return handler.next(options);
  }

  // 响应或错误时执行一些动作
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogView.logger.i(
      "请求接口: ${response.realUri}\n"
      "请求状态: ${response.statusCode}\n"
      "请求参数: ${response.requestOptions.data}\n"
      "请求结果: ${response.data}",
    );
    if (response.statusCode == 200) {
      if (response.data["code"] == -1) {
        print("$response");
        print("${response.data}");
        var message_zh = response.data["data"]["message_zh"];
        if (message_zh != null && message_zh != "") {
          // Fluttertoast.showToast(msg: message_zh, gravity: ToastGravity.CENTER);
          ToastPrint.messageFailToast(response.data);
        }
        // ToastPrint.messageFailToast(response.data);
      }
      if (response.data["code"] == -2) {
        ToastPrint.show("登录过期，请重新登录");
        getx.Get.offAllNamed("/importwallet");
        box.remove('token');
        box.remove('imToken');
        box.remove('userId');
      }
      return handler.next(response);
    } else {
      throw Exception("服务异常");
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // if (err.type == DioExceptionType.unknown || err.type == DioExceptionType.connectionTimeout) {
    //   LogView.loggerDetail.d("未知异常: ${err}");
    // } else {
    LogView.loggerDetail.e("异常: ${err}");
    await Future.delayed(Duration(seconds: 5));
    // ToastPrint.show("服务异常，请稍后重试");
    return handler.next(err);
  }
}
