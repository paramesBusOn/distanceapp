import UIKit
import Flutter
import GoogleMaps
import flutter_background_service_ios


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"

        GMSServices.provideAPIKey("AIzaSyAdvVumVzr7teF3UDRchglwonf_vjvXtZo")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
