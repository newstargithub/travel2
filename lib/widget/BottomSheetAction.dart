import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/route.dart';

///底部 带有确认取消
class BottomSheetAction extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;

  BottomSheetAction({Key key, this.onPressed, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).accentColor;
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max, //在主轴(水平)方向占用的空间, 尽可能少的占用水平空间
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //扁平按钮，默认背景透明并不带阴影。按下后，会有背景色
                FlatButton(
                  child: Text(S.of(context).cancel, style: TextStyles.textMiddle,),
                  onPressed: () {
                    NavigatorUtils.goBack(context);
                  },
                ),
                /// 占用指定比例的空间，实际上它只是Expanded的一个包装类
                Spacer(),
                FlatButton(
                  child: Text(S.of(context).confirm, style: TextStyles.textMiddle,),
                  textColor: textColor,
                  disabledTextColor: Colours.text_gray,
                  onPressed: onPressed,
                ),
              ],
            ),
            Expanded(child: child)
          ],
        )
      );
  }
}
