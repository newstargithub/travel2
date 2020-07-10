
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:share_extend/share_extend.dart';

class ShareUtil {

  /// 分享文本
  static shareText() {
    ShareExtend.share("share text", "text", sharePanelTitle: "android share panel title", subject: "share subject");
  }

  /// 分享图片 （例子中使用了一个image_picker的插件来实现图片的选择)
  static shareImageFromGallery() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    ShareExtend.share(f.path, "image");
  }

  /// 分享视频
  static shareVideo() async {
    File f = await ImagePicker.pickVideo(
        source: ImageSource.gallery);
    ShareExtend.share(f.path, "video");
  }

  /// 分享文件
  static shareFile() async {
    Directory dir = getDirectory();
    File testFile = new File("${dir.path}/flutter/test.txt");
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }


  /// 分享多图(借助了MultiImagePicker来多选获取图片图片，由于该库没有提供文件路径，因此demo里面先将图片保存为图片再调用分享)
  /*static shareMultipleImages() async {
    List<Asset> assetList = await MultiImagePicker.pickImages(maxImages: 5);
    var imageList = List<String>();
    for (var asset in assetList) {
      String path =
      await _writeByteToImageFile(await asset.getByteData(quality: 30));
      imageList.add(path);
    }
    ShareExtend.shareMultiple(imageList, "image",subject: "share muti image");
  }*/

  static Future<String> _writeByteToImageFile(ByteData byteData) async {
    Directory dir = getDirectory();
    File imageFile = new File(
        "${dir.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));
    return imageFile.path;
  }

  static getDirectory() async {
    return Platform.isAndroid
        ? StorageManager.externalStorageDirectory
        : StorageManager.appDocumentsDirectory;
  }

  /// 分享图片
  static void shareImage(File file) {
    ShareExtend.share(file.path, "image");
  }
}

