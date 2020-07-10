import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/RegisterModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/res/styles.dart';

import 'login_page.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _repasswordController = TextEditingController();

  var _isClick = false;

  bool _obscureText = true;

  bool _obscureRepwdText = true;

  @override
  void initState() {
    super.initState();
    print("initState");
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _repasswordController.addListener(_verify);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(Register oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    _nameController.dispose();
    _passwordController.dispose();
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
            "注册",
            style: TextStyles.textBoldDark24,
          ),
          ProviderWidget<RegisterModel>(
            model: RegisterModel(),
            builder: (context, RegisterModel model, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 16),
                    TextField(
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: "用户名或邮箱",
                          prefixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLength: 16,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "密码",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              })
                      ),
                      obscureText: _obscureText,//隐藏正在编辑的文本
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLength: 16,
                      controller: _repasswordController,
                      decoration: InputDecoration(
                          hintText: "再次输入密码",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              icon: Icon(_obscureRepwdText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureRepwdText = !_obscureRepwdText;
                                });
                              })
                      ),
                      obscureText: _obscureRepwdText,//隐藏正在编辑的文本
                    ),
                    SizedBox(height: 16),
                    RegisterButton(_nameController, _passwordController, _repasswordController),
                  ]
                );
            },
          ),
        ],
      ),
    );
  }

  //验证可提交方法
  _verify() {
    String name = _nameController.text;
    String password = _passwordController.text;
    String repassword = _repasswordController.text;
    bool isClick = true;
    if (name.isEmpty ||
        name.length < 11 ||
        password.isEmpty ||
        password.length < 6||
        repassword.isEmpty ||
        repassword.length < 6) {
      isClick = false;
    }
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }


}

class RegisterButton extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _passwordController;
  final TextEditingController _rePasswordController;

  RegisterButton(this._nameController, this._passwordController,
      this._rePasswordController);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<RegisterModel>(context);
    return LoginButtonWidget(
      child: model.loading
          ? ButtonProgressIndicator()
          : Text(S.of(context).register),
      onPressed: () => _register(context),
    );
  }

  //登录
  void _register(BuildContext context) {
    var model = Provider.of<RegisterModel>(context);
    if (model.loading) {
      return;
    }
    String username = _nameController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;
    model.register(username, password, rePassword).then((bool value) {
      if(value) {
        Navigator.of(context).pop(_nameController.text);
      } else {
        showToast(model.errorMessage);
      }
    });
  }

}
