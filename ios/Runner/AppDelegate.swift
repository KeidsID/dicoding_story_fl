import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Restricted Google Maps API key
    // Please notice if this key still can be used on other apps
    GMSServices.provideAPIKey("AIzaSyDVlWW9LW3Sz7_4tMQDb8jR1EBoQLH0zeA")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
