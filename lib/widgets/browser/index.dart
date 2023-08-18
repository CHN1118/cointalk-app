// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/components/op_click.dart';
import 'package:wallet/database/index.dart';

import 'package:wallet/widgets/browser/share.dart';

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _BrowserState();
}

List<dynamic> historyList = DB.box.read('historyList') ?? []; // 历史记录列表
//~收藏弹框
Future<bool?> showSnackBar({String? msg}) {
  return Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT, // 消息框持续的时间
      gravity: ToastGravity.TOP, // 消息框弹出的位置
      timeInSecForIosWeb: 1, // ios
      backgroundColor: const Color(0xffF2F8F5).withOpacity(1),
      textColor: const Color(0xff000000),
      fontSize: 14.sp);
}

//~判断点击选择了哪个收藏按钮
handleItemClick(int index, List list) {
  for (int i = 0; i < list.length; i++) {
    if (i == index) {
      list[i] = !list[i];
    }
  }
}

//主体部分
class _BrowserState extends State<Browser> {
  bool isRecommendedPage = true; // 是否为推荐
  bool isExplorePage = false; // 是否为探索
  bool isFavoritesPage = false; // 是否为收藏

  double isBtns = 0; //是否选中
  List<String> btns = [
    '推荐',
    '探索',
    '收藏',
  ];
  final FocusNode _focussearchNode = FocusNode(); //搜索框焦点控制
  final TextEditingController _textEditingController =
      TextEditingController(); //搜索框控制器
  String _searchText = ''; //搜索内容
  bool isSearching = false; //是否正在搜索

  @override
  void initState() {
    super.initState();
    _focussearchNode.addListener(_focusChanged); //监听输入框是否失去焦点
  }

  @override
  void dispose() {
    _focussearchNode.removeListener(_focusChanged); //移除监听
    _focussearchNode.dispose(); //销毁焦点控制
    _textEditingController.dispose(); //销毁控制器

    super.dispose();
  }

  //监听输入框是否失去焦点,书去焦点后3秒后设置isSearching为false
  void _focusChanged() {
    if (_focussearchNode.hasFocus) {
      setState(() {
        isSearching = true; //设置正在搜索
      });
    } else {
      setState(() {
        isSearching = false; //设置正在搜索
      });
    }
  }

  // 处理搜索提交事件
  void _handleSearchSubmit() {
    if (_searchText.isNotEmpty) {
      // 搜索内容不为空时
    }
  }

  void addToHistory(String item) {
    setState(() {
      historyList.insert(0, item); // 将项添加到历史记录列表
      DB.box.write('historyList', historyList); // 将历史记录列表写入数据库
    });
  }

