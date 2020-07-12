
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';

import '../../BottomSheetAction.dart';
import '../../store_select_text_item.dart';
/// 日记的选地址组件
///
/// 包括选中组件 ，以及组件点击效果
/// 需要外部参数[location],地址
class DiarySelectLocation extends StatelessWidget {

  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return StoreSelectTextItem(
      textAlign: TextAlign.end,
      title: S.of(context).address,
      content: model.location,
      onTap: () {
        _onTapSelectAddress(context);
      },
    );
  }

  /// 选择地址
  void _onTapSelectAddress(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    NavigatorUtils.pushResult(context, ADDRESS_SELECT_PAGE, (result) {
      PoiSearch poi = result;
      String address = poi.provinceName +
          " " +
          poi.cityName +
          " " +
          poi.adName +
          " " +
          poi.title;
      model.setAddress(address);
    });
  }

}
