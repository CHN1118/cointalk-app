import 'package:dio/dio.dart';

import 'dio_util.dart';

class AccountApi {
  Dio dio = DioUtil.init();

  // 获取钱包信息
  Future<Response> my() async {
    Response res = await dio.post('/app/account/my');
    return Future(() => res);
  }

  // 充值和兑换
  Future<Response> recharge(String cardNumber, double amount) async {
    Response res = await dio.post('/app/account/recharge',
        data: {"cardNumber": cardNumber, "amount": amount});
    return Future(() => res);
  }

  // 转账
  Future<Response> transfer(
      String account, double amount, String currentName, String payPwd) async {
    Response res = await dio.post('/app/account/transfer', data: {
      "account": account,
      "amount": amount,
      "payPwd": payPwd
    });
    return Future(() => res);
  }

  // 提现
  Future<Response> withdraw(String address, double amount) async {
    Response res = await dio.post('/app/account/withdraw',
        data: {"address": address, "amount": amount});
    return Future(() => res);
  }

  // 添加提现地址
  Future<Response> addWithdrawAddress(String name,String address) async {
    Response res = await dio.post('/app/withdrawAddress/add',
        data: {"name": name, "address": address});
    return Future(() => res);
  }

  // 修改提现地址
  Future<Response> updateWithdrawAddress( int id,String name,String address) async {
    Response res = await dio.post('/app/withdrawAddress/update',
        data: {"name": name, "address": address,"id":id});
    return Future(() => res);
  }

  // 删除提现地址
  Future<Response> deleteWithdrawAddress( int id) async {
    Response res = await dio.post('/app/withdrawAddress/delete',
        data: {"id":id});
    return Future(() => res);
  }

}
