//
//  LoginViewController.swift
//  NanoChalenge2
//
//  Created by Nova Arisma on 9/20/19.
//  Copyright © 2019 Nova Arisma. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    let myContext = LAContext()

    
    @IBOutlet weak var tapLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapLoginTapped(_ sender: Any) {
        
        tapLogin.isHidden  = true
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            
            myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Your Face ID") {(Benar, error) in
                if Benar{
                    
                    DispatchQueue.main.async {
                        print("oke")
                        self.performSegue(withIdentifier: "faceId", sender: nil)
                    }
                    
                }else{ print("salah")}
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
