
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/MyButton.dart';
import 'package:roll_demo/widget/SearchBar.dart';

///选择地址
class AddressSelectPage extends StatefulWidget {
  @override
  _AddressSelectPageState createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> {
  
  List<PoiSearch> _list = [];
  int _index = 0;
  ScrollController _controller = new ScrollController();
  AMap2DController _aMap2DController;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Flutter2dAMap.setApiKey(Constant.map_api_key);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SearchBar(
        hintText: "搜索地址",
        onPressed: (text){
          _controller.animateTo(0.0, duration: Duration(milliseconds: 10), curve: Curves.ease);
          _index = 0;
          if (_aMap2DController != null){
            _aMap2DController.search(text);
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: AMap2DView(
              onPoiSearched: (result){
                _controller.animateTo(0.0, duration: Duration(milliseconds: 10), curve: Curves.ease);
                _index = 0;
                _list = result;
                setState(() {

                });
              },
              onAMap2DViewCreated: (controller){
                _aMap2DController = controller;
              },
            ),
          ),
          Expanded(
            flex: 11,
            child: 
//            _list.isEmpty ? 
//              Container(
//                alignment: Alignment.center,
//                child: CircularProgressIndicator(),
//              ) : 
            ListView.separated(
                controller: _controller,
                shrinkWrap: true,
                itemCount: _list.length,
                separatorBuilder: (_, index) {
                  return Divider(height: 0.6);
                },
                itemBuilder: (_, index){
                  return InkWell(
                    onTap: (){
                      _index = index;
                      if (_aMap2DController != null){
                        _aMap2DController.move(_list[index].latitude, _list[index].longitude);
                      }
                      setState(() {
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 50.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _list[index].provinceName + " " +
                                  _list[index].cityName + " " +
                                  _list[index].adName + " " +
                                  _list[index].title,
                            ),
                          ),
                          Opacity(
                              opacity: _index == index ? 1 : 0,
                              child: Icon(Icons.done, color: Colors.blue)
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
          SafeArea(
            child: MyButton(
              onPressed: (){
                NavigatorUtils.goBackWithParams(context, _list[_index]);
              },
              text: "确认选择地址",
            ),
          )
        ],
      ),
    );
  }
}
