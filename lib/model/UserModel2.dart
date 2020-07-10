
import 'package:roll_demo/bean/User.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/net/storage_manager.dart';

import 'ViewStateListModel.dart';
/// 用户状态
/// 用户状态在登录状态发生变化时更新、通知其依赖项
class UserModel extends ViewStateModel {
  static const String kUser = "kUser";

  User _user;

  User get user => _user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get hasUser => _user != null;

  UserModel() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    _user = userMap != null ? User.fromJson(userMap) : null;
  }

  setSlogan(String slogan) {
    _user.slogan = slogan;
    saveUser(user);
  }

  setNickname(String name) {
    _user.nickname = name;
    saveUser(user);
  }

  // 用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  void saveUser(User userInfo) {
    _user = userInfo;
    notifyListeners();
    StorageManager.localStorage.setItem(kUser, _user);
  }

  /// 清除持久化的用户数据
  void clearUser() {
    _user = null;
    notifyListeners();
    StorageManager.localStorage.deleteItem(kUser);
  }



}