//
//  ImageUtils.swift
//  flutter_image_utils
//
//  Created by vanya elizarov on 20.06.2019.
//

import Foundation
import CoreGraphics

class ImageUtils {
    public static func crop(with data: Data, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, quality: Int, format: Int) -> Data? {
        guard let img = UIImage(data: data) else { return nil }
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let ref = img.cgImage else { return nil }
        guard let croppedRef = ref.cropping(to: rect) else { return nil }
        
        let croppedImg = UIImage(cgImage: croppedRef)
        return uiImageToData(image: croppedImg, format: format, quality: quality)
    }
    
    public static func resize(with data: Data, destWidth: CGFloat, destHeight: CGFloat, quality: Int, format: Int) -> Data? {
        guard let img = UIImage(data: data) else { return nil }
        
        let widthRatio = destWidth  / img.size.width
        let heightRatio = destHeight / img.size.height
        
        var destSize: CGSize
        
        if widthRatio > heightRatio {
            destSize = CGSize(width: img.size.width * heightRatio, height: img.size.height * heightRatio)
        } else {
            destSize = CGSize(width: img.size.width * widthRatio, height: img.size.height * widthRatio)
        }
        
        let destRect = CGRect(x: 0, y: 0, width: destSize.width, height: destSize.height)
        
        UIGraphicsBeginImageContextWithOptions(destSize, false, 1.0)
        img.draw(in: destRect)
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return uiImageToData(image: resizedImg!, format: format, quality: quality)
    }
    
    public static func resizeToMax(with data: Data, maxSize: CGFloat, quality: Int, format: Int) -> Data? {
        guard let img = UIImage(data: data) else { return nil }
        
        var nextWidth = CGFloat(maxSize)
        var nextHeight = CGFloat(maxSize)
        
        if (img.size.width > img.size.height) {
            nextHeight = img.size.height * CGFloat(maxSize) / img.size.width;
        } else if (img.size.height > img.size.width) {
            nextWidth = img.size.width * CGFloat(maxSize) / img.size.height;
        }
        
        return ImageUtils.resize(with: data, destWidth: nextWidth, destHeight: nextHeight, quality: quality, format: format)
    }
    
    public static func rotate(with data: Data, angle: Int, quality: Int, format: Int) -> Data? {
        guard let img = UIImage(data: data) else { return nil }
        
        let radians = CGFloat(angle) * .pi / 180
        var newSize = CGRect(origin: CGPoint.zero, size: img.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .size
        
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        let destRect = CGRect(x: -img.size.width / 2, y: -img.size.height / 2, width: img.size.width, height: img.size.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        img.draw(in: destRect)
        
        let rotatedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return uiImageToData(image: rotatedImg!, format: format, quality: quality)
    }
    
    private static func uiImageToData(image: UIImage, format: Int, quality: Int) -> Data? {
        var result: Data?
        
        if format == 0 { // jpeg
            result = image.jpegData(compressionQuality: CGFloat(quality) / 100)
        } else { // png
            result = image.pngData()
        }
        
        return result
    }
}
