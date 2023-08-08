// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wallet/common/utils/log.dart';

/// 获取币价
Future<dynamic> getCoinPrice() async {
  const String apiUrl = 'https://min-api.cryptocompare.com/data/price';
  const String query =
      "fsym=BNB&tsyms=USD,JPY,EUR,CNY&api_key=cde28f237040379d697a33bfe487d3131023ec1b942a1aef73b5e99d8e16f5ff";

  final Uri uri = Uri.parse('$apiUrl?$query');
  try {
    final http.Response response = await http.post(
      uri,
    );

    if (response.statusCode == 200) {
      final String data = response.body;
      LLogger.d(data);
      return json.decode(data);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> getUSDTPrice() async {
  const String apiUrl = 'https://api.coingecko.com/api/v3/simple/price';
  const String tokenAddress =
      '0xeBd3f17eD1d756eD4Aa56608D0ab6aF94a9A85C3'; // USDT 在 BSC 上的地址

  final Map<String, String> queryParams = {
    'ids': 'tether',
    'vs_currencies': 'usd',
    'contract_addresses': tokenAddress,
  };

  final Uri uri = Uri.parse(apiUrl);
  try {
    final http.Response response =
        await http.get(uri.replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // double usdtPrice = data[tokenAddress]['usd'];
      print('Tether: \$ $data');
    }
  } catch (e) {
    print(e);
  }
}
