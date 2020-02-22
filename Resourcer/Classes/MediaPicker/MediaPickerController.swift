import UIKit
import AVFoundation
import MobileCoreServices

open class MediaPickerController: NSObject {
    
    // MARK: - Private
    fileprivate let presentingController: UIViewController
    fileprivate let type: MediaPickerControllerType
    fileprivate let source: UIImagePickerController.SourceType
    fileprivate let mediaPicker: UIImagePickerController
    
    // MARK: - Public
    open weak var delegate: MediaPickerControllerDelegate?
    
    // MARK: - Init media picker
    public init(type: MediaPickerControllerType, source: UIImagePickerController.SourceType, presentingViewController controller: UIViewController) {
        
        self.type = type
        self.source = source
        self.presentingController = controller
        self.mediaPicker = UIImagePickerController()
        super.init()
        
        self.mediaPicker.delegate = self
    }
    
    // MARK: - Show media picker
    open func showMediaPicker() {
        
        self.mediaPicker.sourceType = self.source
        
        switch self.type {
        case .imageOnly:
            self.mediaPicker.mediaTypes = [kUTTypeImage as String]
        case .videoOnly:
            self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
        case .imageAndVideo:
            self.mediaPicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        default:
            break
        }
        
        // Present picker
        self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
    }
    
    // MARK: Dismiss presenting VC
    func dismiss() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true, completion: nil)
        }
    }
}

extension MediaPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
        
        self.dismiss()
        
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
