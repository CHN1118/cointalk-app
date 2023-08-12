import 'package:dio/dio.dart';

import '../common/global/global_url.dart';
import 'interceptor/interceptor.dart';
import 'interceptor/long_interceptor.dart';

class DioUtil {
  static Dio init() {
    BaseOptions options = BaseOptions(
        baseUrl: Global.serviceUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        //请求Json数据
        responseType: ResponseType.json //响应数据为json
        );
    Dio dio = Dio(options)..interceptors.add(HttpInterceptor());
    return dio;
  }

  // IM Dio
  static Dio initIM() {
    BaseOptions options = BaseOptions(
        baseUrl: Global.serviceIMUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 60),
        contentType: Headers.jsonContentType,
        //请求Json数据
        responseType: ResponseType.json //响应数据为json
    );

    Dio dio = Dio(options)..interceptors.add(HttpLongInterceptor());
    return dio;
  }

  // syncDB Dio
  static Dio initSyncDB() {
    BaseOptions options = BaseOptions(
        baseUrl: Global.syncUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        //请求Json数据
        responseType: ResponseType.json //响应数据为json
    );
    Dio dio = Dio(options)..interceptors.add(HttpLongInterceptor());
    return dio;
  }

  static Dio initFormData() {
    BaseOptions options = BaseOptions(
        baseUrl: Global.serviceUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 30),
        contentType: Headers.multipartFormDataContentType,
        responseType: ResponseType.json //响应数据为json
    );
    Dio dio = Dio(options)..interceptors.add(HttpInterceptor());
    return dio;
  }
}
