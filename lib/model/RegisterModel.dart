
import 'package:roll_demo/bean/User.dart';
import 'package:roll_demo/net/Http.dart';
import 'package:roll_demo/net/storage_manager.dart';

import 'UserModel2.dart';
import 'ViewStateListModel.dart';
import 'package:roll_demo/model/repository/WanAndroidRepository.dart';

class RegisterModel extends ViewStateModel {

  /// 注册
  Future<bool> register(String username, String password, String repassword) async {
    try{
      setBusy(true);
      await WanAndroidRepository.register(username, password, repassword);
      setBusy(false);
      return true;
    } catch (e, s) {
      handleCatch(e, s);
      return false;
    }
  }

}