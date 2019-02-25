import Flutter
import UIKit

public class SwiftFlutterRtmpPublisherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_rtmp_publisher", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterRtmpPublisherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
