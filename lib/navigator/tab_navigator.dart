import 'package:flutter/material.dart';
import 'package:trip_flutter/pages/home_page.dart';
import 'package:trip_flutter/pages/my_page.dart';
import 'package:trip_flutter/pages/search_page.dart';
import 'package:trip_flutter/pages/travel_page.dart';
import 'package:trip_flutter/util/view_util.dart';

import '../util/navigator_util.dart';

///首页底部导航器
class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key}) : super(key: key);

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _controller = PageController(initialPage: 0);
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //更新导航器的context，供退出登录时使用(todo 换成首页的context,因为首页常驻内存的)
    NavigatorUtil.updateContext(context);
    return Scaffold(
      ///  PageView就相当于ViewPager
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          SearchPage(hideLeft: true),
          TravelPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: shadowWarp(
          child: Opacity(
            opacity: 0.9,
            child: BottomNavigationBar(
              //fixedColor设置底部文字的颜色
              fixedColor: Colors.blue,
              currentIndex: _currentIndex,
              onTap: (index) {
                _controller.jumpToPage(index);
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                _bottomItem('首页', Icons.home, 0),
                _bottomItem('搜索', Icons.search, 1),
                _bottomItem('旅拍', Icons.camera_alt, 2),
                _bottomItem('我的', Icons.account_circle, 3),
              ],
            ),
          ),
          padding: const EdgeInsets.only(top: 1),
          startColor: Colors.deepOrange),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: title);
  }
}
