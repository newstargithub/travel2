
class ArticleTab {
  /*{
  "children": [],
  "courseId": 13,
  "id": 408,
  "name": "鸿洋",
  "order": 190000,
  "parentChapterId": 407,
  "userControlSetTop": false,
  "visible": 1
  }*/

  List<ArticleTab> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  ArticleTab({this.children, this.courseId, this.id, this.name, this.order, this.parentChapterId, this.userControlSetTop, this.visible});

  factory ArticleTab.fromJson(Map<String, dynamic> map){
    return ArticleTab(
        children: List<ArticleTab>.from(map["children"]((it) => ArticleTab.fromJsonMap(it))),
        courseId: map['courseId'],
        id: map['id'],
        name : map['name'],
        order : map ['order'],
        parentChapterId : map ['parentChapterId'],
        userControlSetTop : map['userControlSetTop'],
        visible : map ['visible']
    );
  }

  ArticleTab.fromJsonMap(Map<String, dynamic> map) :
    children = List<ArticleTab>.from(map["children"].map((it) => ArticleTab.fromJsonMap(it))),
    courseId = map['courseId'],
    id = map['id'],
    name = map['name'],
    order = map ['order'],
    parentChapterId = map ['parentChapterId'],
    userControlSetTop = map['userControlSetTop'],
    visible = map ['visible'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['children'] =
    children != null ? children.map((v) => v.toJson()).toList() : null;
    data['courseId'] = courseId;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['parentChapterId'] = parentChapterId;
    data['userControlSetTop'] = userControlSetTop;
    data['visible'] = visible;
    return data;
  }

}