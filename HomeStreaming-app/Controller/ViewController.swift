//
//  ViewController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit
@IBDesignable
class ViewController: UIViewController {

    
    @IBInspectable @IBOutlet weak var addressField: UITextField!
    
    @IBInspectable @IBOutlet weak var portField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
    }


    @IBAction func saveSettingsButtonPressed(_ sender: Any) {
        guard let address = addressField.text, let port = portField.text else{return}
        ClientService.instance.setCustomAddress(ip: address, port: port)
        view.endEditing(true)
    }
    
    func setupToolbar(){
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                doneToolbar.barStyle = .default
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        doneToolbar.items = [flexSpace, flexSpace, doneBtn]
        doneToolbar.sizeToFit()
        portField.inputAccessoryView = doneToolbar
        addressField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

