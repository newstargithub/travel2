
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/ui/page/lock/PatternLockUtils.dart';
import 'package:roll_demo/ui/page/lock/base_pattern_page.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';

import 'TabUserPage.dart';

class DrawerContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _DrawerContentState();
  }

}

class _DrawerContentState extends State<DrawerContent> {

  bool hasPatter = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    hasPatter = await PatternLockUtils.hasPattern();
  }

  void switchPattern() {
    if(hasPatter) {
      NavigatorUtils.pushResult(context, CONFIRM_PATTERN, (result){
        if(result == PATTERN_SUCCESS) {
          setState(() async {
            hasPatter = !hasPatter;
          });
        }
      });
    } else {
      NavigatorUtils.pushResult(context, SET_PATTERN, (result){
        if(result == PATTERN_SUCCESS) {
          setState(() async {
            hasPatter = !hasPatter;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.favorite, color: Theme.of(context).accentColor),
          title: Text(
            S.of(context).favorite,
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            //打开我的收藏页面
            NavigatorUtils.pushNamed(context, TAG_LIST_PAGE);
          },
        ),
        ListTile(
          leading: Icon(Icons.mood, color: Theme.of(context).accentColor),
          title: Text(
            S.of(context).dark_model,
          ),
          trailing: CupertinoSwitch(
              value: themeModel.isDark,
              onChanged: (v) {
                debugPrint("onChanged:$v");
                themeModel.switchTheme(
                    brightness: v ? Brightness.dark : Brightness.light);
              }),
          onTap: () {
            Provider.of<ThemeModel>(context).switchTheme(
                brightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light);
          },
        ),
        SettingThemeWidget(),
        ListTile(
          leading: Icon(Icons.settings, color: Theme.of(context).accentColor),
          title: Text(
            S.of(context).tabSettings,
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            pushNamed(context, SETTING_PAGE);
          },
        ),
        ListTile(
          leading: Icon(Icons.lock, color: Theme.of(context).accentColor),
          title: Text(
            S.of(context).pattern_lock,
          ),
          trailing: CupertinoSwitch(
              value: hasPatter,
              onChanged: (v) {
                debugPrint("onChanged:$v");
                switchPattern();
              }),
          onTap: () {
            switchPattern();
          },
        ),
        ListTile(
          leading: Icon(Icons.account_box, color: Theme.of(context).accentColor),
          title: Text(
            S.of(context).about,
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {

          },
        ),
      ],
    );
  }
}