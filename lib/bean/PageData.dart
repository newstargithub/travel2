import 'Article.dart';

class ArticlePageData {
  bool over;
  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  List<Article> datas;

  ArticlePageData({this.over, this.curPage, this.offset, this.pageCount, this.size, this.total, this.datas});

  ArticlePageData.fromJson(Map<String, dynamic> json) {
    this.over = json['over'];
    this.curPage = json['curPage'];
    this.offset = json['offset'];
    this.pageCount = json['pageCount'];
    this.size = json['size'];
    this.total = json['total'];
    this.datas = (json['datas'] as List)!=null?(json['datas'] as List).map((i) => Article.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['over'] = this.over;
    data['curPage'] = this.curPage;
    data['offset'] = this.offset;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    data['datas'] = this.datas != null?this.datas.map((i) => i.toJson()).toList():null;
    return data;
  }

}


