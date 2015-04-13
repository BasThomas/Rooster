//
//  GlanceController.swift
//  Rooster
//
//  Created by Bas on 07/03/2015.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import WatchKit
import RoosterKit

class GlanceController: WKInterfaceController, RequestDelegate
{
	@IBOutlet weak var timeLabel: WKInterfaceLabel!
	@IBOutlet weak var courseLabel: WKInterfaceLabel!
	
	var courses = [Course]()
	
	override func awakeWithContext(context: AnyObject?)
	{
		super.awakeWithContext(context)
		
		// Configure interface objects here.
		
		let req = Request(delegate: self, username: "", password: "")
		
		req.get(request: "Schedule/me")
		
		let (dictionary, error) = Locksmith.loadDataForUserAccount("user")
		println(dictionary)
		
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
			// TODO: Display error to user.
		}
	}
	
	// MARK: - RequestDelegate methods
	func handleJSON(json: NSDictionary, forRequest request: String)
	{
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
			
			self.setupGlance()
		}
	}
	
	func handleError(error: NSError)
	{
		if (error.code == -1009)
		{
			self.timeLabel.setTextColor(.redColor())
			self.timeLabel.setText("Internet offline")
			
			self.courseLabel.setHidden(true)
		}
	}
	
	func invalidAuth()
	{
		self.timeLabel.setTextColor(.redColor())
		self.timeLabel.setText("Please reauthorize")
		
		self.courseLabel.setHidden(true)
	}
	
	func setupGlance()
	{
		self.courseLabel.setHidden(false)
		
		let earliest = RoosterKit.soonestDates(self.courses)
		
		var timeLabelText: String?
		var courseLabelText: String?
		
		if let courses = earliest
		{
			let timeZone = NSCalendar.currentCalendar().timeZone
			let locale = NSLocale.currentLocale()
			
			let timeFormatter = NSDateFormatter()
			timeFormatter.dateFormat = "HH:mm"
			timeFormatter.timeZone = timeZone
			timeFormatter.locale = locale
			
			let dayFormatter = NSDateFormatter()
			dayFormatter.dateFormat = "EEE"
			dayFormatter.timeZone = timeZone
			dayFormatter.locale = locale
			
			for course in courses
			{
				if (course.begin.isToday())
				{
					timeLabelText = timeFormatter.stringFromDate(course.begin)
				}
				else
				{
					timeLabelText = "\(dayFormatter.stringFromDate(course.begin)) at \(timeFormatter.stringFromDate(course.begin))"
				}
				
				if courseLabelText == nil
				{
					courseLabelText = "\(course.subject) in \(course.room)"
				}
				else
				{
					courseLabelText! += "\n\(course.subject) in \(course.room)"
				}
			}
		}
		
		self.timeLabel.setText(timeLabelText ?? "unknown time")
		self.courseLabel.setText(courseLabelText ?? "unknown course")
	}
}