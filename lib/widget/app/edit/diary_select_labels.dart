
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/ui/page/label/LabelSelectModel.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/common/load_view.dart';

import '../../BottomSheetAction.dart';
import '../../store_select_text_item.dart';
/// 日记的选地址组件
///
/// 包括选中组件 ，以及组件点击效果
/// 需要外部参数[labels],标签
class DiarySelectLabels extends StatelessWidget {

  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return StoreSelectTextItem(
      textAlign: TextAlign.end,
      title: S.of(context).label,
      content: model.labels?? "",
      onTap: () {
        _onTapSelectLabel(context);
      },
    );
  }

  /// 选择标签
  void _onTapSelectLabel(BuildContext context) {
    DiaryModel diaryModel = Provider.of<DiaryModel>(context);
    //直接使用showModalBottomSheet方法创建模态BottomSheet
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ProviderWidget<LabelSelectModel>(
              model: LabelSelectModel(selectLabels: diaryModel.labelList),
              onModelReady: (model) {
                model.initData();
              },
              builder: (context, model, child) {
                return BottomSheetAction(
                  onPressed: () {
                    NavigatorUtils.goBack(context);
                    _selectLabel(diaryModel, model.selectLabels);
                  },
                  child: LoadView(model,
                    _buildLabelList(model),
                    onEmptyPressed: ()=> NavigatorUtils.pushNamed(context, TAG_LIST_PAGE),
                  ),
                );
              }
          );
        });
  }

  void _selectLabel(DiaryModel diaryModel, List<Label> labels) {
    diaryModel.setLabels(labels);
  }

  /// 标签内容
  _buildLabelList(LabelSelectModel model) {
    var list = model.list;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical, //滚动方向，默认是垂直方向,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15),
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.start,
          children: List.generate(
            list.length,
                (index) => ActionChip(
              backgroundColor: list[index].selected
                  ? Colors.red
                  : Colors.grey,
              onPressed: () {
                Label item = list[index];
                model.toggle(item);
              },
              label: Text(
                list[index].title,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
