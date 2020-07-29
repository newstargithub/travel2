import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/bean/rich_text_data.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/ui/page/diary/item_text.dart';
import 'package:roll_demo/ui/page/image_page.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/date_util.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/toast.dart';
import 'package:roll_demo/widget/MyAppBar.dart';
import 'package:roll_demo/widget/app/edit/diary_edit_bottom_bar.dart';
import 'package:roll_demo/widget/app/edit/diary_extra_info.dart';
import 'package:roll_demo/widget/app/edit/diary_set_extra_info.dart';

import 'diary_model.dart';
import 'item_image.dart';

class RichTextEditPage extends StatefulWidget {
  final String title;

  RichTextEditPage({Key key, this.title = ""}) : super(key: key);

  @override
  _RichTextEditPageState createState() => _RichTextEditPageState();
}

class _RichTextEditPageState extends State<RichTextEditPage>
    with AutomaticKeepAliveClientMixin {

//  int currentPosition = 0; //当前获取焦点的位置
//  TextEditingController currentEditController;//当前获取焦点编辑框的控制器
//  FocusNode currentFocusNode;

  @override
  void initState() {
    super.initState();
  }

  //位置 天气 标签
  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    var id = args.toString();
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
      ),
      body: SafeArea(
        child: ProviderWidget<DiaryModel>(
            model: DiaryModel(id),
            onModelReady: (model) {
              model.initData();
            },
            builder: (context, model, child) {
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:
                    buildPageDiaryWidget(model, context),
//                    buildDiaryItemWidget(model, context),
                  ),
                  DiaryEditBottomBar(),
                ],
              );
          },
        ),
      ),
    );
  }

  /// 一篇日记的内容
  Widget buildDiaryItemWidget(DiaryModel model, BuildContext context) {
    return Container(
      color: model.color,
      child: CustomScrollView(
//        physics: NeverScrollableScrollPhysics(),
//        controller: ,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.edit_horizontal_padding,
                  Dimens.edit_vertical_padding,
                  Dimens.edit_horizontal_padding,
                  0
              ),
              // 更新时间
              child: model.isCreate ? SizedBox() :
              Text(S.of(context).update_time + DateUtil.formatUpdateDate(model.item.updateTime)),
            ),
          ),
          SliverList(
            delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int position) {
                  //创建列表项
                  model.textList.list[position] ??= CustomTypeList();
                  var item = model.textList.list[position];
                  if (item.isText) {
                    // 文本编辑框
                    return _buildTextItem(model, position, item);
                  } else if (item.isImage) {
                    // 图片
                    return _buildImageItem(model, position, item);
                  } else {
                    //尺寸限制类容器
                    return SizedBox();
                  }
                },
                childCount: model.textList.size //列表项个数
            ),
          ),
          buildExtraInfoWidget(model, context)
        ],
      ),
    );
  }

  /// 编辑额外（时间，地点，天气， 标签）信息
  SliverToBoxAdapter buildExtraInfoWidget(DiaryModel model, BuildContext context) {
    return SliverToBoxAdapter(
      child: model.isEdit ? DiarySetExtraInfo(): DiaryExtraInfo(),
    );
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

  @override
  bool get wantKeepAlive => true;

  Widget _buildImageItem(DiaryModel model, int position, CustomTypeList customType) {
    return ItemImage(customType, isEdit: model.isEdit, onPressed: (){
      _goImageDetail(context, model.item, customType);
    }, onDeletePressed: () {
      model.textList.remove(position);
      setState(() {

      });
    });
  }

  /// position 列表的第几項
  /// item 文本数据
  Widget _buildTextItem(DiaryModel model, int position, CustomTypeList item) {
    int cPosition = model.currentPosition;
    bool focus = (cPosition == position && model.isEdit);
    return ItemText(position, model.textList.list[position], (index, controller, focusNode) {
      model.currentPosition = index;
      model.currentEditController = controller;
      model.currentFocusNode = focusNode;
      if(!model.isEdit) {
        model.setEditState();
      }
    },
      autofocus: focus,
      readOnly: !model.isEdit,
    );
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
      setState(() {});
    }
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

  /// 获取焦点的项
  /*CustomTypeList _getFocusItem(RichTextData textList) {
    var item = textList.list[currentPosition + 1];
    debugPrint("_getFocusItem:$currentPosition item:$item");
    return item;
  }*/

  Future _save(BuildContext context) async {
    DiaryModel model = Provider.of<DiaryModel>(context);
    String errorMsg = _checkDataValidate(model);
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

  /// 切换到编辑模式
  void _swapEditModel(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    model.setEditState();
  }

  /// 检查数据合法性
  String _checkDataValidate(DiaryModel model) {
    if(CommonUtil.isEmptyList(model.textList.list)
        || (model.textList.list.length == 1 && model.textList.list[0].isText && CommonUtil.isEmpty(model.textList.list[0].data))) {
      return S.of(context).body_content_is_empty;
    }
    return null;
  }


  /// 用来创建上下滑动的页面
  buildPageDiaryWidget(DiaryModel model, BuildContext context) {
    return PageView.builder(
      /// pageview中子条目的个数
      itemCount: 3,
      /// 上下滑动
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context,int index) {
//        VideoModel videoModel = list[index];
        /// 一页
        return buildDiaryItemWidget(model, context);
      }
    );
  }

  /// 底部操作栏
  _buildBottomBar(BuildContext context, DiaryModel model) {
    return Padding(
        padding:
        const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildBottomOptionBar(model),
            ),
            // IconButton是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景
            _buildEditOrSaveButton(context, model.isEdit),
          ],
        ));
  }

  /// 底部可选项
  _buildBottomOptionBar(DiaryModel model) {
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

  /// 选择背景色
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

  /// 去保存图片
  void _saveImage(BuildContext context, DiaryModel model) {
    NavigatorUtils.pushNamed(context, SAVE_IMAGE_PAGE, arguments: model.item);
  }

  /// 编辑或保存按钮
  _buildEditOrSaveButton(BuildContext context, bool isEdit) {
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

  /// 查看大图
  void _goImageDetail(BuildContext context, Diary bean, CustomTypeList customType) {
    List<String> urls = bean.imageUrls;
    int index = urls.indexOf(customType.data);
    Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
      return ImagePage(
        imageUrls: urls,
        initialPageIndex: index,
        onSelect: (current) {},
      );
    }));
  }
}




