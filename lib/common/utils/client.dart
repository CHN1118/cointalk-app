// ignore_for_file: non_constant_identifier_names

import 'package:wallet/common/utils/symbol_arr.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/database/index.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class Client {
  /// *获取当前网络的信息
  var client = Web3Client(
      blockchainInfo.where((element) => element['active'] == true).toList()[0]
          ['rpcUrl'][0],
      http.Client());

  /// *获取当前用户的地址
  EthereumAddress address = EthereumAddress.fromHex(DB.box
      .read('WalletList')
      .firstWhere((e) => e['active'] == true)['address']);

  /// *获取当前账户是否开启生物识别
  bool isEBV =
      DB.box.read('WalletList').firstWhere((e) => e['active'] == true)['isEBV'];

  /// *计算gas
  Map<dynamic, dynamic> calculateGasFee({
    required var amount, // 交易金额，以 Wei 为单位
  }) {
    int gasPriceWei = 2000000000; // 以 Wei 为单位的 gas 价格
    int gasLimit = 21000; // gas 上限

    // 计算燃料费用（以 Wei 为单位）
    BigInt gasFeeWei = BigInt.from(gasPriceWei) * BigInt.from(gasLimit);

    // 计算交易金额（以 Wei 为单位）我输入的时没有添加18个0，所以这里要乘以10的18次方，最好在后面添加18个0
    BigInt amountWei = BigInt.from(amount) * BigInt.from(10).pow(18);

    // 计算实际到账金额（以 Wei 为单位）
    BigInt actualAmountReceivedWei = amountWei - gasFeeWei;

    // 假设 ETH 兑换率为 3000 美元
    double ethToUsdRate = C.usdprice.value;

    // 转换 actualAmountReceivedWei 为 ETH
    double actualAmountReceivedEth =
        actualAmountReceivedWei / BigInt.from(10).pow(18);

    // 将 actualAmountReceivedEth 转换为美元
    double actualAmountReceivedUsd = actualAmountReceivedEth * ethToUsdRate;

    print('燃料费用（Wei）: ${gasFeeWei / BigInt.from(10).pow(18)}');
    print('实际到账金额（Wei）: $actualAmountReceivedWei');
    print('实际到账金额（ETH）: $actualAmountReceivedEth');
    print('实际到账金额（美元）: $actualAmountReceivedUsd');

//gasFeeWei 除以 10 的 18 次方，就是 gasFeeEth

    return {
      'gasFeeWei': gasFeeWei / BigInt.from(10).pow(18),
      'Wei': actualAmountReceivedWei,
      'Eth': actualAmountReceivedEth,
      'Usd': actualAmountReceivedUsd,
    };
  }
}

var CL = Client();
