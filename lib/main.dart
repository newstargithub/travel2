//导入了Material UI组件库
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_amap_location_plugin/flutter_amap_location_plugin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roll_demo/demo/FocusTest.dart';
import 'package:roll_demo/provider/provider_manager.dart';
import 'package:roll_demo/ui/page/diary/save_image_page.dart';
import 'package:roll_demo/ui/page/home/splash_page.dart';
import 'package:roll_demo/pages/label/LabelListPage.dart';
import 'package:roll_demo/ui/page/lock/confirm_pattern_page.dart';
import 'package:roll_demo/ui/page/lock/set_pattern_page.dart';
import 'package:roll_demo/ui/page/search/search_diary.dart';
import 'package:roll_demo/ui/page/setting/name_edit_page.dart';
import 'package:roll_demo/ui/page/diary/rich_text_edit.dart';
import 'package:roll_demo/ui/page/setting/personal_audit_page.dart';
import 'package:roll_demo/ui/page/store/select_address_page.dart';
import 'package:roll_demo/ui/page/store/store_audit_page.dart';
import 'package:roll_demo/ui/page/weather_page.dart';
import 'package:roll_demo/widget/quit_will_pop_scope.dart';

import 'bean/Article.dart';
import 'common/Global.dart';
import 'demo/ConstrainedBox.dart';
import 'generated/i18n.dart';
import 'home/SettingPage.dart';
import 'home/article_detail_page.dart';
import 'pages/home/home_page.dart';
import 'model/LocaleModel.dart';
import 'model/ThemeModel.dart';
import 'net/storage_manager.dart';
import 'ui/page/login/email_reset_pwd_page.dart';
import 'ui/page/login/login_page.dart';
import 'ui/page/login/register_page.dart';
import 'ui/page/setting/slogan_edit_page.dart';
import 'util/constant.dart';

//Flutter应用中main函数为应用程序的入口
//=>符号，这是Dart中单行函数或方法的简写
Future main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    //转发至Zone中 No implementation found for method setup on channel flutter_crash_plugin
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  if (Global.isRelease) {
    customErrorWidget();
  }
  //使用runZone方法将runApp的运行放置在Zone中，并提供统一的异常回调
  runZoned<Future<Null>>(() async {
    //根据 defaultTargetPlatform 来判断当前应用所运行的平台
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      FlutterAmapLocationPlugin.setApiKey(Constant.map_api_key);
    }
    await StorageManager.init();
    await Global.init();
    runApp(MyApp()); // 创建一个 MyApp
  }, onError: (error, stackTrace) async {
    //Do sth for error
    //MissingPluginException(No implementation found for method setup on channel flutter_crash_plugin)
    print(error.toString());
  });
}

///自定义错误页面
void customErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return Scaffold(
        body: Center(
      child: Text("Custom Error Widget"),
    ));
  };
}

