
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/common/IconLabel.dart';

/// 日记额外信息的展示组件
///
/// 包括天气，地址
/// 需要外部参数[date],时间
class DiaryExtraInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.edit_horizontal_padding,
          vertical: Dimens.edit_vertical_padding
      ),
      child: Column(
        children: <Widget>[
          Gaps.vGap10,
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: IconLabel(
                  icon: Icon(Icons.access_time),
                  label: Text(model.date?? ""),
                ),
              ),
              IconLabel(
                icon: Icon(Icons.wb_cloudy),
                /*icon: ImageLoader.loadAssetImage(
                    weatherName2IconMap[model.weather?? "fine"],
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    )*/
                label: Text(model.weather?? ""),
              ),
            ],
          ),
          Gaps.vGap10,
          IconLabel(
            icon: Icon(Icons.location_on),
            label: Expanded(
              flex: 1,
              child: Text(model.location?? ""),
            ),
          ),
          Gaps.vGap10,
          IconLabel(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Icon(Icons.bookmark_border),
            ),
            label: Expanded(
              child: Wrap(
                direction: Axis.horizontal,
                // 主轴方向子widget的间距
                spacing: 10,
                children: List.generate(
                    model.labelList != null ? model.labelList.length : 0,
                        (index) => OutlineButton(
                      child: Text(model.labelList[index].title),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      //()=> setState() or markNeedsBuild() called during build
                      onPressed: ()=> _goSearch(context, model.labelList[index].title),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 去搜索
  _goSearch(BuildContext context, String labelTitle) {
    NavigatorUtils.pushNamed(context, SEARCH_PAGE, arguments: labelTitle);
  }

}