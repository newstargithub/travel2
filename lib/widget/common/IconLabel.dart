
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/res/resources.dart';

class IconLabel extends StatelessWidget {
  Widget icon;

  Widget label;

  VoidCallback onPressed;

  IconLabel({
    Key key,
    this.onPressed,
    EdgeInsetsGeometry padding,
    ShapeBorder shape,
    @required Widget this.icon,
    @required Widget this.label,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        icon,
        Gaps.hGap5,
        label,
      ],
    );
  }

}