import UIKit
import MessageUI

public protocol CommunicatorDelegate: MFMailComposeViewControllerDelegate {
    
    func makeACall(numberString: String)
    func openUrl(urlString: String)
    func composeAnEmail(composer: EmailComposer)
    func displayShareSheet(shareText: String, image: UIImage?)
}

public extension CommunicatorDelegate {
    
    // MARK: - Phone call
    func makeACall(numberString: String) {
        guard let number = URL(string: "tel://" + (numberString.numericValues)) else {
            print("Invalid phone")
            // Show the issue here with Alert Controller
            return
        }
        
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    // MARK: - Open web page
    func openUrl(urlString: String) {
        guard let website = URL(string: urlString) else {
            print("Invalid url")
            // Show the issue here with Alert Controller
            return
        }
        
        if var comps = URLComponents(url: website, resolvingAgainstBaseURL: false) {
            if comps.scheme == nil {
                comps.scheme = "http"
            }
            if let validUrl = comps.url {
                UIApplication.shared.open(validUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Open share sheet
    func displayShareSheet(shareText: String, image: UIImage?) {
        
        var itmes: [Any] = []
        
        itmes.append(shareText)
        
        if let _image = image {
            itmes.append(_image)
        }
        
        let avc = UIActivityViewController(activityItems: itmes, applicationActivities: [])
        present(avc, animated: true, completion: {})
    }
    
    // MARK: - Compose email
    func composeAnEmail(composer: EmailComposer) {
        self.openEmailComposer(composer: composer)
    }
    
    func openEmailComposer(composer: EmailComposer) {
        let mailComposeController = MFMailComposeViewController()
        mailComposeController.mailComposeDelegate = self
        mailComposeController.setToRecipients(composer.recepients)
        mailComposeController.setSubject(composer.subject ?? "")
        mailComposeController.setMessageBody(composer.body ?? "", isHTML: composer.isHtml)
        
        if MFMailComposeViewController.canSendMail() {
            composer.vc.present(mailComposeController, animated: true, completion: { () -> Void in
            })
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { () -> Void in
            
        }
    }
}

extension String {
    
    // MARK: - Remove other characters and get only numeric values
    var numericValues: String {
        return String(describing: filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
    }
}
