
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 收藏动画
class FavouriteAnimationWidget extends StatefulWidget {

  /// Hero动画的唯一标识
  final Object tag;

  /// true 添加到收藏,false从收藏移除
  final bool add;

  FavouriteAnimationWidget({this.tag, this.add});

  @override
  _FavouriteAnimationWidgetState createState() =>
      _FavouriteAnimationWidgetState();

}

class _FavouriteAnimationWidgetState extends State<FavouriteAnimationWidget> {
  bool playing = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        playing = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: FlareActor(
        "assets/animations/like.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: widget.add ? 'like' : 'unLike',
        shouldClip: false,
        isPaused: !playing,
        callback: (name) {
          Navigator.pop(context);
          playing = false;
        },
      ),
    );
  }
}

/// Dialog下使用Hero动画的路由
class HeroDialogRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  HeroDialogRoute({this.builder}): super();

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black12;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);

}