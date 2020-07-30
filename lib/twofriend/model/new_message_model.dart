
import 'package:flutter/material.dart';

/// Message状态管理模块
class NewMessageModel with ChangeNotifier {
  /// 系统未读新消息数
  int newMessageNum;

  NewMessageModel(this.newMessageNum);

  /// 获取未读消息
  int get value => newMessageNum;

  /// 设置已经阅读消息
  /// 设置已读状态，也可以在此调用服务端，将服务端未读状态清零，同时将本地的未读消息数清零
  void readMessage() {
    // 当已经没有未读消息，则不需要处理任何行为
    if(newMessageNum == 0) {
      return;
    }
    newMessageNum = 0;
    notifyListeners();
  }


}