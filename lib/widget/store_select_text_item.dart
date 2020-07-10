import 'package:flutter/material.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/util/image_util.dart';
///点击编辑项
class StoreSelectTextItem extends StatelessWidget {
  GestureTapCallback onTap;

  String title;

  String content;

  TextAlign textAlign;

  TextStyle style;

  StoreSelectTextItem(
      { Key key,
        this.onTap,
        @required this.title,
        this.content = "",
        this.textAlign = TextAlign.start,
        this.style}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.only(right: 8.0, left: 16.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: Divider.createBorderSide(
                    context, color: Colours.line, width: 0.6)
            )
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyles.textSmall,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                child: Text(content,
                  maxLines: 2,
                  textAlign: textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: style ?? TextStyles.textMiddle,
                ),
              ),
            ),
            loadAssetImage("ic_arrow_right",
              height: 16.0,
              width: 16.0,)
          ],
        ),
      ),
    );
  }

}