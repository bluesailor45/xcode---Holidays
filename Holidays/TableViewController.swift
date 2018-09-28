//
//  TableViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 14.05.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//
// This is the main View to display all locations already saved
//

import UIKit
import Reachability                     // used for tests for internet availability

var places = [Dictionary<String, String>()]
// var places = [["name": "La Brigantine", "lat": "43.268", "lon": "6.58", "comment": "my favorite"]]
var activePlace = -1

var fileNames: [URL] = []               // used for saving different "projects"
var activeFile = " "                    // added 20.9

class TableViewController: UITableViewController {

     let reachability = Reachability()!
    
    @IBAction func editMode(_ sender: Any) {
        // change title of "Move Rows" button to "Done" when in editing mode
        if self.isEditing == false {
            self.navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Move Rows"
        }
        self.isEditing = !self.isEditing            // switch editing mode
    }
    
    
    @IBOutlet var table: UITableView!
    

    
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
        // refer to this segue in next views
        // code appended to support data passing
        
        if segue.source is PopUpTableViewController {       // send back file name
     
            if let senderVC = segue.source as? PopUpTableViewController {
                let projectFile = senderVC.passedFileName
                
                if let filePlaces = (NSKeyedUnarchiver.unarchiveObject(withFile: projectFile)) as? [Dictionary<String,String>] {
                    
                    places.removeAll()
                    
                    for i in filePlaces.indices {
                        places.append(filePlaces[i])
                        
                    }
                }
            }
            UserDefaults.standard.set(places, forKey: "places")     // save new values
            
            UserDefaults.standard.set(activeFile, forKey: "activeProject")
            table.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        if ((reachability.connection) == .none) {           // test if internet reachable
            // disable "+" button in right BarButtonItem

            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(true)
        
        if ((reachability.connection) == .none) {           // test if internet reachable
        // disable "+" button in right BarButtonItem

            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        activePlace = -1
        
         if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = tempPlaces
         }
        
        if let tempProject = UserDefaults.standard.object(forKey: "activeProject") as? String {
            activeFile = tempProject
        }
        
        navigationItem.title = "Locations"
        if activeFile != "" {
            navigationItem.title = activeFile
        }
        
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append(["name": "La Brigantine", "lat" :  "43.268336", "lon": "6.586143", "comment": "This is my place"])
            
            UserDefaults.standard.set(places, forKey: "places")
            
            UserDefaults.standard.set(activeFile, forKey: "activeProject")
        }
        
        
    
    table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //  return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return the number of rows
        return places.count
    }

    // functions to enable moving rows
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = places[sourceIndexPath.row]
        places.remove(at: sourceIndexPath.row)
        places.insert(movedObject, at: destinationIndexPath.row)
        
        UserDefaults.standard.set(places, forKey: "places")     // save rearranged rows
        
        UserDefaults.standard.set(activeFile, forKey: "activeProject")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        if places[indexPath.row]["name"] != nil {
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        return cell
    }
    
      override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // test if internet is reachable
        
        if ((reachability.connection) == .none) {

            let alertController = UIAlertController(title: nil, message: "No access to Internet", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
    /*
            alertController.addTextField { (actionToTake) in
                actionToTake.text = "activate network and restart app!"
            }
    */
         self.present(alertController, animated: true, completion: nil)
         
        } else {
        
        activePlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: self)
        }
    }
        

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

     //    change the titles of the edit actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (tableAction, indexPath) in
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            
            UserDefaults.standard.set(activeFile, forKey: "activeProject")
            
            tableView.reloadData()
        }
        let comment = UITableViewRowAction(style: .normal, title: "comment") { (tableAction, indexPath) in

            activePlace = indexPath.row

            self.performSegue(withIdentifier: "toComment", sender: nil)
        }
        comment.backgroundColor = UIColor.blue
        return [comment, delete]
    }

    func goToComment(indexPath: IndexPath) {
        activePlace = indexPath.row
        performSegue(withIdentifier: "toComment", sender: nil)
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
