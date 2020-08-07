import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/dialog/base_dialog.dart';

import 'ResetPwdModel.dart';
import 'login_page.dart';

class EmailResetPwd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailResetPwdState();
  }
}

class _EmailResetPwdState extends State<EmailResetPwd> {
  var _nameController = TextEditingController();

  var _isClick = false;

  // 隐藏正在编辑的文本
  var _obscureText = true;

  // 用户名输入框自动聚焦
  var _nameAutoFocus = true;

  // 用户名不为空
  var _isNotEmptyName = false;

  // 密码不为空
  var _isNotEmptyPwd = false;

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    _nameController.addListener(_verify);
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    if (_nameController.text != null) {
      _nameAutoFocus = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("didChangeDependencies");
  }

  @override
  void didUpdateWidget(EmailResetPwd oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    //销毁
    debugPrint("dispose");
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: Column(
        //纵轴对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).email_reset_pwd,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          ProviderWidget(
            model: ResetPwdModel(),
            onModelReady: (ResetPwdModel model) {
              _nameController.text = model.getLoginName();
            },
            builder: (context, model, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 16),
                  TextFormField(
                    autofocus: _nameAutoFocus,
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: S.of(context).user_name,
                        hintText: S.of(context).user_name_or_email,
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: _isNotEmptyName
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _nameController.clear();
                                })
                            : SizedBox.shrink()),
                    // 校验用户名（不能为空）
                    validator: (v) {
                      return v.trim().isNotEmpty
                          ? null
                          : S.of(context).userNameRequired;
                    },
                  ),
                  SizedBox(height: 16),
                  LoginButtonWidget(
                    child:Text(S.of(context).confirm),
                    onPressed: () => _reset(model)
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  //验证方法
  _verify() {
    String name = _nameController.text;
    bool isNotEmptyName = name.isNotEmpty;
    if (isNotEmptyName != _isNotEmptyName) {
      setState(() {
        _isNotEmptyName = isNotEmptyName;
      });
    }
  }

  /// 邮箱重置密码
  void _reset(ResetPwdModel model) {
    if (model.loading) {
      return;
    }
    String username = _nameController.text;
    if (username.isEmpty) {
      showToast(S.of(context).userNameRequired);
      return;
    }
    model.reset(username).then((bool value) {
      if (value) {
        Navigator.of(context).pop(true);
        //重置邮件发送提示
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BaseDialog(
                hiddenTitle: true,
                hiddenCancel: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("重置密码请求成功，请到邮箱$username查收邮件进行重置",
                      textAlign: TextAlign.center),
                ),
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
            )
        );
      } else {
        showToast(model.errorMessage);
      }
    });
  }
}
