//
//  ChecksumHelper.swift
//  DirectPaymentSDKDemo
//
//  Created by Amit Kumar Gupta on 08/02/21.
//  Copyright © 2021 PhonePe. All rights reserved.
//

import Foundation
import CryptoKit
import CommonCrypto
//This is again Server side code and should not happen in your client side app
public struct ChecksumHelper {
    public static func calculateChecksum(of input: String, api: String, salt: String, saltIndex: Int) -> String {
        let inputString = input + api + salt        

        let finalHash = inputString.sha256() + "###" + String(saltIndex)
        return finalHash
    }
}

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
}

