import 'dart:collection';

import 'package:flutter/material.dart';

// 能绑定InheritedWidget与依赖它的子孙组件的依赖关系，
// 并且当InheritedWidget数据发生变化时，可以自动更新依赖的子孙组件！
// 一个通用的InheritedWidget，保存任何需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({@required this.data, Widget child}) : super(child: child);

  //共享状态使用泛型
  final T data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

// 该方法用于在Dart中获取模板类型
Type _typeOf<T>() => T;

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final T data;

  ChangeNotifierProvider({
    Key key,
    this.data,
    this.child,
  });

  //定义一个便捷方法，方便子树中的widget获取共享数据
  //添加一个listen参数，表示是否建立依赖关系
  static T of<T>(BuildContext context,{bool listener}) {
    final type = _typeOf<InheritedProvider<T>>();
    //子树获取共享数据
    final provider =
    listener ? context.inheritFromWidgetOfExactType(type) as InheritedProvider<T>
    : context.ancestorInheritedElementForWidgetOfExactType(type) as InheritedProvider<T>;
    return provider.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

/// 定义一个Item类，用于表示商品信息
class Item {
  Item(this.price, this.count);

  double price;
  int count;
}

/// 定义一个保存购物车内商品数据的CartModel类
class CartModel extends ChangeNotifier {
  // 用于保存购物车中商品列表
  final List<Item> _items = [];

  // 购物车中商品的总价
  double get totalPrice => _items.fold(0, (value, item) {
        return value + item.price * item.count;
      });

  // 禁止改变购物车里的商品信息
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}

/// CartModel即要跨组件共享的model类。最后我们构建示例页面：
class ProviderRoute extends StatefulWidget {
  @override
  _ProviderRouteState createState() {
    return _ProviderRouteState();
  }
}

class _ProviderRouteState extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
          data: CartModel(),
          child: Builder(
            builder: (context) {
              return Column(
                children: <Widget>[
                  /*Builder(builder: (context) {
                    var cart = ChangeNotifierProvider.of<CartModel>(context);
                    return Text("总价: ${cart.totalPrice}");
                  }),*/
                  Consumer<CartModel>(
                    builder: (context, cart)=> Text("总价: ${cart.totalPrice}")
                  ),
                  Builder(builder: (context) {
                    print("RaisedButton build"); //在后面优化部分会用到
                    return RaisedButton(
                      onPressed: () {
                        //给购物车中添加商品，添加后总价会更新
                        // listen 设为false，不建立依赖关系
                        ChangeNotifierProvider.of<CartModel>(context, listener: false)
                            .add(Item(20.0, 1));
                      },
                      child: Text("添加商品"),
                    );
                  }),
                ],
              );
            },
          )),
    );
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    Key key,
    @required this.builder,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  final Widget child;

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context), //自动获取Model
    );
  }
}
