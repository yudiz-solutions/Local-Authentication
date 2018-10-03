//
//  AuthenticationBlockState.swift
//  LocalAuthenticationDemo
//
//  Created by Yudiz on 03/10/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import LocalAuthentication

/// AuthenticationBlockState
enum AuthenticationBlockState {
    case success
    case failed
    case canceledByUser
    case fallback
    case canceledBySystem
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockedOut
    case other
    
    static func initWith(_ error: LAError?) -> AuthenticationBlockState {
        if error == nil {
            return .success
        } else {
            switch Int32(error!.errorCode) {
            case kLAErrorAuthenticationFailed:
                return .failed
            case kLAErrorUserCancel:
                return .canceledByUser
            case kLAErrorUserFallback:
                return .fallback
            case kLAErrorSystemCancel:
                return .canceledBySystem
            case kLAErrorPasscodeNotSet:
                return .passcodeNotSet
            case kLAErrorBiometryNotAvailable:
                return .biometryNotAvailable
            case kLAErrorBiometryNotEnrolled:
                return .biometryNotEnrolled
            case kLAErrorBiometryLockout:
                return .biometryLockedOut
            default:
                return other
            }
        }
    }
    
    func message() -> String {
        switch self {
        case .canceledByUser, .fallback, .canceledBySystem:
            return ""
        case .passcodeNotSet:
            return kSetPasscode
        case .biometryNotAvailable:
            return kBiometryNotAvailableReason
        case .biometryNotEnrolled:
            return LocalAuthentication.isFaceIdAvailable ? kNoFaceIdentityEnrolled : kNoFingerprintEnrolled
        case .biometryLockedOut:
            return LocalAuthentication.isFaceIdAvailable ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
        default:
            return LocalAuthentication.isFaceIdAvailable ? kDefaultFaceIDAuthenticationFailedReason : kDefaultTouchIDAuthenticationFailedReason
        }
    }
}
