

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/toast.dart';

class DiaryBottomOptionBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return Row(children: <Widget>[
      model.isEdit ?
      Row(children: <Widget>[
        IconButton(
          icon: Icon(Icons.brightness_high,),
          onPressed: () {
            debugPrint("纸");
            _selectBackground(context);
          },
        ),
        Gaps.dividerH,
        IconButton(
          icon: Icon(Icons.insert_photo,),
          onPressed: () {
            _insertImage(model);
          },
        ),
        Gaps.dividerH,
      ]
      ): SizedBox(),
      IconButton(
        icon: Icon(Icons.save_alt,),
        onPressed: () {
          _saveImage(context, model);
        },
      ),
    ]);
  }

  /// 插入图片
  void _insertImage(DiaryModel model) async {
    if (model.currentEditController == null) return;
    File image = await _getImage();
    if (image != null) {
      String data = image.path;
      model.textList.insertOne(
          model.currentPosition,
          getBeforeText(model.currentEditController),
          getSelectText(model.currentEditController),
          getAfterText(model.currentEditController),
          CustomTypeList(flag: TypeFlag.IMAGE, data: data)
      );
      model.notifyListeners();
    }
  }

  String getAfterText(TextEditingController controller) {
    return controller?.selection?.textAfter(controller.text);
  }

  String getSelectText(TextEditingController controller) {
    return controller?.selection?.textInside(controller.text);
  }

  String getBeforeText(TextEditingController controller) {
    return controller?.selection?.textBefore(controller.text);
  }

  void _selectBackground(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    List<Color> list = Colors.primaries.map((MaterialColor color){
      return color.shade200;
    }).toList();
    list.insert(0, Colours.cyan);
    list.insert(1, Colours.brown);
    var colorIndex = Random().nextInt(list.length - 1);
    model.setBackgroundColor(list[colorIndex]);
  }

  ///选择图片
  Future<File> _getImage() async {
    File file;
    try {
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      Toast.show("没有权限，无法打开相册！");
    }
    return file;
  }

  /// 去保存图片
  void _saveImage(BuildContext context, DiaryModel model) {
    NavigatorUtils.pushNamed(context, SAVE_IMAGE_PAGE, arguments: model.item);
  }

}