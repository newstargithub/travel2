import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/bean/update_item_model.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/diary_list_model.dart';
import 'package:roll_demo/pages/home/main_page_drawer.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/widget/WeatherFloatWidget.dart';
import 'package:roll_demo/widget/app/diary_card.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

/// 单独封装一个UpdatedItem Widget 专门用于构建列表项UI

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  UpdateItemModel model;

  //距底部的偏移
  double _bottom = 0.0;

  //距右边的偏移
  double _right = 0.0;

  var _controller = ScrollController();

  //显示返回顶部
  bool showToTopBtn = false;

  //
  int showToTopBtnOffset = 200;

  int firstVisibleIndex = -1;

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      //打印滚动位置
      debugPrint("addListener ${_controller.offset}");
      if (_controller.offset < showToTopBtnOffset && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else
      if (_controller.offset >= showToTopBtnOffset && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
        model: DiaryListModel(),
        onModelReady: (DiaryListModel model) => model.initData(),
        builder: (context, DiaryListModel model, child) {
          return Scaffold(
            //导航栏
            appBar: PreferredSize(
                child: AppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _goSearch,
                    )
                  ],
                  title: _buildCenterTitle(context, model),
                  centerTitle: true,
                ),
                preferredSize: Size.fromHeight(Dimens.app_bar_height)),
            drawer: MainPageDrawer(), //抽屉
            body: Stack(
              children: <Widget>[
                SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: model.refreshController,
                  onRefresh: model.refresh,
                  onLoading: model.loadMore,
                  child: buildDiaryListWidget(model, context),
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
                    onPanEnd: (DragEndDetails e) {
                      //打印滑动结束时在x、y轴上的速度
                      print(e.velocity);
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  //返回到顶部时执行动画
                  _controller.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease
                  );
                }
            ),
          );
        });

    /*return Scaffold(
      //导航栏
      appBar: PreferredSize(
          child: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _goSearch,
              )
            ],
            title: _buildCenterTitle(context),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(Dimens.app_bar_height)),
      drawer: MainPageDrawer(), //抽屉
      body: Stack(
        children: <Widget>[
          ProviderWidget(
              model: DiaryListModel(),
              onModelReady: (DiaryListModel model) => model.initData(),
              builder: (context, DiaryListModel model, child) {
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: model.refreshController,
                  onRefresh: model.refresh,
                  onLoading: model.loadMore,
                  child: buildDiaryListWidget(model, context),
                );
              }),
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
              onPanEnd: (DragEndDetails e) {
                //打印滑动结束时在x、y轴上的速度
                print(e.velocity);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          onPressed: () {
            //返回到顶部时执行动画
            _controller.animateTo(.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease
            );
          }
      ),
    );*/
  }

  /// 定制底部
  Widget _buildCustomFooter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget widget;
        if (mode == LoadStatus.idle) {
          widget = Text("上拉加载");
        } else if (mode == LoadStatus.loading) {
          widget = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          widget = Text("加载失败！点击重试！");
        } else if (mode == LoadStatus.canLoading) {
          widget = Text("松手,加载更多!");
        } else {
          widget = Text("没有更多数据了!");
        }
        return Container(
          height: 55.0,
          child: Center(child: widget),
        );
      },
    );
  }

  StatelessWidget buildDiaryListWidget(DiaryListModel model,
      BuildContext context) {
    if (model.loading) {
      return ViewStateLoadingWidget();
    } else if (model.error) {
      return ViewStateWidget(
          message: model.errorMessage, onPressed: model.initData);
    } else if (model.empty) {
      return ViewStateWidget(
          message: S
              .of(context)
              .empty, onPressed: model.initData);
    }
    var items = model.list;
    //如果需要自定义列表项生成模型，可以通过ListView.custom来自定义，它需要实现一个SliverChildDelegate用来给ListView生成列表项组件
    return ListView.custom(
      childrenDelegate: MyChildrenDelegate(
              (BuildContext context, int index) {
            return HomeDiaryItem(
                data: items[index], key: ValueKey(items[index]));
          },
          childCount: items.length,
          findChildIndexCallback: (Key key) {
            final ValueKey valueKey = key;
            final Diary data = valueKey.value;
            return items.indexOf(data);
          },
          visibleIndex: (int first, int last) {
            if (first != firstVisibleIndex) {
              setState(() {
                firstVisibleIndex = first;
              });
            }

          }
      ),
      controller: _controller,
      cacheExtent: 1.0, // 只有设置了1.0 才能够准确的标记position 位置
    );
    /*return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return HomeDiaryItem(data: items[index], key: ValueKey(items[index]));
      },
      separatorBuilder: (BuildContext context, int index) => Gaps.hGap8,
      itemCount: items.length,
      controller: _controller,
    );*/
  }

  Widget buildTopRow(BuildContext context) {
    return Row( //Row控件，用来水平摆放子Widget
        children: <Widget>[
          Padding(
            //Paddng控件，用来设置Image控件边距
              padding: EdgeInsets.all(10), //上下左右边距均为10
              //圆角矩形裁剪控件
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), //圆角半径为8
                  child: Image.asset(
                      model.appIcon, width: 80, height: 80) //图片控件
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

  /// 中间的标题
  _buildCenterTitle(BuildContext context, DiaryListModel model) {
    if (firstVisibleIndex >= 0 && firstVisibleIndex < model.list.length) {
      final Diary firstItem = model.list[firstVisibleIndex];
      return InkWell(
        child: Text(CommonUtil.formatDate(firstItem.dateTime, pattern: "yyyy年MM月")),
        onTap: _showDatePicker(context),
      );
    }
  }

  _showDatePicker(BuildContext context) {
    var dateNow = DateTime.now();
//    var dateTime = await showDatePicker(context: context, initialDate: dateNow,
//        firstDate: dateNow, lastDate: dateNow);
  }


}

class HomeDiaryItem extends StatelessWidget {
  final Diary data; //数据模型

  GestureTapCallback onTap; //点击回调

  // 构造函数语法糖，用来给model赋值
  // 将`model.id`作为Item的默认key
  HomeDiaryItem({this.data, this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
              () {
            debugPrint("onTap itemId=${data.id}");
            NavigatorUtils.pushNamed(context, DIARY_DETAIL_PAGE,
                arguments: data.id);
          },
//      child: DiaryItem(model: model),
      child: DiaryCard(bean: data),
    );
  }
}

class MyChildrenDelegate extends SliverChildBuilderDelegate {

  Function(int firstIndex, int lastIndex) visibleIndex;

  MyChildrenDelegate(Widget Function(BuildContext, int) builder, {
    int childCount,
    bool addAutomaticKeepAlive = true,
    bool addRepaintBoundaries = true,
    ChildIndexGetter findChildIndexCallback,
    this.visibleIndex
  }) : super(builder,
      childCount: childCount,
      addAutomaticKeepAlives: addAutomaticKeepAlive,
      addRepaintBoundaries: addRepaintBoundaries,
      findChildIndexCallback: findChildIndexCallback);

  @override
  double estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    print(
        'firstIndex: $firstIndex, lastIndex: $lastIndex, leadingScrollOffset: $leadingScrollOffset,'
            'trailingScrollOffset: $trailingScrollOffset  ');
    visibleIndex(firstIndex, lastIndex);
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}
