import UIKit
import AVFoundation
import MobileCoreServices

open class DocumentPickerController: NSObject {
    
    // MARK: - Private
    fileprivate let presentingController: UIViewController
    fileprivate var documentPicker: UIDocumentPickerViewController
    
    // MARK: - Public
    open weak var delegate: MediaPickerControllerDelegate?
    
    // MARK: - Init document picker
    public init(presentingViewController controller: UIViewController, types: [String], mode: UIDocumentPickerMode) {
        
        self.presentingController = controller
        self.documentPicker = UIDocumentPickerViewController(documentTypes: types, in: mode)
        super.init()
        
        self.documentPicker.delegate = self
    }
    
    // MARK: - Show document picker
    open func showDocumentPicker(presentingStyle: UIModalPresentationStyle, canSelectMultiple: Bool) {
        
        if #available(iOS 11.0, *) {
            self.documentPicker.allowsMultipleSelection = canSelectMultiple
        }
        
        self.documentPicker.modalPresentationStyle = presentingStyle
        
        // Present picker
        self.presentingController.present(self.documentPicker, animated: true, completion: nil)
    }
    
    // MARK: Dismiss presenting VC
    func dismiss() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true, completion: nil)
        }
    }
}

extension DocumentPickerController: UIDocumentPickerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let _url = url as URL
        
        self.delegate?.mediaPickerControllerDidPickDocument?(fileData: nil, fileUrl: _url, thumbnail: nil, thumbnailData: nil, thumbnailUrl: nil) // Send only file url
        
        self.dismiss()
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss()
    }
}

