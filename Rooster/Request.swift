//
//  Request.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

protocol RequestDelegate
{
    // Handles the JSON.
    func handleJSON(json: NSDictionary, forRequest request: String)
    func invalidAuth()
	func handleError(error: NSError)
}

class Request
{
    var delegate: RequestDelegate!
    var baseString: String!
    let username: String
    let password: String
    
    init(delegate: RequestDelegate, username: String, password: String)
    {
        self.delegate = delegate
        self.baseString = "https://apps.fhict.nl/api/v1/"
        
        self.username = username
        self.password = password
    }
    
    func get(request requestString: String)
    {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        var URL = NSURL(string: "\(self.baseString + requestString)")
        let URLParams =
        [
            "expandTeacher": "false",
            "daysAhead": "7",
            "IncludeStartOfWeek": "true"
        ]
        
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        // Authorization
        let loginString = "\(self.username):\(self.password)"
        let utf8String = (loginString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = utf8String?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        // Headers
        request.addValue("Basic \(base64String!)", forHTTPHeaderField: "Authorization")
        
        /* Start a new Task */
        let task = session.dataTaskWithRequest(request, completionHandler:
            {
                (data : NSData!, response : NSURLResponse!, error : NSError!) -> Void in
                if(error != nil)
                {
					println("Request error: \(error.localizedDescription); \(error.code)")
					
					self.delegate.handleError(error)
                    
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    var error: NSError?
                    let result = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as? NSDictionary
					
                    if (error != nil)
                    {
                        self.delegate.invalidAuth()
                        
                        return
                    }
                    
                    self.delegate.handleJSON(result!, forRequest: requestString)
                })
        })
        
        task.resume()
    }
    
    func stringFromQueryParameters(queryParameters : Dictionary<String, String>) -> String
    {
        var parts: [String] = []
        for (name, value) in queryParameters
        {
            var part = NSString(format: "%@=%@",
                name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!,
                value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            parts.append(part)
        }
        
        return "&".join(parts)
    }
    
    func NSURLByAppendingQueryParameters(URL : NSURL!, queryParameters : Dictionary<String, String>) -> NSURL
    {
        let URLString : NSString = NSString(format: "%@?%@", URL.absoluteString!, self.stringFromQueryParameters(queryParameters))
        
        return NSURL(string: URLString)!
    }
}
