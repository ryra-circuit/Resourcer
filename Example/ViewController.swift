//
//  ViewController.swift
//  Example
//
//  Created by Dushan Saputhanthri on 3/1/20.
//  Copyright © 2020 Elegant Media Pvt Ltd. All rights reserved.
//

import UIKit
import Resourcer

class ViewController: UIViewController {

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var pickedVideoView: UIView!
    
    var mediaPickerController: MediaPickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}


extension ViewController: CommunicatorDelegate {
    
    func makeACall() {
        self.makeACall(numberString: "1234567890")
    }
    
    func openLink() {
        self.openUrl(urlString: "http://www.espncricinfo.com/")
    }
    
    func composeAnEmail() {
        let emailComposer = EmailComposer(vc: self, recepients: ["a@b.com", "c@d.com", "e@f.com"], subject: nil, body: nil, isHtml: false)
        self.composeAnEmail(composer: emailComposer)
    }
}


extension ViewController: GoogleMapsDirectionsDelegate {
    
    func testGoogleMapsDirections() {
        let plc = Place(_id: 0, name: "", address: "", latitude: 0.0, longitude: 0.0)
        self.manageGoogleMapOpeningResource(place: nil)
    }
}


extension ViewController: AppleMapsDirectionsDelegate {
    
    func testAppleMapsDirections() {
        self.showDirectionsOnAppleMapView(place: nil)
    }
}


extension ViewController: FileDownloaderDelegate {
    
    func downloadFile() {
        self.downloadFileAndSaveToDocuments(from: "http://medihub-backend.sandbox8.elegant-media.com/storage/audio/seethala.mp3", with: "temp_file_name", completion: { success, message, url in
            if success {
                print(message)
            } else {
                print(message)
            }
        })
    }
}

extension ViewController: MediaPickerControllerDelegate {
    
    // Show media picker using camera / photo libary
    func showMediaPickingServices(type: MediaPickerControllerType, source: UIImagePickerController.SourceType) {
        
        self.mediaPickerController = MediaPickerController(type: type, source: source, presentingViewController: self)
        self.mediaPickerController?.delegate = self
        
        self.mediaPickerController?.showMediaPicker()
    }
    
    // MARK: Did Pick image
    func mediaPickerControllerDidPickImage(image: UIImage, fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        
        let _newImageMediaItem = PickedMediaItem(fileType: MessageFileType.image.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: thumbnail, thumbnailData: thumbnailData, thumbnailUrl: thumbnailUrl)
        
        // Get and set / append received image
        // Set image
        self.pickedImageView.image = image
        
        // Do your other stuff here (Set / upload image)
        
    }
    
    // MARK: Did Pick video
    func mediaPickerControllerDidPickVideo(fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        
        let _newVideoMediaItem = PickedMediaItem(fileType: MessageFileType.video.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: thumbnail, thumbnailData: thumbnailData, thumbnailUrl: thumbnailUrl)
        
        // Get and set / append received video
        
        // Do your other stuff here (Set / upload video)
    }
}

