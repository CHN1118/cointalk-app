import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../../api/contact_api.dart';
import '../../../../common/global/global_url.dart';
import '../../../../common/style/common_color.dart';
import '../../../../common/style/common_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../common/utils/toast_print.dart';
import '../../../../db/kv_box.dart';
import '../../../../event/notify_event.dart';
import '../chat_detail.dart';

class AddPeopleDetail extends StatefulWidget {
  const AddPeopleDetail({Key? key}) : super(key: key);

  @override
  State<AddPeopleDetail> createState() => _AddPeopleDetailState();
}

class _AddPeopleDetailState extends State<AddPeopleDetail> {
  final ubox = KVBox.GetUserBox();
  List consumerObject = [];
  final FocusNode _focusSearchNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final EventBus eventBus = globalBus;

  @override
  void dispose() {
    _focusSearchNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  // 添加联系人
  void addContactPeople() async {
    var searchPeople;
    if (searchController.text.isNotEmpty) {
      searchPeople = await contactApi().addContact(searchController.text);
      if (searchPeople.data['code'] == 0) {
        _btnController.success();
        var data = searchPeople.data['data'];
        if (data != null && data.isNotEmpty) {
          setState(() {});
          consumerObject = data;
        } else {
          ToastPrint.show("no_such_account_found".tr);
        }
        Future.delayed(Duration(seconds: 1), () {
          _btnController.reset();
        });
      }
    } else {
      ToastPrint.show("please_input_account".tr);
      _btnController.error();
      Future.delayed(Duration(seconds: 1), () {
        _btnController.reset();
      });
    }
  }

  // 创建单聊频道
  createFriend(int i) async {
    ubox.write('consumer_' + consumerObject[i]['cid'].toString(), consumerObject[i]);
    var addRes = await contactApi().addChannelChat(consumerObject[i]['cid']);
    if (addRes.data['data'] != null && addRes.data['data'].isNotEmpty) {
      var channelInfo = addRes.data['data']['channel'];
      print("---channelInfo---->${channelInfo}");
      // 写入消息角标
      // ubox.write(BoxKey.ChannelCorner + channelInfo['id'].toString(), 0);
      KVBox.SetChannelInfo(channelInfo['id'].toString(), channelInfo);
      // ubox.write('channelInfo_' + channelInfo['id'].toString(), channelInfo);
      var relation_all = addRes.data['data']['relation_all'];
      print("---2312321---->${relation_all}");
      ubox.write('relation_all', relation_all);
      // print(ubox.read('channelInfo_' + channelInfo['id'].toString()));
      print('调用刷新同通讯录-----》');

      eventBus.fire(NotifyEvent(msg: NKey.refresh_chat));
      eventBus.fire(NotifyEvent(msg: NKey.refresh_contact));
      final res = await Get.off(() => ChatDetailPage(), arguments: {
        'name': consumerObject[i]['account'],
        'channelId': channelInfo['id'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var edgeInsets = EdgeInsets.only(
      left: getScreenWidth(context, 0.046153846153846),
      right: getScreenWidth(context, 0.046153846153846),
      bottom: getScreenWidth(context, 0.023076923076923),
      top: getScreenWidth(context, 0.023076923076923),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: SvgPicture.asset(
                //     'assets/svgs/add_group_background.svg',
                //     width: 146.w,
                //     height: 146.w,
                //   ),
                // ),
                Column(
                  children: [
                    AppBar(
                      title: Text(
                        "new_contact".tr,
                        style: CommonStyle.text_18_black,
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      leading: GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: EdgeInsets.only(),
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      elevation: 0.0,
                    ),
                    //*搜索框
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {});
                        },
                        controller: searchController,
                        style: CommonStyle.text_16_black,
                        keyboardType: TextInputType.text,
                        focusNode: _focusSearchNode,
                        decoration: InputDecoration(
                          hintText: "search_friends".tr,
                          hintStyle: TextStyle(
                            color: Color(0xFF7E7E7E),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25), //边角为30
                            ),
                          ),
                          suffixIcon: searchController.text.isNotEmpty && _focusSearchNode.hasFocus
                              ? InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () {
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    addContactPeople();
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                        ),
                        autofocus: false,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.w),
                            topRight: Radius.circular(16.w),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Opacity(
                                opacity: 1,
                                child: Stack(
                                  children: [
                                    Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.w),
                                            topRight: Radius.circular(16.w),
                                          ),
                                          color: const Color.fromRGBO(255, 255, 255, 0.05),
                                        ),
                                        child: Stack(
                                          children: [
                                            if (consumerObject.isNotEmpty)
                                              Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(top: 0.w),
                                                    itemCount: consumerObject.length,
                                                    itemBuilder: (context, i) {
                                                      return ListTile(
                                                        onTap: () {
                                                          createFriend(i);
                                                          setState(() {});
                                                        },
                                                        leading: Container(
                                                          width: 35.w,
                                                          height: 35.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.w),
                                                            image: DecorationImage(
                                                              image: NetworkImage(consumerObject[i]['avatar']),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          consumerObject.isNotEmpty
                                                              ? consumerObject[i]['account']
                                                              : '',
                                                          style: CommonStyle.text_14_black,
                                                        ),
                                                      );
                                                    }),
                                              )
                                            else
                                              SizedBox(),
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 55.w,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 41.w,
                                                  width: 138.w,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(30.w),
                                                      bottomRight: Radius.circular(30.w),
                                                    ),
                                                    child: RoundedLoadingButton(
                                                      duration: Duration(milliseconds: 300),
                                                      color: CommonColor.second1,
                                                      successColor: CommonColor.second1,
                                                      errorColor: CommonColor.second2,
                                                      height: 41.w,
                                                      width: 138.w,
                                                      controller: _btnController,
                                                      borderRadius: 30.w,
                                                      onPressed: () {
                                                        addContactPeople();
                                                      },
                                                      child: Container(
                                                          width: 138.w,
                                                          height: 41.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(30.w),
                                                              bottomRight: Radius.circular(30.w),
                                                            ),
                                                            gradient: const LinearGradient(
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                              colors: [
                                                                Color(0xFFd0effc),
                                                                Color(0xFFe4ddf7),
                                                              ],
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "certain".tr,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
