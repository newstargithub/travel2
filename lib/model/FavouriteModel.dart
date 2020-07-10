
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/bean/PageData.dart';

import 'ViewStateListModel.dart';
import 'package:roll_demo/model/repository/WanAndroidRepository.dart';

class FavouriteModel extends ViewStateModel {
  final Article article;

  FavouriteModel(this.article);

  /// 收藏或取消
  collect() async {
    setBusy(true);
    try {
      if(article.collect) {
        await WanAndroidRepository.unCollect(article.id);
      } else {
        await WanAndroidRepository.collect(article.id);
      }
      article.collect = !article.collect;
      setBusy(false);
    }catch(e, s) {
      handleCatch(e, s);
    }
  }

}