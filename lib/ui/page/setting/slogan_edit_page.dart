
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/User.dart';
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

/// 编辑个性签名
class SloganEdit extends StatefulWidget {
  @override
  _SloganEditState createState() => _SloganEditState();
}

class _SloganEditState extends State<SloganEdit> {

  final FocusNode _nodeText = FocusNode();
  //定义一个controller
  final TextEditingController _controller = TextEditingController();
  UserModel _model;

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    if(_model == null) {
      _model = Provider.of<UserModel>(context);
      var text = _model.user.slogan ?? "";
      _controller.text = text;
      // 保持光标在最后
      _controller.selection = TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: text?.length,
          )
      );
    }
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: MyAppBar(
        centerTitle: S.of(context).slogan_edit,
        actionName: S.of(context).save,
        onPressed: onPressedSave,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  focusNode: _nodeText,
                  autofocus: true,//自动获取焦点
                  maxLines: 5,
                  maxLength: 100,
                  keyboardType: TextInputType.text,
                  controller: _controller,
                  style: TextStyles.textMiddle,
                  decoration: InputDecoration(
                      border: InputBorder.none, //去掉下划线
                      hintStyle: TextStyles.textMain16
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 保存编辑
  void onPressedSave() {
    var text = _controller.text;
    debugPrint("onPressedAuditResult:$text");
    _model.setSlogan(text);//todo 更新到服务端
    NavigatorUtils.goBack(context);
  }

}
