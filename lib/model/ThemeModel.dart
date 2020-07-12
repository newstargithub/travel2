import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:roll_demo/ui/helper/theme_helper.dart';

/// APP主题状态
/// 主题状态在用户更换APP主题时更新、通知其依赖项
class ThemeModel extends ChangeNotifier {
  static const String kThemeBrightnessIndex = "kThemeBrightnessIndex";
  static const String kThemeColorIndex = "kThemeColorIndex";
  static const String kFontIndex = "kFontIndex";
  //在Flutter中使用字体分两步完成。首先在pubspec.yaml中声明它们，以确保它们会打包到应用程序中。然后通过TextStyle属性fontFamily使用字体。
  static const fontValueList = ['system', 'kuaile', 'kangxi'];

  ThemeData _themeData;

  /// 主题颜色
  MaterialColor _themeColor;

  /// 明暗模式
  Brightness _brightness;

  /// 当前字体索引
  int _fontIndex;

  ThemeModel() {
    _brightness = Brightness.values[
        StorageManager.sharedPreferences.getInt(kThemeBrightnessIndex) ?? 0];
    _themeColor = Colors.primaries[
        StorageManager.sharedPreferences.getInt(kThemeColorIndex) ?? 0];

    /// 获取字体
    _fontIndex = StorageManager.sharedPreferences.getInt(kFontIndex) ?? 0;
    _generateThemeData();
  }

  ThemeData get theme => _themeData;

  ThemeData get darkTheme => _themeData.copyWith(brightness: Brightness.dark);

  bool get isDark => _brightness == Brightness.dark;

  int get fontIndex => _fontIndex;

  /// 切换指定色彩
  /// 主题改变后，通知其依赖项，新主题会立即生效
  /// 没有传[brightness]就不改变brightness,color同理
  switchTheme({Brightness brightness, MaterialColor color}) {
    _brightness = brightness ?? _brightness;
    _themeColor = color ?? _themeColor;
    _generateThemeData();
    notifyListeners();
    saveTheme2Storage(_brightness, _themeColor);
  }

  void _generateThemeData() {
    var isDark = Brightness.dark == _brightness;
    var themeColor = _themeColor;
    // 应用主色调 primaryColor 应用次级色调 accentColor
    var accentColor = isDark ? themeColor[700] : _themeColor;
    var themeData = ThemeData(
        brightness: _brightness,//明暗模式
        // 主题颜色属于亮色系还是属于暗色系(eg:dark时,AppBarTitle文字及状态栏文字的颜色为白色,反之为黑色)
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        // 页面的主题颜色
        primarySwatch: themeColor,
        accentColor: accentColor,
        fontFamily: fontValueList[_fontIndex]);
    //继承 App 的主题，使用 copyWith 方法，只更新部分样式。
    themeData = themeData.copyWith(
      brightness: _brightness,
      accentColor: accentColor,
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: themeColor,
          brightness: _brightness,
          textTheme: CupertinoTextThemeData(brightness: Brightness.light)),
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
    );

    _themeData = themeData;
  }

  /// 数据持久化到shared preferences
  void saveTheme2Storage(
      Brightness brightness, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences
          .setInt(kThemeBrightnessIndex, brightness.index),
      StorageManager.sharedPreferences.setInt(kThemeColorIndex, index),
    ]);
  }

  /// 切换字体，
  switchFont(int index) {
    _fontIndex = index;
    switchTheme();
    saveFontIndex(index);
  }

  /// 字体选择持久化
  static saveFontIndex(int index) async {
    await StorageManager.sharedPreferences.setInt(kFontIndex, index);
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,指定则保持不变
  void switchRandomTheme({Brightness brightness}) {
    brightness ??= (Random().nextBool() ? Brightness.light : Brightness.dark);
    var colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(brightness: brightness, color: Colors.primaries[colorIndex]);
  }

  /// 根据索引获取字体名称,这里牵涉到国际化
  static String fontName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).autoBySystem;
      case 1:
        return S.of(context).fontKuaiLe;
      case 2:
        return S.of(context).fontKangXi;
      default:
        return '';
    }
  }

}
