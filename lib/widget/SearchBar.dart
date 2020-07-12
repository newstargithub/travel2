import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/util/image_util.dart';

/// 搜索TapBar
class SearchBar extends StatefulWidget implements PreferredSizeWidget {


  const SearchBar({
    Key key,
    this.backgroundColor,
    this.inputText: "",
    this.hintText: "",
    this.backImage: "assets/image/ic_back_black.png",
    this.onPressed,
    this.focusNode,
  }) : super(key: key);

  final Color backgroundColor;
  final String backImage;
  final String hintText;
  final String inputText;
  final Function(String) onPressed;
  final FocusNode focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  SystemUiOverlayStyle overlayStyle;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.inputText;
    if(widget.inputText != null) {
      // 保持光标在最后
      _controller.selection = TextSelection.fromPosition(
          TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.inputText.length
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    Color backgroundColor = widget.backgroundColor
        ?? appBarTheme.color
        ?? themeData.primaryColor;
    overlayStyle =
        ThemeData.estimateBrightnessForColor(backgroundColor) ==
                Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          //在State里引用Widget的属性
          color: backgroundColor,
          child: SafeArea(
            child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.maybePop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            widget.backImage,
                            color: getColor(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: themeData.dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: TextField(
                          //是否自动对焦
                          autofocus: false,
                          controller: _controller,
                          focusNode: widget.focusNode,
                          //最大行数
                          maxLines: 1,
                          //解决hintText不居中与光标位置不一致
                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 6.0, left: -8.0, right: -16.0),
                            border: InputBorder.none,
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 8.0),
                              child: loadAssetImage("order/order_search"),
                            ),
                            hintText: widget.hintText,
                            hintStyle: TextStyles.textGrayC14,
                            suffixIcon: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 8.0, bottom: 8.0),
                                child: loadAssetImage("order/order_delete"),
                              ),
                              onTap: () {
                                _controller.text = "";
                              },
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, style: BorderStyle.none),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 32,
                      width: 48.0,
                      margin: const EdgeInsets.only(left: 8.0, right: 16.0),
                      child: FlatButton(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          onPressed: () {
                            widget.onPressed(_controller.text);
                          },
                          child: Text("搜索", maxLines: 1),
                          color: Colours.app_main,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          )),
                    )
                  ],
                )),
          ),
        ));
  }

  Color getColor() {
    Color color = overlayStyle == SystemUiOverlayStyle.light ? Colors.white : Colours.text_dark;
    return color;
  }
}
