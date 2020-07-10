import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Girl.dart';
import 'package:roll_demo/model/MeituListModel.dart';
import 'package:roll_demo/ui/page/image_page.dart';

class NetPicturesPageLogic {
  final MeituListModel _model;

  NetPicturesPageLogic(this._model);

  /*void getPhotos({
    int page = 1,
    int perPage = 20,
    CancelToken cancelToken,
  }) {
    ApiService.instance.getPhotos(
      success: (beans) {
        List<PhotoBean> datas = beans;
        if (datas.length == 0) {
          _model.loadingFlag = LoadingFlag.empty;
          _model.refreshController.footerMode.value = LoadStatus.noMore;
        } else {
          _model.loadingFlag = LoadingFlag.success;
          _model.photos.addAll(datas);
          _model.refreshController.loadComplete();
        }
        _model.refresh();
      },
      failed: (fail) {
        _model.loadingFlag = LoadingFlag.error;
        _model.refreshController?.footerMode?.value = LoadStatus.failed;
        _model.refresh();
      },
      error: (error) {
        debugPrint("错误:$error");
        _model.loadingFlag = LoadingFlag.error;
        _model.refreshController?.footerMode?.value = LoadStatus.failed;
        _model.refresh();
      },
      params: {
        "client_id":
            "7b77014ee1e5b9a2518420aa190db74fd82f81cd2cc5c6e03ced781b8205b80e",
        "page": "$page",
        "per_page": "$perPage"
      },
      token: cancelToken,
    );
  }

  void loadMorePhoto() {
    getPhotos(
      page: _model.list.length ~/ 20 + 1,
      cancelToken: _model.cancelToken,
    );
  }*/

  void onPictureTap(List<Girl> list, int index, BuildContext context) {
    final urls = list
        .map((photoBean) => photoBean.url)
        .toList();
    Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
      return ImagePage(
        imageUrls: urls,
        initialPageIndex: index,
        onSelect: (current) {
          final currentUrl = _model.list[current].url;
          Navigator.of(context).pop();
        },
      );
    }));
  }

}
