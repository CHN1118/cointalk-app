// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:wallet/database/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

class Dapp {
  // 助记词 生成钱包
  Future<Map<String, dynamic>> importMnemonic(
      String mnemonic, String walletname, String password,
      {bool active = false}) async {
    // ... （之前的代码生成助记词的部分）

    // 生成钱包名称（用于标识钱包）
    String walletName = walletname;

    // 使用助记词创建种子值
    String seed = bip39.mnemonicToSeedHex(mnemonic);

    // 从种子值生成根私钥
    var root = bip32.BIP32.fromSeed(HEX.decode(seed) as Uint8List);

    // 从根私钥派生指定路径的子私钥
    var child = root.derivePath("m/44'/60'/0'/0/0");
    String privateKey = HEX.encode(child.privateKey as Uint8List);

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
    return {
      'walletname': walletName, // 钱包名称
      'mnemonic': mnemonic, // 助记词
      'seed': seed, // 种子值
      'privatekey': privateKey, // 私钥
      'address': mAddress, // 地址
      'keystore': keystore, // Keystore
      'active': active, // 是否激活
    };
  }

  // keystore 生成钱包
  Future<void> importKetystore(
      String keystore, String walletname, String password) async {
    Wallet wallet = Wallet.fromJson(keystore, password);
    EthereumAddress address = await wallet.privateKey.extractAddress();
    String mAddress = address.hexEip55;
    String privateKey = bytesToHex(wallet.privateKey.privateKey);
    print("地址   ====   " + mAddress);
    print('解析keystore====     ' + keystore);
    print("私钥====     " + privateKey);
  }

  //导入私钥 生成钱包
  Future<void> importPrivate(
      String mprivate, String walletname, String password) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(mprivate);
    EthereumAddress address = await credentials.extractAddress();
    String mAddress = address.hexEip55;
    var random = Random.secure();
    Wallet wallet = Wallet.createNew(credentials, password, random);
    String keystore = wallet.toJson();
    print('私钥====     ' + mprivate);
    print("地址   ====   " + mAddress);
    print("keystore====     " + keystore);
  }
}

class Pbkdf2Parameters {}

var dapp = Dapp();

// 存储钱包信息的构造函数
class StoreWalletInformation {
  // 添加钱包信息
  addWalletInfo(Map<String, dynamic> walletInformation) {
    // 获取钱包信息数组
    var walletList = DB.box.read('WalletList') ?? [];
    // 判断钱包信息数组是已经存在该钱包
    var isExist = false;
    for (var i = 0; i < walletList.length; i++) {
      if (walletList[i]['address'] == walletInformation['address']) {
        isExist = true;
      }
    }
    // 添加钱包信息
    walletList.add(walletInformation);
    // 更新钱包信息数组
    DB.box.write('WalletList', walletList);
  }
}
