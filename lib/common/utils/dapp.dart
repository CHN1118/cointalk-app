// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings, depend_on_referenced_packages
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as material;
import 'package:wallet/common/utils/log.dart';
import 'package:wallet/common/utils/symbol_arr.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/database/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;

class Dapp {
  /// 助记词 生成钱包
  Future<dynamic> importMnemonic(
      String mnemonic, String walletname, String password, bool isEBV,
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
    return {
      'walletname': walletName, // 钱包名称
      'address': mAddress, // 地址
      'active': active, // 是否激活
      'mnemonic': mnemonic, // 助记词
      'isEBV': isEBV, // 是否开启生物识别
      'keystore': keystore, // Keystore
      'password': password, // 钱包密码
    };
  }

  /// keystore 生成钱包
  Future<dynamic> importKetystore(
      String keystore, String walletname, String password, bool isEBV,
      {bool active = false}) async {
    try {
      Wallet wallet = Wallet.fromJson(keystore, password);
      EthereumAddress address = await wallet.privateKey.extractAddress();
      String mAddress = address.hexEip55;
      String privateKey = bytesToHex(wallet.privateKey.privateKey);
      LLogger.i("\n地址          ====>   " +
          mAddress +
          "\n私钥          ====>   " +
          privateKey +
          "\nkeystore     ====>   " +
          keystore);
      return {
        'walletname': walletname, // 钱包名称
        'address': mAddress, // 地址
        'active': active, // 是否激活
        'mnemonic': '', // 助记词
        'isEBV': isEBV, // 是否开启生物识别
        'keystore': keystore, // Keystore
        'password': password, // 钱包密码
      };
    } catch (e) {
      LLogger.e('导入KeyStroe: ========> 您提供了错误的密码或文件已损坏 !!!');
      return null;
    }
  }

  ///导入私钥 生成钱包
  Future<dynamic> importPrivate(
      String mprivate, String walletname, String password, bool isEBV,
      {bool active = false}) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(mprivate);
    EthereumAddress address = await credentials.extractAddress();
    String mAddress = address.hexEip55;
    var random = Random.secure();
    Wallet wallet = Wallet.createNew(credentials, password, random);
    String keystore = wallet.toJson();
    return {
      'walletname': walletname, // 钱包名称
      'address': mAddress, // 地址
      'active': active, // 是否激活
      'mnemonic': '', // 助记词
      'isEBV': isEBV, // 是否开启生物识别
      'keystore': keystore, // Keystore
      'password': password, // 钱包密码
    };
  }

  /// 通过密码加密 明文
  String encryptString(String plainText, String password) {
    String psw = '';
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    if (password.length < 32) {
      psw = (password + timestamp).length < 32
          ? (password + timestamp).padRight(32, ' ')
          : (password + timestamp).substring(0, 32);
    } else {
      // 截取钱19位加上时间戳
      psw = password.substring(0, 19) + timestamp;
    }
    final key = Key.fromUtf8(psw);
    final iv = IV.fromLength(16); // 使用AES算法需要一个16字节的初始化向量(IV)

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv); //iv 为初始化向量

    return encrypted.base64 + '@$timestamp'; // 将加密结果转换为Base64格式返回
  }

  /// 通过密码解密 密文
  String decryptString(String encryptedString, String password) {
    String psw = '';
    var timestamp = encryptedString.split('@')[1];
    if (password.length < 32) {
      psw = (password + timestamp).length < 32
          ? (password + timestamp).padRight(32, ' ')
          : (password + timestamp).substring(0, 32);
    } else {
      // 截取钱19位加上时间戳
      psw = password.substring(0, 19) + timestamp;
    }
    final key = Key.fromUtf8(psw);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = Encrypted.fromBase64(encryptedString.split('@')[0]);

    try {
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      LLogger.e('解密失败');
      return '';
    }
  }

  /// 获取余额
  connect() async {
    var apiUrl =
        blockchainInfo.where((element) => element['active'] == true).toList();
    EthereumAddress address =
        EthereumAddress.fromHex(C.currentWallet['address']);
    print(apiUrl);
    var client = Web3Client(apiUrl[0]['rpcUrl'][0], http.Client());
    EtherAmount balance = await client.getBalance(address);
    print(balance.getValueInUnit(EtherUnit.ether));
  }

  /// 转账
  Future<dynamic> transfer() async {
    var apiUrl =
        blockchainInfo.where((element) => element['active'] == true).toList();
    EthereumAddress address =
        EthereumAddress.fromHex(C.currentWallet['address']);
    var client = Web3Client(apiUrl[0]['rpcUrl'][0], http.Client());
    EtherAmount balance = await client.getBalance(address);
    var keystore = decryptString(C.currentWallet['keystore'], 'Chn1023.');
    Wallet wallet = Wallet.fromJson(keystore, 'Chn1023.');
    Credentials credentials =
        EthPrivateKey.fromHex(HEX.encode(wallet.privateKey.privateKey));

    BigInt amountInWei =
        BigInt.from(100000000000000000); // 以太币的最小单位 Wei，这里表示转 1 ETH
    BigInt gasPriceInWei =
        BigInt.from(20000000000); // 1 Gwei (1e9 Wei) 作为 gasPrice
    int gasLimit = 6721975; // gasLimit 是执行交易所需的 gas 数量，一般情况下转账的固定值为 21000

    Transaction transaction = Transaction(
      to: EthereumAddress.fromHex(
          '0xc645fF291d18203B0F6D2622656B5F894c44641d'), // 接收地址
      gasPrice: EtherAmount.inWei(gasPriceInWei), // gasPrice
      maxGas: gasLimit, // gasLimit
      value: EtherAmount.inWei(amountInWei), // 转账金额
    );
    var signedTransaction =
        await client.signTransaction(credentials, transaction, chainId: 1337);
    var res = await client.sendRawTransaction(signedTransaction);
    print(res);
    print(balance.getValueInUnit(EtherUnit.ether));
    //交易回调定时
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      var receipt = await client.getTransactionReceipt(res);
      print(receipt?.status);
      if (receipt != null) {
        timer.cancel();
        print(receipt);
      }
    });
  }

 
}

