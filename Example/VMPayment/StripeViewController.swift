//
//  StripeViewController.swift
//  VMPayment
//
//  Created by Vasco Mouta on 15.02.17.
//  Copyright © 2017 zucred AG. All rights reserved.
//

import UIKit
import Stripe

class StripeViewController: UIViewController {

    var paymentTextField: STPPaymentCardTextField! = nil
    var submitButton: UIButton! = nil

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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

extension StripeViewController: STPPaymentCardTextFieldDelegate {
    
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
    
    @IBAction func SendPayment(sender: AnyObject) {
        // Initiate the card
        let stripCard = STPCardParams()
    
        // Split the expiration date to extract Month & Year
        if self.expireDateTextField.text?.isEmpty == false {
            let expirationDate = self.expireDateTextField.text?.components(separatedBy: "/")
            let expMonth = UInt((expirationDate?[0])!)
            let expYear = UInt((expirationDate?[1])!)
            
            
            // Send the card info to Strip to get the token
            stripCard.number = self.cardNumberTextField.text
            stripCard.cvc = self.cvcTextField.text
            stripCard.expMonth = expMonth!
            stripCard.expYear = expYear!
        }
        
        switch (STPCardValidator.validationState(forCard: stripCard)) {
            case .incomplete:
                let alert = UIAlertController(title: "Welcome to Stripe", message: "Incomplete Card", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break;
            
            case .invalid:
                let alert = UIAlertController(title: "Welcome to Stripe", message: "Invalide Card", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break;
            case .valid:
                STPAPIClient.shared().createToken(withCard: stripCard, completion: { token, error in
                    guard let stripeToken = token else {
                        NSLog("Error creating token: %@", error!.localizedDescription);
                        return
                    }
                    
                    // TODO: send the token to your server so it can create a charge
                    let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                })

                break;
        }
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        submitButton.isEnabled = textField.valid
    }
}

