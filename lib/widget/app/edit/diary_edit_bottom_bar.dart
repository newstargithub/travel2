
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/toast.dart';

import 'diary_bottom_option_bar.dart';
/// 底部操作栏
///
///
class DiaryEditBottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: DiaryBottomOptionBar(),
            ),
            _buildEditOrSaveButton(context, model.isEdit),
          ],
        )
    );
  }

  /// 编辑或保存按钮
  _buildEditOrSaveButton(BuildContext context, bool isEdit) {
    // IconButton是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景
    return isEdit ? IconButton(
      icon: Icon(Icons.check,),
      onPressed: () {
        _save(context);
      },
    ) : IconButton(
      icon: Icon(Icons.mode_edit,),
      onPressed: () {
        _swapEditModel(context);
      },
    );
  }

  Future _save(BuildContext context) async {
    DiaryModel model = Provider.of<DiaryModel>(context);
    String errorMsg = _checkDataValidate(context, model);
    if(!CommonUtil.isEmpty(errorMsg)) {
      Toast.show(errorMsg);
      return;
    }
    var jsonEncode = json.encode(model.textList.toJson());
    Diary bean = Diary();
    bean.content = jsonEncode;
    bean.richTextData = model.textList;
    bean.weather = model.weather;
    bean.dateTime = model.dateTime;
    bean.location = model.location;
    bean.labelList = model.labelList;
    bean.color = model.color != null ? model.color.value : 0;
    var result = await model.saveDiary(context, bean);
    if(result > 0) {
      debugPrint("currentFocusNode unfocus");
      // 失去焦点并自动隐藏键盘
      model.currentFocusNode?.unfocus();
      model.setSaveSuccess(context, bean);
    } else {
      // 更新失败
      Toast.show(S.of(context).save_fail);
    }
  }

  /// 检查数据合法性
  String _checkDataValidate(BuildContext context, DiaryModel model) {
    if(CommonUtil.isEmptyList(model.textList.list)
        || (model.textList.list.length == 1 && model.textList.list[0].isText && CommonUtil.isEmpty(model.textList.list[0].data))) {
      return S.of(context).body_content_is_empty;
    }
    return null;
  }

  /// 切换到编辑模式
  void _swapEditModel(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    model.setEditState();
  }

}