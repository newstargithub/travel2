/// View接口
abstract class IMvpView {

  /// 展示Toast
  void showToast(String text);

  /// 显示Progress
  void showProgress();

  /// 关闭Progress
  void closeProgress();
}

/// 主持者
abstract class IPresenter extends ILifecycle {}

abstract class ILifecycle {
  /// 初始化状态
  void initState();
  void didChangeDependencies();
  void didUpdateWidgets<W>(W oldWidget);
  /// 处于非活动状态
  void deactivate();
  /// 销毁
  void dispose();
}