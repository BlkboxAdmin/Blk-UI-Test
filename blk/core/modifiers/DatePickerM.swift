//
//  DatePickerM.swift
//  blk
//
//  Created by Nabeel Shafique on 10/12/2022.
//

import SwiftUI

struct DatePickerStandard: ViewModifier {
	func body(content: Content) -> some View {
		content
			.datePickerStyle(.graphical)
			.background(ColorX.borderLight)
			.tint(.black)
			.cornerRadius(8)
	}
}

extension View {
	func datePickerDesign() -> some View {
		modifier(DatePickerStandard())
	}
}
