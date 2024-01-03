//
//  TabM.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct TabBorder: ViewModifier {
	
	var position: Position = .top
	
	func body(content: Content) -> some View {
		
		if position == .top {
			content
				.fontSize(23)
				.padding(.horizontal, 20.0)
				.padding(.top, 25.0)
		}
		else {
			content
				.frame(maxWidth: .infinity)
				.fontSize(23)
				.padding(.bottom, 16.0)
		}
	}
}

enum Position {
case top, bottom
}

extension View {
	
	func tabStyle(_ position: Position = .top) -> some View {
		modifier(TabBorder(position: position))
	}
}
