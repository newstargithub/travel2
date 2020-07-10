package com.halo.roll_demo;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
/**
 * 网络请求插件安卓实现
 */
/*class FlutterPluginNetworkPlugin implements MethodChannel.MethodCallHandler {

    //注册器，通常为MainActivity
    public final PluginRegistry.Registrar registrar;

    //注册插件
    public static void registerWith(PluginRegistry.Registrar registrar) {
        //注册方法通道
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin_network");
        //初始化插件实例，绑定方法通道，并注册方法通道回调函数
        channel.setMethodCallHandler(new FlutterCrashPlugin(registrar));
    }

    private FlutterPluginNetworkPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        //响应doRequest方法调用
        if (call.method.equals("doRequest")) {
            //取出query参数和URL
            HashMap param = call.argument("param");
            String url = call.argument("url");
            doRequest(url,param,result);
        } else {
            //其他方法未实现
            result.notImplemented();
        }
    }

    //处理网络调用
    void doRequest(String url, HashMap<String, String> param, final Result result) {
        //初始化网络调用实例
        OkHttpClient client = new OkHttpClient();
        //加工URL及query参数
        HttpUrl.Builder urlBuilder = HttpUrl.parse(url).newBuilder();
        for (String key : param.keySet()) {
            String value = param.get(key);
            urlBuilder.addQueryParameter(key,value);
        }
        //加入自定义通用参数
        urlBuilder.addQueryParameter("ppp", "yyyy");
        String requestUrl = urlBuilder.build().toString();

        //发起网络调用
        final Request request = new Request.Builder().url(requestUrl).build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, final IOException e) {
                //切换至主线程，通知Dart调用失败
                registrar.activity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.error("Error", e.toString(), null);
                    }
                });
            }

            @Override
            public void onResponse(Call call, final Response response) throws IOException {
                //取出响应数据
                final String content = response.body().string();
                //切换至主线程，响应Dart调用
                registrar.activity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(content);
                    }
                });
            }
        });
    }

}*/
