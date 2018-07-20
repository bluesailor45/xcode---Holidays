//
//  TextViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 13.06.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet var locLabel: UILabel!
    
    @IBOutlet var commentField: UITextView!
    
    @IBAction func saveText(_ sender: Any) {
    //    navigationController?.popViewController(animated: true)
        if activePlace != -1 {
            places[activePlace]["comment"] = commentField.text
            
            UserDefaults.standard.set(places, forKey: "places")
    //    performSegue(withIdentifier: "backToTable", sender: nil)    // PROBLEM !!!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if activePlace != -1 {
            locLabel.text = places[activePlace]["name"]
     //       print(places[activePlace])

            if let comment = places[activePlace]["comment"] {
               commentField.text = comment
            }

        } else {
            locLabel.text = "ERROR: Location invalid !"
        }
        
    }
  
  /*        // funktioniert offenbar nur mit UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
