
import 'package:http/http.dart' as http;
import 'dart:convert';

const rpcUrl = 'http://localhost:7545';  // Ganache 默认 RPC 地址
const myAddress = 'YOUR_ETHEREUM_ADDRESS';  // 替换为您的地址

void scanBlocksForAddress(int startBlock, int endBlock, String address) async {
  for (int i = startBlock; i <= endBlock; i++) {
    final block = await getBlockByNumber(i);
    for (var transaction in block['transactions']) {
      if (transaction['from'] == address || transaction['to'] == address) {
        print('Transaction found in block $i: ${transaction['hash']}');
      }
    }
  }
}

Future<Map<String, dynamic>> getBlockByNumber(int blockNumber) async {
  final body = {
    'jsonrpc': '2.0',
    'method': 'eth_getBlockByNumber',
    'params': ['0x${blockNumber.toRadixString(16)}', true],
    'id': 1,
  };

  final response = await http.post(
    Uri.parse(rpcUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Failed to fetch block');
  }
}

void main() {
  scanBlocksForAddress(3, 23, myAddress);
}
