//
//  RoosterKit.swift
//  Rooster
//
//  Created by Bas on 07/03/2015.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

extension NSDate
{
	/**
		Checks if the date is in the past.
		
		:returns: If date is passed or not
	*/
	public func inPast() -> Bool
	{
		let now = NSDate()
		
		if self.laterDate(now) == now
		{
			return true
		}
		
		return false
	}
	
	/**
		Checks if the date is today.
		
		:returns: If NSDate is today or not.
	*/
	public func isToday() -> Bool
	{
		return NSCalendar.currentCalendar().isDateInToday(self)
	}
}

public class RoosterKit
{
	public init()
	{
		
	}
	
	/**
		Returns the earliest course(s) in a list of courses.
		
		:param: courses One or more Course objects.
		
		:returns: Course(s), which is/are the closest to now.
	*/
	public func getEarliestDates(courses: [Course]) -> [Course]?
	{
		if courses.count == 1
		{
			if courses.first!.begin.inPast()
			{
				// Date is in past
				return nil
			}
			
			return courses
		}
		
		var earliest: [Course]!
		
		for course in courses
		{
			if course.begin.inPast()
			{
				continue
			}
			
			if earliest != nil
			{
				if (earliest.first!.begin.isEqualToDate(course.begin))
				{
					earliest.append(course)
				}
				else if (earliest.first!.begin.earlierDate(course.begin) == course.begin)
				{
					earliest = [course]
				}
			}
			else
			{
				earliest = [course]
			}
		}
		
		return earliest
	}
}
