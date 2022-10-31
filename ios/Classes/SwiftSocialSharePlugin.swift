import Flutter
import UIKit

public class SwiftSocialSharePlugin: NSObject, FlutterPlugin {

    var _result: FlutterResult?
    var _channel: FlutterMethodChannel
    var _dic: UIDocumentInteractionController?

    init(fromChannel channel: FlutterMethodChannel) {
        _channel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "social_share_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSocialSharePlugin(fromChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "shareToTwitterLink":
            guard let args = call.arguments else {
                result(false)
                break
            }
            if let myArgs = args as? [String: Any],
               let text = myArgs["text"] as? String,
               let url = myArgs["url"] as? String
            {
                if let twitterURL = URL(string: "twitter://") {
                    if UIApplication.shared.canOpenURL(twitterURL) {
                        twitterShare(text, url: url)
//                        result(nil)
                    } else {
                        let twitterLink = "itms-apps://itunes.apple.com/us/app/apple-store/id333903271"
                        if #available(iOS 10.0, *) {
                            if let url = URL(string: twitterLink) {
                                UIApplication.shared.open(url, options: [:]) { _ in
                                }
                            }
                        } else {
                            if let url = URL(string: twitterLink) {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        result(false)
                    }
                }
            } else {
                result(false)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func twitterShare(_ text: String,
                      url: String)
    {
        let shareString = "https://twitter.com/intent/tweet?text=\(text)&url=\(url)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let shareUrl = URL(string: shareString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(shareUrl, options: [:]) { success in
                    if success {
                        self._channel.invokeMethod("onSuccess", arguments: nil)
                        guard let result = self._result else {
                            return
                        }
                        result(true)
                    } else {
                        self._channel.invokeMethod("onCancel", arguments: nil)
                        guard let result = self._result else {
                            return
                        }
                        result(false)
                    }
                }
            } else {
                UIApplication.shared.openURL(shareUrl)
                _channel.invokeMethod("onSuccess", arguments: nil)
                guard let result = _result else {
                    return
                }
                result(true)
            }
        }
    }
}
