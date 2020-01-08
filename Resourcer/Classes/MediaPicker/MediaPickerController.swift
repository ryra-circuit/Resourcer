//
//  MediaPickerController.swift
//  Copyright © 2019 ElegantMedia. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

public enum MediaFileType: String {
    case image, audio, video, file, custom
}

public enum MediaPickerControllerType {
    case imageOnly
    case videoOnly
    case imageAndVideo
}

public enum ImageFormat: String {
    case png, jpeg
}

public enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

@objc public protocol MediaPickerControllerDelegate {
    
    @objc optional func mediaPickerControllerDidPickImage(image: UIImage, fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
    @objc optional func mediaPickerControllerDidPickVideo(fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?)
}

open class MediaPickerController: NSObject {
    
    // MARK: - Public
    open weak var delegate: MediaPickerControllerDelegate?
    
    public init(type: MediaPickerControllerType, source: UIImagePickerController.SourceType, presentingViewController controller: UIViewController) {
        self.type = type
        self.source = source
        self.presentingController = controller
        self.mediaPicker = UIImagePickerController()
        super.init()
        self.mediaPicker.delegate = self
    }
    
    open func showMediaPicker() {
        self.mediaPicker.sourceType = self.source
        
        switch self.type {
        case .imageOnly:
            self.mediaPicker.mediaTypes = [kUTTypeImage as String]
        case .videoOnly:
            self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
        case .imageAndVideo:
            self.mediaPicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        }
        
        self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
    }
    
    open func show() {
        let actionSheet = self.optionsActionSheet
        self.presentingController.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Private
    fileprivate let presentingController: UIViewController
    fileprivate let type: MediaPickerControllerType
    fileprivate let source: UIImagePickerController.SourceType
    fileprivate let mediaPicker: UIImagePickerController
    
}

extension MediaPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss()
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            // Is Image
            let _image = info[.originalImage] as! UIImage
            let _orientationFixedImage = _image.fixedOrientation() ?? UIImage()
            
            let _url: URL = source == .photoLibrary ? info[.imageURL] as! URL : self.getURLForPickedTemporaryImage(image: _orientationFixedImage)!
            let chosenImage = _url
            let imageData = try! Data(contentsOf: chosenImage, options: [])
            
            let _thumbnail = _orientationFixedImage.generateThumbnailFromImage()
            let _thumbnailData = _thumbnail.convertImageToData(imageFormat: .jpeg)
            
            self.delegate?.mediaPickerControllerDidPickImage?(image: _orientationFixedImage, fileData: imageData, fileUrl: _url, thumbnail: _thumbnail, thumbnailData: _thumbnailData, thumbnailUrl: nil) // Does not send thumbnail url for sending image
        }
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            // Is Video
            let _url: URL = info[.mediaURL] as! URL
            let chosenVideo = info[.mediaURL] as! URL
            let videoData = try! Data(contentsOf: chosenVideo, options: [])
            
            let _thumbnail = _url.generateThumbnailFromVideo()
            let _thumbnailData = _thumbnail.convertImageToData(imageFormat: .jpeg)
            let _thumbnailUrl: URL = self.getURLForPickedTemporaryImage(image: _thumbnail)!
            
            self.delegate?.mediaPickerControllerDidPickVideo?(fileData: videoData, fileUrl: _url, thumbnail: _thumbnail, thumbnailData: _thumbnailData, thumbnailUrl: _thumbnailUrl)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss()
    }
    
    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func getURLForPickedTemporaryImage(image: UIImage) -> URL? {
        
        let (status, url) = image.saveTemporaryImageToDocumentDirectory(imageFormat: .jpeg, quality: .highest)
        
        switch status {
        case true:
            return url
        default:
            return nil
        }
    }
    
}

// MARK: - Private
private extension MediaPickerController {
    
    var optionsActionSheet: UIAlertController {
        let actionSheet = UIAlertController(title: Strings.Title, message: nil, preferredStyle: .actionSheet)
        
        self.addChooseExistingPhotoActionToSheet(actionSheet)
        self.addChooseExistingVideoActionToSheet(actionSheet)
        self.addChooseExistingMediaActionToSheet(actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.addTakePhotoActionToSheet(actionSheet)
            if self.type == .imageAndVideo {
                self.addTakeVideoActionToSheet(actionSheet)
            }
        }
        self.addCancelActionToSheet(actionSheet)
        return actionSheet
    }
    
