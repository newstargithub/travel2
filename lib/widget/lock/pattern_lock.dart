
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
/// 绘制手势密码
/// https://zhuanlan.zhihu.com/p/88728224
class PatternLock extends StatefulWidget {

  /// 选中状态下的大小
  int _dotSelectedSize;

  /// 正常状态下的大小
  double _dotNormalSize;

  /// 线条宽度粗细
  double _pathWidth = 5;

  /// 点数
  int dotCount;

  /// 正常情况下的颜色
  int normalStateColor;

  /// 选中情况下的颜色
  int selectedStateColor;

  /// 正确时颜色
  int correctStateColor;

  /// 错误时颜色
  int wrongStateColor;

  /// 隐藏手势路径模式
  bool inStealthMode;

  int _patternSize;

  /// 手势点位
  List<Dot> _pattern;

  /// 图案绘制查找
  List<List<bool>> _patternDrawLookup;

  List<List<Dot>> _dotStates;

  /// 最少连接点数
  int minLinkDotCount;

  /// 手势锁结果回调
  /// 图案绘制刚开始时触发
  Function onStarted;

  /// 当手势仍在绘制并继续进行时激发 (List<Dot> progressPattern)
  Function onProgress;

  /// 当用户完成图案绘制并将手指移离视图时激发 (List<Dot> pattern)
  Function onComplete;

  /// 当手势被从视图中清除时激发
  Function onCleared;

  PatternLock({
    this.dotCount = 3,
    this.normalStateColor = 0xffcdbff3,
    this.selectedStateColor = 0xff7d7d7d,
    this.correctStateColor = 0x333333,
    this.wrongStateColor = 0xff3333,
    this.inStealthMode = false,
    this.minLinkDotCount = 4,
    this.onComplete,
    this.onStarted,
    this.onProgress,
    this.onCleared
  });

  @override
  State<StatefulWidget> createState() {
    return _PatternLockState();
  }

  /// 点正常情况下的大小
  void setDotNormalSize(double dotNormalSize) {
    _dotNormalSize = dotNormalSize;
  }

  /// 线条宽度
  void setPathWidth(double pathWidth) {
    _pathWidth = pathWidth;
  }

  /// 点选中情况下的大小
  void setDotSelectedSize(int dotSelectedSize) {
    _dotSelectedSize = dotSelectedSize;
  }

  /// 正常情况下的颜色
  void setNormalStateColor(int normalStateColor) {
    this.normalStateColor = normalStateColor;
  }

  /// 错误情况下的颜色
  void setWrongStateColor(int wrongStateColor) {
    this.wrongStateColor = wrongStateColor;
  }

  /// 正确情况下的颜色
  void setCorrectStateColor(int correctStateColor) {
    this.correctStateColor = correctStateColor;
  }

  /// 隐身模式
  void setInStealthMode(bool inStealthMode) {
    this.inStealthMode = inStealthMode;
  }

}

class _PatternLockState extends State<PatternLock> {
  int _patternSize;

  List<Dot> _pattern;

  List<List<bool>> _patternDrawLookup;

  List<List<Dot>> _dotStates;

  // 当前位置
  double _left;
  double _top;

  @override
  void initState() {
    super.initState();
    //初始化状态
    debugPrint("初始化状态");
    setDotCount(widget.dotCount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: CustomPaint(
          size: Size(300, 300), //指定画布大小
          painter: MyPainter(
            dotCount: widget.dotCount,
            strokeWidth: widget._pathWidth,
            normalStateColor: const Color(0xFFCCCCCC),
            selectedStateColor: const Color(0xFF42A5F5),
            pathColor: const Color(0xFF1E88E5),
            dx: _left,
            dy: _top,
            dotStates: _dotStates,
            patternStates: _pattern,
            inStealthMode: widget.inStealthMode,
          ),
        ),
        //手指按下时会触发此回调
        onPanDown: (DragDownDetails e) {
          //打印手指按下的位置(相对于屏幕)
//          debugPrint("用户手指按下globalPosition：${e.globalPosition}");
          //打印手指按下的位置(相对于父组件)
//          debugPrint("用户手指按下localPosition：${e.localPosition}");
          _left = e.localPosition.dx;
          _top = e.localPosition.dy;
          if (widget.onStarted != null) {
            widget.onStarted();
          }
        },
        //手指滑动时会触发此回调
        onPanUpdate: (DragUpdateDetails e) {
          //用户手指滑动时，更新偏移，重新构建
          double x = _left + e.delta.dx;
          double y = _top + e.delta.dy;
          var dot = findDotInRange(x, y);
//          debugPrint("用户手指滑动：$dot x:$x y:$y");
          if(dot != null) {
            dot.select = true;
//            debugPrint("选中节点：$dot");
            _pattern.add(dot);
            if (widget.onProgress != null) {
              widget.onProgress(_pattern);
            }
          }
          setState(() {
            _left = x;
            _top = y;
          });
        },
        onPanEnd: (DragEndDetails e){
          //打印滑动结束时在x、y轴上的速度
          print(e.velocity);
          _onPanEnd();
        },
      )
    );
  }


  Dot findDotInRange(double x, double y) {
    List<Dot> list;
    Dot dot;
    Offset offset;
    for(int i = 0; i < _dotStates.length; i++) {
      list = _dotStates[i];
      for (int j = 0; j < list.length; j++) {
        dot = list[j];
        if(!dot.select) {
          offset = Offset(x-dot.offset.dx, y-dot.offset.dy);
          bool inRange = offset.distance <= dot._size;
          if(inRange) {
//            debugPrint("find：$offset dot:$dot inRange:$inRange");
            return dot;
          }
        }
      }
    }
    return null;
  }

  ///设置点的数量 dotCount * dotCount
  void setDotCount(int dotCount) {
    _patternSize = dotCount * dotCount;
    _pattern = new List<Dot>();

    _patternDrawLookup = new List<List<bool>>();

    _dotStates = new List<List<Dot>>();
    List<Dot> list;
    Dot dot;
    for (int i = 0; i < dotCount; i++) {
      list = List<Dot>();
      for (int j = 0; j < dotCount; j++) {
        dot = new Dot();
        dot.value = (i * dotCount + j + 1).toString();
        list.add(dot);
      }
      _dotStates.add(list);
    }
  }

  /// 手势结束
  void _onPanEnd() {
//      debugPrint("手势结束");
    widget.onComplete(_pattern);
    timerClear();
  }

  /// 定时恢复
  void timerClear() {
    const timeout = const Duration(milliseconds: 500);
    Timer(timeout, _onCleared);
  }

  /// 还原到初始状态
  void _onCleared() {
//    debugPrint("还原到初始状态");
    List<Dot> list;
    for (int i = 0; i < _dotStates.length; i++) {
      list = _dotStates[i];
      for (int j = 0; j < _dotStates[i].length; j++) {
        list[j].select = false;
      }
    }
    _pattern.clear();
    setState(() {
      _left = 0;
      _top = 0;
    });
    widget.onCleared();
  }
}

