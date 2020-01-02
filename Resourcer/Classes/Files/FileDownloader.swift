import UIKit
import Alamofire

public typealias fileDownloadHandler = (_ status: Bool, _ message: String) -> ()

public protocol FileDownloaderDelegate {
    func downloadFileAndSaveToDocuments(from url: String, with name: String, completion: @escaping fileDownloadHandler)
}

public extension FileDownloaderDelegate {
    
    func downloadFileAndSaveToDocuments(from url: String, with name: String, completion: @escaping fileDownloadHandler) {
        Alamofire.request(url).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)

        }).responseData{ (response) in

            if let data = response.result.value {
                
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                    return (false, "")
                }
                
                if !FileManager.default.fileExists(atPath: directory.path!) {
                    try? FileManager.default.createDirectory(atPath: directory.path!, withIntermediateDirectories: true, attributes: nil)
                }

                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent(name)
                do {
                    try data.write(to: fileURL)
                    completion(true, "File downloaded succesfully. You can find it at Device/Files App/On My iPhone/App/\(name).")

                } catch {
                    completion(false, "Failed to downlod file.")
                }
            }
        }
    }
}
