import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LoginModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/util/constant.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();

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
    _passwordController.addListener(_verify);
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
  void didUpdateWidget(Login oldWidget) {
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
            S.of(context).password_login,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          ProviderWidget(
            model: LoginModel(Provider.of(context)),
            onModelReady: (model) {
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
                  // SizedBox用于给子元素指定固定的宽高
                  SizedBox(height: 10),
                  TextFormField(
                    maxLength: 16,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: S.of(context).password,
                        hintText: S.of(context).login_password_hint,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Wrap(
                          children: <Widget>[
                            _isNotEmptyPwd
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _passwordController.clear();
                                    })
                                : SizedBox.shrink(),
                            IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                })
                          ],
                        )),
                    //隐藏正在编辑的文本
                    obscureText: _obscureText,
                    // 校验用户名（不能为空）
                    validator: (v) {
                      return v.trim().isNotEmpty
                          ? null
                          : S.of(context).passwordRequired;
                    },
                  ),
                  SizedBox(height: 16),
                  LoginButton(() => _login(model)),
                  SizedBox(height: 8),
                  Container(
                    height: 56.0,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    child: Stack(children: [
                      Positioned(
                        left: 0.0,
                        child: GestureDetector(
                          onTap: _resetPwd,
                          child: Text(
                            S.of(context).reset_pwd,
                            style: TextStyle(color: Color(0xFF4688FA)),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: GestureDetector(
                          onTap: _register,
                          child: Text(
                            S.of(context).go_register,
                            style: TextStyle(color: Color(0xFF4688FA)),
                          ),
                        ),
                      ),
                    ]),
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
    String password = _passwordController.text;
    bool isNotEmptyName = name.isNotEmpty;
    if (isNotEmptyName != _isNotEmptyName) {
      setState(() {
        _isNotEmptyName = isNotEmptyName;
      });
    }
    bool isNotEmptyPwd = password.isNotEmpty;
    if (isNotEmptyPwd != _isNotEmptyPwd) {
      setState(() {
        _isNotEmptyPwd = isNotEmptyPwd;
      });
    }
  }

  /// 注册
  _register() async {
    // 将注册成功的用户名,回填如登录框
//    _nameController.text = await
    Navigator.pushNamed(context, REGISTER_PAGE);
  }

  /// 登录
  void _login(LoginModel model) {
    if (model.loading) {
      return;
    }
    String username = _nameController.text;
    String password = _passwordController.text;
    if (username.isEmpty) {
      showToast(S.of(context).userNameRequired);
      return;
    }
    if (password.isEmpty) {
      showToast(S.of(context).passwordRequired);
      return;
    }
    model.login(username, password).then((bool value) {
      if (value) {
        Navigator.of(context).pop(true);
      } else {
        showToast(model.errorMessage);
      }
    });
  }

  /// 去重置密码
  void _resetPwd() {
    Navigator.pushNamed(context, EMAIL_RESET_PWD_PAGE);
  }
}

class LoginButton extends StatelessWidget {
  VoidCallback _onPressed;

  LoginButton(this._onPressed);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LoginModel>(context);
    return LoginButtonWidget(
      child:
          model.loading ? ButtonProgressIndicator() : Text(S.of(context).login),
      onPressed: _onPressed,
    );
  }
}

/// LoginPage 按钮样式封装
class LoginButtonWidget extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;

  LoginButtonWidget({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor.withAlpha(180);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: color,
        disabledColor: color,
        borderRadius: BorderRadius.circular(110),
        pressedOpacity: 0.5,
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}

/// 按钮上转圈进度
class ButtonProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  ButtonProgressIndicator({this.size: 24, this.color: Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ));
  }
}
