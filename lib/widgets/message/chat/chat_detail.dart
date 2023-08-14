import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:wallet/widgets/message/chat/red/red_open.dart';
import 'package:wallet/widgets/message/chat/send_red_pack.dart';
import '../../../api/centre_api.dart';
import '../../../centre/centre.dart';
import '../../../common/global/global_key.dart';
import '../../../common/global/global_url.dart';
import '../../../common/style/common_color.dart';
import '../../../common/style/common_style.dart';
import '../../../common/utils/hash.dart';
import '../../../common/utils/toast_print.dart';
import '../../../components/pay_pwd_controller.dart';
import '../../../db/channel.dart';
import '../../../db/kv_box.dart';
import '../../../db/relation.dart';
import '../../../event/notify_event.dart';
import '../../../spec/chat/chat.dart';
import '../../../spec/chat/consumer.dart';
import '../../../spec/chat/sync_db_ret.dart';
import 'chat_transfer.dart';

class ChatDetailPage extends StatefulWidget {
  ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  BuildContext? _context;
  final ubox = GetStorage(globalCentre.centreDB.box.read("userId"));
  final List<types.Message> _messages = [];
  List showMsgKeys = [];
  final String uid = KVBox.GetUserId();
  final String cid = KVBox.GetCid();
  late types.User _user;
  int limit = 1;
  int channelId = Get.arguments['channelId'];
  String fromRouteName = Get.arguments['name'] ?? "";
  String channelName = "";
  final ImagePicker _picker = ImagePicker();
  Consumer? consumer;
  RelationView? relation;
  EventBus eventBus = globalBus;
  StreamSubscription? _subscription;
  UserInfo userInfo = KVBox.GetUserInfo();
  final List<String> items = [
    'set_notes',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    getConsumerInfo();
    _user = types.User(
      id: cid.toString(),
      firstName: userInfo.account,
    );
    getChannelDetail(limit);
    // 用户信息更新
    _subscription = eventBus.on<NotifyEvent>().listen((event) {
      if (event.msg == NKey.refresh_chat_detail) {
        refreshData();
      }
      if (event.msg == NKey.refresh_note_name) {
        getConsumerInfo();
        getChannelDetail(limit);
        // refreshData();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // 获取对方信息
  getConsumerInfo() {
    ChannelInfo channelInfo = KVBox.GetChannelInfo(channelId);
    consumer = ChannelDB.GetCacheConsumer(ubox, channelInfo, int.parse(cid));
    // 通过对方cid获取关系信息
    relation = RelationDB.GetRelationToCid(consumer!.cid);
    print("getConsumerInfo -=================${relation?.toNoteName}");
  }

  // 刷新数据
  Future<void> refreshData() async {
    var channelIdStr = channelId.toString();
    int index = KVBox.GetChannelIndex(channelId);

    var dataId = channelIdStr + "-" + (index).toString();
    if (ubox.hasData(dataId)) {
      MsgInfo? mi = KVBox.GetMsgInfo(dataId);
      if (mi == null) {
        print("mi is null");
        return;
      }
      var chatName = relation?.toNoteName == "" ? mi.nickName : relation?.toNoteName;
      var msg;
      if (mi.type == GMsgType.TEXT) {
        msg = types.TextMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          text: mi.content,
          createdAt: mi.time,
        );
        if (mi.fromId.toString() != cid) {
          _addMessage(msg);
        }
      } else if (mi.type == GMsgType.TRANS) {
        msg = types.CustomMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          metadata: {
            "type": GMsgType.TRANS,
            "num": mi.content,
            "remark": mi.remark,
          },
          createdAt: mi.time,
        );
        if (mi.fromId.toString() != cid) {
          _addMessage(msg);
        }
      } else if (mi.type == GMsgType.RED) {
        msg = types.CustomMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          metadata: {
            "type": GMsgType.RED,
            "num": mi.content,
            "remark": mi.remark,
          },
          createdAt: mi.time,
        );
        if (mi.fromId.toString() != cid) {
          _addMessage(msg);
        }
      }
    }
  }

  // 获取聊天记录
  Future<void> getChannelDetail(int limit) async {
    // 先清空消息列表和消息key列表
    _messages.clear();
    showMsgKeys.clear();
    int index = KVBox.GetChannelIndex(channelId);
    int allIndex = 1;
    // 从所有key中取出最后10条
    if (index == 0) {
      showMsgKeys = [];
    } else {
      // 大于10条
      if (index >= limit * 10) {
        allIndex = limit * 10;
      } else {
        // 小于10条
        allIndex = index;
      }
      for (int i = 0; i < allIndex; i++) {
        showMsgKeys.insert(0, channelId.toString() + "-" + (index - i).toString());
      }
      showMsgKeys.reversed;
    }
    print("showMsgKeys = ${showMsgKeys}");
    showMsgKeys.forEach((key) {
      MsgInfo? mi = KVBox.GetMsgInfo(key);
      if (mi == null) {
        print("MsgInfo is null");
        return;
      }
      late types.Message msg;
      var chatName = relation?.toNoteName == "" ? mi.nickName : relation?.toNoteName;
      if (mi.type == GMsgType.TEXT) {
        msg = types.TextMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          text: mi.content,
          createdAt: mi.time,
        );
      } else if (mi.type == GMsgType.TRANS) {
        msg = types.CustomMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          metadata: {
            "type": GMsgType.TRANS,
            "num": mi.content,
            "remark": mi.remark,
          },
          createdAt: mi.time,
        );
      } else if (mi.type == GMsgType.RED) {
        msg = types.CustomMessage(
          author: types.User(
            id: mi.fromId.toString(),
            firstName: chatName,
            imageUrl: mi.avatar,
          ),
          id: mi.msgId,
          metadata: {
            "type": GMsgType.RED,
            "num": mi.content,
            "remark": mi.remark,
          },
          createdAt: mi.time,
        );
      }
      _addMessage(msg);
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // 附加栏
  void _handleAttachmentPressed() {
    // if (widget.chatTypes == "public") {
    //   Fluttertoast.showToast(msg: "單聊僅支持文字信息", gravity: ToastGravity.CENTER);
    //   return;
    // }
    showModalBottomSheet<void>(
      context: _context!,
      builder: (BuildContext context) => Container(
        color: Color(0xfff4f4f4),
        height: MediaQuery.of(context).size.height * 0.2,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _chatAttachmentItem("photo".tr, "assets/image/chat_attachment_image.png", tapFunc: () async {

                ToastPrint.show("not_open_yet".tr);

                // final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                // print("照片 pickedFile = ${pickedFile?.path}");
                // if (pickedFile != null) {
                //   Get.back(result: pickedFile);
                // }
              }),
              _chatAttachmentItem("shoot".tr, "assets/image/chat_attachment_shoot.png", tapFunc: () async {
                ToastPrint.show("not_open_yet".tr);

                // final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                // print("拍摄 pickedFile = ${pickedFile?.path}");
                // if (pickedFile != null) {
                //   Get.back(result: pickedFile);
                // }
              }),
              _chatAttachmentItem("red_envelope".tr, "assets/image/chat_attachment_red.png", tapFunc: () async {
                final result = await Get.to(() => SendRedPack(), arguments: {"consumer": consumer});
                // print("红包 result = ${result}");
                if (result == GKey.SUCCESS) {
                  String amount = Get.find< PayPwdBottomController>().amountValue.value;
                  String remark = Get.find<PayPwdBottomController>().remarkValue.value;
                  // print("红包 amount = ${amount}");
                  // print("红包 remark = ${remark}");
                  _handleRed(num.parse(amount), remark);
                }
              }),
              _chatAttachmentItem("transfer".tr, "assets/image/chat_attachment_transfer.png", tapFunc: () async {
                final result = await Get.to(() => ChatTransferPage(), arguments: {"consumer": consumer});
                if (result == GKey.SUCCESS) {
                  String amount = Get.find<PayPwdBottomController>().amountValue.value;
                  String remark = Get.find<PayPwdBottomController>().remarkValue.value;
                  // print("转账 amount = ${amount}");
                  // print("转账 remark = ${remark}");
                  _handleTransfer(num.parse(amount), remark);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  // 点击消息
  _handleMessageTap(BuildContext context, types.Message msg) {
    if (msg.type == MessageType.custom) {
      if (msg.metadata!["type"] == GMsgType.RED) {
        late String openFlag;
        String? name;
        if (cid == msg.author.id) {
          // 自己发的
          openFlag = "0";
          name = consumer!.account;
        } else {
          openFlag = "1"; // 别人发的
          name = msg.author.firstName;
        }
        print(msg.metadata!["num"]);
        print(msg.author.firstName);
        print(msg.metadata!["remark"]);

        Get.to(
          () => RedOpen(),
          arguments: {
            "num": msg.metadata!["num"],
            "name": name,
            "openFlag": openFlag,
            "remark": msg.metadata!["remark"],
          },
        );
      }
    }
  }

  // 文本消息
  Future<void> _handleSendPressed(types.PartialText message) async {
    String hashStr = Hash.genMsgHashId();
    var msgId = hashStr.substring(0, 6);
    DateTime currentTime = DateTime.now();
    var textMessage = types.TextMessage(
      author: _user,
      createdAt: currentTime.millisecondsSinceEpoch,
      id: msgId,
      text: message.text,
      status: types.Status.sending,
    );
    var mInfo = MsgInfo(
      type: GMsgType.TEXT,
      content: message.text,
      msgId: msgId,
      // 默认时间2000-1-1 0:0:0
      time: textMessage.createdAt ?? 946656000,
      fromId: int.parse(cid),
      channelId: channelId,
      nickName: _user.firstName ?? userInfo.account,
      avatar: userInfo.avatar,
    );
    var sp = SendParam(
      channelId: channelId,
      msgInfo: jsonEncode(mInfo.toJson()),
    );
    _addMessage(textMessage);
    var resCode = await CentreApi().sendData(sp);
    if (resCode == 0) {
      final index = _messages.indexWhere((element) => element.id == msgId);
      final updatedMessage = (_messages[index] as types.TextMessage).copyWith(status: types.Status.sent);
      setState(() {
        _messages[index] = updatedMessage;
      });
    }
  }

  // 处理转账消息
  _handleTransfer(num value, String remark) async {
    String hashStr = Hash.genMsgHashId();
    var msgId = hashStr.substring(0, 6);
    final message = types.CustomMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: msgId,
      metadata: {
        "type": GMsgType.TRANS,
        "num": value.toStringAsFixed(6),
        "remark": remark,
      },
      type: MessageType.custom,
    );
    // print("_handleTransfer remark = " + message.metadata!["remark"]);
    var mInfo = MsgInfo(
      type: message.metadata!["type"],
      content: message.metadata!["num"],
      remark: message.metadata!["remark"],
      msgId: message.id,
      time: message.createdAt!,
      fromId: int.parse(cid),
      channelId: channelId,
      nickName: _user.firstName ?? userInfo.account,
      avatar: userInfo.avatar,
    );
    var sp = SendParam(
      channelId: channelId,
      msgInfo: jsonEncode(mInfo.toJson()),
    );
    _addMessage(message);
    var resCode = await CentreApi().sendData(sp);
    if (resCode == 0) {
      final index = _messages.indexWhere((element) => element.id == msgId);
      final updatedMessage = (_messages[index] as types.CustomMessage).copyWith(status: types.Status.sent);
      setState(() {
        _messages[index] = updatedMessage;
      });
    }
  }

  // 处理红包消息
  void _handleRed(num value, String remark) async {
    String hashStr = Hash.genMsgHashId();
    var msgId = hashStr.substring(0, 6);
    final message = types.CustomMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: msgId,
      metadata: {
        "type": GMsgType.RED,
        "num": value.toStringAsFixed(6),
        "remark": remark,
      },
      type: MessageType.custom,
    );
    var mInfo = MsgInfo(
      type: message.metadata!["type"],
      content: message.metadata!["num"],
      remark: message.metadata!["remark"],
      msgId: message.id,
      time: message.createdAt!,
      fromId: int.parse(cid),
      channelId: channelId,
      nickName: _user.firstName ?? userInfo.account,
      avatar: userInfo.avatar,
    );
    var sp = SendParam(
      channelId: channelId,
      msgInfo: jsonEncode(mInfo.toJson()),
    );
    _addMessage(message);
    var resCode = await CentreApi().sendData(sp);
    if (resCode == 0) {
      final index = _messages.indexWhere((element) => element.id == msgId);
      final updatedMessage = (_messages[index] as types.CustomMessage).copyWith(status: types.Status.sent);
      setState(() {
        _messages[index] = updatedMessage;
      });
    }
    // Get.back();
    // _addMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        // 先看上个页面是否有传name，如果没有则看是否有备注，没有则显示账号
        title: Text(
            fromRouteName == ""
                ? relation?.toNoteName == ""
                    ? consumer!.account
                    : relation?.toNoteName ?? consumer!.account
                : fromRouteName,
            style: CommonStyle.text_18_black),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          splashRadius: 1,
          onPressed: () {
            Get.back(result: NKey.refresh_chat);
          },
        ),
        elevation: 0,
        actions: [
          fromRouteName == "客服" ? Offstage() : getPopView(),
        ],
      ),
      body: RefreshIndicator(
        color: CommonColor.primary,
        backgroundColor: Colors.white,
        onRefresh: () {
          // 在这里处理下拉刷新的逻辑
          // return Future.delayed(Duration(seconds: 2));
          print("getChannelDetail limit =${limit}");
          return getChannelDetail(limit++);
        },
        child: Chat(
          user: _user,
          messages: _messages,
          //自定义消息
          customMessageBuilder: customMessageBuilder,
          //附件栏
          onAttachmentPressed: _handleAttachmentPressed,
          // onPreviewDataFetched: _handlePreviewDataFetched,
          //发送消息
          onSendPressed: _handleSendPressed,
          onMessageTap: _handleMessageTap,
          scrollPhysics: BouncingScrollPhysics(),
          showUserAvatars: true,
          showUserNames: true,
          timeFormat: DateFormat('MM月dd日 HH:MM'),
          listBottomWidget: Container(),
          l10n: ChatL10nZhCN(inputPlaceholder: "${'enter_message'.tr}..."),
          theme: DefaultChatTheme(
            backgroundColor: Color(0xFFF1F1F1),
            primaryColor: CommonColor.primary,
            secondaryColor: Colors.white,
            receivedMessageBodyTextStyle: CommonStyle.text_16_primary_w500,
            attachmentButtonIcon: Icon(
              Icons.add_circle_outline,
              size: 28,
              color: Color(0xFF2C2C2C),
            ),
            emptyChatPlaceholderTextStyle: CommonStyle.text_12_grey,
            inputTextCursorColor: CommonColor.primary,
            inputTextColor: Colors.black,
            inputContainerDecoration: BoxDecoration(
              color: Color(0xFFf4f4f4),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
            ),
            sentMessageBodyTextStyle: CommonStyle.text_16_white_w500,
            userNameTextStyle: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
          customButton: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
          ),
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item.tr,
                      style: CommonStyle.text_14_black_w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            // if (value == "设置备注") {
            //   Get.to(() => EditNamePage(), arguments: channelId);
            // }
          },
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            elevation: 6,
            offset: const Offset(0, 10),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 34, right: 14),
          ),
        ),
      ),
    );
  }
}

