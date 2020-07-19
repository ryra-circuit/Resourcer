import UIKit
import AVFoundation
import MobileCoreServices

open class AudioRecorderController: NSObject {
    
    // MARK: - Private
    fileprivate var recordingSession: AVAudioSession?
    fileprivate var audioRecorder: AVAudioRecorder?
    
    fileprivate var audioQuality: AVAudioQuality
    
    fileprivate var audioFileUrl: URL?
    
    // MARK: - Public
    open weak var delegate: MediaPickerControllerDelegate?
    
    // MARK: - Init audio recorder
    public init(audioQuality: AVAudioQuality) {
        
        self.audioQuality = audioQuality
        super.init()
    }
    
    //MARK: Start recording audio clip
    open func startRecording() {
        
        // Get random string to save file with a name in document directory
        let randomString = NSUUID().uuidString
        self.audioFileUrl = getDocumentsDirectory().appendingPathComponent("\(randomString).mp3")

        // As MP3
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEGLayer3),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: audioQuality.rawValue
        ]

        do {
            if let _audioFileUrl = self.audioFileUrl {
                audioRecorder = try AVAudioRecorder(url: _audioFileUrl, settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
            } else {
                self.finishRecording(success: false, url: nil)
            }
        } catch {
            // Nothing will be sent here if did not start recording
            //self.finishRecording(success: false, url: nil)
        }
    }
    
    
    //MARK: Stop recording audio clip
    open func finishRecording(success: Bool, url: URL?) {
        audioRecorder?.stop()
        audioRecorder = nil

        if success {
            
            guard let _url = self.audioFileUrl else {
                // Pass error if failed to find audio file path
                let _error = RSError.failedToFindRecordedAudioPath
                self.delegate?.mediaPickerControllerDidFailedToRecordAudio!(error: _error)
                return
            }
            
            // Pass success if sucessfully recorded the audio
            self.delegate?.mediaPickerControllerDidRecordAudio?(fileData: nil, fileUrl: _url) // Send only file url
            
        } else {
            // Pass error if failed to record audio
            let _error = RSError.failedToRecordAudio
            self.delegate?.mediaPickerControllerDidFailedToRecordAudio!(error: _error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension AudioRecorderController: AVAudioRecorderDelegate {
    
    // MARK: - AVAudioRecorderDelegate
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            self.finishRecording(success: false, url: nil)
        }
    }
}

