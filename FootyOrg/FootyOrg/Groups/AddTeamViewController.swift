//
//  AddTeamViewController.swift
//  FootyOrg
//
//  Created by Christopher Winstanley - Mobile iPlayer - Erbium on 09/02/2017.
//  Copyright © 2017 Winstanley. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddTeamViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createTeam(name: String, passcode: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        if let currentUser = FIRAuth.auth()?.currentUser {
            let key = ref.child("groups").childByAutoId().key
            let newTeam = ["name": name, "passcode": passcode, "members": []] as [String : Any]
            let childUpdates = ["/groups/\(key)": newTeam,
                                "/users/\(currentUser.uid)/groups/\(key)/": true] as [String : Any]
            ref.updateChildValues(childUpdates)
            let groupMemberUpdates = ["/groups/\(key)/members/\(currentUser.uid)": true]
            ref.updateChildValues(groupMemberUpdates)
        }
    }
    
    // MARK: - Actions 
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let name = self.nameTextField.text,
            let passcode = self.passcodeTextField.text {
            if name.characters.count > 0 && passcode.characters.count > 0 {
                createTeam(name: name, passcode: passcode)
            }
        }
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
