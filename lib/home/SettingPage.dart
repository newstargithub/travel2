import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LocaleModel.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:url_launcher/url_launcher.dart';

///设置页面
class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  double _discreteValue = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).tabSettings),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListTileTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              Gaps.vGap10,
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  leading:
                      Icon(Icons.title, color: Theme.of(context).accentColor),
                  title: Text(
                    S.of(context).font,
                  ),
                  children: <Widget>[
                    ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        ThemeModel model = Provider.of<ThemeModel>(context);
                        return RadioListTile(
                          value: index,
                          groupValue: model.fontIndex,
                          onChanged: (v) {
                            model.switchFont(v);
                          },
                          title: Text(ThemeModel.fontName(index, context)),
                        );
                      },
                      itemCount: ThemeModel.fontValueList.length,
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
              Gaps.vGap10,
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  leading:
                  Icon(Icons.format_size, color: Theme.of(context).accentColor),
                  title: Text(
                    S.of(context).font_size,
                  ),
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Slider.adaptive(
                            value: _discreteValue,
                            min: 1.0,
                            max: 6.0,
                            divisions: 5,
                            label: '${_discreteValue.round()}',
                            onChanged: (double value) {
                              MediaQuery.of(context).copyWith(textScaleFactor: 2.0);
                              setState(() {
                                _discreteValue = value;
                              });
                            },
                          ),
                          const Text('调整大小'),
                        ],
                      ),
                      height: 150,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Gaps.vGap10,
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).accentColor),
                  title: Text(
                    S.of(context).language,
                  ),
                  children: <Widget>[
                    ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        LocaleModel model = Provider.of<LocaleModel>(context);
                        return RadioListTile(
                          value: index,
                          groupValue: model.localeIndex,
                          onChanged: (v) {
                            model.switchLocale(v);
                          },
                          title: Text(LocaleModel.localeName(index, context)),
                        );
                      },
                      itemCount: LocaleModel.localeValueList.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
              Gaps.vGap10,
              Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading:
                        Icon(Icons.star, color: Theme.of(context).accentColor),
                    title: Text(
                      S.of(context).score,
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      LaunchReview.launch(
                          androidAppId: "com.iyaffle.rangoli",
                          iOSAppId: "585027354");
                    },
                  )),
              Gaps.vGap10,
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  leading:
                      Icon(Icons.message, color: Theme.of(context).accentColor),
                  title: Text(
                    S.of(context).post_message,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    var url = 'mailto:964355194@qq.com?subject=FunAndroid%20Feedback&body=feedback';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      showToast(S.of(context).could_not_launch + url);
                      /*await Future.delayed(Duration(seconds: 1));
                      launch(
                          'https://github.com/phoenixsky/fun_android_flutter',
                          forceSafariVC: false);*/
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
