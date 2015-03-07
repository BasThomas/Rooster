//
//  Course.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

public class Course
{
	public var begin: NSDate!
	public var oBegin: String!
	public var end: NSDate!
	public var oEnd: String!
	public var day: NSDate!
	public var room: String!
	public var subject: String!
	public var teacher: String!
	public var description: String!
	
	public init(begin: String, end: String, room: String, subject: String, teacher: String, description: String)
	{
		self.oBegin = begin
		self.oEnd = end
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
		
		self.begin = dateFormatter.dateFromString(begin)
		self.end = dateFormatter.dateFromString(end)
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		let day = (begin as NSString).substringToIndex(10)
		self.day = dateFormatter.dateFromString(day)
		
		self.room = room
		self.subject = subject
		self.teacher = teacher
		self.description = description
	}
}
