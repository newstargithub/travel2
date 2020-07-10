
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';

class DialogUtil {

  /// 加载中弹窗
  static void showLoadingDialog(BuildContext context, {String text}) {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        // "去除"多重限制
        // 在实际开发中，当我们发现已经使用SizedBox或ConstrainedBox给子元素指定了宽高，但是仍然没有效果时，几乎可以断定：已经有父元素已经设置了限制！
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(value: .8,),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    // 正在加载，请稍后...
                    child: Text(text?? S.of(context).loading),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showLoadingDialog2(BuildContext context, {String text}) {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(text.isEmpty ? S.of(context).loading : text),
              )
            ],
          ),
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context, true);
  }

  /// 日历选择
  Future<DateTime>  _showDatePickerAndroid(BuildContext context) {

    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add( //未来30天可选
        Duration(days: 30),
      ),
    );
  }



  /// iOS风格的日历选择器需要使用showCupertinoModalPopup方法和CupertinoDatePicker组件来实现
  Future<DateTime> _showDatePicker2(BuildContext context) {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(
              Duration(days: 30),
            ),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print(value);
            },
          ),
        );
      },
    );
  }

  /// 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
    );
  }

}