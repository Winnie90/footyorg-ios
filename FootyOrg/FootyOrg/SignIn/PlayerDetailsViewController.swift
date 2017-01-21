//
//  SignInViewController.swift
//  FootyOrg
//
//  Created by Christopher Winstanley on 21/01/2017.
//  Copyright © 2017 Winstanley. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class PlayerDetailsViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        
        checkUserState()
    }
    
    func showPlayerData(user:FIRUser) {
        if let email = user.email {
            welcomeLabel.text = "Welcome \(email)"
        }
        signInButton.isHidden = true
        signOutButton.isHidden = false
    }
    
    func showNoPlayerData() {
        welcomeLabel.text = "Please sign in to access your teams"
        signInButton.isHidden = false
        signOutButton.isHidden = true
    }

    func checkUserState(){
        if let currentUser = FIRAuth.auth()?.currentUser {
            showPlayerData(user: currentUser)
        } else {
            showNoPlayerData()
        }
    }
    
    func signOut(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            checkUserState()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Actions

    @IBAction func signOutButtonTapped(_ sender: Any) {
        signOut()
    }
    
    //MARK: - GIDSignInUIDelegate
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        if error != nil {
            
        }
        checkUserState()
    }
    
}
