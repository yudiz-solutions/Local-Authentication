//
//  ViewController.swift
//  LocalAuthenticationDemo
//
//  Created by Yudiz on 01/10/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit

/// ViewController
class ViewController: UIViewController {
    
    /// IBOutlet(s)
    @IBOutlet weak var btnAuthenticate: UIButton!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

// MARK: - UI Related Method(s)
extension ViewController {
    
    func prepareUI() {
        
    }
}

// MARK: - UIButton Action(s)
extension ViewController {
    
    @IBAction func tapBtnAuthenticate(_ sender: UIButton) {
        LocalAuthentication.shared.authenticateUserWithBioMetrics(kReasonMessage) { [weak self] (authenticationState) in
            guard let self = self else {
                return
            }
            switch authenticationState {
            case .success:
                self.showAlert("Successfully Authenticated")
            case .canceledByUser, .fallback, .canceledBySystem:
                break
            case .passcodeNotSet:
                self.showAlert(authenticationState.message(), block: { (action) in
                    self.redirectUserToSetting()
                })
            default:
                self.showAlert(authenticationState.message())
            }
        }
    }
}

// MARK: - Other Method(s)
extension ViewController {
    
    func showAlert(_ message: String, block: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: block)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func redirectUserToSetting() {
        if let url = URL(string: "App-Prefs:") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
