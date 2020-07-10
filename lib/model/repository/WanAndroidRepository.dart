import 'dart:collection';

import 'package:roll_demo/bean/PageData.dart';
import 'package:roll_demo/bean/User.dart';
import 'package:roll_demo/bean/ArticleTab.dart';
import 'package:roll_demo/net/Http.dart';

///数据仓库
class WanAndroidRepository {
  /// 公众号分类
  static Future<List<ArticleTab>> fetchWechatAccounts() async {
    var response = await http.get('wxarticle/chapters/json');
    return response.data
        .weatherName2IconMap<ArticleTab>((item) => ArticleTab.fromJsonMap(item))
        .toList();
  }

  /// 公众号文章列表
  static Future<ArticlePageData> fetchAccountArticles(
      int id, int page) async {
    var response = await http.get('wxarticle/list/$id/$page/json');
    return ArticlePageData.fromJson(response.data);
  }

  /// 登录
  /// https://www.wanandroid.com/user/login
  ///
  /// 方法：POST
  /// 参数：
  ///	username，password
  static Future<User> login(String username, String password) async {
    Map<String, dynamic> queryParameters = HashMap();
    queryParameters["username"] = username;
    queryParameters["password"] = password;
    var response = await http.post('user/login', queryParameters: queryParameters);
    return User.fromJson(response.data);
  }

  /*注册
  https://www.wanandroid.com/user/register
  方法：POST
  参数
  username,password,repassword*/
  static Future<User> register(String username, String password, String repassword) async {
    Map<String, dynamic> queryParameters = HashMap();
    queryParameters["username"] = username;
    queryParameters["password"] = password;
    queryParameters["repassword"] = repassword;
    var response = await http.post('user/register', queryParameters: queryParameters);
    return User.fromJson(response.data);
  }

  /*退出
  https://www.wanandroid.com/user/logout/json
  方法：GET
  访问了 logout 后，服务端会让客户端清除 Cookie（即cookie max-Age=0），如果客户端 Cookie 实现合理，可以实现自动清理，如果本地做了用户账号密码和保存，及时清理。
  */
  static Future logout() async {
    return await http.get('user/logout/json');
  }

  /*收藏站内文章
  https://www.wanandroid.com/lg/collect/1165/json
  方法：POST
  参数： 文章id，拼接在链接中。*/
  static Future collect(int id) async {
    var response = await http.post('lg/collect/$id/json');
    return response.data;
  }

  /*文章列表取消收藏
  https://www.wanandroid.com/lg/uncollect_originId/2333/json

  方法：POST
  参数：
  id:拼接在链接上*/
  static Future unCollect(int id) async {
    var response = await http.post('lg/uncollect_originId/$id/json');
    return response.data;
  }

  /*项目分类
  https://www.wanandroid.com/project/tree/json
  方法： GET
  参数： 无
  项目为包含一个分类，该接口返回整个分类。*/
  static Future<List<ArticleTab>> fetchProjectTab() async {
    var response = await http.get('project/tree/json');
    return response.data
        .weatherName2IconMap<ArticleTab>((item) => ArticleTab.fromJsonMap(item))
        .toList();
  }

  /*项目列表数据
  某一个分类下项目列表数据，分页展示
  https://www.wanandroid.com/project/list/1/json?cid=294
  方法：GET
  参数：
  cid 分类的id，上面项目分类接口
  页码：拼接在链接中，从1开始。*/
  static Future<ArticlePageData> fetchProjectList(int cid, int page) async {
    var response = await http.get('project/list/$page/json?cid=$cid');
    return ArticlePageData.fromJson(response.data);
  }

}
