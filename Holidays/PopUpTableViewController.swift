//
//  PopUpTableViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 29.08.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//
//  Table with already saved projects will be displayed when "Load Project" has been hit
//  load the project file selected in table

import UIKit

class PopUpTableViewController: UITableViewController {

    var passedFileName: String = " "        // filename to be passed back to TableViewController
    
    @IBOutlet var popUpTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
      
            // if no files yet saved, save current locations as "defaultFile"
            if fileURLs.count == 0 {

                let fileNameString = documentsURL.appendingPathComponent("defaultFile")
                NSKeyedArchiver.archiveRootObject(places, toFile: (fileNameString.path))
        
                fileNames = [fileNameString]
            }
            
            fileNames = fileURLs
        
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fileNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath)

        // Configure the cell...

     cell.textLabel?.text = fileNames[indexPath.row].lastPathComponent
     
     return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // here code to load the correct file

        let fileName = fileNames[indexPath.row]
        
        passedFileName = fileName.path   // filename to be passed
  
        activeFile = fileNames[indexPath.row].lastPathComponent                 // added 20.9
    
        performSegue(withIdentifier: "unwindToTable", sender: self)

    }

    
        
        
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source

            if editingStyle == .delete {
            if fileNames.count > 1 {  // do NOT delete last file
                let fm = FileManager.default
                
                do {
                    if fm.fileExists(atPath: fileNames[indexPath.row].path) {

                        try fm.removeItem(at: fileNames[indexPath.row])
                        
                    }
                } catch {
                    print(" fileName does not exist")
                }
            }
        }
//         popUpTable.reloadData()
        dismiss(animated: true)
            
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
