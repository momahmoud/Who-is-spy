import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private static var channelRegistered = false

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    registerNotificationSettingsChannelIfNeeded()
  }

  private func registerNotificationSettingsChannelIfNeeded() {
    guard !SceneDelegate.channelRegistered,
          let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "com.fluxy.salfah/notification_settings",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "openAppSettings":
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
          result(
            FlutterError(
              code: "UNAVAILABLE",
              message: "Cannot open settings",
              details: nil
            )
          )
          return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    SceneDelegate.channelRegistered = true
  }
}
