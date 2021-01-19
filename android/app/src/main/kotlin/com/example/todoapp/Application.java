//package com.example.todoapp;
//
//import io.flutter.app.FlutterApplication;
//import io.flutter.plugin.common.PluginRegistry;
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
//import io.flutter.plugins.GeneratedPluginRegistrant;
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
//
//public class Application extends FlutterApplication implements PluginRegistrantCallback {
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//    }
//
//    @Override
//    public void registerWith(PluginRegistry registry) {
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
//    }
//}
//package com.example.todoapp;
//
//import io.flutter.app.FlutterApplication;
//import io.flutter.plugin.common.PluginRegistry;
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
//import io.flutter.plugins.GeneratedPluginRegistrant;
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
//
//public class Application extends FlutterApplication implements PluginRegistrantCallback {
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//    }
//
//    @Override
//    public void registerWith(PluginRegistry registry) {
//        io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(registry);
//    }
//}
// ...
package com.example.todoapp;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService;
import io.flutter.embedding.engine.FlutterEngine;

public class Application extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
//        GeneratedPluginRegistrant.registerWith(registry);
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }
}
