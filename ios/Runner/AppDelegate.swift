import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GMSServices.provideAPIKey("AIzaSyDidoNnBhOLEmIC-tlxcK16inb8Bzu-uxc")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        Messaging.messaging().apnsToken = deviceToken
        print("Token: \(deviceToken)")
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
}
