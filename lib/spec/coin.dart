
// 币种列表
import '../wallet/coin_select.dart';
import 'input.dart';

final List<MenuItem> CoinList = [
  MenuItem(label: "USDT", value: '1', image: "assets/image/wallet_USDT.png"),
];

final List<SelectLabelValue> mainNetworkList = [
  SelectLabelValue(
    value: "TRC20",
    label: "TRC20",
  ),
];


// USDList列表
final List<MenuItem> USDList = [
  MenuItem(label: "USD", value: '1', image: "assets/image/wallet_USD.png"),
];