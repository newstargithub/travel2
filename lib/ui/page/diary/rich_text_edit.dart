import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/bean/rich_text_data.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/LabelListModel.dart';
import 'package:roll_demo/model/LocaleModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/ui/page/diary/item_text.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/date_util.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/myicon.dart';
import 'package:roll_demo/util/resource_mananger.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/toast.dart';
import 'package:roll_demo/widget/BottomSheetAction.dart';
import 'package:roll_demo/widget/CircularButton.dart';
import 'package:roll_demo/widget/MyButton.dart';
import 'package:roll_demo/widget/MyAppBar.dart';
import 'package:roll_demo/widget/common/IconLabel.dart';
import 'package:roll_demo/widget/common/load_view.dart';
import 'package:roll_demo/widget/store_select_text_item.dart';
import 'dart:convert';


import '../label/LabelSelectModel.dart';
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

  int currentPosition = 0; //当前获取焦点的位置
  TextEditingController currentEditController;//当前获取焦点编辑框的控制器
  FocusNode currentFocusNode;

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
                  buildBottomOptionsWidget(model, context),
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
      child: model.isEdit ?
        Column(
          children: <Widget>[
            Gaps.vGap16,
            StoreSelectTextItem(
              textAlign: TextAlign.end,
              title: S.of(context).weather,
              content: model.weather,
              onTap: () {
                _onTapSelectWeather(context);
              },
            ),
            StoreSelectTextItem(
              textAlign: TextAlign.end,
              title: S.of(context).time,
              content: model.date?? "",
              onTap: () {
                _onTapSelectTime(context);
              },
            ),
            StoreSelectTextItem(
              textAlign: TextAlign.end,
              title: S.of(context).address,
              content: model.location,
              onTap: () {
                _onTapSelectAddress(context);
              },
            ),
            StoreSelectTextItem(
              textAlign: TextAlign.end,
              title: S.of(context).label,
              content: model.labels?? "",
              onTap: () {
                _onTapSelectLabel(context);
              },
            ),
            Gaps.vGap16,
          ],
        )
        : Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimens.edit_horizontal_padding,
              vertical: Dimens.edit_vertical_padding
          ),
          child: Column(
            children: <Widget>[
              Gaps.vGap10,
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconLabel(
                      icon: Icon(Icons.access_time),
                      label: Text(model.date?? ""),
                    ),
                  ),
                  IconLabel(
                    icon: Icon(Icons.wb_cloudy),
                    /*icon: ImageLoader.loadAssetImage(
                    weatherName2IconMap[model.weather?? "fine"],
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    )*/
                    label: Text(model.weather?? ""),
                  ),
                ],
              ),
              Gaps.vGap10,
              IconLabel(
                icon: Icon(Icons.location_on),
                label: Expanded(
                    flex: 1,
                    child: Text(model.location?? ""),
                ),
              ),
              Gaps.vGap10,
              IconLabel(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: Icon(Icons.bookmark_border),
                ),
                label: Expanded(
                  child: Wrap(
                    direction: Axis.horizontal,
                    // 主轴方向子widget的间距
                    spacing: 10,
                    children: List.generate(
                        model.labelList != null ? model.labelList.length : 0,
                            (index) => OutlineButton(
                          child: Text(model.labelList[index].title),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          //()=> setState() or markNeedsBuild() called during build
                          onPressed: ()=> _goSearch(model.labelList[index].title),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
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

  Widget _buildImageItem(DiaryModel model, int position, CustomTypeList item) {
    return ItemImage(item, isEdit: model.isEdit, onPressed: () {
      model.textList.remove(position);
      setState(() {

      });
    });
  }

  /// position 列表的第几項
  /// item 文本数据
  Widget _buildTextItem(DiaryModel model, int position, CustomTypeList item) {
    bool focus = (currentPosition == position && model.isEdit);
    return ItemText(position, model.textList.list[position], (index, controller, focusNode) {
      currentPosition = index;
      currentEditController = controller;
      currentFocusNode = focusNode;
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
    if (currentEditController == null) return;
    File image = await _getImage();
    if (image != null) {
      String data = image.path;
      model.textList.insertOne(
          currentPosition,
          getBeforeText(currentEditController),
          getSelectText(currentEditController),
          getAfterText(currentEditController),
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
  CustomTypeList _getFocusItem(RichTextData textList) {
    var item = textList.list[currentPosition + 1];
    debugPrint("_getFocusItem:$currentPosition item:$item");
    return item;
  }

  /// 选择地址
  void _onTapSelectAddress(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    NavigatorUtils.pushResult(context, ADDRESS_SELECT_PAGE, (result) {
      PoiSearch poi = result;
      String address = poi.provinceName +
          " " +
          poi.cityName +
          " " +
          poi.adName +
          " " +
          poi.title;
      model.setAddress(address);
    });
  }


  /// 天气选择
  Future _onTapSelectWeather(BuildContext context) async {
    debugPrint("天气选择弹窗");
      //"fine", "rain", "snow", "cloudy", "overcast"
    showSelectDialog(context, Constant.getWeatherTextList(context));
  }

  void showSelectDialog(BuildContext context, List<String> list) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    var theme = Theme.of(context);
    int indexSelected = 0;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetAction(
            child: Container(
              height: 200,
              child: CupertinoPicker.builder(
                backgroundColor: theme.dialogBackgroundColor,
                itemExtent: 50,
                //item的高度
                onSelectedItemChanged: (index) {
                  print("天气index = $index");
                  indexSelected = index;
                },
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      list[index],
                    ),
                  );
                },
                childCount: list.length,
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              _selectWeather(model, list[indexSelected]);
            },
          );
        }
    );
  }

  void _selectWeather(DiaryModel model, String weather) {
    model.setWeather(weather);
  }

  /// 时间选择
  void _onTapSelectTime(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    DateTime nowTime = DateTime.now();
    DateTime dateTime = model.dateTime ?? nowTime;
    DateTime date = nowTime;
    DateTime time = nowTime;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetAction(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (dateTime) {
                        debugPrint("时间onDateTimeChanged:$dateTime");
                        date = dateTime;
                      },
                      minimumYear: 1960,
                      //最小年份，只有mode为date时有效
                      maximumYear: nowTime.year,
                      maximumDate: nowTime,
                      initialDateTime: dateTime,
                    ),
                  ),
                  Container(
                    height: 150,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (dateTime) {
                        debugPrint("时间onDateTimeChanged:$dateTime");
                        time = dateTime;
                      },
                      maximumDate: nowTime,
                      initialDateTime: dateTime,
                      use24hFormat: false,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              _selectDateTime(model, date, time);
            },
          );
        });
  }

  //设置选择时间
  void _selectDateTime(DiaryModel model, DateTime date, DateTime time) {
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second, time.millisecond);
    model.setDateTime(dateTime);
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
      currentFocusNode?.unfocus();
      model.setSaveSuccess(context, bean);
    } else {
      // 更新失败
      Toast.show(S.of(context).save_fail);
    }
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

  /// 去搜索
  _goSearch(String labelTitle) {
    NavigatorUtils.pushNamed(context, SEARCH_PAGE, arguments: labelTitle);
  }

  /// 底部操作栏
  Widget buildBottomOptionsWidget(DiaryModel model, BuildContext context) {
    return Padding(
        padding:
        const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(children: <Widget>[
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
                IconButton(
                  icon: Icon(Icons.save_alt,),
                  onPressed: () {
                    _saveImage(context, model);
                  },
                ),
              ]),
            ),
            // IconButton是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景
            model.isEdit ? IconButton(
              icon: Icon(Icons.check,),
              onPressed: () {
                _save(context);
              },
            ) : IconButton(
              icon: Icon(Icons.mode_edit,),
              onPressed: () {
                _swapEditModel(context);
              },
            ),
          ],
        )
    );
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

/// 去保存图片
void _saveImage(BuildContext context, DiaryModel model) {
  NavigatorUtils.pushNamed(context, SAVE_IMAGE_PAGE, arguments: model.item);
}


