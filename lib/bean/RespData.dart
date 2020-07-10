
import 'IRespData.dart';

class RespData implements IRespData {
  int errorCode = 0;
  String errorMsg;
  dynamic data;

  RespData({this.errorCode, this.errorMsg, this.data});

  bool get success => errorCode == 0;

  @override
  String toString() {
    return 'RespData{data: $data, status: $errorCode, message: $errorMsg}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['data'] = this.data;
    return data;
  }

  factory RespData.fromJson(Map<String, dynamic> map){
    return RespData(
        errorCode: map['errorCode'],
        errorMsg: map['errorMsg'],
        data: map['data'],
    );
  }
}