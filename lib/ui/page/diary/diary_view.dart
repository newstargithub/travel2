import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/diary/item_text.dart';
import 'package:roll_demo/widget/common/IconLabel.dart';

import '../image_page.dart';
import 'item_image.dart';

/// 展示一篇日志的View
class DiaryView extends StatelessWidget {
  Diary bean;

  DiaryView(this.bean);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).backgroundColor;
    return Container(
      color: bean.color != null ? Color(bean.color) : backgroundColor,
      child: CustomScrollView(
        // 根据子组件的总长度来设置长度
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int position) {
              //创建列表项
              var item = bean.richTextData.list[position];
              if (item.isText) {
                // 文本编辑框
                return ItemText(position, item, (index, controller) {});
              } else if (item.isImage) {
                // 图片
                return ItemImage(item, isEdit: false);
              } else {
                //尺寸限制类容器
                return SizedBox();
              }
            }, childCount: bean.richTextData.list.length //列表项个数
                ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Dimens.edit_horizontal_padding,
                  vertical: Dimens.edit_vertical_padding),
              child: Column(
                children: <Widget>[
                  Gaps.vGap10,
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconLabel(
                          icon: Icon(Icons.access_time),
                          label: Text(bean.date ?? ""),
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
                        label: Text(bean.weather ?? ""),
                      ),
                    ],
                  ),
                  Gaps.vGap10,
                  IconLabel(
                    icon: Icon(Icons.location_on),
                    label: Expanded(
                      flex: 1,
                      child: Text(bean.location ?? ""),
                    ),
                  ),
                  Gaps.vGap10,
                  IconLabel(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 4),
                      child: Icon(Icons.bookmark_border),
                    ),
                    label: Expanded(
                      child: Wrap(
                        direction: Axis.horizontal,
                        // 主轴方向子widget的间距
                        spacing: 10,
                        children: List.generate(
                            bean.labelList != null ? bean.labelList.length : 0,
                            (index) => OutlineButton(
                                  child: Text(bean.labelList[index].title),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  onPressed: () {},
                                )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}
