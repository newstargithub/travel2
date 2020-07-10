import 'package:flutter/material.dart';
import 'package:roll_demo/res/resources.dart';

class CircularButton extends StatelessWidget {
  //点击回调
  VoidCallback onPressed;

  //文字
  var text;

  CircularButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//          width: double.infinity,
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: FlatButton(
          onPressed: onPressed,
          textColor: Colors.white,
          color: Colours.app_main,
          disabledTextColor: Colours.login_text_disabled,
          disabledColor: Colours.login_button_disabled,
          padding: const EdgeInsets.all(0),
          //Container可以实现同时需要装饰、变换、限制的场景
          child: Text(
              text,
              style: TextStyle(fontSize: Dimens.font_sp18),
          ),
      ),
    );
  }
}
