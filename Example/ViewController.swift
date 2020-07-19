//
//  ViewController.swift
//  Copyright © 2020 RYRA Circuit. All rights reserved.
//

import UIKit
import Resourcer
import AVFoundation
import MobileCoreServices
import MessageUI

class ViewController: UIViewController, MediaPickerControllerDelegate {

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var pickedVideoView: UIView!
    
    var mediaPickerController: MediaPickerController?
    var documentPickerController: DocumentPickerController?
    var audioRecorderController: AudioRecorderController?
    
    var recordingSession: AVAudioSession?
    
    @IBOutlet weak var audioRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup audio recording session
        self.setupRecordingSession()
    }
    
}


// How to use communication services
extension ViewController: CommunicatorDelegate {
    
    func makeACall() {
        self.makeACall(numberString: "+61 456 000 001")
    }
    
    func openLink() {
        self.openUrl(urlString: "https://www.elegantmedia.com.au/")
    }
    
    func composeAnEmail() {
        let emailComposer = EmailComposer(vc: self, recepients: ["a@b.com", "c@d.com", "e@f.com"], subject: nil, body: nil, isHtml: false)
        self.composeAnEmail(composer: emailComposer)
    }
    
    func composeMessage() {
        let messageComposer = MessageComposer(vc: self, recepients: ["+61456000001", "+6476535601", "+3287656501"], body: nil)
        self.composeMessage(composer: messageComposer)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { () -> Void in

        }
    }
    
    func displayShareSheet() {
        let _shareText = "https://www.elegantmedia.com.au/"
        let _image = #imageLiteral(resourceName: "emlogo")
        
        self.displayShareSheet(vc: self, shareText: _shareText, image: _image)
    }
}


// How to use Google Map services
extension ViewController: GoogleMapsDirectionsDelegate {
    
    func testGoogleMapsDirections() {
        let plc = Place(_id: 0, name: "", address: "", latitude: 0.0, longitude: 0.0)
        self.manageGoogleMapOpeningResource(place: nil)
    }
}


// How to use Apple Map services
extension ViewController: AppleMapsDirectionsDelegate {
    
    func testAppleMapsDirections() {
        self.showDirectionsOnAppleMapView(place: nil)
    }
}


// How to use file services
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


// How to use media picker services
extension ViewController {
    
    // Action to pick media
    @IBAction func didTapOnMediaPicker(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            self.showMediaPickingServices(type: .imageOnly, source: .camera)
        case 2:
            self.showMediaPickingServices(type: .videoOnly, source: .camera)
        case 3:
            self.showMediaPickingServices(type: .imageOnly, source: .photoLibrary)
        case 4:
            self.showMediaPickingServices(type: .videoOnly, source: .photoLibrary)
        case 5:
            self.showMediaPickingServices(type: .imageAndVideo, source: .camera)
        case 6:
            self.showMediaPickingServices(type: .imageAndVideo, source: .savedPhotosAlbum)
        default:
            break
        }
    }
    
    // Show media picker using camera / photo libary
    func showMediaPickingServices(type: MediaPickerControllerType, source: UIImagePickerController.SourceType) {
        
        self.mediaPickerController = MediaPickerController(type: type, source: source, presentingViewController: self)
        self.mediaPickerController?.delegate = self
        
        self.mediaPickerController?.showMediaPicker()
    }
    
    // MARK: Did Pick image
    func mediaPickerControllerDidPickImage(image: UIImage, fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        
        let _newImageMediaItem = PickedMediaItem(fileType: MediaFileType.image.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: thumbnail, thumbnailData: thumbnailData, thumbnailUrl: thumbnailUrl)
        
        // Get and set / append received image
        // Set image
        self.pickedImageView.image = image
        
        // Do your other stuff here (Set / upload image)
        
    }
    
    // MARK: Did Pick video
    func mediaPickerControllerDidPickVideo(fileData: Data, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        
        let _newVideoMediaItem = PickedMediaItem(fileType: MediaFileType.video.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: thumbnail, thumbnailData: thumbnailData, thumbnailUrl: thumbnailUrl)
        
        // Get and set / append received video
        
        // Do your other stuff here (Set / upload video)
    }
}


