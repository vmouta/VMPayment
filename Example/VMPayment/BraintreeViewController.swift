//
//  BraintreeViewController.swift
//  VMPayment
//
//  Created by Vasco Mouta on 15.02.17.
//  Copyright © 2017 zucred AG. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class BraintreeViewController: UIViewController {
    
    let tokenizationKey = "sandbox_3dd2rj5p_rp7gvgdkqn7mpk5j"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension BraintreeViewController {
    
    @IBAction func SendPayment(sender: AnyObject) {
        showDropIn(clientTokenOrTokenizationKey: self.tokenizationKey)
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
                
            } else if let result = result {
                print(result)
                // Use the BTDropInResult properties to update your UI
                print("paymentOptionType: \(result.paymentOptionType)")
                print("paymentMethod: \(result.paymentMethod)")
                print("paymentIcon: \(result.paymentIcon)")
                print("paymentDescription: \(result.paymentDescription)")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }

    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    
}
