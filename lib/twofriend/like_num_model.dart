
import 'package:flutter/material.dart';
/// 应用 Provider 来实现状态管理。
/// 这里需要保存多个帖子的点赞数量，因此需要将这个状态变量设计为一个 Map
class LikeNumModel with ChangeNotifier {

  /// 声明私有变量
  Map<String, int> _likeInfo;

  /// 点赞
  like(String articleId) {
    if(_likeInfo == null){
      _likeInfo = {};
    }
    _likeInfo[articleId]++;
    notifyListeners();
  }

  /// 设置get方法
  int getLikeNum(String articleId, [int likeNum = 0]) {
    if(_likeInfo == null){
      _likeInfo = {};
    }
    if(articleId == null){
      return likeNum;
    }
    if(_likeInfo[articleId] == null) {
      _likeInfo[articleId] = likeNum;
    }
    return _likeInfo[articleId];
  }

}