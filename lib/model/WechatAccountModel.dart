
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/bean/PageData.dart';
import 'package:roll_demo/bean/ArticleTab.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/model/ViewStateRefreshListModel.dart';
import 'package:roll_demo/net/Http.dart';

import 'package:roll_demo/model/repository/WanAndroidRepository.dart';

/// 微信公众号
// 定义需要共享的数据模型，通过混入 ChangeNotifier 管理听众
// 我们在资源封装类中使用 mixin 混入了 ChangeNotifier
class WechatAccountCategoryModel extends ViewStateListModel<ArticleTab> {

  @override
  Future<List<ArticleTab>> loadData() async {
    return await WanAndroidRepository.fetchWechatAccounts();
  }

}

class WechatArticleListModel extends ViewStateRefreshListModel<Article> {
  /// 公众号id
  final int id;

  WechatArticleListModel(this.id);

  @override
  Future<List<Article>> loadData({int pageNum}) async {
    ArticlePageData data = await WanAndroidRepository.fetchAccountArticles(id, pageNum);
    return data.datas;
  }

}