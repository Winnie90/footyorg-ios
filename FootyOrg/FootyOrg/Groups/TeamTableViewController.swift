//
//  GroupTableViewController.swift
//  FootyOrg
//
//  Created by Christopher Winstanley on 21/01/2017.
//  Copyright © 2017 Winstanley. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TeamTableViewController: UITableViewController {

    var groups = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func loadData() {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()

        self.groups.removeAllObjects()

        if let currentUser = FIRAuth.auth()?.currentUser {
            ref.child("users").child(currentUser.uid).child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
                if let tempGroups = snapshot.value as? NSDictionary {
                    let tempGroupKeys = tempGroups.allKeys as NSArray
                    var index = 0
                    for group in tempGroupKeys {
                        ref.child("groups").child(group as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let group = snapshot.value as? NSDictionary {
                                self.groups.add(group)
                            }
                            index += 1
                            if index == tempGroupKeys.count {
                                self.tableView.reloadData()
                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath)
        let group = groups.object(at: indexPath.row) as? NSDictionary
        cell.textLabel?.text = group?.value(forKey: "name") as! String?
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
