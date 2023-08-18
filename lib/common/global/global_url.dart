class Global {
  // SingleInstance
  static Global instance = Global();

  // static String serviceUrl = "https://api.entysquare.io";
  // static String serviceUrl = "http://192.168.1.90:3010";
  static String serviceUrl = "http://192.168.1.73:3010";

  static String serviceIMUrl = "http://192.168.1.81:3300";
  // static String serviceIMUrl = "http://116.62.185.53:3300/IM/";

  static String syncUrl = "http://192.168.1.81:3330";
  // static String syncUrl = "http://116.62.185.53:3330";
}

var globalContext;
var globalBus;

setGlobalContext(context) {
  globalContext = context;
}

setGlobalBus(bus) {
  globalBus = bus;
}
