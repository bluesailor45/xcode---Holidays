//
//  PopUpViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 29.08.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//
// PopUp with a text entry to enter a "project file name" do be saved will be displayed when "save" is entered in mainView

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileName.text = activeFile                      // display active fileName in save text cell
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var fileName: UITextField!
    
    @IBAction func saveFile(_ sender: Any) {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls.first
        let fileNameString = url?.appendingPathComponent(fileName.text!)
        
 //      let fileNameLast = fileNameString!.lastPathComponent
 //       print( "last Path Component = ", fileNameLast)
        
        NSKeyedArchiver.archiveRootObject(places, toFile: (fileNameString?.path)!)
        
        if let active = fileName.text {
            activeFile = active
        }                                                   // added 20.9
        
  //      print(fileNameString)
        
        
        dismiss(animated: true)
        
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
