// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallet/common/utils/log.dart';

class CustomHttpClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  CustomHttpClient({required this.baseUrl, this.defaultHeaders = const {}});

  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, String>? additionalHeaders}) async {
    _requestInterceptor();

    Map<String, String> allHeaders = {...defaultHeaders};
    if (additionalHeaders != null) {
      allHeaders.addAll(additionalHeaders);
    }

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: allHeaders,
      body: data,
    );

    _responseInterceptor(response);
    var result = json.decode(response.body);
    return result;
  }

  void _requestInterceptor() {
    // print("POST request is being sent");
    // 这里可以加入你的请求拦截逻辑，例如添加或修改 headers、记录日志等
  }

  void _responseInterceptor(http.Response response) {
    if (response.statusCode == 200) {
      // LLogger.d(response.body);
    }
    // 这里可以添加你的响应拦截逻辑，例如检查状态码、处理特定的响应、记录日志等
  }
}

final request = CustomHttpClient(
  baseUrl: 'http://192.168.1.73:3010/app/',
);
