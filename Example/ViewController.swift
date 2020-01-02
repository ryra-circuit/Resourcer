//
//  ViewController.swift
//  Example
//
//  Created by Dushan Saputhanthri on 3/1/20.
//  Copyright © 2020 Elegant Media Pvt Ltd. All rights reserved.
//

import UIKit
import Resourcer

class ViewController: UIViewController, CommunicatorDelegate, GoogleMapsDirectionsDelegate, AppleMapsDirectionsDelegate, FileDownloaderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func testGoogleMapsDirections() {
        self.manageGoogleMapOpeningResource(place: nil)
    }
    
    func testAppleMapsDirections() {
        self.showDirectionsOnAppleMapView(place: nil)
    }
    
    func makeACall() {
        self.makeACall(numberString: "1234567890")
    }
    
    func openLink() {
        self.openUrl(urlString: "http://www.espncricinfo.com/")
    }
    
    func composeAnEmail() {
        //let emailComposer = EmailComposer(vc: self, recepients: ["a@b.com", "c@d.com"], subject: nil, body: nil, isHtml: false)
        //self.composeAnEmail(composer: emailComposer)
    }
    
    func downloadFile() {
        self.downloadFileAndSaveToDocuments(from: "http://medihub-backend.sandbox8.elegant-media.com/storage/audio/seethala.mp3", with: "temp_file_name", completion: { success, message in
            if success {
                print(message)
            } else {
                print(message)
            }
        })
    }
}

