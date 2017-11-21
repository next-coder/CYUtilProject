//
//  TouchID.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 09/10/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit
import LocalAuthentication

public class DeviceAuthentication: NSObject {

    public enum AvailableStatus: Int {
        // notAvailable, unknown reason
        case notAvailable = 0
        case passcodeNotSet
        case biometryLockout
        case biometryNotAvailable
        case biometryNotEnrolled
        case available
    }

    // this method tests the biometrics(touchid, faceid) authentication availability on the device
    // true for available, false for unavailable
    public class var biometricsAuthAvailable: Bool {

        return biometricsAuthStatus == .available
    }

    // if the biometrics is unavailable, this property return the error code
    // else this method return nil
    public class var biometricsAuthStatus: AvailableStatus {
        var error: NSError? = nil
        let success = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                    error: &error)
        if success {
            return .available
        } else if let err = error {
            return AvailableStatus(rawValue: err.code) ?? .notAvailable
        } else {
            return .notAvailable
        }
    }

    // this method auth by biometrics(touchid, faceid)
    // @param localizedReason some useing description for user
    // @param completion auth end callback
    //      Bool, true for success, false for failed
    //      Error, nil if policy evaluation succeeded, an error object that should be presented to the user otherwise. See LAError.Code for possible error codes
    public class func authByBiometrics(localizedReason: String, completion:@escaping (Bool, Error?) -> Void) {

        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: localizedReason) {
                                    result, error in
                                    DispatchQueue.main.async {
                                        completion(result, error)
                                    }
        }
    }

    // this method auth by biometrics(touchid, faceid)
    // @param localizedReason some useing description for user
    // @param localizedCancelTitle cancel title, only available in iOS 10 and later
    // @param localizedCancelTitle fallback title, another button title
    // @param completion auth end callback
    //      Bool, true for success, false for failed
    //      Error, nil if policy evaluation succeeded, an error object that should be presented to the user otherwise. See LAError.Code for possible error codes
    public class func authByBiometrics(localizedReason: String,
                                       localizedCancelTitle: String?,
                                       localizedFallbackTitle: String?,
                                       completion:@escaping (Bool, Error?) -> Void) {

        let context = LAContext()
        context.localizedFallbackTitle = localizedFallbackTitle
        if #available(iOS 10, *) {

            context.localizedCancelTitle = localizedCancelTitle
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) {
                                result, error in
                                DispatchQueue.main.async {
                                    completion(result, error)
                                }
        }
    }

    // this method tests the passcode or biometrics(touchid, faceid) authentication availability on the device
    // passcode authentication needs the system is iOS 9.0 and later
    // true for available, false for unavailable
    public class var biometricsOrPasscodeAuthAvailable: Bool {
        return biometricsOrPasscodeAuthStatus == .available
    }

    // if the biometrics is unavailable, this property return the error code
    // else this method return nil
    public class var biometricsOrPasscodeAuthStatus: AvailableStatus {

        var error: NSError? = nil
        var success: Bool
        if #available(iOS 9, *) {
            success = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication,
                                                    error: &error)
        } else {
            success = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                    error: &error)
        }
        if success {
            return .available
        } else if let err = error {
            return AvailableStatus(rawValue: err.code) ?? .notAvailable
        } else {
            return .notAvailable
        }
    }

    public class func authByBiometricsOrPasscode(localizedReason: String, completion:@escaping (Bool, Error?) -> Void) {
        self.authByBiometricsOrPasscode(localizedReason: localizedReason,
                                        localizedCancelTitle: nil,
                                        localizedFallbackTitle: nil,
                                        completion: completion)
    }

    public class func authByBiometricsOrPasscode(localizedReason: String,
                                                 localizedCancelTitle: String?,
                                                 localizedFallbackTitle: String?,
                                                 completion:@escaping (Bool, Error?) -> Void) {
        if #available(iOS 9, *) {
            let context = LAContext()
            context.localizedFallbackTitle = localizedFallbackTitle
            if #available(iOS 10, *) {

                context.localizedCancelTitle = localizedCancelTitle
            }
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: localizedReason) {
                                    result, error in
                                    DispatchQueue.main.async {
                                        completion(result, error)
                                    }
            }
        } else {
            self.authByBiometrics(localizedReason: localizedReason,
                                  localizedCancelTitle: localizedCancelTitle,
                                  localizedFallbackTitle: localizedFallbackTitle,
                                  completion: completion)
        }
    }
}