// How to use document picker services
extension ViewController {
    
    // Action to pick document/s
    @IBAction func didTapOnDocumentPicker(_ sender: UIButton) {
        
        switch sender.tag {
        case 7:
            self.showDocumentPickingServices()
        default:
            break
        }
    }
    
    // Show document picker
    func showDocumentPickingServices() {
        
        let _types: [String] = [kUTTypePDF as String, kUTTypeText as String, kUTTypeRTF as String, kUTTypeSpreadsheet as String]
        
        self.documentPickerController = DocumentPickerController(presentingViewController: self, types: _types, mode: .import)
        self.documentPickerController?.delegate = self
        
        self.documentPickerController?.showDocumentPicker(presentingStyle: .formSheet, canSelectMultiple: false)
    }
    
    // MARK: Did Pick document
    func mediaPickerControllerDidPickDocument(fileData: Data?, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        
        let _newDocumentItem = PickedMediaItem(fileType: MediaFileType.document.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: thumbnail, thumbnailData: thumbnailData, thumbnailUrl: thumbnailUrl)
        
        // Get and set / append received document
        
        // Do your other stuff here (Set / upload document)
    }
}

// How to use audio recorder
extension ViewController {
    
    func setupRecordingSession() {
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .voiceChat)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startAudioRecordingService()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    // Start audio recording service
    func startAudioRecordingService() {

        self.audioRecorderController = AudioRecorderController(audioQuality: .medium)
        self.audioRecorderController?.delegate = self
        
        self.shouldStartAudioRecordingWithLongPressGesture()
    }
    
    func shouldStartAudioRecordingWithLongPressGesture() {
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recordAudioClip(_:)))
        longPressGestureRecognizer.minimumPressDuration = 1.0 // In Seconds
        
        audioRecordButton.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: Record Audio with long tap on button
    @objc func recordAudioClip(_ sender: UIGestureRecognizer) {
        
        switch sender.state {
        case .began:
            audioRecordButton.backgroundColor = .red
            audioRecordButton.setImage(#imageLiteral(resourceName: "micOrrange"), for: .normal)
            
            print("UILongPressGestureRecognizerStateBegan so start the recording voice here")
            
            //writing the function for start recording the voice here
            self.audioRecorderController?.startRecording()
            
        case .ended:
            audioRecordButton.backgroundColor = .white
            audioRecordButton.setImage(#imageLiteral(resourceName: "micBlue"), for: .normal)
            
            print("UILongPressGestureRecognizerStateEnded so stop the recording voice here")
            
            //writing the function for stop recording the voice here
            self.audioRecorderController?.finishRecording(success: true, url: nil)
            
        case .cancelled:
            audioRecordButton.backgroundColor = .white
            audioRecordButton.setImage(#imageLiteral(resourceName: "micBlue"), for: .normal)
            
            print("UILongPressGestureRecognizerStateCancelled so stop the recording voice here")
            
            //writing the function for stop recording the voice here
            self.audioRecorderController?.finishRecording(success: false, url: nil)
            
        default:
            break
        }
    }

    func mediaPickerControllerDidRecordAudio(fileData: Data?, fileUrl: URL) {

        let _newAudioItem = PickedMediaItem(fileType: MediaFileType.audio.rawValue, fileData: fileData, fileUrl: fileUrl, thumbnail: nil, thumbnailData: nil, thumbnailUrl: nil)

        // Get and set / append received audio
        
        // Do your other stuff here (Set / upload audio)

    }
    
    func mediaPickerControllerDidFailedToRecordAudio(error: Error) {
        
    }
}

