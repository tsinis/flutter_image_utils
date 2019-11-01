import Flutter
import UIKit

var serialQueue: DispatchQueue?

public class SwiftFlutterImageUtilsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        serialQueue = DispatchQueue(label: "com.vanelizarov.flutter_image_utils.SerialQueue")
    
        let channel = FlutterMethodChannel(name: "flutter_image_utils", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterImageUtilsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        serialQueue?.sync {
            if call.method == "crop" {
                let args = call.arguments as! Dictionary<String, AnyObject>
                let bytes = args["bytes"] as! FlutterStandardTypedData
                let x = args["x"] as! CGFloat
                let y = args["y"] as! CGFloat
                let width = args["width"] as! CGFloat
                let height = args["height"] as! CGFloat
                let quality = args["quality"] as! Int
                
                let data = bytes.data
                
                guard let croppedData = ImageUtils.crop(
                    with: data,
                    x: x,
                    y: y,
                    width: width,
                    height: height,
                    quality: quality
                    ) else {
                        result(nil)
                        return
                }
                
                result(FlutterStandardTypedData(bytes: croppedData))
            } else if call.method == "resize" {
                let args = call.arguments as! Dictionary<String, AnyObject>
                let bytes = args["bytes"] as! FlutterStandardTypedData
                let destWidth = args["destWidth"] as! CGFloat
                let destHeight = args["destHeight"] as! CGFloat
                let quality = args["quality"] as! Int
                
                let data = bytes.data
                
                guard let resizedData = ImageUtils.resize(
                    with: data,
                    destWidth: destWidth,
                    destHeight: destHeight,
                    quality: quality
                    ) else {
                        result(nil)
                        return
                }
                
                result(FlutterStandardTypedData(bytes: resizedData))
            } else if call.method == "resizeToMax" {
                let args = call.arguments as! Dictionary<String, AnyObject>
                let bytes = args["bytes"] as! FlutterStandardTypedData
                let maxSize = args["maxSize"] as! CGFloat
                let quality = args["quality"] as! Int
                
                let data = bytes.data
                
                guard let resizedData = ImageUtils.resizeToMax(
                    with: data,
                    maxSize: maxSize,
                    quality: quality
                    ) else {
                        result(nil)
                        return
                }
                
                result(FlutterStandardTypedData(bytes: resizedData))
            } else if call.method == "rotate" {
                let args = call.arguments as! Dictionary<String, AnyObject>
                let bytes = args["bytes"] as! FlutterStandardTypedData
                let angle = args["angle"] as! Int
                let quality = args["quality"] as! Int
                
                let data = bytes.data
                
                guard let rotatedData = ImageUtils.rotate(
                    with: data,
                    angle: angle,
                    quality: quality
                    ) else {
                        result(nil)
                        return
                }
                
                result(FlutterStandardTypedData(bytes: rotatedData))
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