/// 自定义绘制
class MyPainter extends CustomPainter {

  Paint _normalPaint;

  Paint _selectedPaint;

  int dotCount;

  Color normalStateColor;

  Color selectedStateColor;

  List<List<Dot>> dotStates;

  List<Dot> patternStates;

  double dx;

  double dy;

  //线宽
  double strokeWidth;

  Color backgroundColor;

  Paint _pathPaint;

  Color pathColor;

  double totalAngle = 2 * pi;//360度角

  bool inStealthMode;

  bool isClipRect;

  Paint bgPaint;

  MyPainter({
    this.dotCount,
    this.normalStateColor,
    this.selectedStateColor,
    this.pathColor,
    this.dotStates,
    this.patternStates,
    this.dx,
    this.dy,
    this.backgroundColor,
    this.strokeWidth: 10.0,
    this.inStealthMode = false,
    this.isClipRect = true
  }) {
    _init();
  }

  /// 虚函数paint:
  /// Canvas: 2D画布
  /// Size：当前绘制区域大小
  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / dotCount; //每格平均宽度
    double eHeight = size.height / dotCount;
//    debugPrint("eWidth:$eWidth eHeight:$eHeight");//100 * 100

    //背景
    if(backgroundColor != null) {
      canvas.drawRect(Offset.zero & size, bgPaint);
    }

    //划手势路径
    if(!inStealthMode) {
      Offset p1;
      Path path = Path();
      if(patternStates.length != 0) {
        for(int k = 0; k < patternStates.length; k++) {
          p1 = patternStates[k].offset;
          if(k == 0) {
            path.moveTo(p1.dx, p1.dy);
          } else {
            path.lineTo(p1.dx, p1.dy);
          }
        }
        path.lineTo(dx, dy);
        if(isClipRect) {
          Rect clipRect = Offset.zero & size;
          canvas.clipRect(clipRect);
        }
        canvas.drawPath(path, _pathPaint);
      }
    }

    //画触摸点
    double radius = eWidth / 8; //宽度1/4为点半径
    List<Dot> list;
    Dot dot;
    Offset offset;
    Rect rect;
//    debugPrint("画触摸点");
    double selectedRadius = radius * 0.6;
    double selectedShadeRadius = radius * 2;
    double x, y;
    for(int i = 0; i < dotStates.length; i++) {
      list = dotStates[i];
      for(int j = 0; j < list.length; j++) {
        dot = list[j];
        offset = dot.offset;
        if(offset == null) {
          x = eWidth * j + eWidth / 2;
          y = eHeight * i + eHeight / 2;
          offset = Offset(x, y);
          dot.offset = offset;
          dot._size = radius * 2;
//          debugPrint("dot:$dot radius:$radius");
        }
        if(dot.select) {
          //选中状态下
          _selectedPaint.color = selectedStateColor;
          canvas.drawCircle(offset, selectedRadius, _selectedPaint);
          _selectedPaint.color = selectedStateColor.withAlpha(128);
          rect = Rect.fromCircle(center: offset, radius: selectedShadeRadius);
          canvas.drawArc(
              rect,
              0,
              totalAngle,
              false,
              _selectedPaint
          );
        } else {
          //正常状态下
          canvas.drawCircle(offset, radius, _normalPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _init() {
    //背景画笔
    if(backgroundColor != null) {
      bgPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill //填充
        ..color = backgroundColor; //背景为纸黄色
    }

    //画笔 画正常点
    _normalPaint = Paint()
      ..isAntiAlias = true //抗锯齿
      ..style = PaintingStyle.fill //填充
      ..color = normalStateColor;

    //画笔 画选中点
    _selectedPaint = Paint()
      ..isAntiAlias = true //抗锯齿
      ..style = PaintingStyle.fill //填充
//      ..strokeWidth = 20
      ..color = selectedStateColor; //背景为纸黄色

    //路径
    _pathPaint = Paint()
      ..isAntiAlias = true //抗锯齿
      ..style = PaintingStyle.stroke //填充
      ..color = pathColor;
    _pathPaint.strokeWidth = strokeWidth;
    // 线段之间的连接是半圆形的
    _pathPaint.strokeJoin = StrokeJoin.round;
  }

}

// 触摸的点
class Dot {
  double _size;
  Offset offset;
  bool select = false;
  String value;

  @override
  String toString() {
    return 'Dot{_size: $_size, offset: $offset, select: $select, value: $value}';
  }
}


enum StateCode {
  /// 手势路径太短
  patternShort,

  stroke,
}