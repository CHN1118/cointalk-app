import 'package:event_bus/event_bus.dart';

class Eventer {
  EventBus eventBus = EventBus();

  //私有构造函数
  Eventer._internal();

  static Eventer? _instance;

  static Eventer get instance => _getInstance();

  static Eventer _getInstance() {
    // return _instance ??= Eventer._internal();
    return _instance ??= Eventer._internal();
  }

  // 存储事件回调方法
  final Map<String, Function> _events = {};

  // 设置事件监听
  void addListener(String eventKey, Function callback) {
    _events[eventKey] = callback;
  }

  // 移除监听
  void removeListener(String eventKey) {
    _events.remove(eventKey);
  }

  // 提交事件
  void commit(String eventKey) {
    _events[eventKey]?.call();
  }

  Eventer() {}
}

class EventKeys {
  static const String logout = "Logout";
  static const String token_invalid = "Token_Invalid";
  static const String refresh_chat = "Refresh_Chat";
  static const String refresh_chat_detail = "Refresh_Chat_Detail";
}

class Notify {
  String message;

  Notify(this.message);
}
