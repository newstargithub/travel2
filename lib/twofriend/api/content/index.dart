
import 'package:roll_demo/twofriend/api/user/api_user_info_index.dart';
import 'package:roll_demo/twofriend/struct/content_detail.dart';
import 'package:roll_demo/twofriend/struct/content_list_ret_info.dart';
import 'package:roll_demo/twofriend/struct/user_info.dart';

class ApiContentIndex {

  /// 根据内容id拉取内容详情
  static StructContentDetail getOneById(String id) {
    StructContentDetail detailInfo = StructContentDetail(
        '1001',
        'hello test',
        'summary',
        'detail info ${id}',
        '1001',
        1,
        2,
        'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png'
    );
    UserInfoStruct userInfo = ApiUserInfoIndex.getOneById(detailInfo.uid);
    return StructContentDetail(
        detailInfo.id, detailInfo.title,
        detailInfo.summary, detailInfo.detailInfo,
        detailInfo.uid, detailInfo.likeNum, detailInfo.commentNum,
        detailInfo.articleImage, userInfo: userInfo
    );
  }

  /// 获取首页推荐的内容列表
  StructApiContentListRetInfo getRecommendList([lastId = null]) {
    if(lastId != null) {
      List<StructContentDetail> dataList = [
        StructContentDetail('1001',
            'hello test',
            'summary',
            'detail info 1',
            '1001',
            1,
            2,
            'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png'),
        StructContentDetail('1001',
            'hello test',
            'summary',
            'detail info 2',
            '1001',
            1,
            2,
            'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png'),
      ];
      return StructApiContentListRetInfo(
          0,
          'success',
          false,
          '2001',
          dataList
      );
    } else {
      List<StructContentDetail> dataList =  [
        StructContentDetail('1001',
            'hello test',
            'summary',
            'detail info 1',
            '1001',
            1,
            2,
            'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png'),
        StructContentDetail('1001',
            'hello test',
            'summary',
            'detail info 2',
            '1001',
            1,
            2,
            'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png'),
      ];
      return StructApiContentListRetInfo(
          0,
          'success',
          true,
          '1010',
          dataList
      );
    }
  }

  /// 获取关注人的内容列表
  List<UserInfoStruct> getFollowList() {
    return [
      UserInfoStruct(
          'hello test',
          'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png',
          '1001'),
      UserInfoStruct(
          'hello test',
          'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png',
          '1001'),
    ];
  }


}