//
//  TableViewController.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, RequestDelegate
{
    var json: NSDictionary?
    var courses = [Course]()
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        if let json = self.json
        {
            self.handleJSON(json, forRequest: "")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        //var req = Request(self)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Request delegate methods
    func handleJSON(json: NSDictionary, forRequest request: String)
    {
		//println(json)
		
        if let courses = json["data"] as? NSArray
        {
            for course in courses
            {
                println(course)
                
                var begin: String!
                var end: String!
                var room: String!
                var subject: String!
                var teacher: String!
				var description: String = "-" // no description
                
                if let _begin = course["start"] as? String
                {
                    begin = _begin
                }
                
                if let _end = course["end"] as? String
                {
                    end = _end
                }
                
                if let _room = course["room"] as? String
                {
					if _room == ""
					{
						room = "no room"
					}
					else
					{
						room = _room
					}
                }
                
                if let _subject = course["subject"] as? String
                {
                    subject = _subject
                }
                
                if let _teacher = course["teacherAbbreviation"] as? String
                {
                    teacher = _teacher
                }
				
				if let _description = course["description"] as? String
				{
					description = _description
				}
                
                if (begin != nil &&
                    end != nil &&
                    room != nil &&
                    subject != nil &&
                    teacher != nil)
                {
					var course: Course?
					var editCourse: Course?
					var same = false
					
					if self.courses.count > 0
					{
						for _course in self.courses
						{
							if (_course.oBegin == begin &&
								_course.oEnd == end &&
								_course.room == room &&
								_course.subject == subject)
							{
								same = true
								editCourse = _course
								break
							}
						}
					}
					
					if !same
					{
						course = Course(begin: begin, end: end, room: room, subject: subject, teacher: teacher, description: description)
					}
					else
					{
						editCourse?.teacher! += ", \(teacher)"
					}
					
					if let _course = course
					{
						self.courses.append(_course)
					}
                }
            }
        }
    }
    
    func invalidAuth()
    {
        // Log the user out.
		// Empty the keychain
    }
	
	func handleError(error: NSError)
	{
		//
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        return self.courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as TableViewCell

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
		
        let course = self.courses[indexPath.row]
        
		cell.fromTime.text = dateFormatter.stringFromDate(course.begin)
		cell.toTime.text = dateFormatter.stringFromDate(course.end)
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		cell.course.text = course.subject
		cell.room.text = course.room
		cell.teacher.text = course.teacher
		//cell.teacher.text = dateFormatter.stringFromDate(course.day)

        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