  List experienceList = [for (int i = 0; i < 10; i++) false]; //* 立即体验列表数据

//&主体部分
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // 点击空白处隐藏键盘
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              SizedBox(
                height: 135.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = true; //设置正在搜索
                          _focussearchNode.requestFocus(); // 获取焦点
                        });
                      },
                      child: Container(
                        width:
                            _focussearchNode.hasFocus || _searchText.isNotEmpty
                                ? 319.w
                                : 348.w,
                        height: 30.h,
                        margin: EdgeInsets.only(top: 70.h, left: 19.w),
                        padding: EdgeInsets.only(right: 30.w),
                        decoration: BoxDecoration(
                            // 背景渐变色
                            gradient: const LinearGradient(
                              colors: [Color(0x4d75b099), Color(0x4d4979D6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25.w)),
                        //^搜索框
                        child: TextField(
                          controller: _textEditingController, // 设置控制器
                          cursorColor: Colors.green, //设置光标颜色
                          strutStyle: StrutStyle.fromTextStyle(
                              TextStyle(fontSize: 25.0.w, height: 0.8.w)),
                          style: TextStyle(
                              fontSize: 14.0.w,
                              textBaseline:
                                  TextBaseline.alphabetic), //设置字体大小 以及基线对齐

                          cursorHeight: 18.sp, //设置光标高度
                          cursorRadius: const Radius.circular(10), // 设置光标圆角半径
                          textAlignVertical: TextAlignVertical.center, // 将光标居中
                          focusNode: _focussearchNode, // 将搜索框和FocusNode关联
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              margin: EdgeInsets.only(right: 5.w),
                              padding: EdgeInsets.only(top: 3.w, bottom: 3.w),
                              decoration: const BoxDecoration(),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color(0xaa75b099),
                                      Color(0xaa4979D6)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: SvgPicture.asset(
                                  'assets/svgs/sousuo.svg', // 设置SVG图标的路径
                                  width: 15.w,
                                  height: 17.w,
                                ),
                              ),
                            ),
                            isCollapsed: true, //去除内边距
                            contentPadding: EdgeInsets.all(0.w), //*去除内边距
                            border: InputBorder.none,
                          ),
                          // 添加 onSubmitted 回调处理用户按下键盘上的搜索按钮的事件
                          onSubmitted: (value) {
                            setState(() {
                              _searchText = value.trim();
                              if (value.trim() == '') {
                                _searchText = '';
                                _textEditingController.clear(); //清空搜索框
                              }

                              if (_searchText.isNotEmpty) {
                                addToHistory(_searchText); // 将搜索内容添加到历史记录列表
                                //将搜索内容保存到本地
                                DB.box.write('_searchText', _searchText);
                              }
                            });
                            _handleSearchSubmit();
                          },
                          // 添加 onChanged 回调处理搜索文本的更新
                          onChanged: (value) {
                            setState(() {
                              String trimmedValue = value.replaceAll(' ', '');
                              _textEditingController.value =
                                  _textEditingController.value
                                      .copyWith(text: trimmedValue);

                              if (value == '') _searchText = '';
                            });
                          }, // 添加 onChanged 回调处理搜索文本的更新
                        ),
                      ),
                    ),
                    if (_focussearchNode.hasFocus || _searchText.isNotEmpty)
                      //^ 取消按钮
                      Container(
                        width: 35.h,
                        height: 23.w,
                        margin: EdgeInsets.only(top: 70.h, left: 8.w),
                        child: OpClick(
                          onTap: () {
                            setState(() {
                              isSearching = false; //设置正在搜索
                              _focussearchNode.unfocus(); //取消搜索框的焦点
                              _textEditingController.clear(); //清空搜索框
                              _searchText = ''; //清空搜索内容
                            });
                          },
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: const Color(0xff0C666B).withOpacity(0.5),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              //^ 历史记录
              if (_focussearchNode.hasFocus && _searchText.isEmpty)
                const HistoricalRecord(),
              //^ 搜索结果
              if (_searchText.isNotEmpty) const SearchResults(),
              //^ 推荐 探索  收藏
              if (!_focussearchNode.hasFocus && _searchText.isEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 120.h,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.only(top: 106.w),
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 15.w, right: 21.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.blue,
                                  width: 140.w,
                                  height: 22.w,
                                  margin: EdgeInsets.only(
                                      top: 18.h, bottom: 15.h, left: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (String i in btns)
                                        //& 推荐探索收藏
                                        OpClick(
                                          onTap: () {
                                            setState(() {
                                              isBtns =
                                                  btns.indexOf(i).toDouble();
                                              i == btns[0]
                                                  ? isRecommendedPage = true
                                                  : isRecommendedPage = false;
                                              i == btns[1]
                                                  ? isExplorePage = true
                                                  : isExplorePage = false;
                                              i == btns[2]
                                                  ? isFavoritesPage = true
                                                  : isFavoritesPage = false;
                                            });
                                          },
                                          child: Center(
                                              child: Text(
                                            i,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: isBtns == btns.indexOf(i)
                                                  ? AppTheme.themeColor
                                                  : AppTheme.browserColor,
                                            ),
                                          )),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),

                      //^ 推荐
                      if (isRecommendedPage)
                        Positioned(
                            top: 170.h,
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 12.w, top: 10.w),
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 10.w),
                                itemCount: 1, // 列表项数
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      //^ 推荐：图片和立即体验
                                      Container(
                                        color: Colors.white,
                                        // padding: EdgeInsets.only(left: 13.w, right: 14.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                width: 348.w,
                                                height: 149.h,
                                                child: const Image(
                                                    image: AssetImage(
                                                        'assets/images/shopping_online.png')),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 23.h,
                                                bottom: 15.h,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.w)),
                                              child: Text(
                                                '立即体验',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //^ 推荐：立即体验的列表
                                      for (int i = 0;
                                          i < experienceList.length;
                                          i++)
                                        GestureDetector(
                                          onTap: () {
                                            //跳转到 SharePage 页面
                                            Get.to(() => const SharePage());
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            margin:
                                                EdgeInsets.only(bottom: 14.w),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 60.w,
                                                  height: 60.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.w)),
                                                  child: const Image(
                                                    image: AssetImage(
                                                        'assets/images/colt.png'),
                                                  ),
                                                ),
                                                Container(
                                                  width: 245.w,
                                                  margin: EdgeInsets.only(
                                                      left: 15.w, right: 15.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Uniswap',
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                      Text(
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        'A protocol for trading and automated liquidity provision on Ethereum',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: AppTheme
                                                              .browserColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 3.w),
                                                  child: OpClick(
                                                    onTap: () {
                                                      setState(() {
                                                        handleItemClick(
                                                            i, experienceList);
                                                        showSnackBar(
                                                            msg: experienceList[
                                                                    i]
                                                                ? '收藏成功'
                                                                : '取消收藏');
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/xingxing.svg', // 设置SVG图标的路径
                                                      width: 24.w,
                                                      height: 24.w,
                                                      // ignore: deprecated_member_use
                                                      color: experienceList[i]
                                                          ? const Color(
                                                              0xffF3D11C)
                                                          : const Color(
                                                              0xffEDEFF5),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                },
                              ),
                            )),
                      //~ 探索
                      if (isExplorePage)
                        Positioned(
                          top: 177.h,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: const ExplorePage(),
                        ),

                      //~ 收藏
                      if (isFavoritesPage) const FavoritesPage(),
                    ],
                  ),
                )
            ])));
  }
}

