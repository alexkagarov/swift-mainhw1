//
//  ViewController.swift
//  Homework-LoginForm
//
//  Created by Alex Kagarov on 3/1/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

protocol MyLoginDelegate: class {
    func getCredentials(_ cred: [String:String])
}

class MyLogin {
    weak var delegate: MyLoginDelegate?
    
    var userCredentials = [String:String]()
    
    static var loginInstance = MyLogin()
    
    func isLoginSuccessful(_ inputLogin: String?,_ inputPwd: String?) -> Bool {
        var isSuccessful = false
        for (login, password) in userCredentials {
            if (inputLogin == login && inputPwd == password) {
                isSuccessful = true
                break
            }
        }
        return isSuccessful
    }
    
    func isLoginExist(_ inputLogin: String) -> Bool {
        var isExist = false
        for (login, _) in userCredentials {
            if inputLogin == login {
                isExist = true
                break
            }
        }
        return isExist
    }
    
    func createUser (_ inputLogin: String,_ inputPwd: String) {
        userCredentials[inputLogin] = inputPwd
        print("User \(inputLogin) created")
    }
    
    func resetPwd (_ inputLogin: String) {
        let defaultPwd = "07931505"
        userCredentials[inputLogin] = defaultPwd
    }
    
    func setCredentials() {
        let cred = userCredentials
        delegate?.getCredentials(cred)
    }
    
    private init(){
        
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    static var userCredentials = [String:String]()
    let login = MyLogin.loginInstance
    
    //properties
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myPwTextField: UITextField!
    @IBOutlet weak var enterLoginBtn: UIButton!
    
    @IBOutlet weak var loginResetTextField: UITextField!
    @IBOutlet weak var loginResetBtn: UIButton!
    
    @IBOutlet weak var newUserTextField: UITextField!
    @IBOutlet weak var newPwTextField: UITextField!
    @IBOutlet weak var rptNewPwTextField: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var showPwdSwitch: UISwitch!
    
    //actions
    @IBAction func showPwdSwtiched(_ sender: UISwitch) {
        if (showPwdSwitch.isOn) {
            newPwTextField.isSecureTextEntry = false
            rptNewPwTextField.isSecureTextEntry = false
        } else {
            newPwTextField.isSecureTextEntry = true
            rptNewPwTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func onUserCreate(_ sender: UIButton) {
        let newLogin = newUserTextField.text ?? ""
        let newPwd = newPwTextField.text ?? ""
        let rptPwd = rptNewPwTextField.text ?? ""
        let isLogin = login.isLoginExist(newLogin)
        
        if isLogin {
            let alert = UIAlertController(title: "Invalid login", message: "This name already exists! Choose another or use password reset form.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Sorry!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            newPwTextField.text = ""
            rptNewPwTextField.text = ""
        }
        
        if !(newPwd == rptPwd) {
            let alert = UIAlertController(title: "Password mismatch", message: "Password doesn't match repeating one. Please try again carefully.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Sorry!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (!isLogin && (newPwd == rptPwd)) {
            let alert = UIAlertController(title: "User created", message: "User created successfully!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thank you!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            login.createUser(newLogin, newPwd)
            performSegue(withIdentifier: "newUserSegue", sender: nil)
        }
    }
    
    @IBAction func onLoginReset(_ sender: UIButton) {
        let currentLogin = loginResetTextField.text ?? ""
        let isLogin = login.isLoginExist(currentLogin)
        
        if isLogin {
            login.resetPwd(currentLogin)
            let alert = UIAlertController(title: "Password reset", message: "Password for login \(currentLogin) reset to default.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thank you!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            performSegue(withIdentifier: "pwResetSuccessfulSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid credentials", message: "Login not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onEnterLogin(_ sender: UIButton) {
        let isLoginSuccessful = login.isLoginSuccessful(myTextField.text ?? "", myPwTextField.text ?? "")
        if isLoginSuccessful {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid credentials", message: "Login or password is incorrect", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            myPwTextField.text = ""
        }
    }
    
    
//main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loginResetTextField?.delegate = self
        self.myPwTextField?.delegate = self
        self.myTextField?.delegate = self
        self.newPwTextField?.delegate = self
        self.newUserTextField?.delegate = self
        self.rptNewPwTextField?.delegate = self
        
        login.delegate = self
        login.setCredentials()
    }
    
// fixing keyboard appear-dissapear issues
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let login = segue.destination as? HomeViewController
        {
            login.loginPassed = myTextField.text!
        }
    }
}

extension ViewController: MyLoginDelegate {
    func getCredentials(_ cred: [String : String]) {
        print(cred) // temporary action
    }
}

// extension for button radius 
@IBDesignable extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
