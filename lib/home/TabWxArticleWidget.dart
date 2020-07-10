import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/bean/ArticleTab.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/model/WechatAccountModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';

import 'ArticleListItem.dart';

class TabWxArticleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabWxArticleState();
  }
}

class _TabWxArticleState extends State<TabWxArticleWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<WechatAccountCategoryModel>(
      model: WechatAccountCategoryModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, WechatAccountCategoryModel model, child) {
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //需要定义一个Controller，用于控制/监听Tab菜单切换的
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
            child: TabBar(  //生成Tab菜单
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
              return WechatArticleList(e);
            }).toList(),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    return ProviderWidget<WechatArticleListModel>(
      model: WechatArticleListModel(widget.article.id),
      onModelReady: (model) => model.initData(),
      builder: (context, WechatArticleListModel model, child) {
        if (model.loading) {
          return ViewStateLoadingWidget();
        } else if (model.error) {
          return ViewStateWidget(
              message: model.errorMessage, onPressed: model.initData);
        }
        List<Article> list = model.list;
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: model.refreshController,
          onRefresh: model.refresh,
          onLoading: model.loadMore,
          child: ListView.separated(
            itemBuilder: (context, index) {
                Article bean = list[index];
                return ArticleItemWidget(bean);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1.0,
            ),
            itemCount: list.length, //长度+1为加载更多
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
