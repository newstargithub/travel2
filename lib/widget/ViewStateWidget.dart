import 'package:flutter/material.dart';
import 'package:roll_demo/generated/i18n.dart';

/// 加载中视图（圆形转圈）
class ViewStateLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      //通过尺寸限制类Widget，如ConstrainedBox、SizedBox来指定尺寸
      //圆形进度条直径指定为24
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

/// 基础状态Widget （加载出错视图：图片 文本 按钮）
class ViewStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  final Widget image;
  final Widget buttonText;

  ViewStateWidget(
      {Key key, this.message, this.onPressed, this.buttonText, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ?? Icon(Icons.error),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 50),
            child: Text(message ?? "Load Fail"),
          ),
          onPressed != null ? ViewStateButton(
            child:buttonText,
            onPressed: onPressed,
          ) : SizedBox()
        ],
      ),
    );
  }

  ViewStateWidget.empty({
    this.message = "空空如也",
    this.onPressed,
    this.image = const Icon(Icons.insert_drive_file),
    this.buttonText}
    ): super();
}

/// 共用Button
class ViewStateButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  ViewStateButton({this.child, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //轮廓线按钮
    return OutlineButton(
      child: child ?? Text(
        S.of(context).retry,
        style: TextStyle(wordSpacing: 5),
      ),
      onPressed: onPressed,
    );
  }
}
