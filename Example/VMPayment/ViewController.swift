//
//  ViewController.swift
//  VMPayment
//
//  Created by Vasco Mouta on 15.02.17.
//  Copyright © 2017 zucred AG. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {

    var paymentTextField: STPPaymentCardTextField! = nil
    var submitButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0);
        setupStripeButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupStripeButtons() {
        paymentTextField = STPPaymentCardTextField(frame: CGRect(x:15, y:30, width:view.frame.width - 30, height:44))
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x:15, y:100, width:100, height:44)
        submitButton.isEnabled = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitCard(_ :)), for:.touchUpInside)
        view.addSubview(submitButton)
    }
}

extension ViewController: STPPaymentCardTextFieldDelegate {
    
    @IBAction func submitCard(_ sender: AnyObject?) {
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        let card = paymentTextField.card!
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        submitButton.isEnabled = textField.valid
    }
}