//这个 widget 作为应用的顶层widget.
//这个 widget 是无状态的，所以我们继承的是 [StatelessWidget].
//widget的主要工作是提供一个build()方法来描述如何构建UI界面
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
          providers: multiProviders,
          // MaterialApp消费（依赖）了ThemeModel和LocaleModel，所以当APP主题或语言改变时MaterialApp会重新构建
          child: Consumer2<ThemeModel, LocaleModel>(builder:
              (BuildContext context, ThemeModel themeModel,
                  LocaleModel localeModel, Widget child) {
                // 全局配置子树下的SmartRefresher,下面列举几个特别重要的属性
            return RefreshConfiguration(
              // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
              headerBuilder: () => WaterDropHeader(),
              // 配置默认底部指示器
              footerBuilder:  () => ClassicFooter(),
              // 头部触发刷新的越界距离
              headerTriggerDistance: 80.0,
              // 自定义回弹动画,三个属性值意义请查询flutter api
              springDescription: SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
                  maxOverScrollExtent :100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
                  maxUnderScrollExtent:0, // 底部最大可以拖动的范围
                  enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
                  enableLoadingWhenFailed : true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
                  hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
                  enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
                  child: MaterialApp (
                    theme: themeModel.theme,
                    //设置主题
                    darkTheme: themeModel.darkTheme,
                    // 夜间模式
                    locale: localeModel.locale,
                    // 多语言
                    localizationsDelegates: const [
                      // 本地化的代理类
                      S.delegate, // 应用程序的翻译回调
                      GlobalMaterialLocalizations.delegate, // Material 组件的翻译回调
                      GlobalWidgetsLocalizations.delegate, // 普通 Widget 的翻译回调
                      GlobalCupertinoLocalizations.delegate, // 加入这个Cupertino
                      RefreshLocalizations.delegate, // Refresh的翻译回调
                    ],
                    // 支持的语系
                    supportedLocales: S.delegate.supportedLocales,
                    // title 的国际化回调
                    onGenerateTitle: (context) => S.of(context).app_title,
                    // 注册路由表
                    //是一个Map， key 为路由的名称，是个字符串；value是个builder回调函数，用于生成相应的路由Widget。
                    /*routes: {
                      LOGIN_PAGE: (context) => Login(),
                      REGISTER_PAGE: (context) => Register(),
                    },*/
                    onGenerateRoute: generateRoute,
                    // 错误路由处理，统一返回 UnknownPage
                    onUnknownRoute: (RouteSettings setting) =>
                        MaterialPageRoute(builder: (context) => UnknownPage()),
                    // 应用主页
                    home: SplashPage(),
//                  home: FocusTestRoute(),
                  ),
              );
          }),
      ),
      position: ToastPosition.bottom,
      textPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
      backgroundColor: const Color(0xDD333333),
    );
  }

  // 注册命名路由表
  Route generateRoute(RouteSettings settings) {
    debugPrint("generateRoute settings:$settings");
    switch (settings.name) {
      case HOME_PAGE:
        return CupertinoPageRoute(builder: (_) => HomePageIndex());
      case SETTING_PAGE:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      case LOGIN_PAGE:
        return CupertinoPageRoute(builder: (_) => Login());
      case REGISTER_PAGE:
        return CupertinoPageRoute(builder: (_) => Register());
      case WEATHER_PAGE:
//        return CupertinoPageRoute(builder: (_) => WeatherPage());
        return CupertinoPageRoute(builder: (_) => RichTextEditPage());
      case STORE_AUDIT_PAGE:
        return CupertinoPageRoute(builder: (_) => StoreAudit());
      case ADDRESS_SELECT_PAGE:
        return CupertinoPageRoute(builder: (_) => AddressSelectPage());
      case TAG_LIST_PAGE:
        return CupertinoPageRoute(builder: (_) => LabelListPage());
      case PERSONAL_AUDIT_PAGE:
        return CupertinoPageRoute(builder: (_) => PersonalAudit());
      case NAME_AUDIT_PAGE:
        return CupertinoPageRoute(builder: (_) => NameEdit());
      case SLOGAN_EDIT_PAGE:
        return CupertinoPageRoute(builder: (_) => SloganEdit());
      case SET_PATTERN:
        return CupertinoPageRoute(builder: (_) => SetPatternPage());
      case CONFIRM_PATTERN:
        return CupertinoPageRoute(builder: (_) => ConfirmPatternPage());
      case SAVE_IMAGE_PAGE:
        return CupertinoPageRoute(
            builder: (_) => SaveImage(),
            settings: settings
        );
      case DIARY_DETAIL_PAGE:
        //路由传值要传递settings
        return CupertinoPageRoute(
            builder: (_) => RichTextEditPage(),
            settings: settings,
        );
      case ARTICLE_DETAIL:
        var article = settings.arguments as Article;
        return CupertinoPageRoute(
            builder: (_) => ArticleDetailPage(
                  article: article,
            )
        );
      case SEARCH_PAGE:
        var content = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => SearchDiaryPage(
            searchContent: content,
          ),
          settings: settings,
        );
    }
  }
}

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("页面走丢了o(╥﹏╥)o");
  }
}

class RoutePate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter rolling demo"),
      ),
      body: ConstrainedBoxTest(),
    );
  }
}

class RollingButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RollingButtonState();
  }
}

class _RollingButtonState extends State<RollingButton> {
  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      // 用户点击时候调用
      onPressed: _onPressed,
      child: Text("roll"),
    );
  }

  void _onPressed() {
    debugPrint("_onPressed");
    final rollResults = _roll();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content:
                Text('Roll result: (${rollResults[0]}, ${rollResults[1]})'),
          );
        });
  }

  _roll() {
    final roll1 = _random.nextInt(6) + 1;
    final roll2 = _random.nextInt(6) + 1;
    return [roll1, roll2];
  }
}

///Stateful widget可以拥有状态
///Stateful widget至少由两个类组成：
///一个StatefulWidget类。
///一个 State类；
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

///将build()方法放在State中的话，构建过程则可以直接访问状态
///继承StatefulWidget方便
class _MyHomePageState extends State<MyHomePage> {
  //状态
  int _counter = 0;

  ///设置状态的自增函数
  void _incrementCounter() {
    setState(() {
      // setState方法的作用是通知Flutter框架.
      // Flutter框架收到通知后，会执行build方法来根据新的状态重新构建界面
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次setState被调用此方法都会返回，例如上面的_incrementCounter方法
    // Scaffold 是 Material库中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。
    return Scaffold(
      appBar: AppBar(
        // 设置 appbar 标题.
        title: Text(widget.title),
      ),
      body: Center(
        // Center 是一个布局 widget. 它有一个居中的孩子.
        child: Column(
          // Column 是线性布局，默认宽度是包括子布局，高度是匹配父布局
          // mainAxisAlignment 属性设置垂直居中
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(
            // Flutter封装了IconData和Icon来专门显示字体图标。Icons类中包含了所有Material Design图标的IconData静态变量定义。
            Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
