
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/twofriend/struct/article_summary.dart';
import 'package:roll_demo/twofriend/struct/content_detail.dart';
import 'package:roll_demo/twofriend/struct/user_info.dart';
import 'package:roll_demo/twofriend/widgets/article_card.dart';
import 'package:roll_demo/twofriend/widgets/banner_info.dart';

/// 首页列表信息
///
/// 展示banner和帖子信息
class HomePage extends StatelessWidget {

  /// banner 地址信息
  final String bannerImage =
      'https://img.089t.com/content/20200227/osbbw9upeelfqnxnwt0glcht.jpg';
  /// 帖子标题
  final UserInfoStruct userInfo = UserInfoStruct('flutter',
      'https://i.pinimg.com/originals/1f/00/27/1f0027a3a80f470bcfa5de596507f9f4.png', "1");
  /// 帖子概要描述信息
  final StructContentDetail articleInfo = StructContentDetail('1001',
      'hello test',
      'summary',
      'detail info 2',
      '1001',
      1,
      2,
      'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          BannerInfo(bannerImage: bannerImage),
          ArticleCard(
            userInfo: userInfo,
            articleInfo: articleInfo,
          ),
        ],
      ),
    );
  }

}