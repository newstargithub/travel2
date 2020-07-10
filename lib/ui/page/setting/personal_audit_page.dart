
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/UserModel2.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/toast.dart';
import 'package:roll_demo/widget/MyAppBar.dart';
import 'package:roll_demo/widget/MyButton.dart';
import 'package:roll_demo/widget/SelectedImage.dart';
import 'package:roll_demo/widget/store_select_text_item.dart';
import 'package:roll_demo/widget/text_field_item.dart';

///编辑个人信息
class PersonalAudit extends StatefulWidget {
  @override
  _PersonalAuditState createState() => _PersonalAuditState();
}

class _PersonalAuditState extends State<PersonalAudit> {

  File _imageFile;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  var nicknameController = TextEditingController();

  var emailController = TextEditingController();

  var sloganController = TextEditingController();

  UserModel _model;

  ///选择图片
  void _getImage() async{
    try {
      _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {});
    } catch (e) {
      Toast.show("没有权限，无法打开相册！");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: MyAppBar(
        centerTitle: S.of(context).personal_info,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: defaultTargetPlatform == TargetPlatform.iOS ? FormKeyboardActions(
                child: _buildBody()
              ) : SingleChildScrollView(
                child: _buildBody()
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: MyButton(
                onPressed: () {
                  onPressedAuditResult();
                },
                text: S.of(context).commit,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildBody() {
    if(_model == null) {
      _model = Provider.of<UserModel>(context);
      var user = _model.user;
      nicknameController.text = user.nickname;
      emailController.text = user.email;
      sloganController.text = user.slogan;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vGap5,
          const Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: const Text("头像",
                style: TextStyles.textBoldDark18),
          ),
          Gaps.vGap16,
          Center(
            child: SelectedImage(
              image: _imageFile,
              onTap: _getImage
            ),
          ),
          Gaps.vGap16,
          StoreSelectTextItem(
              title: S.of(context).nickname,
              content: _model.user.nickname,
              onTap: (){
                _onTapAuditName();
              }
          ),
          TextFieldItem(
              focusNode: _nodeText2,
              title: S.of(context).email,
              hintText: "填写邮箱",
              controller: emailController
          ),
          StoreSelectTextItem(
              title: S.of(context).slogan,
              content: _model.user.slogan ?? "暂无签名",
              onTap: (){
                _onTapAuditSlogan();
              }
          ),
          Gaps.vGap16,
        ],
      ),
    );
  }

  void onPressedAuditResult() {

  }

  /// 编辑名字
  void _onTapAuditName() {
    NavigatorUtils.pushNamed(context, NAME_AUDIT_PAGE);
  }

  /// 编辑签名
  void _onTapAuditSlogan() {
    NavigatorUtils.pushNamed(context, SLOGAN_EDIT_PAGE);
  }

}
