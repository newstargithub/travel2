import 'package:flutter/material.dart';

import 'InfiniteGridView.dart';
import 'InfiniteListView.dart';

class TabHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TabHomeState();
  }
}

class TabHomeState extends State<TabHomeWidget>
    with SingleTickerProviderStateMixin {
  List tabs = ["新闻", "历史", "图片"];
  TabController _tabController;
  var _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: tabs.map((e) {
        // 创建3个Tab页内容
        if (e == "新闻") {
          return InfiniteListView();
        } else if (e == "历史") {
          return InfiniteGridView();
        }
        return Container(
          alignment: Alignment.center,
          child: Text(
            e,
            textScaleFactor: 5,
          ),
        );
      }).toList(),
      // TabBar和TabBarView的controller是同一个！
      controller: _tabController,
    );
  }

  _onTopItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }
}