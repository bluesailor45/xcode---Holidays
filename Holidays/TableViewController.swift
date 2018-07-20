//
//  TableViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 14.05.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>()]
// var places = [["name": "La Brigantine", "lat": "43.268", "lon": "6.58", "comment": "my favorite"]]
var activePlace = -1

class TableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationItem.title = "Locations"
        activePlace = -1
        
         if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = tempPlaces
         }
     
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append(["name": "La Brigantine", "lat" :  "43.268336", "lon": "6.586143", "comment": "This is my place"])
            
            UserDefaults.standard.set(places, forKey: "places")
        }
        table.reloadData()    }

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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if places[indexPath.row]["name"] != nil {
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        return cell
    }
    
      override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: nil)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

  /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            tableView.reloadData()
      //      tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    */
     //    Test for changing the title
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (tableAction, indexPath) in
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            tableView.reloadData()
        }
        let comment = UITableViewRowAction(style: .normal, title: "comment") { (tableAction, indexPath) in

            activePlace = indexPath.row
            // self.goToComment(indexPath: indexPath)

            self.performSegue(withIdentifier: "toComment", sender: nil)
        }
        comment.backgroundColor = UIColor.blue
        return [delete, comment]
    }

    func tableAction(_ action: [UITableViewRowAction]) {
        print("action entered")
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