//~搜索结果 ---start
class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List SearchResultsList = [for (int i = 0; i < 10; i++) false];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 135.h,
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 21.w),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.w),
                itemCount: 1, // 列表项数
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 14.w),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15.h, left: 5.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.w)),
                                          child: Text(
                                            '搜索结果',
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])),
                          for (int i = 0; i < SearchResultsList.length; i++)
                            CustomListItem(
                                svgPath: 'assets/svgs/xingxing.svg',
                                isCollect: SearchResultsList[i],
                                onTapIncident: () {
                                  setState(() {
                                    handleItemClick(i, SearchResultsList);
                                    showSnackBar(
                                        msg: SearchResultsList[i]
                                            ? '收藏成功'
                                            : '取消收藏');
                                  });
                                })
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }
}
//~搜索结果 ---end

//~历史记录 ---start
class HistoricalRecord extends StatefulWidget {
  const HistoricalRecord({
    super.key,
  });

  @override
  State<HistoricalRecord> createState() => _HistoricalRecordState();

  void addToHistory(String searchText) {}
}

class _HistoricalRecordState extends State<HistoricalRecord> {
  @override
  void initState() {
    super.initState();
  }

  void deleteItem(int index) {
    setState(() {
      historyList.removeAt(index); // 删除对应的列表项
      DB.box.write('historyList', historyList); // 将历史记录列表写入数据库
    });
  }

