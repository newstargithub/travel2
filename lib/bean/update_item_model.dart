
class UpdateItemModel {
  String appIcon; //App图标
  String appName; //App名称
  String appSize; //App大小
  String appDate; //App更新日期
  String appDescription; //App更新文案
  String appVersion; //App版本
  //构造函数语法糖，为属性赋值
  UpdateItemModel(
      {this.appIcon,
        this.appName,
        this.appSize,
        this.appDate,
        this.appDescription,
        this.appVersion});
}