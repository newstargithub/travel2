
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/resources.dart';
/// 对齐按钮（左 居中 右）
class AlignButton extends StatefulWidget {
  int align;
  Function onPressed;

  AlignButton({Key key, this.align = TypeAlignment.left, @required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlignButtonState();
  }
}

class _AlignButtonState extends State<AlignButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
            var align = widget.align;
            if(align == TypeAlignment.left) {
              align = TypeAlignment.center;
            } else if(align == TypeAlignment.center){
              align = TypeAlignment.right;
            } else {
              align = TypeAlignment.left;
            }
            widget.onPressed(align);
            setState(() {
              widget.align = align;
            });
          },
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: new Text(
                _getNextText(widget.align),
                style: TextStyle(
                    fontSize: Dimens.font_normal,
                    color: Theme.of(context).accentColor
                ),
              )
      ),
    );
  }

  String _getNextText(int align) {
    var text;
    if(align == TypeAlignment.left) {
      text = S.of(context).center;
    } else if(align == TypeAlignment.center) {
      text = S.of(context).right;
    } else {
      text = S.of(context).left;
    }
    return text;
  }
}