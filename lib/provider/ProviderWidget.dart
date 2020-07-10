import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider封装类
///
/// 方便数据初始化
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model; //定义需要共享的数据模型，通过混入 ChangeNotifier 管理听众
  final Widget child; //不变的部分, 会传给builder

  //initState中调用
  final Function(T) onModelReady;

  //builder 函数可以直接获取到 model
  final Function(BuildContext context, T value, Widget child) builder;

  ProviderWidget({
    Key key,
    this.model,
    this.child,
    this.onModelReady,
    this.builder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProviderWidgetState<T>();
  }
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      builder: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
