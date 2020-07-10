import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/util/util.dart';
/// 加载
class LoadingWidget extends StatelessWidget {
  final Color progressColor;
  final Color textColor;
  final double textSize;
  final String loadingText;
  final String emptyText;
  final String errorText;
  final String idleText;
  final LoadingFlag flag;
  final VoidCallback errorCallBack;
  final Widget successWidget;
  final double size;

  LoadingWidget(
      {this.progressColor,
      this.textColor,
      this.textSize,
      this.loadingText,
      this.flag = LoadingFlag.loading,
      this.errorCallBack,
      this.emptyText,
      this.errorText, this.size = 100, this.successWidget, this.idleText});

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    switch (flag) {
      case LoadingFlag.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: size / 2,
                width: size / 2,
                //圆形进度条
                child: CircularProgressIndicator(
                  strokeWidth: size / 10,
                  valueColor: AlwaysStoppedAnimation(
                      progressColor ?? primaryColor),
                ),
              ),
              SizedBox(
                height: size / 5,
              ),
              Text(
                loadingText ?? S.of(context).loading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: textSize ?? size / 5, color: textColor ?? primaryColor),
              )
            ],
          ),
        );
        break;
      case LoadingFlag.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                Utils.getSvgPath("loading_error"),
                color: progressColor ?? primaryColor,
                width: size,
                height: size,
                semanticsLabel: 'loading error',
              ),
              FlatButton(
                  onPressed: errorCallBack ?? (){},
                  child: Text(
                    "${errorText??""}".isEmpty? S.of(context).reLoading : errorText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize ?? size / 5, color: textColor ?? primaryColor),
                  )),
            ],
          ),
        );
        break;
      case LoadingFlag.success:
        return successWidget ?? SizedBox();
        break;
      case LoadingFlag.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                Utils.getSvgPath("empty_list"),
                color: progressColor ?? primaryColor,
                width: size,
                height: size,
                semanticsLabel: 'empty list',
              ),
              Text(
                emptyText ?? S.of(context).loadingEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: textSize ?? size / 5, color: textColor ?? primaryColor),
              ),
            ],
          ),
        );
        break;

      case LoadingFlag.idle:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                Utils.getSvgPath("loading_idle"),
                color: progressColor ?? primaryColor,
                width: size,
                height: size,
                semanticsLabel: 'idle',
              ),
              Text(
                idleText ?? S.of(context).loadingIdle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: textSize ?? size / 5, color: textColor ?? primaryColor),
              )
            ],
          ),
        );
        break;
    }
    return Container();
  }
}

/// 加载状态枚举
enum LoadingFlag { loading, error, success, empty, idle}
