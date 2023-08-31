// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as material;
import 'package:wallet/api/index.dart';
import 'package:wallet/common/utils/client.dart';
import 'package:wallet/common/utils/index.dart';
import 'package:wallet/common/utils/log.dart';
import 'package:wallet/common/utils/symbol_arr.dart';
import 'package:wallet/components/custom_dialog.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/event/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

import '../../api/centre_api.dart';
import '../../centre/centre.dart';
import '../../db/kv_box.dart';
import '../../spec/chat/sync_db_ret.dart';
import '../../spec/user.dart';

class Dapp {
  /// *获取区块高度定时器
  Timer? _timer;

  /// *助记词 生成钱包
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
    Wallet wallet = Wallet.createNew(credentials, password, random); // 钱包
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

  /// *keystore 生成钱包
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

  ///*导入私钥 生成钱包
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

  /// *通过密码加密 明文
  String encryptString(String plainText, String password) {
    String psw = '';
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    if (password.length < 32) {
      psw = (password + timestamp).length < 32
          ? (password + timestamp).padRight(32, ' ')
          : (password + timestamp).substring(0, 32);
    } else {
      // *截取钱19位加上时间戳
      psw = password.substring(0, 19) + timestamp;
    }
    final key = Key.fromUtf8(psw);
    final iv = IV.fromLength(16); // 使用AES算法需要一个16字节的初始化向量(IV)

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv); //iv 为初始化向量

