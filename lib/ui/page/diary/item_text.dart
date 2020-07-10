import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';

/// 文本输入框
class ItemText extends StatelessWidget {
  /// 当前位置
  final int index;
  /// 数据
  final CustomTypeList _entry;
  /// 焦点回调
  final Function focusCallBack;
  /// 编辑框的控制器
  final TextEditingController _controller = TextEditingController();
  /// 和键盘交互的一个句柄
  final FocusNode _focusNode = FocusNode();
  /// 对齐方式
  TextAlign textAlign = TextAlign.start;
  /// 自动获取焦点
  final autofocus;

  var readOnly;

  /// 构造函数
  ItemText(
      this.index,
      this._entry,
      this.focusCallBack,
      {
        this.autofocus = false,
        this.readOnly = false
      }
  ) {
    var item = _entry;
    String inputText = item.data;
    _controller.text = inputText;
    // 保持光标在最后
    _controller.selection = TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.downstream,
          offset: inputText.length
        )
    );
//    _getTextAlign(item);
  }

  /// 对齐方式
  void _getTextAlign(CustomTypeList item) {
    if (item.alignment == TypeAlignment.center) {
      textAlign = TextAlign.center;
    } else if (item.alignment == TypeAlignment.right) {
      textAlign = TextAlign.end;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ItemText.build 当前的是:$index 自动获取焦点:$autofocus");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8, ),
      child: TextField(
        // 编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件。
        controller: _controller,
        // 文本在水平方向的对齐方式
        textAlign: textAlign,
        // 输入框内容改变时的回调函数；注：内容改变事件也可以通过controller来监听。
        onChanged: (text) => _entry.data = text,
        // 设置该输入框默认的键盘输入类型：多行文本，需和maxLines配合使用(设为null或大于1)
        keyboardType: TextInputType.multiline,
        // 输入框的最大行数，默认为1；如果为null，则无行数限制。
        maxLines: null,
        // 文字方向：从左到右
        textDirection: TextDirection.ltr,
        // 是否自动获取焦点
        autofocus: autofocus,
        readOnly: readOnly,
        // 控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个句柄
        // 获得焦点时focusNode.hasFocus值为true，失去焦点时为false
        focusNode: _focusNode
          ..addListener(() {
            if (_focusNode.hasFocus) {
              focusCallBack(index, _controller, _focusNode);
              print("当前选择的是:$index");
            } else {
              print("当前选择的是:$index, 失去焦点");
            }
          }),
        style: TextStyle(textBaseline: TextBaseline.alphabetic),
        // 控制TextField的外观显示，如提示文本、背景颜色、边框等
        decoration: InputDecoration(
          hintText: index == 0 ? "在这里开始..." : (_focusNode.hasFocus ? "在这里继续..." : ""),
          border: InputBorder.none,
          // 未获得焦点下划线设为灰色, 隐藏下划线
//          enabledBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.grey, style: BorderStyle.none),
//          ),
        ),
      ),
    );
  }
}