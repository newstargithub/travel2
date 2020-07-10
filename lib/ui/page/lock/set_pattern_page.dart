
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/ui/page/lock/base_pattern_page.dart';

class SetPatternPage extends BasePatternWidget {
  Stage mStage;

  @override
  void onCompleted(String pin) {
    debugPrint("onCompleted:$pin");
  }

}



/*
class Stage {
   String message;
   bool patternEnabled;
   LeftButtonState leftButtonState;
   RightButtonState rightButtonState;

  Stage(this.message,
      this.leftButtonState,
      this.rightButtonState,
      this.patternEnabled);

  Draw("绘制解锁图案", LeftButtonState.Cancel, RightButtonState.ContinueDisabled,
    true),

  DrawTooShort("至少连接 %d 个点，请重画", LeftButtonState.Redraw,
    RightButtonState.ContinueDisabled, true),

  DrawValid(R.string.pl_pattern_recorded, LeftButtonState.Redraw, RightButtonState.Continue,
    false),

  Confirm(R.string.pl_confirm_pattern, LeftButtonState.Cancel,
    RightButtonState.ConfirmDisabled, true),

  ConfirmWrong(R.string.pl_wrong_pattern, LeftButtonState.Cancel,
    RightButtonState.ConfirmDisabled, true),

  ConfirmCorrect(R.string.pl_pattern_confirmed, LeftButtonState.Cancel,
    RightButtonState.Confirm, false);


}*/
