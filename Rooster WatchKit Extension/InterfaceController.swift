//
//  InterfaceController.swift
//  Rooster WatchKit Extension
//
//  Created by Bas on 13/02/2015.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController, RequestDelegate
{
	@IBOutlet weak var courseTable: WKInterfaceTable!
	
	var courses = [Course]()
	
    override func awakeWithContext(context: AnyObject?)
	{
        super.awakeWithContext(context)
        
        // Configure interface objects here.
		
		let req = Request(delegate: self, username: "i306880", password: "bdf-Crf-cGV-Q4h")
		
		req.get(request: "Schedule/me")
    }
	
	// MARK: - RequestDelegate methods
	func handleJSON(json: NSDictionary, forRequest request: String)
	{
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
		
		self.loadTableData()
	}
	
	func handleError(error: NSError)
	{
		//
	}
	
	func invalidAuth()
	{
		//
	}
	
	func loadTableData()
	{
		self.courseTable.setNumberOfRows(self.courses.count, withRowType: "default")
		
		for (index, course) in enumerate(self.courses)
		{
			let row = self.courseTable.rowControllerAtIndex(index) as! WatchTableViewController
			
			row.courseLabel.setText(self.courses[index].subject)
			row.roomLabel.setText(self.courses[index].room)
		}
	}

    override func willActivate()
	{
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate()
	{
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
