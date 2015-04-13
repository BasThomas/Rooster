//
//  TableViewController.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit
import RoosterKit

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
        return 5
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE dd-MM-yyyy"
        
        let day = NSDate(timeInterval: Double(24 * 60 * 60 * section), sinceDate: NSDate().roosterMonday())
        
        return formatter.stringFromDate(day)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        switch(section)
        {
            case 0:
                return RoosterKit.dayCourses(forDay: .Monday, inCourses: self.courses)?.count ?? 0
                
            case 1:
                return RoosterKit.dayCourses(forDay: .Tuesday, inCourses: self.courses)?.count ?? 0
                
            case 2:
                return RoosterKit.dayCourses(forDay: .Wednesday, inCourses: self.courses)?.count ?? 0
                
            case 3:
                return RoosterKit.dayCourses(forDay: .Thursday, inCourses: self.courses)?.count ?? 0
                
            case 4:
                return RoosterKit.dayCourses(forDay: .Friday, inCourses: self.courses)?.count ?? 0
                
            default:
                println("Something went wrong...")
        }
        
        return self.courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as! TableViewCell

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		dateFormatter.timeZone = NSCalendar.currentCalendar().timeZone
		dateFormatter.locale = NSLocale.currentLocale()
        
        var courses = [Course]()
        
        switch(indexPath.section)
        {
            case 0:
                courses =  RoosterKit.dayCourses(forDay: .Monday, inCourses: self.courses)!
                
            case 1:
                courses = RoosterKit.dayCourses(forDay: .Tuesday, inCourses: self.courses)!
                
            case 2:
                courses = RoosterKit.dayCourses(forDay: .Wednesday, inCourses: self.courses)!
                
            case 3:
                courses = RoosterKit.dayCourses(forDay: .Thursday, inCourses: self.courses)!
            
            case 4:
                courses = RoosterKit.dayCourses(forDay: .Friday, inCourses: self.courses)!
                
            default:
                println("Something went wrong...")
        }
		
        let course = courses[indexPath.row]
        
		cell.fromTime.text = dateFormatter.stringFromDate(course.begin)
		cell.toTime.text = dateFormatter.stringFromDate(course.end)
		
		cell.course.text = course.subject
		cell.room.text = course.room
		cell.teacher.text = course.teacher

        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
