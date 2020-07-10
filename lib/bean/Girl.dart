class Girl {

  String url;
  int width;
  int height;
  String link;
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
