//
//  LocalAuthentication.swift
//  LocalAuthenticationDemo
//
//  Created by Yudiz on 01/10/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import LocalAuthentication

/// LocalAuthentication
class LocalAuthentication: NSObject {
    
    /// Variable Declaration(s)
    /// Singleton Variable
    static var shared: LocalAuthentication = LocalAuthentication()
    
    class var isFaceIdAvailable: Bool {
        let context: LAContext = LAContext()
        let evaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if #available(iOS 11.0, *) {
            return (context.biometryType == .faceID)
        }
        return evaluate
    }
    
    class var isTouchIdAvailable: Bool {
        let context: LAContext = LAContext()
        let evaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if #available(iOS 11.0, *) {
            return (context.biometryType == .touchID)
        }
        return evaluate
    }
    
    /// Change default message as per your need.
    var defaultReasonMessage: String {
        return LocalAuthentication.isFaceIdAvailable ? kFaceIdAuthenticationReason : kTouchIdAuthenticationReason
    }
    
    /// Block Declaration(s)
    typealias authenticationBlock = ((AuthenticationBlockState) -> ())
}

// MARK: - Authentication Related Method(s)
extension LocalAuthentication {
    
    /// This method will check the user authentication with biometeric. If biometrics get failed user will prompt with passcode option.
    ///
    /// - Parameters:
    ///   - reasonMessage: Reason message is must be and cannot be empty/nil for using biometeric/passcode.
    ///   - cancelTitle: By default is `Cancel`.
    ///   - block: Return the state of user authentication is success or failure.
    func authenticateUserWithBioMetrics(_ reasonMessage: String, cancelTitle: String? = "", block: @escaping authenticationBlock) {
        let context: LAContext = LAContext()
        context.localizedCancelTitle = cancelTitle
        context.localizedFallbackTitle = "Passcode"
        evaluate(.deviceOwnerAuthentication, reason: (reasonMessage.isEmpty ? defaultReasonMessage : reasonMessage), context: context, block: block)
    }
    
    fileprivate func evaluate(_ policy: LAPolicy, reason: String, context: LAContext, block: @escaping authenticationBlock) {
        context.evaluatePolicy(policy, localizedReason: reason) { (isSuccess, error) in
            block(AuthenticationBlockState.initWith(error as? LAError))
        }
    }
}
