import 'package:roll_demo/bean/User.dart';

import 'ProfileChangeNotifier.dart';

/// 用户状态 profile
/// 用户状态在登录状态发生变化时更新、通知其依赖项，我们定义如下：
class UserProfileModel extends ProfileChangeNotifier {

  User get user => profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    if (user != this.user) {
      profile.lastLogin = profile.user?.username;
      profile.user = user;
      notifyListeners();
    }
  }

}