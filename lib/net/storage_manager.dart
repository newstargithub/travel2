import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

/// Flutter 提供了两种文件存储的目录，即临时（Temporary）目录与文档（Documents）目录
class StorageManager {
  /// app全局配置 eg:theme
  /// 缓存少量的键值对信息，只能存储基本类型的数据，比如 int、double、bool 和 string。
  static SharedPreferences sharedPreferences;

  /// 临时目录 eg: cookie
  /// 临时目录是操作系统可以随时清除的目录，通常被用来存放一些不重要的临时缓存数据。
  static Directory temporaryDirectory;

  /// 初始化必备操作 eg:user数据
  static LocalStorage localStorage;

  /// 文档目录则是只有在删除应用程序时才会被清除的目录，通常被用来存放应用产生的重要数据文件。
  static Directory appDocumentsDirectory;

  static Directory externalStorageDirectory;

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    // async 异步操作

    // sync 同步操作
    //PathProvider 插件提供了一种平台透明的方式来访问设备文件系统上的常用位置。

    //获取临时目录: 系统可随时清除的临时目录（缓存）。
    //这个目录在 iOS 上对应着 NSTemporaryDirectory 返回的值，而在 Android 上则对应着 getCacheDir 返回的值。
    temporaryDirectory = await getTemporaryDirectory();
    //获取应用程序的文档目录，该目录用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。
    //在 iOS 上，这个目录对应着 NSDocumentDirectory，而在 Android 上则对应着 AppData 目录。
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
    //获取外部存储目录，如SD卡；由于iOS不支持外部目录，所以在iOS下调用该方法会抛出UnsupportedError异常
    externalStorageDirectory = await getExternalStorageDirectory();
    //在 iOS 上使用 NSUserDefaults，在 Android 使用 SharedPreferences。
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('LocalStorage');
    await localStorage.ready;
  }
}
