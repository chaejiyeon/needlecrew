import UIKit
import Flutter
import NaverThirdPartyLogin
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

 override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       var result = false

      if url.absoluteString.hasPrefix("kakao") {
          result = super.application(app, open: url, options: options)
      }

//       if url.absoluteString.hasPrefix("google") {
//           result = FirebaseApp.configure()
//       }

      if !result {
          result = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
      }

      // 2022/10/11 - flutter local notification setting
//       if #available(iOS 10.0, *) {
//        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//       }

      return result
   }

   override func application(
     _ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
     GeneratedPluginRegistrant.register(with: self)
     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
   }
}

