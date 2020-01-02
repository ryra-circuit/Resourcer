import UIKit

public struct Place: Codable {
    public var _id: Int?
    public var name: String?
    public var address: String?
    public var latitude: Double?
    public var longitude: Double?
    
    public init(_id: Int?, name: String?, address: String?, latitude: Double?, longitude: Double?) {
        self._id = _id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case name
        case address
        case latitude
        case longitude
    }
}
