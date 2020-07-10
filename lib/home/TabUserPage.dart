import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LoginModel.dart';
import 'package:roll_demo/model/SettingModel.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/model/UserModel2.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/lock/PatternLockUtils.dart';
import 'package:roll_demo/ui/page/lock/base_pattern_page.dart';
import 'package:roll_demo/ui/page/setting/ExitDialog.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/route.dart';

class TabUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabUserPageState();
  }
}

class _TabUserPageState extends State<TabUserPage>
    with AutomaticKeepAliveClientMixin {
  bool hasPatter = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          ProviderWidget<LoginModel>(
            model: LoginModel(Provider.of<UserModel>(context)),
            builder: (context, LoginModel model, child) {
              return Offstage(
                offstage: !model.userModel.hasUser,
                child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    //弹出对话框并等待其关闭
                    bool logout = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => ExitDialog()
                    );
                    if(logout) {
                      model.logout();
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ProviderWidget(
        model: SettingModel(
            userModel: Provider.of(context), themeModel: Provider.of(context)),
        builder: (context, SettingModel model, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserHeaderWidget(),
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
                      value: model.themeModel.isDark,
                      onChanged: (v) {
                        debugPrint("onChanged:$v");
                        model.themeModel.switchTheme(
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
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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

  Future initData() async {
    hasPatter = await PatternLockUtils.hasPattern();
  }
}

///设置主题颜色的选项
class SettingThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.color_lens, color: Theme.of(context).accentColor),
        title: Text(
          S.of(context).theme,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: <Widget>[
                ...Colors.primaries.map((color) {
                  return Material(
                    color: color,
                    child: InkWell(
                      onTap: () {
                        var model = Provider.of<ThemeModel>(context);
                        model.switchTheme(color: color);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }).toList(),
                Material(
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context);
                      var brightness = Theme.of(context).brightness;
                      model.switchRandomTheme(brightness: brightness);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Theme.of(context).accentColor)),
                      width: 40,
                      height: 40,
                      child: Text(
                        "?",
                        style: TextStyle(
                            fontSize: 20, color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]);
  }
}

class UserHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingModel model = Provider.of<SettingModel>(context);
    return InkWell(
      onTap: () => model.userModel.hasUser
          ? NavigatorUtils.pushNamed(context, PERSONAL_AUDIT_PAGE)
          : NavigatorUtils.pushNamed(context, LOGIN_PAGE),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'loginLogo',
              child: ClipOval(
                child: loadAssetImage(
                  "user_avatar",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Gaps.vGap10,
            Text(model.userModel.hasUser
                ? model.userModel.user.username
                : S.of(context).click_go_login),
            Gaps.vGap10,
            Visibility(
              child: Text("ID:${model.userModel.user?.id}"),
              visible: model.userModel.hasUser,
            ),
          ],
        ),
      ),
    );
  }
}
