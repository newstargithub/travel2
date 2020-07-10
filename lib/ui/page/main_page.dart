import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/diary_list_model.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/resource_mananger.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/widget/WeatherFloatWidget.dart';
import 'package:roll_demo/widget/app/diary_item.dart';
import 'package:roll_demo/widget/app/diary_item2.dart';

import 'diary/diary_model.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class UpdateItemModel {
  String appIcon; //App图标
  String appName; //App名称
  String appSize; //App大小
  String appDate; //App更新日期
  String appDescription; //App更新文案
  String appVersion; //App版本
  //构造函数语法糖，为属性赋值
  UpdateItemModel(
      {this.appIcon,
      this.appName,
      this.appSize,
      this.appDate,
      this.appDescription,
      this.appVersion});
}

/// 单独封装一个UpdatedItem Widget 专门用于构建列表项UI

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  UpdateItemModel model;
  double _bottom = 0.0; //距底部的偏移
  double _right = 0.0;//距右边的偏移

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  /// 下拉刷新
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  /// 上拉加载
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: PreferredSize(
          child: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _goSearch,
              )
            ],
          ),
          preferredSize: Size.fromHeight(Dimens.app_bar_height)
      ),*/
      body: Stack(
        children: <Widget>[
          ProviderWidget(
              model: DiaryListModel(),
              onModelReady: (DiaryListModel model) => model.initData(),
              builder: (context, DiaryListModel model, child) {
                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context,LoadStatus mode){
                        Widget widget ;
                        if(mode==LoadStatus.idle){
                          widget =  Text("上拉加载");
                        }
                        else if(mode==LoadStatus.loading){
                          widget = CupertinoActivityIndicator();
                        }
                        else if(mode == LoadStatus.failed){
                          widget = Text("加载失败！点击重试！");
                        }
                        else if(mode == LoadStatus.canLoading){
                          widget = Text("松手,加载更多!");
                        }
                        else{
                          widget = Text("没有更多数据了!");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: widget),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: buildDiaryListWidget(model, context),
                  );
  //              return buildDiaryListWidget(model, context);
              }
          ),
          Positioned(
            bottom: _bottom,
            right: _right,
            child: GestureDetector(
              child: WeatherFloatWidget(),
              onTap: _onFloatingAction,
              //手指按下时会触发此回调
              onPanDown: (DragDownDetails e) {
                //打印手指按下的位置(相对于屏幕)
                debugPrint("用户手指按下：${e.globalPosition}");
              },
              //手指滑动时会触发此回调
              onPanUpdate: (DragUpdateDetails e) {
                //用户手指滑动时，更新偏移，重新构建
                setState(() {
  //                _left += e.delta.dx;
  //                _top += e.delta.dy;
                  _right -= e.delta.dx;
                  _bottom -= e.delta.dy;
                });
              },
              onPanEnd: (DragEndDetails e){
                //打印滑动结束时在x、y轴上的速度
                print(e.velocity);
              },
            ),
          ),
        ],
      ),
    );
  }

  StatelessWidget buildDiaryListWidget(DiaryListModel model, BuildContext context) {
    if (model.loading) {
      return ViewStateLoadingWidget();
    } else if (model.error) {
      return ViewStateWidget(
          message: model.errorMessage, onPressed: model.initData);
    } else if(model.empty) {
      return ViewStateWidget(
          message: S.of(context).empty, onPressed: model.initData);
    }
    var list = model.list;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return UpdatedItem(model: list[index]);
        },
        separatorBuilder: (BuildContext context, int index) => Gaps.hGap8,
        itemCount: list.length
    );
  }

  Widget buildTopRow(BuildContext context) {
    return Row(//Row控件，用来水平摆放子Widget
        children: <Widget>[
      Padding(
          //Paddng控件，用来设置Image控件边距
          padding: EdgeInsets.all(10), //上下左右边距均为10
          //圆角矩形裁剪控件
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), //圆角半径为8
              child: Image.asset(model.appIcon, width: 80, height: 80) //图片控件
              )),
      Expanded(
        //Expanded控件，用来拉伸中间区域
        child: Column(
          //Column控件，用来垂直摆放子Widget
          mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对齐
          crossAxisAlignment: CrossAxisAlignment.start, //水平方向居左对齐
          children: <Widget>[
            Text(model.appName, maxLines: 1), //App名字
            Text(model.appDate, maxLines: 1), //App更新日期
          ],
        ),
      ),
      Padding(
          //Paddng控件，用来设置Widget间边距
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0), //右边距为10，其余均为0
          child: FlatButton(
            //按钮控件
            child: Text("OPEN"),
            onPressed: () => {}, //点击回调
          ))
    ]);
  }

  //点击悬浮按钮
  void _onFloatingAction() {
    pushNamed(context, WEATHER_PAGE);
  }

  @override
  bool get wantKeepAlive => true;

  /// 去搜索页面
  void _goSearch() {
    NavigatorUtils.pushNamed(context, SEARCH_PAGE);
  }
}

class UpdatedItem extends StatelessWidget {

  final Diary model; //数据模型

  GestureTapCallback onTap; //点击回调

  // 构造函数语法糖，用来给model赋值
  // 将`model.id`作为Item的默认key
  UpdatedItem({this.model, this.onTap}) : super(key: ValueKey(model.id));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            debugPrint("onTap itemId=${model.id}");
            NavigatorUtils.pushNamed(context, DIARY_DETAIL_PAGE, arguments: model.id);
          },
//      child: DiaryItem(model: model),
        child: DiaryItem2(bean: model),
    );
  }
}
