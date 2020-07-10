import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/common/FlutterCrashPlugin.dart';
import 'package:roll_demo/demo/InfiniteGridView.dart';
import 'package:roll_demo/demo/InfiniteListView.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/SettingModel.dart';
import 'package:roll_demo/model/UserModel2.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/ui/page/label/LabelListPage.dart';
import 'package:roll_demo/ui/page/lock/set_pattern_page.dart';
import 'package:roll_demo/ui/page/main_page.dart';
import 'package:roll_demo/ui/page/diary/rich_text_edit.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/util.dart';
import 'package:roll_demo/widget/quit_will_pop_scope.dart';

import 'TabUserPage.dart';
import 'TabWxArticleWidget.dart';
import 'drawer_content.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var _pageController = PageController();
  var _selectedIndex = 0;
  var _lastPressed;

  @override
  void initState() {
    super.initState();
    //由于Bugly视iOS和Android为两个独立的应用，因此需要使用不同的App ID进行初始化
    if (Platform.isAndroid) {
      //todo 改App ID
      FlutterCrashPlugin.setUp('43eed8b173');
    } else if (Platform.isIOS) {
      FlutterCrashPlugin.setUp('088aebe0d5');
    }
  }

  List<Widget> pages = <Widget>[
    MainPage(),
    SetPatternPage(),
    TabWxArticleWidget(),
    LabelListPage(),
    TabUserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return QuitWillPopScope(
      // 一个完整的路由页可能会包含导航栏、抽屉菜单(Drawer)以及底部Tab导航菜单等。
      // Scaffold是一个路由页的骨架，我们使用它可以很容易地拼装出一个完整的页面。
      child:
//        _buildBottomNavigateScaffold(),
        _buildDrawerScaffold(context),
    );
  }

  /// 底部导航栏
  _buildBottomNavigateScaffold() {
    return Scaffold(
//      appBar: AppBar(
//      ),//导航栏
//      drawer: MyDrawer(), //抽屉
      body: PageView.builder(
        itemBuilder: (ctx, index) => pages[index],
        itemCount: pages.length,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // 底部导航
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(S.of(context).tabHome),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            title: Text(S.of(context).tabProject),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text(S.of(context).wechatAccount),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backup),
            title: Text(S.of(context).tabStructure),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(S.of(context).tabSettings),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => _pageController.jumpToPage(index),
      ),
      /*floatingActionButton: FloatingActionButton(
              onPressed: _onAdd,
              child: Icon(Icons.add),
            ),*/
    );
  }

  _buildDrawerScaffold(BuildContext context) {
    return Scaffold(
      //导航栏
      appBar: PreferredSize(
          child: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _goSearch,
              )
            ],
            title: _buildCenterTitle(context),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(Dimens.app_bar_height)
      ),
      drawer: MyDrawer(), //抽屉
      body: MainPage(),
    );
  }

  /// 去搜索页面
  void _goSearch() {
    NavigatorUtils.pushNamed(context, SEARCH_PAGE);
  }

  _buildCenterTitle(BuildContext context) {
    return InkWell(
      child: Text("2020年6月"),
      onTap: _showDatePicker(context),

    );
  }

  _showDatePicker(BuildContext context) {
    var dateNow = DateTime.now();
//    var dateTime = await showDatePicker(context: context, initialDate: dateNow,
//        firstDate: dateNow, lastDate: dateNow);
  }

}

class TabHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TabHomeState();
  }
}

class TabHomeState extends State<TabHomeWidget>
    with SingleTickerProviderStateMixin {
  List tabs = ["新闻", "历史", "图片"];
  TabController _tabController;
  var _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: tabs.map((e) {
        // 创建3个Tab页内容
        if (e == "新闻") {
          return InfiniteListView();
        } else if (e == "历史") {
          return InfiniteGridView();
        }
        return Container(
          alignment: Alignment.center,
          child: Text(
            e,
            textScaleFactor: 5,
          ),
        );
      }).toList(),
      // TabBar和TabBarView的controller是同一个！
      controller: _tabController,
    );
  }

  _onTopItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }
}

/// 抽屉栏
class MyDrawer extends Drawer {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userModel.hasUser ? userModel.user.username: S.of(context).click_go_login),
            accountEmail: userModel.hasUser ? Text(userModel.user.email) : SizedBox(),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(Utils.getImgPath("user_avatar")),
            ),
            margin: EdgeInsets.zero,
            onDetailsPressed: () {
              _onDetailPressed(context);
            },
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.抽屉的初始内容。
                      DrawerContent()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotImplementedMessage() {

  }

  /// 去设置页面
  void _goSetting(BuildContext context) {
    NavigatorUtils.pushNamed(context, SETTING_PAGE);
  }

  /// 用户详情主页或去登录
  void _onDetailPressed(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    userModel.hasUser ? NavigatorUtils.pushNamed(context, PERSONAL_AUDIT_PAGE)
        : NavigatorUtils.pushNamed(context, LOGIN_PAGE);
  }
}

class NavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationBarState();
  }
}

class _NavigationBarState extends State<NavigationBar> {
  var _appBarTitles = ['订单', '商品', '统计', '店铺'];

  @override
  Widget build(BuildContext context) {
    // 给其子节点添加填充（留白），和边距效果类似。
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        children: <Widget>[
          _buildTab("首页"),
          _buildTab("知识体系"),
          _buildTab("公众号"),
          _buildTab("项目"),
          _buildTab("我的"),
        ],
        //子widget的布局顺序
        textDirection: TextDirection.ltr,
        //Row在主轴(水平)方向占用的空间
        mainAxisSize: MainAxisSize.max,
        //Row所占用的水平空间内对齐方式
        mainAxisAlignment: MainAxisAlignment.center,
        //子Widgets在纵轴方向的对齐方式，Row的高度等于子Widgets中最高的子元素高度
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget _buildTab(String text) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Center(
            child: Text(text),
          )),
    );
  }

  ///底部标签
  Widget _buildTabText(int curIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(_appBarTitles[curIndex]),
    );
  }
}
