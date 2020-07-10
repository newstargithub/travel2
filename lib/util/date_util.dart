import 'package:intl/intl.dart';
import 'package:roll_demo/util/conmon_util.dart';

class DateUtil {

  /// 格式化日志
  static String formatDate(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    return dateTime.toIso8601String();
  }

  static String formatUpdateDate(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    var dateTimeNow = DateTime.now();
    if(dateTimeNow.year == dateTime.year) {
      if(dateTimeNow.month == dateTime.month && dateTimeNow.day == dateTime.day) {
        return DateFormat("HH:mm").format(dateTime);
      }
      return DateFormat("MM月dd日 HH:mm").format(dateTime);
    } else {
      return DateFormat("yyyy年MM月dd日 HH:mm").format(dateTime);
    }
  }


  static String formatYearAndMonth(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    return DateFormat("yyyy年MM月").format(dateTime);
  }

  static getWeekday(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    String weekday;
    switch(dateTime.weekday) {
      case DateTime.monday:
        weekday = "一";
        break;
      case DateTime.thursday:
        weekday = "二";
        break;
      case DateTime.wednesday:
        weekday = "三";
        break;
      case DateTime.tuesday:
        weekday = "四";
        break;
      case DateTime.friday:
        weekday = "五";
        break;
      case DateTime.saturday:
        weekday = "六";
        break;
      default: weekday = "日";
        break;
    }
    return "星期$weekday";
  }

  /// 凌晨:3:00--6:00早晨:6:00---8:00 上午:8:00--11:00中午:11:00--13:00 下午:13:00--17:00傍晚:17:00--19:00晚上:19:00--23:00深夜:23:00--3:00
  static getTimeQuantum(DateTime dateTime) {
    if(dateTime == null) {
      return null;
    }
    String result;
    var hour = dateTime.hour;
    if(3 <= hour && hour < 6) {
      result = "凌晨";
    } else if(6 <= hour && hour < 9) {
      result = "早晨";
    } else if(9 <= hour && hour < 11) {
      result = "上午";
    } else if(11 <= hour && hour < 13) {
      result = "中午";
    } else if(13 <= hour && hour < 17) {
      result = "下午";
    } else if(17 <= hour && hour < 19) {
      result = "傍晚";
    } else if(19 <= hour && hour < 23) {
      result = "晚上";
    } else {
      result = "深夜";
    }
    return result;
  }

  static DateTime parse(String formattedString) {
    if(CommonUtil.isEmpty(formattedString)) {
      return null;
    }
    return DateTime.parse(formattedString);
  }

}