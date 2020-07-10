
class CustomTypeList {
  int flag;//默认为文字——0：文字，1：图片，2：视频，3：音乐
  var data;//文字：文字内容 其它：资源地址
  int alignment;//对齐方式

  CustomTypeList({this.flag = TypeFlag.TEXT, this.data = "", this.alignment = TypeAlignment.left});

  bool get isText => flag == TypeFlag.TEXT;

  bool get isImage => flag == TypeFlag.IMAGE;

  @override
  String toString() {
    return 'CustomTypeList{flag: $flag, data: $data, alignment: $alignment}';
  }

  CustomTypeList.fromJson(Map<String, dynamic> json)
      : flag = json['flag'],
        data = json['data'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'flag': flag,
        'data': data,
      };
}

/// 资源类型
class TypeFlag{
  //文字
  static const int TEXT = 0;
  //图片
  static const int IMAGE = 1;
  //视频
  static const int VIDEO = 2;
  //音乐
  static const int MUSIC = 3;
}

/// 对齐方式
class TypeAlignment{
  static const int left = 0;
  static const int center = 1;
  static const int right = 2;
}