
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/bean/ArticleTab.dart';
import 'package:roll_demo/bean/PageData.dart';
import 'ViewStateListModel.dart';
import 'ViewStateRefreshListModel.dart';
import 'package:roll_demo/model/repository/WanAndroidRepository.dart';

class ProjectCategoryModel extends ViewStateListModel<ArticleTab> {
  @override
  Future<List<ArticleTab>> loadData() async {
    return await WanAndroidRepository.fetchProjectTab();
  }
}

class ProjectListModel extends ViewStateRefreshListModel<Article> {
  /// 分类的id
  final int id;

  ProjectListModel(this.id);

  @override
  Future<List<Article>> loadData({int pageNum}) async {
    ArticlePageData data = await WanAndroidRepository.fetchProjectList(id, pageNum);
    return data.datas;
  }

}