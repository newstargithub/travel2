
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/dialog_util.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/share.dart';
import 'package:roll_demo/util/sp_util.dart';
import 'package:roll_demo/util/toast.dart';
import 'package:roll_demo/widget/MyAppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';

import 'diary_view.dart';

class SaveImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SaveImagePageState();
  }
}

class _SaveImagePageState extends State<SaveImage> {

  // 边框颜色
  Color _boxColor = Colours.cyan;

  var _globalKey = GlobalKey();

  WhyFarther _selection;

  bool showBorder;

  @override
  void initState() {
    super.initState();
    showBorder = SpUtil.getBool(Constant.save_image_show_border, defValue: true);
  }

  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    debugPrint("SaveImage arguments $args");
    Diary bean = args;
    // 页面框架
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(S.of(context).save_image),
            actions: <Widget>[
              PopupMenuButton<WhyFarther>(
                offset: Offset(0.0, 50.0),
                onSelected: (WhyFarther result) {
                  if(result == WhyFarther.harder) {
                    setState(() {
                      showBorder = !showBorder;
                      SpUtil.putBool(Constant.save_image_show_border, showBorder);
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
                  PopupMenuItem<WhyFarther>(
                    value: WhyFarther.harder,
                    child: new Text(showBorder ? S.of(context).hide_border : S.of(context).show_border),
                  ),
                  /*const PopupMenuItem<WhyFarther>(
                 value: WhyFarther.smarter,
                 child: Text('Being a lot smarter'),
               ),*/
                ],
              )
            ],
          ),
          preferredSize: Size.fromHeight(Dimens.app_bar_height)
      ),
//      MyAppBar(
//        title: S.of(context).save_image,
//      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10), //容器外填充
                  decoration: BoxDecoration(//背景装饰
                      boxShadow: [ //卡片阴影
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0
                        )
                      ]
                  ),
                  alignment: Alignment.center, //卡片内文字居中
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      padding: showBorder
                          ? EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 20)
                          : EdgeInsets.all(0.0),
                      color: _boxColor,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              // 内容图片
                              child: DiaryView(bean),
                            ),
                            Gaps.vGap16,
                            FlatButton.icon(
                              icon: Icon(Icons.apps, color: Theme.of(context).accentColor),
                              label: Text(S.of(context).app_name, style: TextStyles.textDark16),
                              onPressed: (){

                              },
                            )
                          ],
                        ),
                      ),
                  ),
                ),
              ),
            ),
          ),
          // 操作栏，选择背景色
          Column(
            children: <Widget>[
              Container(
                height: 80,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  scrollDirection: Axis.horizontal,
                  itemExtent: 80,
                  children: <Widget>[
                    _buildColorContainer(Colours.cyan),
                    _buildColorContainer(Colours.brown),
                    ...Colors.primaries.map((MaterialColor color) {
                      return _buildColorContainer(color.shade200);
                    }).toList(),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      child: Text(S.of(context).save_to_phone),
                      onPressed: () {
                        _saveCapturePng(_globalKey);
                      },
                    ),
                  ),
                  Gaps.dividerH,
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      child: Text(S.of(context).share),
                      onPressed: () {
                        _shareCapturePng(_globalKey);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 返回颜色选择方块
  Widget _buildColorContainer(Color color) {
    bool isChecked = color == _boxColor;
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          setState(() {
            _boxColor = color;
          });
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: isChecked ? Border.all(color: Theme.of(context).accentColor) : null,
          ),
        ),
      ),
    );
  }

  /// 保存截屏生成PNG图片
  void _saveCapturePng(globalKey) async {
    await _saveCapture(globalKey).then((file) {
      Toast.show(S.of(context).save_success);
    }).catchError((e){
      Toast.show(S.of(context).save_fail);
    });
  }

  /// 保存截屏生成图片并分享
  void _shareCapturePng(globalKey) async {
    await _saveCapture(globalKey).then((file) {
      Toast.show(S.of(context).save_success);
      ShareUtil.shareImage(file);
    }).catchError((e){
      Toast.show(S.of(context).save_fail);
    });
  }

  /// 保存截屏生成PNG图片
  Future<File> _saveCapture(globalKey) async {
    DialogUtil.showLoadingDialog(context, text: S.of(context).saving);
    var name = "${DateTime.now().toIso8601String()}.png";
    var unitVal = await _capturePng(globalKey);
    String path = await _capturePath(name);
    //路径 /storage/emulated/0/Android/data/com.halo.memoir/files/2020-06-01T15:08:56.439982.png
    debugPrint("_saveCapturePng:$path");
    return await File(path).writeAsBytes(unitVal).whenComplete((){
      DialogUtil.dismissLoadingDialog(context);
    });
  }

  /// 截屏生成PNG图片数据
  Future<Uint8List> _capturePng(globalKey) async {
    // 获取页面渲染对象
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    // 转为 ui.Image 类型字节流 pixelRatio像素比
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    // 转为常用的 Uint8List 存储在内存中
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //
    Uint8List picBytes = byteData.buffer.asUint8List();
    return picBytes;
  }

  /// 获取图片存储路径
  Future<String> _capturePath(name) async {
    var dir = StorageManager.externalStorageDirectory.path;
    String path = "$dir/$name";
    return path;
  }

}

enum WhyFarther {
  harder,
  smarter,
  selfStarter,
  tradingCharter
}
