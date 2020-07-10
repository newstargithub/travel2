
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/sp_util.dart';
/// 手势密码帮助类
class PatternLockUtils {
  static int REQUEST_CODE_CONFIRM_PATTERN = 100;
  static int RESULT_OK = 1;

  static void setPattern(String pattern) {
    SpUtil.saveString(PreferenceContract.KEY_PATTERN, pattern);
  }

  static Future<String> getPattern() async {
    String value = await SpUtil.getString(PreferenceContract.KEY_PATTERN, defValue: null);
    debugPrint("getPattern:$value");
    return value;
  }

  static Future<bool> hasPattern() async {
    var patten = await getPattern();
    return patten != null;
  }

  static Future<bool> isPatternCorrect(String pattern) async {
    var setPattern = await getPattern();
    return pattern == setPattern;
  }

  static void clearPattern() {
    SpUtil.remove(PreferenceContract.KEY_PATTERN);
  }

  /// 去设置手势
  static void setPatternByUser() {
  }

  /// 去确认手势
  /// NOTE: Should only be called when there is a pattern for this account.
  static void confirmPattern(context, {int requestCode}) {
//    confirmPattern(activity, REQUEST_CODE_CONFIRM_PATTERN);
  }

  static Future confirmPatternIfHas(context) async {
    if (await hasPattern()) {
      confirmPattern(context);
    }
  }

  static bool checkConfirmPatternResult(context, int requestCode, int resultCode) {
    if (requestCode == REQUEST_CODE_CONFIRM_PATTERN) {
      context.onConfirmPatternResult(resultCode == RESULT_OK);
      return true;
    } else {
      return false;
    }
  }
}

abstract class OnConfirmPatternResultListener {
  void onConfirmPatternResult(bool successful);
}