    return encrypted.base64 + '@$timestamp'; // 将加密结果转换为Base64格式返回
  }

  /// *通过密码解密 密文
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

  /// *获取余额
  connect({EthereumAddress? address}) async {
    // *切换钱包的时候需要重新赋值钱包地址
    CL.address = EthereumAddress.fromHex(DB.box
        .read('WalletList')
        .firstWhere((e) => e['active'] == true)['address']);
    EtherAmount balance = await CL.client.getBalance(address ?? CL.address);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  /// *转账
  Future<dynamic> transfer(String to, var amount,
      {int gasPrice = 2000000000000,
      int gasL = 21000,
      String? password}) async {
    //* 1.通过密码解密keystore
    var keystore = decryptString(C.currentWallet['keystore'], password!);
    //* 2.通过keystore获取钱包的实例
    Wallet wallet = Wallet.fromJson(keystore, password);
    //* 3.通过钱包实例的私钥获取钱包的凭证
    Credentials credentials =
        EthPrivateKey.fromHex(HEX.encode(wallet.privateKey.privateKey));
    //* 4.计算转账金额
    amount = BigInt.from(amount) * BigInt.from(10).pow(18); //*转换成wei
    //* 5.创建交易
    Transaction transaction = Transaction(
      to: EthereumAddress.fromHex(to), //* 转账地址
      gasPrice: EtherAmount.inWei(BigInt.from(gasPrice)), //* 燃料价格
      maxGas: gasL, //* 燃料限制
      value:
          EtherAmount.inWei(BigInt.from(num.parse(amount.toString()))), //* 转账金额
    );

    try {
      //* 6.签名交易
      var signedTransaction = await CL.client
          .signTransaction(credentials, transaction, chainId: 1337);
      print(signedTransaction);
      //* 7.发送交易
      var thash = await CL.client.sendRawTransaction(signedTransaction);
      //* 8.监听交易状态
      print('交易hash: $thash');
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        var receipt = await CL.client.getTransactionReceipt(thash);
        print(receipt?.status); //* 交易状态
        if (receipt != null) {
          timer.cancel();
          print(receipt); //* 交易信息
        }
      });
      C.getWL(); //* 刷新钱包列表
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// *扫链，传入起始块和结束块，扫描指定地址的交易
  void scanBlocksForAddress(
      int startBlock, int endBlock, String address) async {
    for (int i = startBlock; i <= endBlock; i++) {
      final block = await getBlockByNumber(i);
      print('Scanning block $i');
      for (var transaction in block['transactions']) {
        var from = transaction['from'] ?? '0x';
        var to = transaction['to'] ?? '0x';
        if (from.toLowerCase() == address.toLowerCase() ||
            to.toLowerCase() == address.toLowerCase()) {
          final confirmationTimestamp = block['timestamp'];
          transaction['confirmationTimestamp'] = confirmationTimestamp;
          swi.addTransaction(transaction);
        }
      }
    }
  }

  /// *获取指定块的信息
  Future<Map<String, dynamic>> getBlockByNumber(int blockNumber) async {
    final body = {
      'jsonrpc': '2.0',
      'method': 'eth_getBlockByNumber',
      'params': ['0x${blockNumber.toRadixString(16)}', true],
      'id': 1,
    };
    var rpcUrl = blockchainInfo
        .where((element) => element['active'] == true)
        .toList()[0]['rpcUrl'][0]; // Ganache 默认 RPC 地址
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

  /// *签名消息 并且登录
  Future<dynamic> signMessage(
      {String? message = 'login', String? password = ''}) async {
    //* 1.通过密码解密keystore
    var keystore = decryptString(
        DB.box
            .read('WalletList')
            .firstWhere((e) => e['active'] == true)['keystore'],
        password!);

    //* 2.通过keystore获取钱包的实例
    Wallet wallet = Wallet.fromJson(keystore, password);
    //* 3.通过钱包实例的私钥获取钱包的凭证
    Credentials credentials =
        EthPrivateKey.fromHex(HEX.encode(wallet.privateKey.privateKey));
    //* 4.签名消息
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var signedMessage = credentials.signPersonalMessageToUint8List(
        utf8.encode('${message!}$timestamp') as Uint8List,
        chainId: 1); //* 签名消息
    //* 5.验证签名
    print('签名哈希0x${HEX.encode(signedMessage)}');
    print('签名地址:${CL.address.hex}');
    print('签名消息$message$timestamp');

    // 调用登录接口
    var res = await request.post('user/login', data: {
      'sign': '0x${HEX.encode(signedMessage)}',
      'name': CL.address.hex,
      'msg': '$message$timestamp',
      "password": password
    });
    print(res);
    if (res['code'] == 0) {
      LLogger.d('登录成功:$res');
      BusinessUser bu = BusinessUser.fromJson(res["data"]);
      KVBox.SetToken(bu.token);
      KVBox.SetImToken(bu.imToken);
      KVBox.SetCid(bu.cid.toString());
      KVBox.SetUserId(bu.userId.toString());
      KVBox.SetAddress(CL.address.hex);
      // 第一次登录,初始化ubox
      print("init ubox");
      late GetStorage ubox;
      await GetStorage.init(bu.userId.toString());
      ubox = GetStorage(bu.userId.toString()); //!这里不要动,上面一行赋值后才能读取的到,否则会很有大错误
      globalCentre.centreDB.ubox = ubox;
      // 同步客服信息
      // var ssData = await CentreApi().supportSync();
      // if (ssData.data['code'] == 0) {
      //   KVBox.SetSupportCid(ssData.data['data']['cid']);
      // }
      // 同步IM端用户数据
      var imSyncData = await CentreApi().imSyncDB(0);
      SyncDBRet ret = SyncDBRet.fromJson(imSyncData.data['data']);
      //缓存最新数据时间
      ubox.write('update_time', ret.updateTime);
      //缓存用户关系
      ret.relationList.forEach((rElement) {
        ubox.write('relation_' + rElement.cId.toString(), rElement.toJson());
      });
      // print("relation === "+ubox.read('relation_133').toString());
      //缓存自己的信息
      DB.box.write(BoxKey.UserInfo, ret.userInfo.toJson());
      //缓存其他所有用户信息
      ret.consumerList.forEach((element) {
        ubox.write('consumer_' + element.cid.toString(), element);
      });
      //缓存我的通讯录
      ubox.write('relation_all', ret.relationAll);
      print('token${res['data']['token']}');
      DB.box.write(
          'token', {'token': res['data']['token'], 'address': CL.address.hex});
      LLogger.d('存储的token${DB.box.read('token')}');
      LLogger.d('登录后初始化成功');
    }

    return {
      'sign': '0x${HEX.encode(signedMessage)}',
      'name': CL.address,
      'msg': '$message$timestamp'
    };
  }

  /// *定时获取区块高度16秒
  void getBlockNumber() {
    _timer = Timer.periodic(const Duration(seconds: 16), (timer) async {
      var blockNumber = await CL.client.getBlockNumber();
      // *扫描上一个区块
      scanBlocksForAddress(
          blockNumber - 1, blockNumber - 1, CL.address.toString());
    });
  }

  /// *清除定时器
  void clearTimer() {
    _timer?.cancel();
  }
}

var dapp = Dapp();

/// *存储钱包信息的构造函数
class StoreWalletInformation {
  /// *加密后 存储钱包信息
  Future<dynamic> addWalletInfo(material.BuildContext context,
      Map<String, dynamic> walletInformation) async {
    // *获取钱包信息数组
    var walletList = DB.box.read('WalletList') ?? [];
    // *判断钱包信息数组是已经存在该钱包
    var isExist = false;
    for (var i = 0; i < walletList.length; i++) {
      if (walletList[i]['address'] == walletInformation['address']) {
        isExist = true;
      }
    }
    if (isExist) {
      // *如果存在该钱包则弹出提示框
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
    //*判断本地是否有钱包信息，有就覆盖，没有就添加
    if (isExist) {
      for (var i = 0; i < walletList.length; i++) {
        if (walletList[i]['address'] == walletInformation['address']) {
          walletList[i] = walletInformation;
        } else {
          walletList[i]['active'] = false;
        }
      }
    } else {
      walletList.forEach((wallet) {
        wallet['active'] = false;
      });
      walletList.add(walletInformation);
    }
    await DB.box.write('WalletList', walletList); // *存储钱包信息数组
    var walletkey =
        await storage.read(key: walletInformation['address']); // *获取钱包地址
    var walletInfo = await DB.box.read('WalletList'); // *获取钱包信息数组
    print('加密后的钱包信息：$walletInformation\n');
    LLogger.d('存储到普通缓存的数据：$walletInfo\n');
    LLogger.d('存储到安全缓存的数据：$walletkey');
    return walletInformation;
  }

  /// *使用了生物识别 获取密码
  Future<String> getpassword() async {
    // * 获取加密后的钱包地址
    var address = await storage.read(key: C.currentWallet['address']);
    // * 使用加密后的钱包地址解密密码
    String password = dapp.decryptString(C.currentWallet['password'], address!);
    return password;
  }

  /// *钱包相关的交易存储
  Future<dynamic> addTransaction(Map<String, dynamic> transaction) async {
    // *获取交易数组
    List<dynamic> transactionList =
        DB.box.read(CL.address.hex.toLowerCase()) ?? [];
    // *判断交易数组是已经存在该交易
    var isExist = false;
    for (var i = 0; i < transactionList.length; i++) {
      if (transactionList[i]['hash'] == transaction['hash']) {
        isExist = true;
      }
    }
    if (isExist) {
      return null; //* 如果存在该交易则返回 null
    }
    var receipt = await CL.client.getTransactionReceipt(transaction['hash']);
    // print(receipt); //* 交易状态
    if (receipt != null) {
      transaction['status'] = receipt.status;

      transactionList.add(transaction);
      // 将交易信息存储按照时间排序
      transactionList.sort((a, b) => utils
          .formatTimestamp(b['confirmationTimestamp'])
          .compareTo(utils.formatTimestamp(a['confirmationTimestamp'])));
      await DB.box
          .write(CL.address.hex.toLowerCase(), transactionList); // *存储交易信息数组
      var transactionInfo =
          await DB.box.read(CL.address.hex.toLowerCase()); // *获取交易信息数组
      LLogger.d('存储到普通缓存的数据：$transactionInfo\n');
      C.getWL(); // *更新交易列表
      bus.emit('updateTransactionList'); // *更新交易列表
      return transaction;
    }
  }
}

var swi = StoreWalletInformation();
