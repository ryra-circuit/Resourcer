import UIKit
import MessageUI

public protocol CommunicatorDelegate: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func makeACall(numberString: String)
    func openUrl(urlString: String)
    func composeAnEmail(composer: EmailComposer)
    func composeMessage(composer: MessageComposer)
    func displayShareSheet(vc: UIViewController, shareText: String, image: UIImage?)
}

public extension CommunicatorDelegate {
    
    // MARK: - Phone call
    func makeACall(numberString: String) {
        guard let number = URL(string: "tel://" + (numberString.plusAndNumericValues)) else {
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
    func displayShareSheet(vc: UIViewController, shareText: String, image: UIImage?) {
        
        var itmes: [Any] = []
        
        itmes.append(shareText)
        
        if let _image = image {
            itmes.append(_image)
        }
        
        let avc = UIActivityViewController(activityItems: itmes, applicationActivities: [])
        vc.present(avc, animated: true, completion: {})
    }
}


public extension CommunicatorDelegate {
    
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


public extension CommunicatorDelegate {
    
    // MARK: - Compose message
    func composeMessage(composer: MessageComposer) {
        self.openMessageComposer(composer: composer)
    }
    
    func openMessageComposer(composer: MessageComposer) {
        let messageComposeController = MFMessageComposeViewController()
        messageComposeController.messageComposeDelegate = self
        messageComposeController.recipients = composer.recepients
        messageComposeController.body = composer.body
        
        if MFMessageComposeViewController.canSendText() {
            composer.vc.present(messageComposeController, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { () -> Void in

        }
    }
}


extension String {
    
    // MARK: - Remove other characters and get only numeric values
    var numericValues: String {
        return String(describing: filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
    }
    
    // MARK: - Remove other characters and get only numeric values
    var plusAndNumericValues: String {
        return String(describing: filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "+0123456789")) != nil })
    }
}

