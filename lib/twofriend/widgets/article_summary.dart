
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/res/styles.dart';
/// 帖子的概要信息
///
class ArticleSummary extends StatelessWidget {

  /// 标题
  final String title;
  /// 简要
  final String summary;
  /// 图片
  final String articleImage;

  const ArticleSummary({Key key, this.title, this.summary, this.articleImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(title, style: TextStyles.commonStyle()),
            Text(summary, style: TextStyles.commonStyle()),
          ],
        ),
        Image.network(articleImage),
      ],
    );
  }

}