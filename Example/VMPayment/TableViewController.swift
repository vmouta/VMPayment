//
//  TableViewController.swift
//  VMPayment
//
//  Created by Vasco Mouta on 15.02.17.
//  Copyright © 2017 zucred AG. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var pymentServices = ["Stripe":"STRIPE_PAYMENT", "Paypal":"PAYPAL_PAYMENT", "Braintree":"BRAINTREE_PAYMENT"]
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pymentServices.keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let serviceName = Array(pymentServices.keys)[indexPath.row]
        cell.textLabel?.text = serviceName
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: pymentServices[Array(pymentServices.keys)[indexPath.row]]!, sender: self)
    }
}
