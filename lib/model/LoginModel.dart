
import 'package:roll_demo/bean/User.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:roll_demo/util/constant.dart';

import 'UserModel2.dart';
import 'ViewStateListModel.dart';
import 'package:roll_demo/model/repository/WanAndroidRepository.dart';
/// 用户登录Model
class LoginModel extends ViewStateModel {

  final UserModel userModel;

  LoginModel(this.userModel) : assert(userModel != null);

  getLoginName() {
    return StorageManager.sharedPreferences.getString(Constant.kLoginName);
  }

  /// 登录
  Future<bool> login(String username, String password) async {
    try{
      setBusy(true);
      User userInfo = await WanAndroidRepository.login(username, password);
      userModel.saveUser(userInfo);
      StorageManager.sharedPreferences.setString(Constant.kLoginName, userInfo.username);
      setBusy(false);
      return true;
    } catch (e, s) {
      handleCatch(e, s);
      return false;
    }
  }

  /// 登出
  Future<bool> logout() async {
    if(!userModel.hasUser) {
      //防止递归
      return false;
    }
    setBusy(true);
    try {
      await WanAndroidRepository.logout();
      userModel.clearUser();
      setBusy(false);
      return true;
    } catch(e, s) {
      handleCatch(e, s);
      return false;
    }
  }

}