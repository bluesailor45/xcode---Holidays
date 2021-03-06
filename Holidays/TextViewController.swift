//
//  TextViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 13.06.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//
// TextView to enter a comment to a location
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate {


    @IBOutlet var locLabel: UILabel!
    
    @IBOutlet var commentField: UITextView!
    
    @IBAction func saveText(_ sender: Any) {
   
        if activePlace != -1 {
            places[activePlace]["comment"] = commentField.text
            
            UserDefaults.standard.set(places, forKey: "places")
            
            UserDefaults.standard.set(activeFile, forKey: "activeProject")                // save active project filename
            
            performSegue(withIdentifier: "unwindToTable", sender: nil)        }
    }
    
    
    // func textView implemented to force keyboard to dismiss if return hit
    // also "commentField.delegate ... " included
   
    /* deleted due to new function with IQKeyboardManager: "Done"
     
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
   */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if activePlace != -1 {
            locLabel.text = places[activePlace]["name"]

            if let comment = places[activePlace]["comment"] {
               commentField.text = comment
            }

        } else {
            locLabel.text = "ERROR: Location invalid !"
        }
        
    }
  
    
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
