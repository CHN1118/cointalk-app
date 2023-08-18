import 'dart:async';

import 'package:azlistview/azlistview.dart';
import 'package:event_bus/event_bus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../../../centre/centre.dart';
import '../../../../common/global/global_url.dart';
import '../../../../common/style/common_color.dart';
import '../../../../common/style/common_style.dart';
import '../../../../db/channel.dart';
import '../../../../db/consumer.dart';
import '../../../../db/kv_box.dart';
import '../../../../db/relation.dart';
import '../../../../event/notify_event.dart';
import '../../../../spec/chat/chat.dart';
import '../../../../spec/chat/sync_db_ret.dart';
import '../chat_detail.dart';
import 'add_people.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ubox = KVBox.GetUserBox();
  final ubox1 = KVBox.GetUserBox();
  final ubox2 = GetStorage(globalCentre.centreDB.box.read("userId").toString());
  List<ContactInfo> contactList = [];

  // final Controller c = Get.find(); //*获取控制器
  final nameController = TextEditingController();
  FocusNode nameNode = FocusNode();
  EventBus eventBus = globalBus;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // print("ubox.read('relation_all')=======>${ubox.read('relation_all')}");
    loadData();
    _subscription = eventBus.on<NotifyEvent>().listen((event) {
      if (event.msg == NKey.refresh_contact) {
        contactList.clear();
        loadData();
      }
      if (event.msg == NKey.refresh_note_name) {
        print("刷新通讯录");
        contactList.clear();
        loadData();
        // setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // _subscription?.cancel();
    super.dispose();
  }

  loadData() async {
    // await c.setUserInfo();
    // contactList.clear();
    print("has1 = ${ubox1.hasData("relation_all")}");
    print("has1 value = ${ubox1.read("relation_all")}");
    print("has2 = ${ubox2.hasData("relation_all")}");
    print("has2 value = ${ubox2.read("relation_all")}");
    var allCidList = ubox.read('relation_all');
    print("-------我的通讯录-------->${allCidList}");
    // 如果box.read('relation_all')不是null，这段代码会被执行
    for (var cid in allCidList) {

      var consumerInfo = await ConsumerDB.GetConsumerByCid(ubox, cid);
      // 取备注
      RelationView? rv = RelationDB.GetRelationToCid(cid);
      var showName = consumerInfo.account;
      if (rv != null) {
        if(rv.toNoteName != ""){
          showName = rv.toNoteName+"(${consumerInfo.account})";
        }
        // nName = rv.toNoteName == "" ? "" : "${rv.toNoteName}";
      }
      print("-------------${consumerInfo}");
      contactList.add(ContactInfo(
        // name: consumerInfo.account + nName,
        name: showName,
        img: consumerInfo.avatar,
        id: cid.toString(),
      ));
    }
    print("contactList======>${contactList}");
    _handleList(contactList);
  }

  // 处理列表
  void _handleList(List<ContactInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(contactList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(contactList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (content) {
        // var constraints;
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  toolbarHeight: 48.w,
                  title: Text(
                    "index_Contacts".tr,
                    style: CommonStyle.text_18_black_w500,
                  ),
                  // 设置 toolbar 控件的高度
                  leading: Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 6.w, bottom: 6.w),
                    child: Container(
                      height: 36.w,
                      width: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.1),
                        shape: BoxShape.circle, //圆形装饰线
                      ),
                      child: Center(
                        child: SizedBox(
                          child: InkWell(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Get.back();
                              }),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.search_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Get.to(AddPeopleDetail());
                        }),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 16.w,
                    ),
                    child: SizedBox(
                      height: double.infinity,
                      child: Stack(
                        children: [
                          //* 毛玻璃
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18.w),
                                  topRight: Radius.circular(18.w),
                                ),
                                child: Container(
                                  color: Color(0xF1c3fd6).withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.w),
                                topRight: Radius.circular(18.w),
                              ),
                            ),
                          ),
                          Positioned(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18.w),
                                  topRight: Radius.circular(18.w),
                                ),
                                child: AzListView(
                                  data: contactList,
                                  susPosition: const Offset(1, -100),
                                  //悬停位置 移出可见区域
                                  itemCount: contactList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    ContactInfo model = contactList[index];
                                    int len = contactList.length;
                                    return getWeChatListItem(
                                      context,
                                      model,
                                      index,
                                      len,
                                    );
                                  },
                                  // physics:const BouncingScrollPhysics(),
                                  susItemBuilder: (BuildContext context, int index) {
                                    ContactInfo model = contactList[index];
                                    if ('↑' == model.getSuspensionTag()) {
                                      return Container();
                                    }
                                    return Container(
                                      height: 40,
                                      // 设置高度
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(left: 16.0.w),
                                      color: const Color(0x01ffffff),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        model.getSuspensionTag(),
                                        softWrap: false, // 设置是否自动换行
                                        style: CommonStyle.text_14_black,
                                      ),
                                    );
                                  },
                                  indexBarData: const ['↑', ...kIndexBarData],
                                  indexBarOptions: IndexBarOptions(
                                    needRebuild: true,
                                    ignoreDragCancel: true,
                                    downTextStyle: CommonStyle.text_12_white,
                                    downItemDecoration: BoxDecoration(
                                      color: CommonColor.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    indexHintWidth: 120 / 2,
                                    indexHintHeight: 100 / 2,
                                    indexHintDecoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/punctuation.jpg'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    indexHintAlignment: Alignment.centerRight,
                                    indexHintChildAlignment: const Alignment(-0.25, 0.0),
                                    indexHintOffset: const Offset(-20, 0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }

  // 通讯录列表每个元素
  Widget getWeChatListItem(BuildContext context, ContactInfo model, int index, int len) {
    DecorationImage? image;
    // if (model.img != null && model.img.isNotEmpty) {
    //   image = DecorationImage(
    //     image: CachedNetworkImageProvider(model.img),
    //     fit: BoxFit.contain,
    //   );
    // }
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // 确保能够接收点击事件
      onTap: () async {
        if (model.id != null) {
          print('--model.id--->${model.id}');
          // 通过cid获取channelId
          // var res = await KVBox.GetRelationToCidAsync(int.parse(model.id!));
          var data = await RelationDB.GetRelationToCidAsync(int.parse(model.id!));
          await ChannelDB.ChannelSolveNull(data!.channelId);
          // print('--31321--->${data.channelId}');
          //跳转到好友详情
          var res = Get.to(() => ChatDetailPage(), arguments: {'channelId': data.channelId});
          if (res != null) {
            print("res ==============$res");
            setState(() {
              contactList.clear();
              loadData();
            });
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
          // shape: Border(
          //   bottom: Divider.createBorderSide(context, width: 0.125),
          // ),
          leading: Container(
            width: model.tagIndex == '↑' ? 24.w : 44.w,
            height: model.tagIndex == '↑' ? 24.w : 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50.w),
              image: image,
            ),
            child: model.img == null
                ? Image.asset(
                    "assets/images/avatar.png",
                    fit: BoxFit.cover,
                  )
                : 'assets/svgs/layout-bottom.svg' == model.img ||
                        'assets/svgs/marker-04.svg' == model.img ||
                        'assets/svgs/users-profiles-01.svg' == model.img
                    ? SvgPicture.asset(
                        model.img!,
                        fit: BoxFit.cover,
                      )
                    : ClipOval(
                        child: Image.network(
                          model.img!,
                          width: 50.w,
                          height: 50.w,
                        ),
                      ),
          ),
          title: Text(
            model.name,
            style: CommonStyle.text_14_black,
          ),
        ),
      ),
    );
  }
}
