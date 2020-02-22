import UIKit

public struct PickedMediaItem {

    public var fileType: String
    public var fileUrl: URL
    public var fileData: Data?
    public var thumbnail: UIImage?
    public var thumbnailData: Data?
    public var thumbnailUrl: URL?

    public init(fileType: String, fileData: Data?, fileUrl: URL, thumbnail: UIImage?, thumbnailData: Data?, thumbnailUrl: URL?) {
        self.fileType = fileType
        self.fileData = fileData
        self.fileUrl = fileUrl
        self.thumbnail = thumbnail
        self.thumbnailData = thumbnailData
        self.thumbnailUrl = thumbnailUrl
    }
}
