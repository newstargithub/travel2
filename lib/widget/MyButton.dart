import 'package:flutter/material.dart';
import 'package:roll_demo/res/resources.dart';
/// 扁平按钮
class MyButton extends StatelessWidget {
  //点击回调
  VoidCallback onPressed;

  //文字
  var text;

  MyButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        textColor: Colors.white,
        color: Colours.app_main,
        disabledTextColor: Colours.login_text_disabled,
        disabledColor: Colours.login_button_disabled,
        // Container可以实现同时需要装饰、变换、限制的场景
        child: Container(
          // 宽度尽可能大
          width: double.infinity,
          height: 48,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: Dimens.font_sp18),
          ),
        )
    );
  }
}
