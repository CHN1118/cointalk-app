// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:encrypt/encrypt.dart';
import 'package:wallet/common/utils/log.dart';
import 'package:wallet/database/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

class Dapp {
  // 助记词 生成钱包
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

  // keystore 生成钱包
  Future<dynamic> importKetystore(
      String keystore, String walletname, String password,
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
        'keystore': keystore, // Keystore
        'active': active, // 是否激活
      };
    } catch (e) {
      LLogger.e('导入KeyStroe: ========> 您提供了错误的密码或文件已损坏 !!!');
      return null;
    }
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

  // 通过密码加密 明文
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

    return encrypted.base64; // 将加密结果转换为Base64格式返回
  }

  // 通过密码解密 密文
  String decryptString(String encryptedString, String password) {
    String psw = '';
    if (password.length < 32) {
      psw = password.padRight(32, ' ');
    } else {
      psw = password.substring(0, 32);
    }
    final key = Key.fromUtf8(psw);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = Encrypted.fromBase64(encryptedString);

    try {
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      LLogger.e('解密失败');
      return '';
    }
  }
}

var dapp = Dapp();

// 存储钱包信息的构造函数
class StoreWalletInformation {
  // 助记词导入钱包 存储钱包信息
  dynamic addWalletInfo(Map<String, dynamic> walletInformation) async {
    // 获取钱包信息数组
    var walletList = DB.box.read('WalletList') ?? [];
    // 判断钱包信息数组是已经存在该钱包
    var isExist = false;
    // for (var i = 0; i < walletList.length; i++) {
    //   if (walletList[i]['address'] == walletInformation['address']) {
    //     isExist = true;
    //   }
    // }
    if (isExist) {
      return null;
    } else {
      //判断是否开启生物识别
      if (walletInformation['isEBV']) {
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 获取当前时间戳
        var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用时间戳加密钱包地址用来加密密码
        String encryptaddress =
            dapp.encryptString(walletInformation['address'], timestamp);
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的钱包地址
        await storage.write(
            key: walletInformation['address'], value: encryptaddress);
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用密码加密助记词
        String encryptmnemonic = dapp.encryptString(
            walletInformation['mnemonic'], walletInformation['password']);
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的助记词
        walletInformation['mnemonic'] = encryptmnemonic;
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用密码加密keystore
        String encryptkeystore = dapp.encryptString(
            walletInformation['keystore'], walletInformation['password']);
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的keystore
        walletInformation['keystore'] = encryptkeystore;
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 使用加密后的钱包地址加密密码
        String encryptpassword =
            dapp.encryptString(walletInformation['password'], encryptaddress);
        //&->>>>>>>>>>>>>>>>>>>>>>>>>>>> 存储加密后的密码
        walletInformation['password'] = encryptpassword;
        print(walletInformation);
      }
      // 添加钱包信息
      walletList.add(walletInformation);
      // 更新钱包信息数组
      // DB.box.write('WalletList', walletList);
      DB.box.write('WalletList', null);
    }
  }
}

var swi = StoreWalletInformation();
