
import 'package:flutter/material.dart';

/// loading 组件会有三种状态：加载中、上拉加载提示、加载完成
///
/// 自行展示，load more还是已加载完成
class CommonLoadingButton extends StatelessWidget {
  /// 加载状态
  final bool loadingState;
  /// 是否有更多
  final bool hasMore;
  /// 默认构造函数
  const CommonLoadingButton({Key key, this.loadingState, this.hasMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!hasMore) {
      return NoMore();
    }
    if(loadingState) {
      return Loading();
    } else{
      return LoadingStatic();
    }
  }
}

class LoadingStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("下拉加载更多");
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("正在加载更多...");
  }
}

class NoMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("我们是有底线的~");
  }
}