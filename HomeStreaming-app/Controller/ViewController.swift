//
//  ViewController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func connectButtonPressed(_ sender: Any) {
        
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let message = messageTxtField.text else {return}
        
        if (message != ""){
            ClientService.instance.getMessage { (message) in
                print(message)
            } onError: { (message) in
                print(message)
            }

            messageTxtField.text = ""
        }
        
       
    }
}

