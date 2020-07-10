
arb 文件是 JSON 格式的配置，用来存放文案标识符和文案翻译的键值对。

###国际化
MaterialApp 初始化时，为其设置了支持国际化的两个重要参数，
即 localizationsDelegates 与 supportedLocales。
前者为应用的翻译回调，而后者则为应用所支持的语言地区属性。


###接入数据上报服务
对于一个应用而言，接入数据上报服务的过程，总体上可以分为两个步骤：
1.初始化 Bugly SDK；
2.使用数据上报接口。

出过的错
2020-01-10 15:53:14.760 9151-9260/com.halo.memoir I/authErrLog:                                    鉴权错误信息
2020-01-10 15:53:14.760 9151-9260/com.halo.memoir I/authErrLog: ================================================================================
2020-01-10 15:53:14.760 9151-9260/com.halo.memoir I/authErrLog: |SHA1Package:02:71:19:B6:F6:9D:08:D7:59:6A:6B:40:E0:B4:D6:15:55:B4:7C:BF:com.ha|
2020-01-10 15:53:14.760 9151-9260/com.halo.memoir I/authErrLog: |lo.memoir                                                                     |
2020-01-10 15:53:14.760 9151-9260/com.halo.memoir I/authErrLog: |key:9b7bba47cab06470f4cc9eb894bf1e28                                          |
2020-01-10 15:53:14.761 9151-9260/com.halo.memoir I/authErrLog: |csid:4f4b59a06f414ddcb37746f145107d93                                         |
2020-01-10 15:53:14.761 9151-9260/com.halo.memoir I/authErrLog: |gsid:011131176088157864279424100034739923951                                  |
2020-01-10 15:53:14.761 9151-9260/com.halo.memoir I/authErrLog: |json:{"info":"INVALID_USER_SCODE","infocode":"10008","status":"0","sec_code_de|
2020-01-10 15:53:14.761 9151-9260/com.halo.memoir I/authErrLog: |bug":"4b2ee94cbecc38b7100635c07663fae3","key":"9b7bba47cab06470f4cc9eb894bf1e2|
2020-01-10 15:53:14.762 9151-9260/com.halo.memoir I/authErrLog: |8","sec_code":"4b2ee94cbecc38b7100635c07663fae3"}                             |
2020-01-10 15:53:14.762 9151-9260/com.halo.memoir I/authErrLog:
2020-01-10 15:53:14.762 9151-9260/com.halo.memoir I/authErrLog: 请在高德开放平台官网中搜索"INVALID_USER_SCODE"相关内容进行解决
2020-01-10 15:53:14.762 9151-9260/com.halo.memoir I/authErrLog: ================================================================================

flutter_amap_location_plugin 1.0.2
1.Apply ApiKey
Android
manifestPlaceholders = [
             LOCATION_APP_KEY : "xxxxxx", /// amap ApiKey
         ]
IOS
FlutterAmapLocationPlugin.setApiKey("xxx");

2.Add Dependency
dependencies:
  flutter_amap_location_plugin: ^1.0.0

3.Use
//启动客户端,这里设置ios端的精度小一点
    FlutterAmapLocationPlugin.startup(
      AMapLocationOption(
        iosOption: IosAMapLocationOption(
          locatingWithReGeocode: true,
          desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters,
        ),
      ),
    );

//注意这里关闭
FlutterAmapLocationPlugin.shutdown();

//Get Location Once定位一次
AMapLocation location =
        await FlutterAmapLocationPlugin.getLocation();
    print(
        "location = ${location.longitude},${location.latitude}，${location.address}");