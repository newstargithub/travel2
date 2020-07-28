
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:roll_demo/util/dialog_util.dart';

/// 用于未登录等权限不够,需要跳转授权页面

/// 页面状态枚举类
enum ViewState {
  idle,
  loading, //加载中
  empty, //暂无数据
  error, //加载出错
  unAuthorized
}
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

// 定义需要共享的数据模型，通过混入 ChangeNotifier 管理听众
// 我们在资源封装类中使用 mixin 混入了 ChangeNotifier
// 使用了一个 Dart 的 with 关键词，这个用法是表示 ViewStateModel 可以直接调用 ChangeNotifier 的方法
class ViewStateModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 当前的页面状态,默认为idle,可在viewModel的构造方法中指定;
  ViewState _viewState;

  /// 构造方法
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  ViewStateModel({ViewState viewState}) : _viewState = viewState ?? ViewState.idle;

  // 读方法
  ViewState get viewState => _viewState;

  // 写方法
  set viewState(ViewState viewState) {
    this._viewState = viewState;
    //通过 ChangeNotifier 通知监听方
    notifyListeners();
  }

  /// 出错时的message
  String _errorMessage;

  String get errorMessage => _errorMessage;

  void initData() {

  }

  void setBusy(bool value) {
    _errorMessage = null;
    viewState = value ? ViewState.loading : ViewState.idle;
  }

  void setError(String message) {
    _errorMessage = message;
    viewState = ViewState.error;
  }

  void setEmpty() {
    _errorMessage = null;
    viewState = ViewState.empty;
  }

  void setUnAuthorized() {
    _errorMessage = null;
    viewState = ViewState.unAuthorized;
  }

  @override
  void notifyListeners() {
    if(!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _errorMessage: $_errorMessage}';
  }

  /// Handle Error and Exception 捕获异常
  ///
  /// 统一处理子类的异常情况
  /// [e],有可能是Error,也有可能是Exception.所以需要判断处理
  /// [s] 为堆栈信息
  void handleCatch(e, s) {
    // DioError的判断,理论不应该拿进来,增强了代码耦合性,抽取为时组件时.应移除
    if (e is DioError && e.error is UnAuthorizedException) {
      setUnAuthorized();
    } else {
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      setError(e is Error ? e.toString() : e.message);
    }
  }

  /// 以下变量是为了代码书写方便,加入的变量.严格意义上讲,并不严谨
  bool get loading => viewState == ViewState.loading;
  bool get error => viewState == ViewState.error;
  bool get empty => viewState == ViewState.empty;
  bool get unAuthorized => viewState == ViewState.unAuthorized;

}


/// 列表加载Model
abstract class ViewStateLoadModel<T> extends ViewStateModel {
  /// 数据
  T _data;

  /// 第一次进入页面loading
  initData() async {
    setBusy(true);
    await refresh(init: true);
  }

  //下拉刷新
  refresh({bool init = false}) async {
    try {
      T data = await loadData();
      if(data == null) {
        setEmpty();
      } else {
        _data = data;
        if(init) {
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
      }
    } catch (e, s) {
      handleCatch(e, s);
    }
  }

  /// 加载数据
  Future<T> loadData();
}


/// 列表加载Model
abstract class ViewStateListModel<T> extends ViewStateModel {
  /// 列表数据
  List<T> list = [];

  /// 第一次进入页面loading
  Future initData() async {
    setBusy(true);
    await refresh(init: true);
  }

  //下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if(data == null || data.isEmpty) {
        setEmpty();
      } else {
        list = data;
        if(init) {
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
      }
    } catch (e, s) {
      handleCatch(e, s);
    }
  }

  /// 加载数据
  Future<List<T>> loadData();

}
