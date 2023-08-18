import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/common/style/app_theme.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/controller/index.dart';
import 'package:wallet/event/index.dart';
import 'package:wallet/widgets/browser/index.dart';
import 'package:wallet/widgets/message/index.dart';
import 'package:wallet/widgets/mine/index.dart';
import 'package:wallet/widgets/wallet/index.dart' as wallet;

import 'message/chat/chat.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const wallet.Wallet(),
    const ChatPage(),
    const Browser(),
    const Mymine(),
  ];

  @override
  void initState() {
    super.initState();
    C.getWL();
    dapp.getBlockNumber(); // ?定时获取区块高度
  }

  @override
  void dispose() {
    bus.off("login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      BottomNavigationBarItem(
        label: "钱包",
        icon: SizedBox(
          height: 25.w,
          child: SvgPicture.asset(
            height: 22.w,
            'assets/svgs/wallet.svg',
          ),
        ),
        activeIcon: SizedBox(
          height: 28.w,
          child: SvgPicture.asset(
            height: 26.w,
            'assets/svgs/wallet_active.svg',
          ),
        ),
      ),
      BottomNavigationBarItem(
        label: "消息",
        icon: SizedBox(
          height: 25.w,
          child: SvgPicture.asset(
            height: 22.w,
            'assets/svgs/msg.svg',
          ),
        ),
        activeIcon: SizedBox(
          height: 28.w,
          child: SvgPicture.asset(
            height: 26.w,
            'assets/svgs/msg_active.svg',
          ),
        ),
        // icon: badges.Badge(
        //   position: badges.BadgePosition.topEnd(top: -8, end: -10),
        //   showBadge: true,
        //   ignorePointer: false,
        //   badgeAnimation: const badges.BadgeAnimation.size(toAnimate: false),
        //   badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(4.w)),
        //   badgeContent: Text('99',
        //       style: TextStyle(color: Colors.white, fontSize: 12.sp)),
        //   child: SizedBox(
        //     height: 25.w,
        //     child: SvgPicture.asset(
        //       height: 18.w,
        //       'assets/svgs/msg.svg',
        //     ),
        //   ),
        // ),
        // activeIcon: badges.Badge(
        //   position: badges.BadgePosition.topEnd(top: -8, end: -10),
        //   showBadge: true,
        //   ignorePointer: false,
        //   badgeAnimation: const badges.BadgeAnimation.size(toAnimate: false),
        //   badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(4.w)),
        //   badgeContent: Text('99',
        //       style: TextStyle(color: Colors.white, fontSize: 12.sp)),
        //   child: SizedBox(
        //     height: 28.w,
        //     child: SvgPicture.asset(
        //       height: 22.w,
        //       'assets/svgs/msg_active.svg',
        //     ),
        //   ),
        // ),
      ),
      BottomNavigationBarItem(
        label: "浏览器",
        icon: SizedBox(
          height: 25.w,
          child: SvgPicture.asset(
            height: 18.w,
            'assets/svgs/browser.svg',
          ),
        ),
        activeIcon: SizedBox(
          height: 28.w,
          child: SvgPicture.asset(
            height: 22.w,
            'assets/svgs/browser_active.svg',
          ),
        ),
      ),
      BottomNavigationBarItem(
        label: "我的",
        icon: SizedBox(
          height: 25.w,
          child: SvgPicture.asset(
            height: 21.w,
            'assets/svgs/mine.svg',
          ),
        ),
        activeIcon: SizedBox(
          height: 28.w,
          child: SvgPicture.asset(
            height: 25.w,
            'assets/svgs/mine_active.svg',
          ),
        ),
      ),
    ];
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedLabelStyle:
            TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        selectedItemColor: AppTheme.themeColor,
        unselectedItemColor: const Color(0xfF808291),
        unselectedLabelStyle: TextStyle(
            color: const Color(0xfF808291),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: items,
      ),
    );
  }
}
