//
//  StringX.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

extension String {
	var br2nl: String {
		
		var text = self.replacingOccurrences(of: "<br />", with: "\n")
		text = text.replacingOccurrences(of: "<br>", with: "\n")
		text = text.replacingOccurrences(of: "<br/>", with: "\n")
		
		return text
	}
	
	var html2AttributedString: NSAttributedString? {
		do {
			return try NSAttributedString(data: data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!,
										  options: [.documentType: NSAttributedString.DocumentType.html,
													.characterEncoding: String.Encoding.utf8.rawValue],
										  documentAttributes: nil)
		} catch {
			print("error: ", error)
			return nil
		}
	}
	var html2String: String {
		return html2AttributedString?.string ?? ""
	}
	
	var stripSlashes: String {
		return self.replacingOccurrences(of: "\\", with: "")
	}
	
	var clearFormat: String {
		var number: String = self.replacingOccurrences(of: "(", with: "")
		number = number.replacingOccurrences(of: ")", with: "")
		number = number.replacingOccurrences(of: "-", with: "")
		number = number.replacingOccurrences(of: " ", with: "")
		return number
	}
	
	func strRegexReplace(regex: String, replacementStr: String) -> String
	{
		var str = self
		let regex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
		str = regex.stringByReplacingMatches(in: str, options: [], range: NSRange(0..<str.utf16.count), withTemplate: replacementStr)
		
		return str
	}
	
	func toDate(format: String = "MM/dd/yyyy") -> Date
	{
		let formatter = DateFormatter()
		formatter.dateFormat = format
		
		let date = self.replacingOccurrences(of: "T", with: " ")
			.replacingOccurrences(of: ".", with: " +")
			.replacingOccurrences(of: "Z", with: "0")
		
		return(formatter.date(from: date))!
	}
	
	var toTimeAgo: String {
		
		let date = self.toDate(format: "yyyy-MM-dd HH:mm:ss Z")
		let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
		
		if let year = interval.year, year > 0 {
			return year == 1 ? "\(year)" + " " + "year ago" :
			"\(year)" + " " + "years ago"
		} else if let month = interval.month, month > 0 {
			return month == 1 ? "\(month)" + " " + "month ago" :
			"\(month)" + " " + "months ago"
		} else if let day = interval.day, day > 0 {
			return day == 1 ? "\(day)" + " " + "day ago" :
			"\(day)" + " " + "days ago"
		} else if let hour = interval.hour, hour > 0 {
			return hour == 1 ? "\(hour)" + " " + "hour ago" :
			"\(hour)" + " " + "hours ago"
		} else if let minute = interval.minute, minute > 0 {
			return minute == 1 ? "\(minute)" + " " + "minute ago" :
			"\(minute)" + " " + "minutes ago"
		} else if let second = interval.second, second > 0 {
			return second == 1 ? "\(second)" + " " + "second ago" :
			"\(second)" + " " + "seconds ago"
		} else {
			return "a moment ago"
		}
		
	}
}

