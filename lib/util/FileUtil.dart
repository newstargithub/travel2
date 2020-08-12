
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:roll_demo/model/repository/ApiStrategy.dart';
import 'package:roll_demo/net/storage_manager.dart';

class FileUtil {
  static FileUtil _instance;

  FileUtil._internal();

  static FileUtil getInstance() {
    if(_instance == null) {
      _instance = FileUtil._internal();
    }
    return _instance;
  }

  /// 获取应用文件保存目录
  Future<String> getSavePath(String endPath) async {
    var tempDir = StorageManager.appDocumentsDirectory;
    String path = tempDir.path + endPath;
    Directory directory = Directory(path);
    if(!directory.existsSync()) {
      //recursive: true所有不存在的目录都创建
      directory.createSync(recursive: true);
    }
    return directory.path;
  }

  /// 复制文件 oldPath-> newPath
  void copyFile(String oldPath, String newPath) {
    File file = File(oldPath);
    if(file.existsSync()) {
      file.copy(newPath);
    }
  }

  Future<List<String>> getDirChildren(String path) async {
    Directory directory = Directory(path);
    var childrenDir = directory.listSync();
    List<String> pathList = [];
    for(var item in childrenDir) {
      final filename = item.path.split("/").last;
      if(filename.contains(".")) {
        pathList.add(item.path);
      }
    }
    return pathList;
  }

  ///[assetPath] 例子 'images/'
  ///[assetName] 例子 '1.jpg'
  ///[filePath] 例子:'/myFile/'
  ///[fileName]  例子 'girl.jpg'
  /// 复制Asset文件到数据目录
  Future<String> copyAssetToFile(String assetPath, String assetName,
      String filePath, String fileName) async {
    String newPath = await FileUtil.getInstance().getSavePath(filePath);
    File file = File(newPath + fileName);
    if(await file.exists()) {
      var data = await rootBundle.load(assetPath + assetName);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes);
    }
    return newPath + fileName;
  }

  /// 下载文件
  void downloadFile(
      {String url,
        String filePath,
        String fileName,
        Function onComplete}) async {
    final path = await FileUtil.getInstance().getSavePath(filePath);
    var name = fileName ?? url.split("/").last;
    //执行网络下载
    ApiStrategy.getInstance().client.download(
      url,
      path + name,
      //下载进度
      onReceiveProgress: (int count, int total) {
        final downloadProgress = (count / total * 100).toInt();
        if(downloadProgress == 100) {
          if(onComplete != null) onComplete(path + name);
        }
      },
      options: Options(sendTimeout: 15 * 1000, receiveTimeout: 360 * 1000),
    );
  }

}
