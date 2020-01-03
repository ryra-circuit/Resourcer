import UIKit

public struct EmailComposer {
    
    public var vc: UIViewController
    public var recepients: [String]
    public var subject: String?
    public var body: String?
    public var isHtml: Bool = false

    public init(vc: UIViewController, recepients: [String], subject: String?, body: String?, isHtml: Bool) {

        self.vc = vc
        self.recepients = recepients
        self.subject = subject
        self.body = body
        self.isHtml = isHtml
    }
}