var dapp = Dapp();

// 存储钱包信息的构造函数
class StoreWalletInformation {
  /// 加密后 存储钱包信息
  Future<dynamic> addWalletInfo(material.BuildContext context,
      Map<String, dynamic> walletInformation) async {
    // 获取钱包信息数组
    var walletList = DB.box.read('WalletList') ?? [];
    // 判断钱包信息数组是已经存在该钱包
    var isExist = false;
    for (var i = 0; i < walletList.length; i++) {
      if (walletList[i]['address'] == walletInformation['address']) {
        isExist = true;
      }
    }
    if (isExist) {
      bool? res;
      await Cdog.show(context, '钱包已存在,是否覆盖?', isCancel: true, confirm: () {
        res = true;
      }, cancel: () {
        res = false;
      });
      if (res == null || !res!) {
        return null; //* 如果存在该钱包则返回 null
      }
    }
    //* 如果助记词不为空，则使用密码加密助记词
    if (walletInformation['mnemonic'] != '') {
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用密码加密助记词
      String encryptmnemonic = dapp.encryptString(
          walletInformation['mnemonic'], walletInformation['password']);
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的助记词
      walletInformation['mnemonic'] = encryptmnemonic;
    }
    //* 不论如何都要使用密码加密keystore
    //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用密码加密keystore
    String encryptkeystore = dapp.encryptString(
        walletInformation['keystore'], walletInformation['password']);
    //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的keystore
    walletInformation['keystore'] = encryptkeystore;
    //* 判断是否开启生物识别
    if (walletInformation['isEBV']) {
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 获取当前时间戳
      var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用时间戳加密钱包地址用来加密密码
      String encryptaddress =
          dapp.encryptString(walletInformation['address'], timestamp);
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的钱包地址
      await storage.write(
          key: walletInformation['address'], value: encryptaddress);
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用加密后的钱包地址加密密码
      String encryptpassword =
          dapp.encryptString(walletInformation['password'], encryptaddress);
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的密码
      walletInformation['password'] = encryptpassword;
    } else {
      //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 将密码设置为空字符串
      walletInformation['password'] = '';
    }
    //判断本地是否有钱包信息，有就覆盖，没有就添加
    if (isExist) {
      for (var i = 0; i < walletList.length; i++) {
        if (walletList[i]['address'] == walletInformation['address']) {
          walletList[i] = walletInformation;
        }
      }
    } else {
      walletList.add(walletInformation);
    }
    await DB.box.write('WalletList', walletList); // 存储钱包信息数组
    var walletkey = await storage.read(key: walletInformation['address']);
    var walletInfo = await DB.box.read('WalletList');
    print('加密后的钱包信息：$walletInformation\n');
    LLogger.d('存储到普通缓存的数据：$walletInfo\n');
    LLogger.d('存储到安全缓存的数据：$walletkey');
    return walletInformation;
  }
}

var swi = StoreWalletInformation();
