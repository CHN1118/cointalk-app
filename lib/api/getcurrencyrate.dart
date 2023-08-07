import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wallet/common/utils/log.dart';

Future<dynamic> getCoinPrice() async {
  const String apiUrl = 'https://min-api.cryptocompare.com/data/price';
  const String query =
      "fsym=ETH&tsyms=USD,JPY,EUR,CNY&api_key=cde28f237040379d697a33bfe487d3131023ec1b942a1aef73b5e99d8e16f5ff";

  final Uri uri = Uri.parse('$apiUrl?$query');
  final http.Response response = await http.post(
    uri,
  );

  if (response.statusCode == 200) {
    print(response.statusCode);
    print(json.decode(response.body));
    final String data = response.body;
    LLogger.d(data);
    return json.decode(data);
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
