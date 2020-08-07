import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Girl.dart';
import 'package:roll_demo/model/MeituListModel.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';

/// 网络图片
class NetPicturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PictureTab> tabs = [];
    PictureTab tab = PictureTab(name: "最热", path: "hot");
    tabs.add(tab);
    tab = PictureTab(name: "感性", path: "xinggan");
    tabs.add(tab);
    tab = PictureTab(name: "japan", path: "japan");
    tabs.add(tab);
    tab = PictureTab(name: "taiwan", path: "taiwan");
    tabs.add(tab);
    tab = PictureTab(name: "mm", path: "mm");
    tabs.add(tab);
    tab = PictureTab(name: "share", path: "share");
    tabs.add(tab);
    return TabPictureWidget(tabs);
  }
}

class PictureTab {
  String name;
  String path;

  PictureTab({this.name, this.path});
}

class TabPictureWidget extends StatefulWidget {
  List<PictureTab> tabs = [];

  TabPictureWidget(this.tabs);

  @override
  State<StatefulWidget> createState() {
    return _TabArticleWidgetState();
  }
}

class _TabArticleWidgetState extends State<TabPictureWidget>
    with SingleTickerProviderStateMixin {
  //需要定义一个Controller
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Container(
            color: Provider.of<ThemeModel>(context).theme.appBarTheme.color,
            child: TabBar(
              controller: _tabController,
              tabs: widget.tabs.map((e) => Tab(text: e.name)).toList(),
              isScrollable: true,
              indicatorColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((e) {
              //创建Tab页
              return MeituList(e);
            }).toList(),
          ),
        )
      ],
    );
  }
}

/// 文章列表
class MeituList extends StatefulWidget {
  PictureTab tab;

  MeituList(this.tab);

  @override
  State<StatefulWidget> createState() {
    return _MeituListState();
  }
}

///查看类注释 Ctrl+Shift+空格
/// 允许子树请求在惰性列表中保持活动状态。提供方便方法的混合。
class _MeituListState extends State<MeituList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MeituListModel>(
      model: MeituListModel(widget.tab.path),
      onModelReady: (model) => model.initData(),
      builder: (context, MeituListModel model, child) {
        if (model.loading) {
          /// 加载中
          return ViewStateLoadingWidget();
        } else if (model.error) {
          /// 加载出错
          return ViewStateWidget(
              message: model.errorMessage, onPressed: model.initData);
        }
        final List<Girl> list = model.list;
        return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              //如果到了最后一项
              if (index == list.length) {
                //继续获取数据
                if (!model.noMoreData) {
                  //获取数据
                  model.loadMore();
                  //加载时显示loading
                  return ViewStateLoadingWidget();
                } else {
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        "没有更多了",
                        style: TextStyle(color: Colors.grey),
                      ));
                }
              }
              final Girl bean = list[index];
              return InkWell(
                onTap: () => model.logic.onPictureTap(list, index, context),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Hero(
                      tag: "tag_$index",
                      child: CachedNetworkImage(
                        imageUrl: bean.url,
                        fit: BoxFit.cover,
                        httpHeaders: {"Referer": bean.refer},
                        /// 展位图
                        placeholder: (context, url) => new Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                        /// 加载出错
                        errorWidget: (context, url, error) => new Icon(
                          Icons.error,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
