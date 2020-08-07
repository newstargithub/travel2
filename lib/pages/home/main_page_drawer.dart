import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/widget/home/drawer_content.dart';
import 'package:roll_demo/model/UserModel2.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/util.dart';

/// 抽屉栏
class MainPageDrawer extends Drawer {
  const MainPageDrawer({
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
                      DrawerSetting(isDraw: true,)
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