// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

class Dapp {
  // 导入助记词
  Future<void> importMnemonic(
      String mnemonic, String walletname, String password) async {
    // ... （之前的代码生成助记词的部分）

    // 生成钱包名称（用于标识钱包）
    String walletName = walletname;

    // 使用助记词创建种子值
    String seed = bip39.mnemonicToSeedHex(mnemonic);

    // 从种子值生成根私钥
    var root = bip32.BIP32.fromSeed(HEX.decode(seed) as Uint8List);

    // 从根私钥派生指定路径的子私钥
    var child = root.derivePath("m/44'/60'/0'/0/0");
    String privateKey = '0x' + HEX.encode(child.privateKey as Uint8List);

    // 生成凭证（Credentials）
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);

    // 提取地址（Ethereum Address）并进行EIP-55格式转换
    EthereumAddress address = await credentials.extractAddress();
    String mAddress = address.hexEip55;

    // 使用随机数生成新的钱包（Wallet）并转换为JSON格式的Keystore
    var random = Random();
    Wallet wallet = Wallet.createNew(credentials, password, random);
    String keystore = wallet.toJson();

    // 打印结果
    print('助记词: $mnemonic');
    print('钱包名称: $walletName');
    print('种子值: $seed');
    print('私钥: $privateKey');
    print('地址: $mAddress');
    print('Keystore: $keystore');
  }
}

var dapp = Dapp();