// 附件栏
Widget _chatAttachmentItem(String message, String image, {required VoidCallback tapFunc}) {
  return InkWell(
    onTap: () {
      tapFunc();
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 5),
          child: Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(14),
            child: Image.asset(
              image,
              width: 32,
              height: 32,
            ),
          ),
        ),
        Text(message, style: CommonStyle.text_14_grey),
      ],
    ),
  );
}

// 自定义消息
Widget customMessageBuilder(types.CustomMessage message, {required int messageWidth}) {
  String cid = KVBox.GetCid();
  if (message.metadata!["type"] == GMsgType.TRANS) {
    return TransferMessageBuilder(message, cid);
  }
  if (message.metadata!["type"] == GMsgType.RED) {
    return RedPacketBuilder(message, cid);
  }
  return SizedBox(width: 0);
}

// 自定义转账消息
Widget TransferMessageBuilder(types.CustomMessage message, String cid) {
  return Container(
    width: Get.width * 0.6,
    padding: EdgeInsets.all(12),
    color: Colors.orange,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              cid == message.author.id ? Icons.check_circle_outline : Icons.currency_exchange,
              size: 32,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(text: message.metadata!["num"], style: CommonStyle.text_18_white_w700, children: [
                  TextSpan(
                    text: " USDT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ])),
                Text(
                  message.metadata!["remark"] == null || message.metadata!["remark"] == ""
                      ? cid == message.author.id
                          ? "transfer_success".tr
                          : "receive_transfer".tr
                      : message.metadata!["remark"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(
          color: Colors.white,
        ),
        Text(
          "transfer".tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

// 红包消息
Widget RedPacketBuilder(types.CustomMessage message, String cid) {
  return Container(
    width: Get.width * 0.6,
    padding: EdgeInsets.all(12),
    color: Colors.orange,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
              child: Image.asset(
                "assets/image/red_packet.png",
                width: 40,
                height: 40,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.metadata!["remark"] == null || message.metadata!["remark"] == ""
                      ? "red_envelope_remarks_hint".tr
                      : message.metadata!["remark"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(
          color: Colors.white,
        ),
        Text(
          "red_envelope".tr,
          style: CommonStyle.text_12_white,
        ),
      ],
    ),
  );
}

Widget UpdateGroupNameMessageBuilder(types.CustomMessage message) {
  return Container(
    // width: messageWidth.toDouble(),
    // width: Get.width * 0.6,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black12,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "update_group_name".tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Text(
          message.metadata!["name"],
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
