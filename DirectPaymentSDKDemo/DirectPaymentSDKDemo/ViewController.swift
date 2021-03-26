//
//  ViewController.swift
//  DirectPaymentSDKDemo
//
//  Created by Hitendrakumar Solanki on 17/12/20.
//  Copyright © 2020 PhonePe. All rights reserved.
//

import UIKit
import DirectPaymentSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var salt: UITextField!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var saltIndex: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var midField: UITextField!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor.white
        indicator.color = UIColor.purple
        indicator.startAnimating()
        indicator.style = .whiteLarge
        return indicator
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func btnPayDidTap(_ sender: Any) {
        self.makeDebitRequest()
    }
    
    func getServerSideData() -> (String, String)? {
        
        // This is server side code. THIS SHOULD NOT happen on the client side
        let service = "/v4/debit"
        let saltValue = salt.text ?? ""
        let saltIndexValue = Int(saltIndex.text ?? "1") ?? 1
        
        //Model Needed: Offer,
        let txnId = UUID.init().uuidString
        //        let amount = 200
        let userId = ""
        let merchantId = midField.text ?? ""
        
        
        
        let offerInfo = ["offerId": "offerId", "offerDescription": "Amazing offer"]
        let discountInfo = ["discountId": "abc", "discountDescription": "mydescription", "someInfo": ["otherInfo" : "Test"]] as [String : Any]
        
        var data: [String: Any] = [:]
        data["merchantId"] = merchantId
        data["transactionId"] = txnId
        data["amount"] = Int(amountField.text ?? "200") ?? 200
        data["merchantOrderId"] = "OD139924923"
        data["message"] = "Payment towards order No. OD139924923"
        if(!userId.isEmpty) {
            data["merchantUserId"] = userId
        }
        
        data["offer"] = offerInfo
        data["discount"] = discountInfo
        data["providerName"] = "xMerchantId"
        data["paymentScope"] = "PHONEPE"
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            print("Invalid Data to convert")
            return nil
        }
        let base64EncodedString = jsonData.base64EncodedString()
        
        
        let payloadChecksum = ChecksumHelper.calculateChecksum(of: base64EncodedString, api: service, salt: saltValue, saltIndex: saltIndexValue)
        
        return (base64EncodedString, payloadChecksum)
    }
    
    func makeDebitRequest(){
        
        //Make Server Side call here
        guard let (requestBody, checksum) = getServerSideData() else {
            return
        }
        
        let callBackURL = "demoAppScheme"
        
        
        let request:DPSTransactionRequest = DPSTransactionRequest(body: requestBody,
                                                                  apiEndPoint: "/v4/debit",
                                                                  checksum: checksum,
                                                                  headers: nil,
                                                                  callBackURL: callBackURL)
        
        self.resultText.text = PhonePeDPSDK.getPackageSignature()
        
        PhonePeDPSDK.init(environment: .uat)
            .startPhonePeTransactionRequest(transactionRequest: request,
                                            on: self,
                                            animated: true) { request, result in
                print("Completion:---------------------")
                print("result.isSuccess := \(String(describing: result))")
                var text = ""
                text = text + "Successful: \(result.isSuccessful)\n"
                text = text + "Message: \(result.message ?? "")\n"
                text = text + "Status Code: \(String(describing: result.statusCode))\n"
                self.resultText.text = text
                
            }
    }
    
    
}
