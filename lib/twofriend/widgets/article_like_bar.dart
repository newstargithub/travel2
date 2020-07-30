
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/res/styles.dart';

import '../like_num_model.dart';

/// 帖子文章的赞组件
///
/// 包括点赞组件 icon ，以及组件点击效果
/// 需要外部参数[articleId],文章id
class ArticleLikeBar extends StatelessWidget {

  /// 外部传入参数
  final String articleId;

  /// 构造函数
  const ArticleLikeBar({Key key, this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeNumModel = Provider.of<LikeNumModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.thumb_up, color: Colors.grey, size: 18),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                '${likeNumModel.getLikeNum(articleId)}',
                style: TextStyles.commonStyle(),
              ),
            ],
          ),
          onPressed: () => likeNumModel.like(articleId),
        ),
      ],
    );
  }

}