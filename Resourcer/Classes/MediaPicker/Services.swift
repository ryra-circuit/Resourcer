import UIKit
import AVFoundation
import MobileCoreServices

//MARK: Media types
public enum MediaFileType: Int {
    case image = 1
    case audio = 2
    case video = 3
    case document = 4
    case custom = 0
}


//MARK: Media picker types
public enum MediaPickerControllerType {
    case imageOnly
    case videoOnly
    case imageAndVideo
    case document
}


//MARK: Image format/extension
public enum ImageFormat: String {
    case png, jpeg
}


//MARK: JPEG Image quality
public enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}


//MARK: Services
@objc public protocol MediaPickerControllerDelegate {
    
    //MARK: Pick media services
    @objc optional func mediaPickerControllerDidPickImage(image: UIImage, fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
    @objc optional func mediaPickerControllerDidPickVideo(fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
    @objc optional func mediaPickerControllerDidPickAudio(fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
    @objc optional func mediaPickerControllerDidFailedToPickMedia(error: Error)
    
    
    //MARK: Pick document services
    @objc optional func mediaPickerControllerDidPickDocument(fileData: Data?, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
    @objc optional func mediaPickerControllerDidFailedToPickDocument(error: Error)
    
    
    //MARK: Record audio services
    @objc optional func mediaPickerControllerDidRecordAudio(fileData: Data?, fileUrl: URL)
    @objc optional func mediaPickerControllerDidFailedToRecordAudio(error: Error)
}


//MARK: Extensions

public extension URL {
    
    // MARK: - Thumbnail for video
    func generateThumbnailFromVideo() -> UIImage {
        let asset = AVAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = 0
        let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: imageRef!)
        return thumbnail
    }
    
}


public extension UIImage {
    
    // MARK: - Thumbnail for image
    func generateThumbnailFromImage() -> UIImage {

        guard let imageData = self.pngData() else { return UIImage() }

        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary

        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return UIImage() }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return UIImage() }
        return UIImage(cgImage: imageReference)

    }
    
    // Save image to document directory
    func saveTemporaryImageToDocumentDirectory(imageFormat: ImageFormat = .png, quality: JPEGQuality = .highest) -> (Bool, URL?) {
        
        let pngData = self.pngData()
        let jpgData = self.jpegData(compressionQuality: quality.rawValue)
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return (false, nil)
        }
        
        if !FileManager.default.fileExists(atPath: directory.path!) {
            try? FileManager.default.createDirectory(atPath: directory.path!, withIntermediateDirectories: true, attributes: nil)
        }
        
        do {
            let randomString = NSUUID().uuidString
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(randomString + ".\(imageFormat.rawValue)")
            
            if let _data = imageFormat == .png ? pngData : jpgData {
                do {
                    try _data.write(to: fileURL)
                    return (true, fileURL)
                    
                } catch {
                    print("Error saving image")
                    return (false, nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return (false, nil)
    }
    
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    func convertImageToData(imageFormat: ImageFormat = .png, quality: JPEGQuality = .highest) -> Data? {
        
        let pngData = self.pngData()
        let jpgData = self.jpegData(compressionQuality: quality.rawValue)
        
        switch imageFormat {
        case .png:
            return pngData
        default:
            return jpgData
        }
    }
}
