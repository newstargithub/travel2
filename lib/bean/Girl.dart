class Girl {
  /// 图片地址
  String url;
  /// 宽
  int width;
  /// 高
  int height;
  /// 详情页链接
  String link;
  /// 伪造 refer 破解防盗链
  String refer;

  Girl({this.url, this.width, this.height});

  Girl.fromJson(Map<String, dynamic> json) {    
    this.url = json['url'];
    this.width = json['width'];
    this.height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }

}
