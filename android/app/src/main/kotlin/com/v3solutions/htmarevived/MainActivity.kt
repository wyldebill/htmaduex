package com.v3solutions.htmarevived

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mapme/config")
            .setMethodCallHandler { call, result ->
                if (call.method == "getFirebaseConfig") {
                    result.success(
                        mapOf(
                            "apiKey" to BuildConfig.FIREBASE_API_KEY,
                            "appId" to BuildConfig.FIREBASE_APP_ID,
                            "messagingSenderId" to BuildConfig.FIREBASE_MESSAGING_SENDER_ID,
                            "projectId" to BuildConfig.FIREBASE_PROJECT_ID,
                            "authDomain" to BuildConfig.FIREBASE_AUTH_DOMAIN,
                            "storageBucket" to BuildConfig.FIREBASE_STORAGE_BUCKET,
                            "iosBundleId" to "",
                        )
                    )
                } else {
                    result.notImplemented()
                }
            }
    }
}
