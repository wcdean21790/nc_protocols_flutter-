import UIKit
import Flutter
import OneSignal

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize OneSignal
    OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
    OneSignal.initWithLaunchOptions(launchOptions)
    OneSignal.setAppId("a06e33e4-84d5-405f-9ab2-4c15e5654056")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
