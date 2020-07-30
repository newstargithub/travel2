import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/res/styles.dart';

import '../like_num_model.dart';

/// 帖子文章的赞组件
///
/// 包括点赞组件 icon ，以及组件点击效果
/// 需要外部参数[likeNum],点赞数量
/// [articleId] 帖子的内容
class SingleLikeBar extends StatelessWidget {
  /// 帖子id
  final String articleId;

  /// like num
  final int likeNum;

  const SingleLikeBar({Key key, this.articleId, this.likeNum})
      : super(key: key);

  /// 返回组件信息
  @override
  Widget build(BuildContext context) {
    final likeNumModel = Provider.of<LikeNumModel>(context);
    // Container 的目的是限制 FlatButton 的大小，避免 FlatButton 产生一些 margin 引起布局问题
    return Container(
      width: 50,
      child: FlatButton(
          onPressed: () => likeNumModel.like(articleId),
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Icon(Icons.thumb_up, color: Colors.grey, size: 36),
              Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                '${likeNumModel.getLikeNum(articleId, likeNum)}',
                style: TextStyles.commonStyle(),
              ),
            ],
          )),
    );
  }
}