  void clearList() {
    setState(() {
      historyList.clear(); // 清空列表
      DB.box.write('historyList', historyList); // 将历史记录列表写入数据库
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 125.h,
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 21.w),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0.w),
                itemCount: 1, // 设置列表项数为historyList的长度
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 14.w),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.w)),
                                          child: Text(
                                            '历史记录',
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            clearList(); // 点击清空按钮时调用清空函数
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 23.h,
                                                bottom: 15.h,
                                                left: 5.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.w)),
                                            child: SvgPicture.asset(
                                              'assets/svgs/a-12Fshanchu.svg', // 设置SVG图标的路径
                                              width: 24.w,
                                              height: 24.w,
                                              // ignore: deprecated_member_use
                                              color: AppTheme.browserColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])),
                          // for (int i = 0; i < 10; i++)
                          for (int i = 0; i < historyList.length; i++)
                            CustomListItem(
                              svgPath: 'assets/svgs/del2.svg',
                              title: historyList[i],
                              onTapIncident: () {
                                deleteItem(i); // 点击删除按钮时调用删除函数
                              },
                              width: 17,
                              height: 14,
                              color1: 0xffDCDCDC,
                            )
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }
}
//~历史记录 ---end

//~搜索结果和历史记录的自定义列表项 ---start
class CustomListItem extends StatefulWidget {
  final String svgPath; //SVG路径
  final String imagePath; //图片路径
  final String title; //标题
  final String content; //内容
  final double width; //宽
  final double height; //高
  final int color1; //高
  final GestureTapCallback? onTapIncident; //点击事件
  final bool isCollect; //是否收藏

  const CustomListItem(
      {super.key,
      required this.svgPath,
      this.imagePath = 'assets/images/colt.png',
      this.onTapIncident,
      this.title = 'Uniswap',
      this.content = 'https://app.uniswap.org/',
      this.isCollect = false,
      this.width = 24,
      this.height = 24,
      this.color1 = 0xffEDEFF5});

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.w),
      padding: EdgeInsets.only(bottom: 8.w),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.w, color: const Color(0xffDCDCDC)))),
      child: Column(
          children: List.generate(1, (index) {
        return OpClick(
          onTap: () {
            //跳转到SharePage页面
            setState(() {
              // ignore: deprecated_member_use
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SharePage()));
            });
          },
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                  child: Image(
                    image: AssetImage(widget.imagePath),
                  ),
                ),
                Container(
                  width: 240.w,
                  margin: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000)),
                      ),
                      Text(
                        widget.content,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppTheme.browserColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 3.w),
                  child: OpClick(
                    onTap: () {
                      widget.onTapIncident!();
                    },
                    child: SvgPicture.asset(
                      widget.svgPath, // 设置SVG图标的路径
                      width: widget.width.w,
                      height: widget.height.w,
                      // ignore: deprecated_member_use
                      color: widget.isCollect
                          ? const Color(0xffF3D11C)
                          : Color(widget.color1),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      })),
    );
  }
}
//~搜索结果和历史记录的自定义列表项  ----end

