import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/twofriend/api/content/index.dart';
import 'package:roll_demo/twofriend/struct/content_detail.dart';
import 'package:roll_demo/twofriend/struct/content_list_ret_info.dart';
import 'package:roll_demo/twofriend/widgets/article_card.dart';
import 'package:roll_demo/twofriend/widgets/common/error.dart';
import 'package:roll_demo/twofriend/widgets/common/loading.dart';

class HomePageIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageIndexState();
  }
}

class _HomePageIndexState extends State<HomePageIndex> {
  /// 首页推荐贴子列表
  List<StructContentDetail> contentList;

  /// 列表事件监听
  ScrollController scrollController = ScrollController();

  /// 是否存在下一页
  bool hasMore;

  /// 页面是否正在加载
  bool isLoading;

  /// 最后一个数据 ID
  String lastId;

  bool error;

  /// 处理刷新操作
  Future onRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      setFirstPage();
    });
  }

  @override
  void initState() {
    super.initState();

    /// 拉取首页接口数据
    setFirstPage();

    /// 监听上滑事件，活动加载更多
    scrollController.addListener(() {
      if (!hasMore) {
        return;
      }
      if (!isLoading &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        isLoading = true;
        loadMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(error){
      return CommonError(action: this.setFirstPage);
    }
    return RefreshIndicator(
      //下拉刷新
      onRefresh: onRefresh,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: contentList.length + 1,
        itemBuilder: (BuildContext context, int position) {
          if(position < contentList.length) {
            return ArticleCard(userInfo: contentList[position].userInfo, articleInfo: contentList[position]);
          } else {
            return CommonLoadingButton(
                loadingState: isLoading, hasMore: hasMore
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: .5,
            //indent: 75,
            color: Color(0xFFDDDDDD),
          );
        },
      ),
    );
  }

  /// 处理首次拉取和刷新数据获取动作
  void setFirstPage() {
    StructApiContentListRetInfo retInfo = ApiContentIndex().getRecommendList();
    if(retInfo.ret != 0){ // 判断返回是否正确
      error = true;
      return;
    }
    error = false;
    setState(() {
      contentList = retInfo.data;
      hasMore = retInfo.hasMore;
      isLoading = false;
      lastId = retInfo.lastId;
    });
  }

  /// 加载下一页
  void loadMoreData() {
    StructApiContentListRetInfo retInfo =
        ApiContentIndex().getRecommendList(lastId);
    List<StructContentDetail> newList = retInfo.data;
    /// 使用 setState 来更新状态变量 contentList ，从而触发界面 build 。
    setState(() {
      isLoading = false;
      hasMore = retInfo.hasMore;
      contentList.addAll(newList);
    });
  }
}
