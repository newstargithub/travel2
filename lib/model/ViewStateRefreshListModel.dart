
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ViewStateListModel.dart';

abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T> {
  /// 分页第一页页码
  static const int pageNumFirst = 0;

  /// 分页条目数量
  static const int sPageSize = 20;

  /// 当前页码
  int _curPageNum = pageNumFirst;
  /// 一页数量
  int pageSize = sPageSize;

  /// 没有更多数据
  bool noMoreData = true;

  RefreshController _refreshController = RefreshController(initialRefresh: false);


  get refreshController => _refreshController;

  /// 下拉刷新
  Future<List<T>> refresh({bool init = false}) async {
    try {
      _curPageNum = pageNumFirst;
      var data = await loadData(pageNum: _curPageNum);
      refreshCompleted();
      if (data.isEmpty) {
        noMoreData = true;
        setEmpty();
      } else {
        list.clear();
        list.addAll(data);
        noMoreData = data.length < pageSize;
        if (noMoreData) {
          loadNoData();
        }
        if (init) {
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
      }
      return data;
    } catch (e, s) {
      handleCatch(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future<List<T>> loadMore() async {
    try {
      _curPageNum = pageNumFirst;
      var data = await loadData(pageNum: _curPageNum + 1);
      if (data.isEmpty) {
        noMoreData = true;
        loadNoData();
      } else {
        _curPageNum ++;
        list.addAll(data);
        noMoreData = data.length < pageSize;
        if(noMoreData) {
          loadNoData();
        } else {
          loadCompleted();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      loadFailed();
      return null;
    }
  }

  // 加载数据
  Future<List<T>> loadData({int pageNum});

  /// 刷新完成
  void refreshCompleted() {
    _refreshController.refreshCompleted();
  }

  /// 没有更多数据
  void loadNoData() {
    _refreshController.loadNoData();
  }

  /// 加载更多完成
  void loadCompleted() {
    _refreshController.loadComplete();
  }

  /// 加载更多失败
  void loadFailed() {
    _refreshController.loadFailed();
  }
}
