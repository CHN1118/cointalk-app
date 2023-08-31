import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:wallet/database/index.dart';
import '../../common/global/global_url.dart';
import '../../common/utils/loading_animation.dart';
import '../../common/utils/log_view.dart';
import '../../common/utils/toast_print.dart';
import '../../event/notify_event.dart';

/// 拦截器发送访问令牌
class HttpInterceptor extends Interceptor {
  HttpInterceptor();
  static final box = GetStorage();
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
    // 加载令牌到 header
    var token = DB.box.read('token') ?? "";
    print('------------------------>token');
    print(token);
    options.headers.addAll({"token": token['token']});
    var im_token = box.read('im_token') ?? "";
    options.headers.addAll({"im_token": im_token});
    //宇航
    //  options.headers.addAll({'token': "test123123123test123123123"});
    //西子
    // options.headers.addAll({'token':"fC2TbXokEab5E5X1LVvkM0MWThpJ2jVKzQxJruBtHKnlZ45QkKURtIVKSEVTxNcQ"});
    //print("-"*30);
    //print("\n 请求头信息==${options.headers}------\n 请求接口URL：${options.baseUrl+options.path}\n 请求参数：${options.data}");
    //print("-"*30);
    return handler.next(options);
  }

  // 响应或错误时执行一些动作
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogView.logger.i(
        "请求接口: ${response.realUri}\n请求状态: ${response.statusCode}\n请求参数: ${response.requestOptions.data}\n请求结果: ${response.data}");
    if (response.statusCode == 200) {
      if (response.data["code"] == -1) {
        LoadingAnimation.hide();
        // 接口报错统一弹窗
        // var message_zh = response.data["data"]["message_zh"];
        // ToastPrint.show(message_zh);
        ToastPrint.messageFailToast(response.data);

        return;
      }
      if (response.data["code"] == -2) {
        LoadingAnimation.hide();
        // token 失效
        globalBus.fire(NotifyEvent(msg: NKey.token_invalid));
        return;
      }
      return handler.next(response);
    } else {
      throw Exception("服务异常");
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      return handler.next(err);
    } else {
      LogView.loggerDetail.e("异常: ${err}");
      ToastPrint.show("service_exception".tr);
    }
    LoadingAnimation.hide();
    return handler.next(err);
  }
}
