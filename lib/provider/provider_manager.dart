import 'package:provider/provider.dart';
import 'package:roll_demo/model/LocaleModel.dart';
import 'package:roll_demo/model/ThemeModel.dart';
import 'package:roll_demo/model/UserModel2.dart';

/// 主题、用户、语言三种状态绑定到了应用的根上，这三种状态是全局共享的
List<SingleChildCloneableWidget> multiProviders = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildCloneableWidget> independentServices = [
//  Provider.value(value: Api())
  ChangeNotifierProvider<ThemeModel>.value(value: ThemeModel()),
  ChangeNotifierProvider<LocaleModel>.value(value: LocaleModel()),
  ChangeNotifierProvider<UserModel>.value(value: UserModel())
];

/// 需要依赖的model
List<SingleChildCloneableWidget> dependentServices = [
//  ProxyProvider<Api, AuthenticationService>(
//    builder: (context, api, authenticationService) =>
//        AuthenticationService(api: api),
//  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
