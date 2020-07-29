import 'package:intl/intl.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/generated/i18n.dart';

class CommonUtil {
  static bool isEmpty(String text) {
    return text == null || text.isEmpty;
  }

  static bool isEmptyList(List list) {
    return list == null || list.isEmpty;
  }

  static String formatDate(DateTime dateTime, {String pattern = "yyyy-MM-dd HH:mm:ss"}) {
    if(dateTime == null) {
      return null;
    }
    return DateFormat(pattern).format(dateTime);
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