import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/bean/ArticleTab.dart';
import 'package:roll_demo/model/ProjectCategoryModel.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';

import 'ArticleListItem.dart';

class TabProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabProjectPageState();
  }
}

class _TabProjectPageState extends State<TabProjectPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ProjectCategoryModel>(
      model: ProjectCategoryModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, ProjectCategoryModel model, child) {
        if (model.loading) {
          return ViewStateLoadingWidget();
        } else if (model.error) {
          return ViewStateWidget(
              message: model.errorMessage, onPressed: model.initData);
        }
        List<ArticleTab> tabs = model.list;
        return TabArticleWidget(tabs);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TabArticleWidget extends StatefulWidget {
  List<ArticleTab> tabs = [];

  TabArticleWidget(this.tabs);

  @override
  State<StatefulWidget> createState() {
    return _TabArticleWidgetState();
  }
}

class _TabArticleWidgetState extends State<TabArticleWidget>
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
            child: TabBar (
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
              //创建3个Tab页
              return WechatArticleList(e);
            }).toList(),
          ),
        )
      ],
    );
  }
}

/// 微信公众号 文章列表
class WechatArticleList extends StatefulWidget {
  ArticleTab article;

  WechatArticleList(this.article);

  @override
  State<StatefulWidget> createState() {
    return _ArticleListState();
  }
}

///查看类注释 Ctrl+Shift+空格
/// 允许子树请求在惰性列表中保持活动状态。提供方便方法的混合。
class _ArticleListState extends State<WechatArticleList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<ProjectListModel>(
      model: ProjectListModel(widget.article.id),
      onModelReady: (model) => model.initData(),
      builder: (context, ProjectListModel model, child) {
        if (model.loading) {
          return ViewStateLoadingWidget();
        } else if (model.error) {
          return ViewStateWidget(
              message: model.errorMessage, onPressed: model.initData);
        }
        List<Article> list = model.list;
        return ListView.separated(
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
            } else {
              Article bean = list[index];
              return ArticleItemWidget(bean);
            }
          },
          separatorBuilder: (context, index) => Divider(
            height: 1.0,
          ),
          itemCount: list.length + 1, //长度+1为加载更多
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
