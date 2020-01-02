import UIKit
import Alamofire

typealias fileDownloadHandler = (_ status: Bool, _ message: String) -> ()

protocol FileDownloaderDelegate {
    func downloadFileAndSaveToDocuments(from url: String, with name: String, completion: @escaping fileDownloadHandler)
}

extension FileDownloaderDelegate {
    
    func downloadFileAndSaveToDocuments(from url: String, with name: String, completion: @escaping fileDownloadHandler) {
        Alamofire.request(url).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            
        }).responseData{ (response) in
            
            if let data = response.result.value {
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent(name)
                do {
                    try data.write(to: fileURL)
                    completion(true, "File downloaded succesfully. You can find it at Device/Files App/On My iPhone/Cummins Power/\(name).")
                    
                } catch {
                    completion(false, "Failed to downlod file.")
                }
            }
        }
    }
}
