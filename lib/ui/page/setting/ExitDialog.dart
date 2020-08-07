
import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/widget/dialog/base_dialog.dart';
/// 退出登录弹窗
/*
 showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ExitDialog()
  );
*/

class ExitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: S.of(context).tips,
      height: 160.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
        child: Text(S.of(context).logout_message, style: TextStyles.textMiddle,),
      ),
      onPressed: () {
        //登出
        Navigator.pop(context, true);
        //跳转到登录页面
//        NavigatorUtils.push(context, LoginRouter.loginPage, clearStack: true);
      },
    );
  }
}