//
//  ViewController.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RequestDelegate, UITextFieldDelegate
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
	@IBOutlet weak var error: UILabel!
    
    var json: NSDictionary?
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.username.delegate = self
        self.username.becomeFirstResponder()
        
        self.password.delegate = self
        
        self.login.enabled = true
		
		self.username.text = "i306880"
		self.password.text = ""
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
    
    // MARK: - Request delegate methods
    func handleJSON(json: NSDictionary, forRequest request: String)
    {
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