//~ 探索页面  isExplorePage  ----start
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  double isBtns = 0; //是否选中
  List<String> btns = [
    'Defi',
    '链游',
    'DEX',
    '市场',
    '工具',
  ];
  List explorePageList = [for (int i = 0; i < 10; i++) false]; //探索列表
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width, //设置宽度 适配
        color: Colors.white,
        child: Stack(
          children: [
            Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250.w,
                      height: 22.w,
                      margin: EdgeInsets.only(
                        top: 18.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (String i in btns)
                            //& 推荐探索收藏列表
                            OpClick(
                              onTap: () {
                                setState(() {
                                  isBtns = btns.indexOf(i).toDouble();
                                });
                              },
                              child: Center(
                                  child: Text(
                                i,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isBtns == btns.indexOf(i)
                                      ? const Color(0xff000000)
                                      : AppTheme.browserColor,
                                ),
                              )),
                            )
                        ],
                      ),
                    ),
                    Container(
                      width: 347.w,
                      height: 1.w,
                      margin: EdgeInsets.only(top: 16.h, left: 3.w),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.w, color: const Color(0xffDCDCDC)))),
                    )
                  ],
                )),
            explorePageList.isNotEmpty
                ? Positioned(
                    top: 86.h,
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15.w, right: 12.w),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0.w),
                        itemCount: 1, // 列表项数
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 0.w),
                              child: Column(
                                children: [
                                  for (int i = 1;
                                      i < explorePageList.length;
                                      i++)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 16.w),
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            i.toString(),
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff000000)),
                                          ),
                                          Container(
                                            width: 45.w,
                                            height: 45.w,
                                            // margin: EdgeInsets.only(left: 10.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.w)),
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/images/colt.png'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 232.w,
                                            // margin: EdgeInsets.only(left: 15.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Uniswap',
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xff000000)),
                                                ),
                                                Text(
                                                  // maxLines: null, // 设置为null或者大于1的整数，表示不限制行数
                                                  softWrap:
                                                      true, // 设置为true，表示文本将在换行符处中断，如果为false，文本将在宽度处中断。
                                                  'A protocol for trading and automated liquidity provision on Ethereum',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color:
                                                        AppTheme.browserColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          OpClick(
                                            onTap: () {
                                              setState(() {
                                                handleItemClick(
                                                    i, explorePageList);
                                                showSnackBar(
                                                    msg: explorePageList[i]
                                                        ? '收藏成功'
                                                        : '取消收藏');
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svgs/xingxing.svg', // 设置SVG图标的路径
                                              width: 22.w,
                                              height: 22.w,
                                              // ignore: deprecated_member_use
                                              color: explorePageList[i]
                                                  ? const Color(0xffF3D11C)
                                                  : const Color(0xffEDEFF5),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              ));
                        },
                      ),
                    ))
                : Container(
                    margin: EdgeInsets.only(top: 144.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '暂无相关应用上架',
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: const Color(0xff000000).withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
          ],
        ));
  }
}
//~探索页面  isExplorePage -----end

//~收藏页面  isFavoritesPage -----start
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  List FavoritesList = [for (int i = 0; i < 10; i++) true]; //&收藏列表
  @override
  Widget build(BuildContext context) {
    return FavoritesList.isNotEmpty
        ? Stack(
            children: [
              Positioned(
                  top: 174.h,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.w),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 23.w),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.w),
                      itemCount: 1, // 列表项数
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 14.w),
                            child: Column(
                              children: [
                                for (int i = 0; i < 10; i++)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 14.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 45.w,
                                          height: 45.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.w)),
                                          child: const Image(
                                            image: AssetImage(
                                                'assets/images/colt.png'),
                                          ),
                                        ),
                                        Container(
                                          width: 234.w,
                                          margin: EdgeInsets.only(left: 16.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Uniswap',
                                                style: TextStyle(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                              Text(
                                                // maxLines: null, // 设置为null或者大于1的整数，表示不限制行数
                                                softWrap: true,
                                                'A protocol for trading and automated liquidity provision on Ethereum',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: AppTheme.browserColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 7.w),
                                          child: OpClick(
                                            onTap: () {
                                              setState(() {
                                                handleItemClick(
                                                    i, FavoritesList);
                                                showSnackBar(
                                                    msg: FavoritesList[i]
                                                        ? '收藏成功'
                                                        : '取消收藏');
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svgs/xingxing.svg', // 设置SVG图标的路径
                                              width: 24.w,
                                              height: 24.w,
                                              // ignore: deprecated_member_use
                                              color: FavoritesList[i]
                                                  ? const Color(0xffF3D11C)
                                                  : const Color(0xffEDEFF5),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ));
                      },
                    ),
                  )),
            ],
          )
        : Positioned(
            top: 0.h,
            left: 0,
            bottom: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '尚未收藏任何应用',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: const Color(0xff000000).withOpacity(0.5)),
                ),
              ],
            ));
  }
}
//~收藏页面  isFavoritesPage -----end