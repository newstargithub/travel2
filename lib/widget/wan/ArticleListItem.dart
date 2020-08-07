import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oktoast/oktoast.dart';
import 'package:roll_demo/bean/Article.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/FavouriteModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/helper/DialogHelper.dart';
import 'package:roll_demo/ui/helper/FavouriteAnimation.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/resource_mananger.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/ScaleAnimatedSwitcher.dart';

/// 文章条目
class ArticleItemWidget extends StatelessWidget {
  Article bean;

  ArticleItemWidget(this.bean);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: ImageHelper.randomUrl(
                        key: bean.author, width: 24, height: 24),
                    placeholder: (context, url) =>
                        ImageHelper.placeHolder(width: 24, height: 24),
                    errorWidget: (context, url, error) =>
                        ImageHelper.error(width: 24, height: 24),
                    width: 24,
                    height: 24,
                    fit: BoxFit.fill,
                  )),
                  Gaps.hGap5,
                  Expanded(
                    child: Text(
                      bean.author,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  Text(
                    bean.niceDate,
                    style: Theme.of(context).textTheme.body2,
                  )
                ],
              ),
              _buildContent(context, bean),
              // Align 组件可以调整子组件的位置，并且可以根据子组件的宽高来确定自身的的宽高
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ArticleFavouriteWidget(bean),
              ),
            ],
          )),
      onPressed: () {
        pushNamed(context, ARTICLE_DETAIL, arguments:bean);
      },
    );
  }

  _buildContent(BuildContext context, Article bean) {
    if (bean.envelopePic.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: ArticleTitleWidget(bean.title),
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ArticleTitleWidget(bean.title),
                Gaps.hGap5,
                Text(
                  bean.desc,
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Gaps.hGap5,
          CachedNetworkImage(
            imageUrl: bean.envelopePic,
            placeholder: (context, url) =>
                ImageHelper.placeHolder(width: 60, height: 60),
            errorWidget: (context, url, error) =>
                ImageHelper.error(width: 60, height: 60),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ],
      );
    }
  }
}

///文章标题 解析html标签
class ArticleTitleWidget extends StatelessWidget {
  final String title;

  ArticleTitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: EdgeInsets.symmetric(vertical: 5),
      useRichText: false,
      data: title,
      defaultTextStyle: Theme.of(context).textTheme.subtitle,
    );
  }
}

/// 收藏按钮
class ArticleFavouriteWidget extends StatelessWidget {
  final Article article;

  ArticleFavouriteWidget(this.article);

  @override
  Widget build(BuildContext context) {
    ///位移动画的tag
    var uniqueKey = UniqueKey();
    return ProviderWidget<FavouriteModel>(
      key: uniqueKey,
      model: FavouriteModel(article),
      builder: (_, model, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque, //否则padding的区域点击无效
          onTap: () async {
            if (!model.loading) {
              addFavourites(context, model, uniqueKey);
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //todo Hero?
            child: Hero(
                tag: uniqueKey,
                child: ScaleAnimatedSwitcher(
                  child:
//                    model.loading ?
                      //创建一个尽可能小的框。
//                    SizedBox.shrink() :
                      Icon(
                          model.article.collect
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.redAccent[100]),
                )),
          ),
        );
      },
    );
  }

  /// 添加或取消收藏
  void addFavourites(BuildContext context, FavouriteModel model, UniqueKey tag,
      {playAnim: true}) async {
    await model.collect();
    if (model.unAuthorized) {
      //提示登录框
      var result = await DialogHelper.showLoginDialog(context);
      if (result) {
        var success = Navigator.pushNamed(context, LOGIN_PAGE);
        if (success ?? false) {
          addFavourites(context, model, tag);
        }
      }
    } else if (model.error) {
      //失败
      showToast(S.of(context).loadFail);
    } else {
      if (playAnim) {
        ///接口调用成功播放动画
        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return FavouriteAnimationWidget(
            tag: tag,
            add: model.article.collect,
          );
        }));
      }
    }
  }
}