    func addTakePhotoActionToSheet(_ actionSheet: UIAlertController) {
        let takePhotoAction = UIAlertAction(title: Strings.TakePhoto, style: .default) { (_) -> Void in
            self.mediaPicker.sourceType = .camera
            self.mediaPicker.mediaTypes = [kUTTypeImage as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
        actionSheet.addAction(takePhotoAction)
    }
    
    func addTakeVideoActionToSheet(_ actionSheet: UIAlertController) {
        let takeVideoAction = UIAlertAction(title: Strings.TakeVideo, style: .default) { (_) -> Void in
            self.mediaPicker.sourceType = .camera
            self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
        actionSheet.addAction(takeVideoAction)
    }
    
    func addChooseExistingPhotoActionToSheet(_ actionSheet: UIAlertController) {
        let chooseExistingPhotoAction = UIAlertAction(title: self.chooseExistingText, style: .default) { (_) -> Void in
            self.mediaPicker.sourceType = .photoLibrary
            self.mediaPicker.mediaTypes = [kUTTypeImage as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
        actionSheet.addAction(chooseExistingPhotoAction)
    }
    
    func addChooseExistingVideoActionToSheet(_ actionSheet: UIAlertController) {
        let chooseExistingVideoAction = UIAlertAction(title: self.chooseExistingText, style: .default) { (_) -> Void in
            self.mediaPicker.sourceType = .photoLibrary
            self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
        actionSheet.addAction(chooseExistingVideoAction)
    }
    
    func addChooseExistingMediaActionToSheet(_ actionSheet: UIAlertController) {
        let chooseExistingAction = UIAlertAction(title: self.chooseExistingText, style: .default) { (_) -> Void in
            self.mediaPicker.sourceType = .photoLibrary
            self.mediaPicker.mediaTypes = self.chooseExistingMediaTypes
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
        actionSheet.addAction(chooseExistingAction)
    }
    
    func addCancelActionToSheet(_ actionSheet: UIAlertController) {
        let cancel = Strings.Cancel
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true, completion: nil)
        }
    }
    
    var chooseExistingText: String {
            switch self.type {
            case .imageOnly: return Strings.ChoosePhoto
            case .videoOnly: return Strings.ChooseVideo
            case .imageAndVideo: return Strings.ChoosePhotoOrVideo
        }
    }
    
    var chooseExistingMediaTypes: [String] {
            switch self.type {
            case .imageOnly: return [kUTTypeImage as String]
            case .videoOnly: return [kUTTypeMovie as String]
            case .imageAndVideo: return [kUTTypeImage as String, kUTTypeMovie as String]
        }
    }
    
    // MARK: - Constants
    struct Strings {
        static let Title = NSLocalizedString("Attach", comment: "Title for a generic action sheet for picking media from the device.")
        static let ChoosePhoto = NSLocalizedString("Choose existing photo", comment: "Text for an option that lets the user choose an existing photo in a generic action sheet for picking media from the device.")
        static let ChooseVideo = NSLocalizedString("Choose existing video", comment: "Text for an option that lets the user choose an existing video in a generic action sheet for picking media from the device.")
        static let ChoosePhotoOrVideo = NSLocalizedString("Choose existing photo or video", comment: "Text for an option that lets the user choose an existing photo or video in a generic action sheet for picking media from the device.")
        static let TakePhoto = NSLocalizedString("Take a photo", comment: "Text for an option that lets the user take a picture with the device camera in a generic action sheet for picking media from the device.")
        static let TakeVideo = NSLocalizedString("Take a video", comment: "Text for an option that lets the user take a video with the device camera in a generic action sheet for picking media from the device.")
        static let Cancel = NSLocalizedString("Cancel", comment: "Text for the 'cancel' action in a generic action sheet for picking media from the device.")
    }
    
}


private extension URL {
    
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


private extension UIImage {
    
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
