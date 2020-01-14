import UIKit
import Alamofire

public typealias fileDownloadHandler = (_ status: Bool, _ message: String,_ url: URL?) -> ()

var sessionManager: SessionManager = {
  let configuration = URLSessionConfiguration.default
  configuration.timeoutIntervalForRequest = 20
  return SessionManager(configuration: configuration)
}()

public protocol FileDownloaderDelegate {
    func downloadFileAndSaveToDocuments(from url: String, with name: String, config: URLSessionConfiguration, parameters: [String: Any], method: HTTPMethod, encoding: URLEncoding, headers: HTTPHeaders, timeout: Double, completion: @escaping fileDownloadHandler)
}

public extension FileDownloaderDelegate {
    
    func downloadFileAndSaveToDocuments(from url: String, with name: String, config: URLSessionConfiguration = .default, parameters: [String: Any] = [:], method: HTTPMethod = .get, encoding: URLEncoding = .default, headers: HTTPHeaders = [:], timeout: Double = 30, completion: @escaping fileDownloadHandler) {
        
        //make session manager and assign
        sessionManager = {
            let configuration = config
            configuration.timeoutIntervalForRequest = timeout
            return SessionManager(configuration: configuration)
        }()
        
        sessionManager.request(url,method: method, parameters: parameters, encoding: encoding, headers: headers).downloadProgress(queue: .main) { progress in
            print("Progress is \(progress.fractionCompleted)")
        }.responseData { response in
            
            switch response.result {
            case .success(let data):
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent(name)
                do {
                    try data.write(to: fileURL)
                    completion(true, "successfully written to \(fileURL.absoluteString)",fileURL)

                } catch {
                    completion(false, "Failed to write the file.", nil)
                }
            case .failure(let error):
                completion(false, "Failed to download file.)", nil)
            }
        }
    }
}
