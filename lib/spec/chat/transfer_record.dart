import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/style/common_color.dart';
import '../../common/utils/modal_util.dart';

class TransferRecord extends StatefulWidget {
  const TransferRecord({super.key});

  @override
  State<TransferRecord> createState() =>
      _TransferRecordState(); //* 重写 createState 方法 创建状态
}

//* 下拉框选项
final List<String> _items = ['all'.tr, 'transfer'.tr, 'refund'.tr];

final List _elements = [
  {
    'data': {
      'type': 1,
      'date': '2023-6-12-12-12-12',
      'name': '大洋',
      'amount': 120.00,
      'unit': 'USDT'
    }, //* 1 转给别人 2 别人转给自己 3 退款 4 付款 5 转给别人但是被拒绝
    'date': '2023-6'
  },
  {
    'data': {
      'type': 2,
      'date': '2023-6-12-12-12-11',
      'name': '富墩',
      'amount': 110.00,
      'unit': 'BTC'
    },
    'date': '2023-6'
  },
  {
    'data': {
      'type': 3,
      'date': '2023-6-12-12-12-10',
      'name': '浩楠',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-6'
  },
  {
    'data': {
      'type': 4,
      'date': '2023-6-12-12-12-9',
      'name': '博远',
      'amount': 90.00,
      'unit': 'BTC'
    },
    'date': '2023-6'
  },
  {
    'data': {
      'type': 5,
      'date': '2023-6-12-12-12-8',
      'name': '宇航',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-6'
  },
  {
    'data': {
      'type': 1,
      'date': '2023-5-12-12-12-12',
      'name': '大洋',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-5'
  },
  {
    'data': {
      'type': 2,
      'date': '2023-5-12-12-12-11',
      'name': '富墩',
      'amount': 100.00,
      'unit': 'BTC'
    },
    'date': '2023-5'
  },
  {
    'data': {
      'type': 3,
      'date': '2023-5-12-12-12-10',
      'name': '浩楠',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-5'
  },
  {
    'data': {
      'type': 4,
      'date': '2023-5-12-12-12-9',
      'name': '博远',
      'amount': 100.00,
      'unit': 'BTC'
    },
    'date': '2023-5'
  },
  {
    'data': {
      'type': 5,
      'date': '2023-5-12-12-12-8',
      'name': '宇航',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-5'
  },
  {
    'data': {
      'type': 1,
      'date': '2023-4-12-12-12-12',
      'name': '大洋',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-4'
  },
  {
    'data': {
      'type': 2,
      'date': '2023-4-12-12-12-11',
      'name': '富墩',
      'amount': 100.00,
      'unit': 'BTC'
    },
    'date': '2023-4'
  },
  {
    'data': {
      'type': 3,
      'date': '2023-4-12-12-12-10',
      'name': '浩楠',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-4'
  },
  {
    'data': {
      'type': 4,
      'date': '2023-4-12-12-12-9',
      'name': '博远',
      'amount': 100.00,
      'unit': 'BTC'
    },
    'date': '2023-4'
  },
  {
    'data': {
      'type': 5,
      'date': '2023-4-12-12-12-8',
      'name': '宇航',
      'amount': 100.00,
      'unit': 'USDT'
    },
    'date': '2023-4'
  },
];

class _TransferRecordState extends State<TransferRecord> {
  TextButton newMethod(fun, title) {
    return TextButton(
      onPressed: fun,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
        child: Text(title, style: TextStyle(color: Colors.black)),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CommonColor.bgColor)),
    );
  }

  String setDate(date, type) {
    //切割字符串
    var arr = date.split('-');
    if (type == 'heard') {
      String heardDate = arr[0] + '${'year'.tr}' + arr[1] + '${'month'.tr}';
      return heardDate;
    } else if (type == 'item') {
      String itemDate =
          arr[1] + '${'month'.tr}' + arr[2] + '${'day'.tr}' + ' ' + arr[3] + ':' + arr[4];
      return itemDate;
    } else {
      return '';
    }
  }

  String setName(name, type) {
    if (type == 1 || type == 5) {
      return '${'transfer_transfer_to'.tr} ' + name;
    } else if (type == 2) {
      return '${'transfer_transfer_from'.tr} ' + name;
    } else if (type == 3) {
      return 'transfer_transfer_refund'.tr;
    } else {
      return name;
    }
  }

  String selectedValue = 'all_bill'.tr; //* 下拉框选中的值

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override //重写
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Container(
          child: TextButton.icon(
            //文字按钮
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 16,
            ),
            label: Text(""),
          ),
        ),
        title:  Text("transfer_record".tr,
            style: TextStyle(color: Colors.black, fontSize: 18)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: TextButton(
              //文字按钮
              onPressed: () => showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SwitchScreen()),
              child: Row(
                children: [
                  Text(
                    selectedValue,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black)
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: CommonColor.bgColor),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          child: GroupList(context),
        ),
      ),
    );
  }

  GroupedListView<dynamic, String> GroupList(BuildContext context) {
    return GroupedListView<dynamic, String>(
      elements: _elements,
      //数据源
      groupBy: (element) => element['date'],
      //分组依据
      groupComparator: (value1, value2) => value2.compareTo(value1),
      //排s序
      order: GroupedListOrder.ASC,
      //排序方式 降序
      useStickyGroupSeparators: true,
      //分组头部是否固定
      floatingHeader: true,
      //分组头部是否悬浮
      groupSeparatorBuilder: (String value) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
        ),
        color: CommonColor.bgColor,
        shadowColor: Colors.transparent,
        child: Row(
          //分组头部
          children: [
            TextButton(
              //文字按钮
              onPressed: () => {
                // ItemHeardFun(context, () {})

                ModalUtil.showCustomDatePicker(
                  context: context,
              selectDate: PDuration(),
                  mode: DateMode.YM,
                  // 或者 DateMode.YM, DateMode.YMD, 根据需要进行选择
                  onConfirm: (p) {
                    print('返回数据：${p.toString()}');
                    setState(() {});
                  },
                )
              },
              child: Row(
                children: [
                  Text(
                    setDate(value, 'heard'),
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black)
                ],
              ),
            )
          ],
        ),
      ),
      itemBuilder: (c, element) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            side: BorderSide(
              color: CommonColor.bgColor,
              width: .50,
              style: BorderStyle.solid,
            ),
          ),
          //边框线颜色
          child: Row(
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 10, top: 16, bottom: 16),
                child: Image.asset(
                  'assets/image/chat_def_head.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      setName(element['data']['name'], element['data']['type']),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      setDate(element['data']['date'], 'item'),
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Text(
                        (element['data']['type'] == 2
                                ? '+'
                                : element['data']['type'] == 3
                                    ? '+'
                                    : '-') +
                            element['data']['amount'].toString() +
                            ' ' +
                            element['data']['unit'],
                        style: TextStyle(
                            color: (element['data']['type'] == 2
                                ? Colors.orange
                                : element['data']['type'] == 3
                                    ? Colors.orange
                                    : Colors.black),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        element['data']['type'] == 5 ? 'return_by_other_party'.tr : '',
                        style: TextStyle(color: Colors.red[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container SwitchScreen() {
    return Container(
      height: 150,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            // 遍历
            _items
                .map((e) => newMethod(() {
                      setState(() {
                        selectedValue = e + '${'bill'.tr}';
                      });
                      Get.back();
                    }, e))
                .toList(),
      ),
    );
  }
}
