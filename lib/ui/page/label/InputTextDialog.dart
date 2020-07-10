import 'package:flutter/material.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/base_dialog.dart';
/// 输入文本
class InputTextDialog extends StatefulWidget {
  String title;
  var text;
  Function(String) onPressed;

  InputTextDialog({
    Key key,
    this.title = "",
    this.text,
    this.onPressed,
  }) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _InputTextDialogState();
  }
}

class _InputTextDialogState extends State<InputTextDialog> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.text;
    if (!_controller.selection.isValid) {
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }
    return BaseDialog(
      child: Container(
        height: 34,
        margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: TextField(
            autofocus: true,
            controller: _controller,
            maxLines: 1,
            style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              fontSize: Dimens.font_sp16,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              border: OutlineInputBorder(),
              hintText: "输入文字…",
              hintStyle: TextStyles.textGray16,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, style: BorderStyle.none),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none),
              ),
            ),
        ),
      ),
      height: 160.0,
      onPressed: () {
        widget.onPressed(_controller.text);
        NavigatorUtils.goBack(context);
      },
      title: widget.title,
    );
  }
}
