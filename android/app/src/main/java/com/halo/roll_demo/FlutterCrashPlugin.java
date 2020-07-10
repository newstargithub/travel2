package com.halo.roll_demo;

import com.tencent.bugly.crashreport.CrashReport;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Author: zx
 * Date: 2019/11/11
 * Description: 初始化插件实例、绑定方法通道，并在方法通道中先后为
 * setup 与 postException 提供 Bugly Android SDK 的实现版本
 */
public class FlutterCrashPlugin implements MethodChannel.MethodCallHandler {

    //注册器，通常为MainActivity
    public final PluginRegistry.Registrar registrar;

    //注册插件
    public static void registerWith(PluginRegistry.Registrar registrar) {
        //注册方法通道
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_crash_plugin");
        //初始化插件实例，绑定方法通道，并注册方法通道回调函数
        channel.setMethodCallHandler(new FlutterCrashPlugin(registrar));
    }

    private FlutterCrashPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("setUp")) {
            //Bugly SDK初始化方法
            String appID = call.argument("app_id");
            CrashReport.initCrashReport(registrar.activity().getApplicationContext(), appID, true);
            result.success(0);
        } else if (call.method.equals("postException")) {
            //获取Bugly数据上报所需要的各个参数信息
            String message = call.argument("crash_message");
            String detail = call.argument("crash_detail");
            //调用Bugly数据上报接口
            CrashReport.postException(4, "Flutter Exception", message, detail, null);
            result.success(0);
        } else {
            result.notImplemented();
        }
    }
}
