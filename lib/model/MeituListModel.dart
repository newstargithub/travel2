
import 'package:roll_demo/bean/Girl.dart';
import 'package:roll_demo/model/repository/GirlRepository.dart';
import 'package:roll_demo/ui/logic/net_pictures_page_logic.dart';

import 'ViewStateRefreshListModel.dart';

/// 妹子图数据模型
class MeituListModel extends ViewStateRefreshListModel<Girl> {
  /// 页面路径
  String path;

  NetPicturesPageLogic logic;

  MeituListModel(this.path) {
    logic = NetPicturesPageLogic(this);
  }

  @override
  Future<List<Girl>> loadData({int pageNum}) async {
    /// 加载妹子图列表
    List<Girl> data = await GirlRepository.fetchData(path, pageNum);
    return data;
  }

}