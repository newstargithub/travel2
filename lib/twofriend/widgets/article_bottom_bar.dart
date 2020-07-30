
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/res/resources.dart';

class ArticleBottomBar extends StatelessWidget{
  final String nickname;
  final String headerImage;
  final int commentNum;

  const ArticleBottomBar({Key key, this.nickname, this.headerImage, this.commentNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(nickname, style: TextStyles.commonStyle(),),
        Icon(Icons.comment, color: Colors.grey, size: 18),
        Padding(padding: EdgeInsets.only(left: 10)),
        FlatButton(
          child: Text('$commentNum', style: TextStyles.commonStyle()),
          onPressed: null,
        ),
      ],
    );
  }

}