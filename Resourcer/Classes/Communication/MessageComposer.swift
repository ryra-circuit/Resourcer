import UIKit

public struct MessageComposer {
    
    public var vc: UIViewController
    public var recepients: [String]
    public var body: String?

    public init(vc: UIViewController, recepients: [String], body: String?) {

        self.vc = vc
        self.recepients = recepients
        self.body = body
    }
}
