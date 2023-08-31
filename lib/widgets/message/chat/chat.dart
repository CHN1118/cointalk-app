import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/contact_api.dart';
import '../../../common/global/global_key.dart';
import '../../../common/global/global_url.dart';
import '../../../common/style/common_color.dart';
import '../../../common/style/common_style.dart';
import '../../../common/utils/toast_print.dart';
import '../../../db/channel.dart';
import '../../../db/kv_box.dart';
import '../../../db/relation.dart';
import '../../../event/notify_event.dart';
import '../../../spec/chat/chat.dart';
import '../../../spec/chat/sync_db_ret.dart';
import 'address/add_people.dart';
import 'address/address_book.dart';
import 'chat_detail.dart';
import 'package:badges/badges.dart' as badges;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with RouteAware {
  final box = KVBox.GetBox();
  final ubox = KVBox.GetUserBox();
  final int sCid = KVBox.GetSupportCid();
  final fieldTextController = TextEditingController();
  int tCorner = 0;
  var systemMsgCorner = true.obs;

  // 聊天列表元素
  List<ChatListItem> chat_list = <ChatListItem>[];
  ChatListItem? supportItem;

  final List<String> items = ['add_friends'.tr];
  String? selectedValue;
  List<String> menuItem = ['add_friends'.tr];
  int seconds_time = 1;
  int msg_index = 1;
  List channelList = [];
  int? sChannelId;
  final int cid = int.parse(KVBox.GetCid());
  final EventBus eventBus = globalBus;

  @override
  void initState() {
    super.initState();

    refreshDataList();
    eventBus.on<NotifyEvent>().listen((event) {
      if (event.msg == NKey.refresh_chat) {
        print("refresh_chat:${event.msg}");
        refreshDataList();
      }
      if (event.msg == NKey.refresh_note_name) {
        print("刷新聊天列表");
        refreshDataList();
        // setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 置顶
  void topAct(ChatListItem item) {
    KVBox.SetTopChat(item.chat_id);
    refreshDataList();
  }

  // 取消置顶
  void unTopAct(ChatListItem item) {
    KVBox.RmvTopChat(item.chat_id);
    refreshDataList();
  }

  // 删除消息列表的元素
  delAct(ChatListItem item) async {
    List channelList = KVBox.GetChannelList();
    channelList.remove(BoxKey.ChannelIndex + item.chat_id.toString());
    await KVBox.SetChannelList(channelList);
    // 消息下标清零
    await KVBox.SetChannelIndex(item.chat_id, 0);
    // 消息角标清零
    await KVBox.SetCorner(item.chat_id, 0);
    List<String> keys = ubox.getKeys().toList();
    for (String key in keys) {
      if (key.startsWith(item.chat_id.toString() + "-")) {
        ubox.remove(key);
      }
    }
    refreshDataList();
  }

  // 刷新聊天页面
  Future<void> refreshDataList() async {
    ubox.write(BoxKey.ChannelTotalCorner, 0);
    List bc = ubox.read("channelList") ?? [];
    print("bc---------->${bc}");
    channelList = bc.reversed.toList();
    final int cid = KVBox.GetCidInt();
    List<ChatListItem> chat_list_n = <ChatListItem>[];
    List<ChatListItem> chat_list_new = <ChatListItem>[];
    if (ubox.hasData(BoxKey.SupportChannelId)) {
      sChannelId = ubox.read(BoxKey.SupportChannelId);
    }
    // channelList.forEach((item) {
    for (var i = 0; i < channelList.length; i++) {
      // 如果是客服频道且不是客服登录就跳过
      String channelId = channelList[i].toString().substring(12);
      print("refreshDataList cid---------->${cid}");
      if (channelId == sChannelId?.toString() && cid != sCid) {
        print("refreshDataList cid remove---------->${cid}");
        continue;
      }
      // 读出每一个channel的最新index
      var syncIndex = ubox.read(channelList[i]);
      int corner = ubox.read(BoxKey.ChannelCorner + channelId) ?? 0;
      print("corner=============${corner}");
      // String dataId = cid + "-" + (syncIndex + 1).toString();
      // 读取最新的一条消息
      String dataId = channelId + "-" + (syncIndex).toString();
      if (ubox.hasData(dataId)) {
        var channelDetail = ubox.read(dataId);
        print("channelDetail=============${channelDetail}");
        // ChannelDetail cd = ChannelDetail.fromJson(channelDetail);
        MsgInfo mi = MsgInfo.fromJson(channelDetail);
        var date = DateFormat('MM-dd HH:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(mi.time));
        var channelInfo = ChannelDB.GetChannelToConsumer(ubox, channelId);
        //单聊
        if (channelInfo.state == 0) {
          var toConsumer = ChannelDB.GetCacheConsumer(ubox, channelInfo, cid);
          // 通过对方cid获取关系信息
          RelationView? rv = RelationDB.GetRelationToCid(toConsumer.cid);
          if (rv == null) {
            channelInfo.name = toConsumer.account;
          } else {
            channelInfo.name =
                rv.toNoteName == "" ? toConsumer.account : rv.toNoteName;
          }
          channelInfo.avatar = toConsumer.avatar;
        }

        if (ubox.hasData("$channelId-isTop")) {
          chat_list_new.add(
            ChatListItem(
              chat_id: mi.channelId,
              from: mi.fromId,
              from_name: channelInfo.name ?? "",
              time: date.toString(),
              content:
                  mi.type == "transfer" ? "[转账]:" + mi.content : mi.content,
              type: mi.type,
              head_img: channelInfo.avatar ?? "",
              corner: corner,
              types: channelInfo.types ?? 0,
            ),
          );
        } else {
          print("--------------->ubox.hasData( else {");
          print("00-----${channelInfo.name} ----${channelInfo.avatar}");
          chat_list_n.add(
            ChatListItem(
              chat_id: mi.channelId,
              from: mi.fromId,
              from_name: channelInfo.name ?? "",
              time: date.toString(),
              content:
                  mi.type == "transfer" ? "[转账]:" + mi.content : mi.content,
              type: mi.type,
              head_img: channelInfo.avatar ?? "",
              corner: corner,
              types: channelInfo.types ?? 0,
            ),
          );
        }
      }
    }
    // );
    chat_list_new.addAll(chat_list_n);
    setState(() {
      chat_list = chat_list_new;
    });
    tCorner = KVBox.GetTotalCorner();
    chat_list.forEach((e) {
      tCorner += e.corner;
    });
    KVBox.SetTotalCorner(tCorner);
    if (cid != sCid) {
      refreshSupport();
    }
  }

  // 刷新客服频道
  Future<void> refreshSupport() async {
    // sChannelId = await createSupportChannel();
    print("refreshSupport sChannelId = ${sChannelId}");
    if (sChannelId == null) {
      return;
    }
    // 读出客服channel的最新index
    var syncIndex = ubox.read("channelIndex" + sChannelId.toString()) ?? -1;
    int corner = ubox.read(BoxKey.ChannelCorner + sChannelId.toString()) ?? 0;
    print("refreshSupport corner=============${corner}");
    // String dataId = cid + "-" + (syncIndex + 1).toString();
    // 读取最新的一条消息
    String dataId = sChannelId.toString() + "-" + (syncIndex).toString();
    print("refreshSupport dataId=============${dataId}");
    if (ubox.hasData(dataId)) {
      var channelDetail = ubox.read(dataId);
      print("refreshSupport channelDetail=============${channelDetail}");
      MsgInfo mi = MsgInfo.fromJson(channelDetail);
      var date = DateFormat('MM-dd HH:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(mi.time));
      var channelInfo =
          ChannelDB.GetChannelToConsumer(ubox, sChannelId.toString());
      print("客服信息-----${channelInfo.name} ----${channelInfo.avatar}");
      supportItem = ChatListItem(
        chat_id: mi.channelId,
        from: mi.fromId,
        from_name: channelInfo.name ?? "",
        time: date.toString(),
        content: mi.content,
        type: mi.type,
        head_img: channelInfo.avatar ?? "",
        corner: corner,
        types: channelInfo.types ?? 0,
      );
    }
    tCorner = KVBox.GetTotalCorner();
    tCorner += corner;
    KVBox.SetTotalCorner(tCorner);
  }

  // 搜索过滤
  void _filterList() {
    refreshDataList();
    final String searchText = fieldTextController.text;
    final List<ChatListItem> originalList = chat_list;
    if (searchText.isNotEmpty) {
      final List<ChatListItem> filteredList = originalList
          .where((element) => element.from_name.contains(searchText))
          .toList();
      // 更新你的列表并刷新UI
      setState(() {
        chat_list = filteredList;
      });
    } else {
      setState(() {
        refreshDataList();
      });
    }
  }

  // 创建客服聊天频道
  Future<int?> createSupportChannel() async {
    // ubox.write('consumer_' + consumerObject[i]['cid'].toString(), consumerObject[i]);
    // var addRes = await contactApi().addChannelChat(consumerObject[i]['cid']);
    var addRes = await contactApi().addChannelChat(sCid);
    if (addRes.data['data'] != null && addRes.data['data'].isNotEmpty) {
      var channelInfo = addRes.data['data']['channel'];
      print("---channelInfo---->${channelInfo}");
      // 写入消息角标
      KVBox.SetChannelInfo(channelInfo['id'].toString(), channelInfo);
      // ubox.write('channelInfo_' + channelInfo['id'].toString(), channelInfo);
      var relation_all = addRes.data['data']['relation_all'];
      print("---createSupportChannel relation_all---->${relation_all}");
      ubox.write('relation_all', relation_all);
      // print(ubox.read('channelInfo_' + channelInfo['id'].toString()));
      // eventBus.fire(NotifyEvent(msg: NKey.refresh_chat));
      // eventBus.fire(NotifyEvent(msg: NKey.refresh_contact));
      return channelInfo['id'];
      // Get.to(() => ChatDetailPage(), arguments: {
      //   'name': "客服",
      //   'channelId': channelInfo['id'],
      // });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/chat_bg.png"),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 0, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Text(
                              tCorner == 0
                                  ? "message".tr
                                  : "message".tr + "(${tCorner.toString()})",
                              style: CommonStyle.text_18_black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: IconButton(
                                    onPressed: () {
                                      // 通讯录页面
                                      Get.to(() => ContactsPage());
                                    },
                                    icon: Image.asset(
                                      "assets/images/chat_address_book.png",
                                      width: 28.w,
                                      height: 28.w,
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                          getPopView()
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Container(
                  height: 30.w,
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 0, bottom: 0),
                  child: TextFormField(
                    onChanged: (value) {
                      // setState(() {});
                      _filterList();
                    },
                    controller: fieldTextController,
                    style: CommonStyle.text_16_black_w500,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // icon: GestureDetector(
                      //   onTap: () => Get.back(),
                      //   child: Icon(
                      //     Icons.arrow_back_ios_new_outlined,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      hintText: "search_friends".tr,
                      hintStyle: TextStyle(
                        color: Color(0xFF7E7E7E),
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w), //设置内边距  horizontal为水平方向
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.w),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.w), //边角为30
                        ),
                      ),
                      suffixIcon: IconButton(
                          iconSize: 25.w,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(
                            Icons.search_outlined,
                            color: Color(0xFF7E7E7E),
                          ),
                          onPressed: () {
                            setState(() {});
                            fieldTextController.clear();
                          }),
                    ),
                    autofocus: false,
                  ),
                ),
                SizedBox(height: 10.w),
                // 登录用户为客服自己时，隐藏客服对话框
                // cid == sCid ? Offstage() : _supportChat(),
                Expanded(
                    flex: 1,
                    child: (chat_list.length == 0)
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    12.h), //垂直方向内边距 vertical :垂直 horizontal:水平
                            itemCount: chat_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getRow(index);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                color: Colors.white,
                                child: Divider(
                                  color: Color(0xFFEAEAEA),
                                  height: 5.w,
                                ),
                              );
                            },
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 客服
  Widget _supportChat() {
    return InkWell(
      onTap: () async {
        // int? channelId = await createSupportChannel();
        if (ubox.hasData(BoxKey.SupportChannelId)) {
          sChannelId = ubox.read(BoxKey.SupportChannelId);
        } else {
          sChannelId = await createSupportChannel();
        }
        if (sChannelId == null) {
          print("_supportChat channelId is null");
          ToastPrint.show("customer_service_not_online".tr);
          return;
        }
        // 跳转聊天详情
        var res = await Get.to(
          () => ChatDetailPage(),
          arguments: {
            'name': "customer_service".tr,
            'channelId': sChannelId,
          },
        );
        if (res != null) {
          setState(() {
            refreshDataList();
          });
        }
        int corner = KVBox.GetCorner(sChannelId!);
        // 角标清零 - 进去清除
        KVBox.SetCorner(sChannelId!, 0);
        // 计算总角标
        tCorner = KVBox.GetTotalCorner();
        KVBox.SetTotalCorner(tCorner - corner);
        eventBus.fire(NotifyEvent(msg: NKey.refresh_corner));
        setState(() {
          refreshDataList();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -10.w, end: 0),
                  showBadge:
                      supportItem == null ? false : supportItem!.corner > 0,
                  badgeContent: Text(
                    supportItem == null
                        ? "0"
                        : supportItem!.corner > 99
                            ? "..."
                            : supportItem!.corner.toString(),
                    style: CommonStyle.text_10_white,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Image.network(
                      supportItem?.head_img ??
                          "https://ispay-app.oss-cn-beijing.aliyuncs.com/chat_def_head.png",
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "customer_service".tr,
                      style: CommonStyle.text_16_black,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      supportItem?.content ?? "",
                      style: CommonStyle.text_12_grey,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              supportItem?.time ?? "",
              style: CommonStyle.text_12_grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(index) {
    ChatListItem cItem = chat_list[index];
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dragDismissible: false,
        children: [
          ubox.hasData("${cItem.chat_id}-isTop")
              ? SlidableAction(
                  onPressed: (BuildContext context) {
                    setState(() {
                      unTopAct(cItem);
                    });
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  icon: Icons.vertical_align_bottom,
                  label: 'cancel'.tr,
                )
              : SlidableAction(
                  onPressed: (BuildContext context) {
                    setState(() {
                      topAct(cItem);
                    });
                  },
                  backgroundColor: Color(0xFF3D3F41),
                  foregroundColor: Colors.white,
                  icon: Icons.vertical_align_top,
                  label: 'sticky'.tr,
                ),
          SlidableAction(
            onPressed: (BuildContext context) {
              setState(() {
                delAct(cItem);
              });
            },
            backgroundColor: CommonColor.redPackColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'personal_set_delect'.tr,
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: InkWell(
          onTap: () async {
            int corner = KVBox.GetCorner(cItem.chat_id);
            // 角标清零 - 进去清除
            KVBox.SetCorner(cItem.chat_id, 0);
            // 计算总角标
            int tCorner = KVBox.GetTotalCorner();
            KVBox.SetTotalCorner(tCorner - corner);
            eventBus.fire(NotifyEvent(msg: NKey.refresh_corner));
            setState(() {
              refreshDataList();
            });
            // 跳转聊天详情
            var res = await Get.to(() => ChatDetailPage(),
                arguments: {'channelId': cItem.chat_id});
            if (res != null) {
              // print("res route ==============$res");
              setState(() {
                refreshDataList();
              });
            }
            corner = KVBox.GetCorner(cItem.chat_id);
            // 角标清零 - 进去清除
            KVBox.SetCorner(cItem.chat_id, 0);
            // 计算总角标
            tCorner = KVBox.GetTotalCorner();
            KVBox.SetTotalCorner(tCorner - corner);
            eventBus.fire(NotifyEvent(msg: NKey.refresh_corner));
            setState(() {
              refreshDataList();
            });
          },
          child: Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    badges.Badge(
                      // position: badges.BadgePosition.topEnd(top: -5, end: 5),
                      showBadge: cItem.corner > 0,
                      position: badges.BadgePosition.topEnd(top: -10, end: 0),
                      badgeContent: Text(
                        cItem.corner > 99 ? "..." : cItem.corner.toString(),
                        style: CommonStyle.text_10_white,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Image.network(
                          cItem.head_img,
                          width: 40.w,
                          height: 40.w,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width*0.5,
                          child:Text(
                            cItem.from_name,
                            style: CommonStyle.text_16_black,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          cItem.type == GMsgType.TRANS
                              ? "[转账]" + cItem.content
                              : cItem.type == GMsgType.RED
                                  ? "[红包]"
                                  : cItem.content,
                          style: CommonStyle.text_12_grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  cItem.time.toString(),
                  style: CommonStyle.text_12_grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 下拉框
  Widget getPopView() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Image.asset(
            "assets/images/chat_add.png",
            width: 28.w,
            height: 28.w,
          ),
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: CommonStyle.text_14_black_w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              //selectedValue = value as String;
              print(value);
              if (value == "添加好友") {
                Get.to(() => AddPeopleDetail());
              }
            });
          },
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200.h,
            width: 120.w,
            //padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.w),
              color: Colors.white,
            ),
            elevation: 8, //阴影
            offset: const Offset(0, -10),
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(40.w), //滚动条两端圆角
              thickness: MaterialStateProperty.all<double>(6.w), //滚动条宽度
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 40.w,
            padding: EdgeInsets.only(left: 34.w, right: 14.w),
          ),
        ),
      ),
    );
  }
}
