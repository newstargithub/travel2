
import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/image_util.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
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
                child: Center(
                  child: loadAssetImage("user_avatar",
                    width: 64,
                    height: 64
                  ),
                ),
              ),
              Gaps.vGap10,
              Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: Icon(Icons.update, color: Theme.of(context).accentColor),
                    title: Text(
                      S.of(context).check_update,
                    ),
                    onTap: checkUpdate,
                  )),
              Gaps.vGap10,
            ],
          ),
        ),
      ),
    );
  }

  void checkUpdate( ) {

  }

}