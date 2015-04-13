//
//  RoosterKit.swift
//  Rooster
//
//  Created by Bas on 07/03/2015.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

public enum Weekday: Int
{
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

extension NSDate
{
    public var weekday: Weekday
    {
        let weekday = NSCalendar.currentCalendar().components(.CalendarUnitWeekday, fromDate: self).weekday
        
        switch(weekday)
        {
            case 1:
                return .Sunday
                
            case 2:
                return .Monday
                
            case 3:
                return .Tuesday
                
            case 4:
                return .Wednesday
                
            case 5:
                return .Thursday
                
            case 6:
                return .Friday
                
            case 7:
                return .Saturday
                
            default:
                return .Monday
        }
    }
    
    private func lastMonday() -> NSDate
    {
        let daysUntil: Double
        
        switch(self.weekday)
        {
            case .Monday:
                daysUntil = 0
            default:
                daysUntil = Double(self.weekday.rawValue - 2)
        }
        
        let toLastMonday = 24 * 60 * 60 * -daysUntil
        
        return self.dateByAddingTimeInterval(toLastMonday)
    }
    
    private func nextMonday() -> NSDate
    {
        let daysUntil: Double
        
        switch(self.weekday)
        {
            case .Sunday:
                daysUntil = 1
                
            case .Saturday:
                daysUntil = 2
                
            default:
                daysUntil = Double(8 - self.weekday.rawValue)
        }
        
        let toNextMonday = 24 * 60 * 60 * daysUntil
        
        return self.dateByAddingTimeInterval(toNextMonday)
    }
    
    public func roosterMonday() -> NSDate
    {
        switch(self.weekday)
        {
            case .Saturday, .Sunday:
                return self.nextMonday()
                
            case .Monday, .Tuesday, .Wednesday, .Thursday, .Friday:
                return self.lastMonday()
        }
    }
    
    public func isDay(day: Weekday) -> Bool
    {
        if self.weekday == day
        {
            return true
        }
        
        return false
    }
    
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
	/**
		Returns the earliest course(s) in a list of courses.
		
		:param: courses One or more Course objects.
		
		:returns: Course(s), which is/are the closest to now.
	*/
	public class func soonestDates(courses: [Course]) -> [Course]?
	{
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
			else if (!course.begin.inPast())
			{
				earliest = [course]
			}
		}
		
		return earliest
	}
	
	public class func todayCourses(inCourses courses: [Course]) -> [Course]?
	{
		var today: [Course]!
		
		for course in courses
		{
			if (course.begin.isToday())
			{
				if today != nil
				{
					today.append(course)
				}
				else
				{
					today = [course]
				}
			}
		}
		
		return today
	}
    
    public class func dayCourses(forDay day: Weekday, inCourses courses: [Course]) -> [Course]?
    {
        var today: [Course]!
        
        for course in courses
        {
            if (course.begin.weekday == day)
            {
                if today != nil
                {
                    today.append(course)
                }
                else
                {
                    today = [course]
                }
            }
        }
        
        return today
    }
}
