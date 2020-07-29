import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/common/FlutterCrashPlugin.dart';
import 'package:roll_demo/demo/InfiniteGridView.dart';
import 'package:roll_demo/demo/InfiniteListView.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LocaleModel.dart';
import 'package:roll_demo/model/SettingModel.dart';
import 'package:roll_demo/model/UserModel2.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/pages/label/LabelListPage.dart';
import 'package:roll_demo/ui/page/lock/set_pattern_page.dart';
import 'package:roll_demo/pages/home/main_page.dart';
import 'package:roll_demo/ui/page/diary/rich_text_edit.dart';
import 'package:roll_demo/ui/page/net_pictures_page.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/util.dart';
import 'package:roll_demo/widget/quit_will_pop_scope.dart';

import '../user/TabUserPage.dart';
import '../../home/TabWxArticleWidget.dart';
import '../../home/drawer_content.dart';
import 'main_page_drawer.dart';

class HomePageIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageIndexState();
  }
}

class _HomePageIndexState extends State<HomePageIndex> with SingleTickerProviderStateMixin {
  var _pageController = PageController();
  var _selectedIndex = 0;

  /// 可以在此期间执行 State 各变量的初始赋值，
  /// 同时也可以在此期间与服务端交互，获取服务端数据后调用 setState 来设置 State。
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
    NetPicturesPage(),
    TabUserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return QuitWillPopScope(
      // 一个完整的路由页可能会包含导航栏、抽屉菜单(Drawer)以及底部Tab导航菜单等。
      // Scaffold是一个路由页的骨架，我们使用它可以很容易地拼装出一个完整的页面。
      child: _buildDrawerScaffold(),
    );
  }

  /// 底部导航栏
  _buildBottomNavigateScaffold() {
    return Scaffold(
//      appBar: AppBar(
//      ),//导航栏
//      drawer: MyDrawer(), //抽屉
      body: _buildHomePageView(),
      // 底部导航
      bottomNavigationBar: _buildBottomNavigationBar(),
      /*floatingActionButton: FloatingActionButton(
              onPressed: _onAdd,
              child: Icon(Icons.add),
            ),*/
    );
  }

  /// 底部导航栏
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  PageView _buildHomePageView() {
    return PageView.builder(
      itemBuilder: (ctx, index) => pages[index],
      itemCount: pages.length,
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  /// 带侧边栏的页面框架
  _buildDrawerScaffold() {
    final localModel = Provider.of<LocaleModel>(context);
    bool showBottomNavigationBar = localModel.showBottomNavigationBar;
    return Scaffold(
      /*//导航栏
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
      drawer: MainPageDrawer(), //抽屉*/
      body: showBottomNavigationBar? _buildHomePageView(): MainPage(),
      bottomNavigationBar: showBottomNavigationBar? _buildBottomNavigationBar(): null,
    );
  }

  /// 永久移除组件，并释放组件资源。
  @override
  void dispose() {

  }

  /// 在组件被移除节点后会被调用
  @override
  void deactivate() {

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
