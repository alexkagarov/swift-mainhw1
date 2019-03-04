//
//  HomeViewController.swift
//  Homework-LoginForm
//
//  Created by Alex Kagarov on 3/2/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    
    var loginPassed: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLbl.text = "Welcome to Home ViewController, \(loginPassed)!"
        
        // Do any additional setup after loading the view.
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
