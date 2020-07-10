import 'package:intl/intl.dart';
import 'package:roll_demo/bean/Label.dart';

class CommonUtil {
  static bool isEmpty(String text) {
    return text == null || text.isEmpty;
  }

  static bool isEmptyList(List list) {
    return list == null || list.isEmpty;
  }

  static String formatDate(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }

  /// 是网络图片
  static bool isNetLink(String url) {
    return url != null &&
        (url.startsWith("http://") || url.startsWith("https://"));
  }

  static appendString(List<Label> labelList) {
    if(isEmptyList(labelList)) {
      return null;
    }
    StringBuffer sb = StringBuffer();
    for (var i = 0; i < labelList.length; i++) {
      if(i != 0) {
        sb.write(",");
      }
      sb.write(labelList[i].title);
    }
    return sb.toString();
  }

}