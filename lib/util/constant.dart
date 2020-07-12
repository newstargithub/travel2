
import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/util/conmon_util.dart';

/// 共享状态和全局变量的不同在于前者发生改变时需要通知所有使用该状态的组件，
/// 而后者不需要。为此，我们将全局变量和共享状态分开单独管理。
const HTTP_BASE_URL = "https://www.wanandroid.com";
const LOGIN_PAGE = "login_page";
const REGISTER_PAGE = "register_page";
const EMAIL_RESET_PWD_PAGE = "email_reset_pwd_page";
const SETTING_PAGE = "setting_page";
const ARTICLE_DETAIL ="article_detail";
const WEATHER_PAGE ="weather_page";
const HOME_PAGE = "home_page";
const STORE_AUDIT_PAGE = "store_audit";
const ADDRESS_SELECT_PAGE = "address_select_page";
const TAG_LIST_PAGE = "tag_list_page";
const PERSONAL_AUDIT_PAGE = "personal_audit_page";
const NAME_AUDIT_PAGE = "name_audit_page";
const SLOGAN_EDIT_PAGE = "slogan_edit_page";
const SLOGAN_AUDIT_PAGE = "name_audit_slogan";
const SAVE_IMAGE_PAGE = "save_image_page";
const DIARY_DETAIL_PAGE = "diary_detail";
const SEARCH_PAGE = "search_page";
const SET_PATTERN = "set_pattern";
const CONFIRM_PATTERN = "confirm_pattern";


class Constant {
  static const String key_guide = 'key_guide';
  static const String phone = 'phone';
  static const String access_Token = 'accessToken';
  static const String refresh_Token = 'refreshToken';
  static const String save_image_show_border = 'key_save_image_show_border';
  static const String save_image_show_author = 'key_save_image_show_author';

  //todo Amap IOSApiKey
  static const String map_api_key = "4327916279bf45a044bb53b947442387";

  static const String kLoginName = "kLoginName";//本地配置键

  static List<String> weatherTextList;
  static final List weatherIconNameList = ["fine", "rain", "snow", "cloudy", "overcast"];
  static Map<String, String> weatherName2IconMap;

  /// 初始化图标数据
  static void _initWeatherData(BuildContext context) {
    if(weatherTextList == null) {
      weatherTextList = [
        S.of(context).fine,
        S.of(context).rain,
        S.of(context).snow,
        S.of(context).cloudy,
        S.of(context).overcast
      ];
      weatherName2IconMap = Map();
      for(int i = 0; i < weatherTextList.length; i++) {
        String text = weatherTextList[i];
        String icon = weatherIconNameList[i];
        weatherName2IconMap[text] = icon;
      }
    }
  }

  /// 获取天气对应图标名
  static String getWeatherIcon(BuildContext context, String weather) {
    if(CommonUtil.isEmpty(weather)) {
      return null;
    }
    if(weatherName2IconMap == null) {
      _initWeatherData(context);
    }
    return weatherName2IconMap[weather];
  }

  static List<String> getWeatherTextList(BuildContext context) {
    if(weatherTextList == null) {
      _initWeatherData(context);
    }
    return weatherTextList;
  }
}

/// 设置合同类
class PreferenceContract {
  static String KEY_PATTERN = "pattern";

}

void testFuture() {
  Future.delayed(Duration(seconds: 2), (){
    return "hi world!";
  }).then((data){
    //执行成功会走到这里 
    print(data);
  }).catchError((e){
    //执行失败会走到这里
    print(e);
  }).whenComplete((){
    //无论成功或失败都会走到这里
  });
}

///需要等待多个异步任务都执行结束后才进行一些操作
void testFutureWait() {
  Future.wait([
    Future.delayed(Duration(seconds: 2), (){
    return "hello ";
    }),
    Future.delayed(Duration(seconds: 2), (){
    return "world!";
    })
  ]).then((results){
    //执行成功会走到这里
    print(results[0] + results[1]);
  }).catchError((e){
    //执行失败会走到这里
    print(e);
  }).whenComplete((){
    //无论成功或失败都会走到这里
  });
}

//先分别定义各个异步任务
Future<String> login(String userName, String pwd){
  //用户登录
}

Future<String> getUserInfo(String id){
  //获取用户信息
}

Future saveUserInfo(String userInfo){
  // 保存用户信息
}

void testCallbackHell() {
  login("张三", "123").then((id){
    return getUserInfo(id);
  }).then((userInfo){
    return saveUserInfo(userInfo);
  }).then((e){
    //执行接下来的操作
  }).catchError((e){
    //错误处理
    print(e);
  });
}

///async和await处理异步
task() async {
  try {
    var id = await login("张三", "123");
    var userInfo = await getUserInfo(id);
    await saveUserInfo(userInfo);
    //执行接下来的操作
  } catch(e) {
    //错误处理
    print(e);
  }
}

void testStream() {
  Stream.fromFutures([
    // 1秒后返回结果
    Future.delayed(new Duration(seconds: 1), () {
      return "hello 1";
    }),
    // 抛出异常
    Future.delayed(new Duration(seconds: 2), () {
      throw AssertionError("Error");
    }),
    // 3秒后返回结果
    Future.delayed(new Duration(seconds: 3), () {
      return "hello 3";
    }),
  ]).listen((data){
    print(data);
  }, onError: (e){
    print(e.message);
  }, onDone: (){

  });
}