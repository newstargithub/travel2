import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LocaleModel.dart';
import 'package:roll_demo/pages/label/LabelListModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/pages/label/InputTextDialog.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/widget/common/load_view.dart';

class LabelListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LabelListPageState();
  }
}

class _LabelListPageState extends State<LabelListPage> {

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<LabelListModel>(
        model: LabelListModel(),
        onModelReady: (model) {
          model.initData();
        },
        builder: (context, model, child) {
          // 通过WillPopScope来实现返回按钮拦截，编辑状态时退出编辑
          return WillPopScope(
              onWillPop: () async {
                if (model.isEdit) {
                  model.switchEditModel();
                  return false;
                }
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context).label),
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        //编辑
                        model.switchEditModel();
                      },
                      icon: Icon(
                        Icons.mode_edit,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //添加
                        _showAddLabel(model);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 24,
                      ),
                      /*loadAssetImage(
                    "goods/add",
                    width: 24.0,
                    height: 24.0,
                  ),*/
                    )
                  ],
                ),
                body: _bodyViewState(model),
              ),
          );
        });
  }

  void _showAddLabel(LabelListModel model, {Label bean}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InputTextDialog(
            title: S.of(context).label_name,
            text: bean != null ? bean.title : null,
            onPressed: (name) {
              if(bean == null) {
                _addLabel(model, name);
              } else {
                bean.title = name;
                _updateLabel(model, bean);
              }
            },
          );
        });
  }

  void _addLabel(LabelListModel model, String name) {
    model.insertLabel(name);
  }

  void _updateLabel(LabelListModel model, Label bean) {
    model.updateLabel(bean);
  }

  _bodyViewState(LabelListModel model) {
    return LoadView(model, _buildLabelCategory(model));
  }

  _buildLabelCategory(LabelListModel model) {
    List<Label> list = model.list;
    debugPrint("_onPressedDeleteItem:" + model.toString() + " isEdit" + model.isEdit.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.vertical, //滚动方向，默认是垂直方向,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 超出屏幕显示范围会自动折行的布局称为流式布局。Flutter中通过Wrap和Flow来支持流式布局
            Wrap(
              // 主轴方向子widget的间距
                spacing: 10,
                children: List.generate(
                    list.length,
                        (index) =>
                    /*Stack(
                      children: <Widget>[
                        ActionChip(
                          onPressed: () {},
                          label: Text(
                            widget.list[index].title,
                            maxLines: 1,
                          ),
                        ),
                        Positioned(
                          child: Offstage(
                            offstage: !model.isEdit,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              alignment: Alignment.topLeft,
                              onPressed: () {
                                _onPressedDeleteItem(model, widget.list[index]);
                              },
                              icon: loadAssetImage(
                                "order/order_delete",
                                width: 24.0,
                                height: 24.0,
                              ),
                            ),
                          ),
                          left: 0,
                          top: 0,
                        ),
                      ],
                    )*/
                    InputChip(
                      label: Text(
                        list[index].title,
                        maxLines: 1,
                      ),
                      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      onDeleted: model.isEdit ? () {
                        _onPressedDeleteItem(model, list[index]);
                      } : null,
                      onPressed: () {
                        _showAddLabel(model, bean: list[index]);
                      },
                    )
                )
            )
          ],
        ),
      ),
    );
  }


  ///删除此项
  void _onPressedDeleteItem(LabelListModel model, Label item) {
    model.deleteLabel(item.id);
  }

}


