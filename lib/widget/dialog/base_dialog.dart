import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/route.dart';

/// 自定义dialog的模板
class BaseDialog extends StatelessWidget {
  double height;

  bool hiddenTitle;

  ///隐藏取消按钮
  bool hiddenCancel;

  String title;

  Widget child;

  VoidCallback onPressed;

  BaseDialog({
    Key key,
    this.title,
    this.onPressed,
    this.height,
    this.hiddenTitle : false,
    this.hiddenCancel : false,
    @required this.child
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //创建透明层
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      // 键盘弹出收起动画过渡
      body: AnimatedContainer(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewInsets.bottom,
        duration: const Duration(milliseconds: 120),
        // 曲线
        curve: Curves.easeInCubic,
        // 通过一个Container组件可以实现同时需要装饰、变换、限制的场景。
        child: Container(
          // 在其子组件绘制前(或后)绘制一些装饰（Decoration），如背景、边框、渐变等
          decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
          ),
          width: 270.0,
//          height: height,
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                offstage: hiddenTitle,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    hiddenTitle ? "" : title,
                    style: TextStyles.textBoldDark18,
                  ),
                ),
              ),
              Flexible(child: child),
              Gaps.vGap8,
              Gaps.line,
              _buildOption(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context) {
     if(hiddenCancel) {
       return Container(
         width: double.maxFinite,
         height: 48.0,
         child: FlatButton(
             onPressed: (){
               ///关闭对话框
               NavigatorUtils.goBack(context);
             },
             textColor: Colours.app_main,
             child: Text(
               S.of(context).confirm,
               style: TextStyle(fontSize: Dimens.font_sp18),
             )),
       );
    } else {
       return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 48.0,
              child: FlatButton(
                  onPressed: () {
                    NavigatorUtils.goBack(context);
                  },
                  textColor: Colours.text_gray,
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(fontSize: Dimens.font_sp18),
                  )),
            ),
          ),
          Container(
            width: 0.6,
            height: 48,
            color: Colours.line,
          ),
          Expanded(
              child: Container(
                height: 48.0,
                child: FlatButton(
                    onPressed: onPressed,
                    textColor: Colours.app_main,
                    child: Text(
                      S.of(context).confirm,
                      style: TextStyle(fontSize: Dimens.font_sp18),
                    )),
              )
          ),
        ],
      );
    }
  }
}
