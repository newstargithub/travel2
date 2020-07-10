
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:roll_demo/util/constant.dart';

class ResetPwdModel extends ViewStateModel {

  String getLoginName() {
    return StorageManager.sharedPreferences.getString(Constant.kLoginName);
  }

  Future<bool> reset(String username) async {
    try{
      setBusy(true);
      //todo 发送重置请求
      await StorageManager.sharedPreferences.getString(Constant.kLoginName);
      setBusy(false);
      return true;
    } catch (e, s) {
      handleCatch(e, s);
      return false;
    }
  }


}