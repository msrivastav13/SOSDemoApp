import UIKit
import ServiceCore
import ServiceSOS

class ViewController: UIViewController, SOSDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add our SOS delegate
        SCServiceCloud.sharedInstance().sos.add(self)
    }
    @IBAction func startSOS1(_ sender: Any) {
        
        // Create options object
        let options = SOSOptions(liveAgentPod: "d.la2-c1-iad.salesforceliveagent.com",
                                 orgId: "00D1I0000001NXK",
                                 deploymentId: "0NW1I000000fxSL"
                              )
        //options!.featureClientBackCameraEnabled = true
        //options!.featureClientFrontCameraEnabled = true
        //options!.featureClientScreenSharingEnabled = false
        //options!.initialCameraType = .backFacing
        
        // Start the session
        SCServiceCloud.sharedInstance().sos.startSession(with: options)
    }
    
    // Delegate method for session stop event.
    // You can also check for fatal errors with this delegate method.
    func sos(_ sos: SOSSessionManager!, didStopWith reason: SOSStopReason,
             error: Error!) {
        
        var title = ""
        var description = ""
        
        // If there's an error...
        if (error != nil) {
            
            switch (error as NSError).code {
                
            // No agents available
            case SOSErrorCode.SOSNoAgentsAvailableError.rawValue:
                title = "Session Failed"
                description = "It looks like there are no agents available. Try again later."
                
            // Insufficient network error
            case SOSErrorCode.SOSInsufficientNetworkError.rawValue:
                title = "Session Failed"
                description = "Insufficient network. Check network quality and try again."
                
                // TO DO: Use SOSErrorCode to check for ALL other error conditions
            //        in order to give a more clear explanation of the error.
            default:
                title = "Session Error"
                description = "Unknown session error."
            }
            
            // Else if session stopped without an error condition...
        } else {
            
            switch reason {
                
            // Handle the agent disconnect scenario
            case .agentDisconnected:
                title = "Session Ended"
                description = "The agent has ended the session."
                
                // TO DO: Use SOSStopReason to check for
            //        other reasons for session ending...
            default:
                break
            }
        }
        
        // Display dialog if we have something to say...
        if (title != "") {
            
            let alert = UIAlertController(title: title,
                                          message: description,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
