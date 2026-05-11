import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsApiKey") as? String,
      !apiKey.isEmpty,
      !apiKey.hasPrefix("$(")
    else {
      // Fail loudly so builds never "work" with a missing secret.
      fatalError("Missing GoogleMapsApiKey in Info.plist build settings.")
    }
    GMSServices.provideAPIKey(apiKey)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "mapme/config",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        guard call.method == "getFirebaseConfig" else {
          result(FlutterMethodNotImplemented)
          return
        }
        let bundle = Bundle.main
        result([
          "apiKey": bundle.object(forInfoDictionaryKey: "FirebaseApiKey") as? String ?? "",
          "appId": bundle.object(forInfoDictionaryKey: "FirebaseAppId") as? String ?? "",
          "messagingSenderId": bundle.object(forInfoDictionaryKey: "FirebaseMessagingSenderId") as? String ?? "",
          "projectId": bundle.object(forInfoDictionaryKey: "FirebaseProjectId") as? String ?? "",
          "authDomain": bundle.object(forInfoDictionaryKey: "FirebaseAuthDomain") as? String ?? "",
          "storageBucket": bundle.object(forInfoDictionaryKey: "FirebaseStorageBucket") as? String ?? "",
          "iosBundleId": bundle.object(forInfoDictionaryKey: "FirebaseIosBundleId") as? String ?? "",
        ])
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
