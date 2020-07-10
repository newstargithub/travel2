
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/toast.dart';
import 'package:roll_demo/widget/MyAppBar.dart';
import 'package:roll_demo/widget/MyButton.dart';
import 'package:roll_demo/widget/SelectedImage.dart';
import 'package:roll_demo/widget/store_select_text_item.dart';
import 'package:roll_demo/widget/text_field_item.dart';

///编辑店铺
class StoreAudit extends StatefulWidget {
  @override
  _StoreAuditState createState() => _StoreAuditState();
}

class _StoreAuditState extends State<StoreAudit> {

  File _imageFile;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  String _address = "陕西省 西安市 雁塔区 高新六路201号";

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
        centerTitle: "编辑店铺",
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
                text: "提交",
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildBody(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vGap5,
          const Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: const Text("店铺资料", style: TextStyles.textBoldDark18),
          ),
          Gaps.vGap16,
          Center(
            child: SelectedImage(
              image: _imageFile,
              onTap: _getImage
            ),
          ),
          Gaps.vGap10,
          const Center(
            child: const Text(
              "店主手持身份证或营业执照",
              style: TextStyles.textGray14,
            ),
          ),
          Gaps.vGap16,
          TextFieldItem(
              focusNode: _nodeText1,
              title: "店铺名称",
              hintText: "填写店铺名称"
          ),
          StoreSelectTextItem(
              title: "主营范围",
              content: _sortName,
              onTap: (){
                _showBottomSheet();
              }
          ),
          StoreSelectTextItem(
              title: "店铺地址",
              content: _address,
              onTap: () {
                _onTapSelectAddress(context);
              },
          ),
          Gaps.vGap16,
          Gaps.vGap16,
          const Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: const Text("店主信息", style: TextStyles.textBoldDark18),
          ),
          Gaps.vGap16,
          TextFieldItem(
              focusNode: _nodeText2,
              title: "店主姓名",
              hintText: "填写店主姓名"
          ),
          TextFieldItem(
              focusNode: _nodeText3,
              config: _buildConfig(context),
              keyboardType: TextInputType.phone,
              title: "联系电话",
              hintText: "填写店主联系电话"
          )
        ],
      ),
    );
  }

  String _sortName = "";
  var _list = ["水果生鲜", "家用电器", "休闲食品", "茶酒饮料", "美妆个护", "粮油调味", "家庭清洁", "厨具用品", "儿童玩具", "床上用品"];

  _showBottomSheet(){
    //底部弹窗
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 360.0,
          child: ListView.builder(
            itemBuilder: (_, index){
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 48.0,
                  alignment: Alignment.centerLeft,
                  child: Text(_list[index]),
                ),
                onTap: (){
                  setState(() {
                    _sortName = _list[index];
                  });
                  NavigatorUtils.goBack(context);
                },
              );
            },
            itemCount: _list.length,
          ),
        );
      },
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _nodeText1,
          displayCloseWidget: false,
        ),
        KeyboardAction(
          focusNode: _nodeText2,
          displayCloseWidget: false,
        ),
        KeyboardAction(
          focusNode: _nodeText3,
          closeWidget: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text("关闭"),
          ),
        ),
      ],
    );
  }

  void onPressedAuditResult() {

  }

  ///选择地址
  _onTapSelectAddress(BuildContext context) {
    /*跳转新页面并获取结果*/
    NavigatorUtils.pushResult(context, ADDRESS_SELECT_PAGE, (result){
      setState(() {
        PoiSearch model = result;
        _address = model.provinceName + " " +
            model.cityName + " " +
            model.adName + " " +
            model.title;
      });
    });
  }
}
