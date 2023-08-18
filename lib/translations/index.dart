import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login_nation': 'Nation',

          'search_friends': 'Search Friends',
          'customer_service': 'Customer Service',
          'message': 'Message',
          'add_friends': 'Add Friends',
          'certain': 'Certain',
          'cancel': 'Cancel',
          'new_contact': 'Create A Contact',
          'no_such_account_found': 'No such account found',
          'please_input_account': 'Please enter the account',
        },
        'zh_CN': {
          'login_nation': '国家和地区',

          'search_friends': '搜索好友',
          'customer_service': '客服',
          'message': '消息',
          'add_friends': '添加好友',
          'certain': '确定',
          'cancel': '取消',
          'new_contact': '新建联系人',
          'no_such_account_found': '查无此账号',
          'please_input_account': '请输入账号',
        }
      };
}
