import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color backgroundColor;

  final String centerTitle;

  final String title;

  final bool canBack;

  final String backImg;

  final String actionName;

  final VoidCallback onPressed;

  final IconData backIconData;

  SystemUiOverlayStyle _overlayStyle;

  MyAppBar(
      {Key key,
      this.backgroundColor,
      this.title: "",
      this.centerTitle: "",
      this.actionName: "",
      this.backImg,
      this.backIconData: Icons.arrow_back,
      this.onPressed,
      this.canBack: true})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(Dimens.app_bar_height);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    backgroundColor = backgroundColor
        ?? appBarTheme.color
        ?? themeData.primaryColor;
    _overlayStyle =
    ThemeData.estimateBrightnessForColor(backgroundColor) ==
        Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return Material(
      color: backgroundColor,
      child: SafeArea(
        // Stack允许子组件堆叠，而Positioned用于根据Stack的四个角来确定子组件的位置。
        child: Stack(
          // 指定未定位或部分定位widget的对齐方式
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              alignment:
                  centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
              width: double.infinity,
              child: Text(title.isEmpty ? centerTitle : title,
                  style: TextStyle(
                    fontSize: Dimens.font_sp18,
                    color: getTextColor(),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
            ),
            canBack
                ? IconButton(
                    onPressed: () {
                      FocusScope.of(context).autofocus(new FocusNode());
                      Navigator.maybePop(context);
                    },
                    padding: const EdgeInsets.all(12),
                    icon: backImg != null
                        ? Image.asset(backImg, color: getTextColor())
                        : Icon(backIconData, color: getTextColor()),
                  )
                : Gaps.empty,
            Positioned(
                right: 0,
                child: Theme(
                    data: ThemeData(
                        buttonTheme: ButtonThemeData(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      minWidth: 60.0,
                    )),
                    child: actionName.isEmpty
                        ? Container()
                        : FlatButton(
                            onPressed: onPressed,
                            textColor: getTextColor(),
                            highlightColor: Colors.transparent,
                            child: Text(actionName)
                        )
                )
            )
          ],
        ),
      ),
    );
  }

  Color getTextColor() {
    Color color = _overlayStyle == SystemUiOverlayStyle.light ? Colors.white : Colours.text_dark;
    return color;
  }
}
