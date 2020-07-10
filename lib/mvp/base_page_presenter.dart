
import 'package:dio/dio.dart';
import 'package:roll_demo/mvp/mvps.dart';
import 'package:roll_demo/mvp/mvps.dart';

class BasePagePresenter<V extends IMvpView> extends IPresenter {

  V view;
  CancelToken _cancelToken;

  @override
  void deactivate() {
  }

  @override
  void didChangeDependencies() {
  }

  @override
  void didUpdateWidgets<W>(W oldWidget) {
  }

  @override
  void dispose() {
    /// 销毁时，将请求取消
    if(!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  @override
  void initState() {
  }

}