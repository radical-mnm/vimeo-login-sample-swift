//
//  LoggedInViewController.swift
//  Sample
//
//  Created by Noor Mustafa on 13/01/17.
//  Copyright © 2017 Noor Mustafa. All rights reserved.
//

import Foundation
import UIKit


class LoggedInViewController: UIViewController {
    
    @IBOutlet weak var accessTokenTextField: UILabel!
    @IBOutlet weak var userNameTextField: UILabel!
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessTokenTextField.text = defaults.string(forKey: "access_token")
        userNameTextField.text = defaults.string(forKey: "user_name")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
