//
//  ViewController.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit
import RoosterKit

class ViewController: UIViewController, RequestDelegate, UITextFieldDelegate
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
	@IBOutlet weak var error: UILabel!
    
    var json: NSDictionary?
	
	required init(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		
		let (dictionary, error) = Locksmith.loadDataForUserAccount("user")
		
		if (error == nil)
		{
			let username = dictionary!["username"] as? String
			let password = dictionary!["password"] as? String
			
			var req = Request(delegate: self, username: username!, password: password!)
			req.get(request: "Schedule/me")
		}
		else
		{
			println(error?.localizedDescription)
			let resetError = Locksmith.deleteDataForUserAccount("user")
		}
	}
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.username.delegate = self
        self.username.becomeFirstResponder()
        
        self.password.delegate = self
        
        self.login.enabled = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField delegate methods
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.username.textColor = .blackColor()
        self.password.textColor = .blackColor()
    }
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		self.login("")
		textField.resignFirstResponder()
		
		return true
	}
    
    // MARK: - Request delegate methods
    func handleJSON(json: NSDictionary, forRequest request: String)
    {
		/*
		if let error = json["error"] as? String
		{
			println(error)
			
			self.errorLabel.text = "Gebruikersnaam of wachtwoord klopt niet."
			self.errorLabel.hidden = false
			
			return
		}
		*/
		
		let usernameError = Locksmith.saveData(["username": self.username.text, "password": self.password.text], forUserAccount: "user")
		
        self.json = json
        self.performSegueWithIdentifier("login", sender: self)
    }
    
    func invalidAuth()
    {
        println("invalid auth")
        self.username.textColor = .redColor()
        self.password.textColor = .redColor()
        
        self.login.enabled = true
    }
	
	func handleError(error: NSError)
	{
		if (error.code == -1009)
		{
			self.error.hidden = false
			self.error.text = "Please check your internet connection."
		}
		
		self.login.enabled = true
	}
    
    @IBAction func login(sender: AnyObject)
    {
        let req = Request(delegate: self, username: self.username.text, password: self.password.text)
        
        req.get(request: "Schedule/me")
		
		self.error.hidden = true
        self.login.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let dvc = navigationController.topViewController as! TableViewController
        dvc.json = self.json
    }
}

