
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/util/sp_util.dart';
import 'package:roll_demo/util/util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///开屏页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  int _status = 0;
  List<String> _guideList = [
    "app_start_1",
    "app_start_2",
    "app_start_3",
  ];
  StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _initSplash();
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  void _initAsync() async {
    if (!SpUtil.getBool(Constant.key_guide, defValue: true)) {
      SpUtil.putBool(Constant.key_guide, false);
      //新手引导
      _initGuide();
    } else {
      //去登录
      _goLogin();
    }
  }

  void _initGuide() {
    setState(() {
      _status = 1;
    });
  }

  //延迟两秒触发订阅
  void _initSplash(){
    _subscription = Observable.just(1).delay(Duration(milliseconds: 2000)).listen((_){
      _initAsync();
    });
  }
  
  _goLogin(){
    //直接去首页了
    pushNamed(context, HOME_PAGE, replace: true);
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          //启动背景图 可隐藏其子控件
          Offstage(
            offstage: !(_status == 0),
            child: Image.asset(
              Utils.getImgPath("start_page", format: "jpg"),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          //新手引导
          Offstage(
            offstage: !(_status == 1),
            child: Swiper(
              itemCount: _guideList.length,
              loop: false,
              itemBuilder: (_, index){
                return loadAssetImage(
                  _guideList[index],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
              onTap: (index){
                if (index == _guideList.length - 1){
                  _goLogin();
                }
              },
            )
          )
        ],
      ),
    );
  }
}
