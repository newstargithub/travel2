
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/ui/page/lock/base_confirm_pattern.dart';
import 'package:roll_demo/ui/page/lock/base_pattern_page.dart';
import 'package:roll_demo/util/route.dart';

import 'PatternLockUtils.dart';

class ConfirmPatternPage extends BaseConfirmPattern {

  @override
  void onConfirmed(BuildContext context) {
    PatternLockUtils.clearPattern();
    NavigatorUtils.goBackWithParams(context, PATTERN_SUCCESS);
  }

  @override
  void onForgotPassword(BuildContext context) {
    NavigatorUtils.goBackWithParams(context, PATTERN_FORGOT);
  }

  @override
  void onPatternCancel(BuildContext context) {
    NavigatorUtils.goBackWithParams(context, CANCELLED);
  }

  @override
  Future<bool> isPatternCorrect(String pattern) async {
    return await PatternLockUtils.isPatternCorrect(pattern);
  }


}