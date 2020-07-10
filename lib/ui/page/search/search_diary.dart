
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/ui/page/search/search_model.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/dialog_util.dart';
import 'package:roll_demo/widget/SearchBar.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/widget/app/history_item.dart';

class SearchDiaryPage extends StatefulWidget {

  final String title;
  //搜索内容
  final String searchContent;

  SearchDiaryPage({Key key, this.title, this.searchContent}) : super(key: key);

  @override
  _SearchDiaryState createState() => _SearchDiaryState();
}

class _SearchDiaryState extends State<SearchDiaryPage> {

  ScrollController _controller = new ScrollController(keepScrollOffset: true);
  //是否显示“返回到顶部”按钮
  bool showToTopBtn = false;

  FocusNode _node;

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      print(_controller.offset); //打印滚动位置
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
    _node = FocusNode(debugLabel: 'SearchBar');
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchModel>(
      model: SearchModel(widget.searchContent),
      onModelReady: (model) {
        /// 搜索所有历史记录
        model.initData();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: SearchBar(
            inputText: widget.searchContent,
            hintText: "搜索关键字",
            onPressed: (text) {
              _search(text, context);
            },
            focusNode: _node,
          ),
          body: _buildBody(context, model),
          floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画， 控制跳转滚动位置
                _controller.animateTo(.0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease
                );
              }
          ),
        );
      },
    );
  }

  /// 搜索关键字
  Future _search(String text, BuildContext context) async {
    debugPrint("搜索关键字: $text");
    _node.unfocus();
    var searchModel = Provider.of<SearchModel>(context);
    await searchModel.search(text);
  }

  _buildBody(BuildContext context, SearchModel model) {
    Widget divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Divider(color: Colors.grey.shade400, height: 0.5,),
    );
    if(model.loading) {
      debugPrint("加载中");
      return ViewStateLoadingWidget();
    } else if(model.error) {
      debugPrint("搜索出错");
      return ViewStateWidget(
          message: model.errorMessage, onPressed: model.initData);
    } else if(model.empty) {
      debugPrint("搜索为空");
      return ViewStateWidget.empty(
          message: S.of(context).empty,
          onPressed: model.initData);
    } else {
      var list = model.list;
      debugPrint("历史记录：$list");
      return Column(children: <Widget>[
//              ListTile(title:Text("列表头")),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index){
              return divider;
            },
            itemBuilder: (BuildContext context, int index) {
              var item = list[index];
              var showDateHeader;
              if(index == 0) {
                showDateHeader = true;
              } else {
                Diary pre = list[index - 1];
                debugPrint("");
                showDateHeader = pre != null && item.yearAndMonth != pre.yearAndMonth;
              }
              return HistoryItem(bean: item,
                showDateHeader: showDateHeader,
              );
            },
            controller: _controller,
//                  itemExtent: 50.0, //列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
            itemCount: list.length,
          ),
        ),
      ]);
    }
  }

}