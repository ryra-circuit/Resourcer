import UIKit
import MessageUI

public protocol CommunicatorDelegate: MFMailComposeViewControllerDelegate {
    
    func makeACall(numberString: String)
    func openUrl(urlString: String)
    func composeAnEmail(composer: EmailComposer)
}

public extension CommunicatorDelegate {
    
    // MARK: - Phone call
    func makeACall(numberString: String) {
        guard let number = URL(string: "tel://" + (numberString)) else {
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
