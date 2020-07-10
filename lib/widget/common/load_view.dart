
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';

import '../ViewStateWidget.dart';

class LoadView extends StatelessWidget {

  ViewStateModel model;
  Widget contentChild;
  VoidCallback onErrorPressed;
  VoidCallback onEmptyPressed;
  String messageError;
  String messageEmpty;

  LoadView(this.model,
    this.contentChild,
    {
      this.onErrorPressed,
      this.onEmptyPressed,
      this.messageError,
      this.messageEmpty
    });

  @override
  Widget build(BuildContext context) {
    if (model.loading) {
      return ViewStateLoadingWidget();
    } else if (model.error) {
      return ViewStateWidget(
          message: messageError?? model.errorMessage, onPressed: onErrorPressed?? model.initData);
    } else if(model.empty) {
      return ViewStateWidget.empty(
        message: messageEmpty?? S.of(context).empty,
        onPressed: onEmptyPressed,
      );
    }
    return contentChild;
  }

}