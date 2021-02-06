//
//  ViewController.swift
//  DoggieDays
//
//  Created by Josue Ballona on 9/19/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!

    @IBOutlet weak var outputLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     * Function that runs when the button is pressed.
     */
    @IBAction func buttonPress(_ sender: Any) {
        
        ageTextField.resignFirstResponder()
        
        outputLabel.text = ""
        
        // if dog age entered is empty, you get an error window
        guard let dogAge = ageTextField.text, !dogAge.isEmpty else {
            presentAlert("Please enter your dog's age.")
            return
        }
        
        let finalAge = HumanAgeConverter(age: Int(dogAge) ?? 0)
        outputLabel.text = "Your dog is \(finalAge.humanAge) years old in human years."
    }
    
    /**
     *  Closes the software keyoard when screen is touched outside of keyboard area
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ageTextField.resignFirstResponder()
    }
    
    /**
     *  Presents an alert to display error messages
     *
     * - Parameter message  Error message to display.
     */
    func presentAlert(_ message: String) {
        let alertController = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

