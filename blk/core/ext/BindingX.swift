//
//  BindingX.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

extension Binding {
	func toString(format: String = "MM/dd/yyyy") -> Binding<String>
	{
		let date = self.wrappedValue
		let formatter = DateFormatter()
		formatter.dateFormat = format
		
		return Binding<String>.constant(formatter.string(from: date as! Date))
	}
}
