//
//  FontSize.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct FontSize: ViewModifier {
	
	var size: CGFloat = 18
	
	func body(content: Content) -> some View {
		content
			.font(.custom("Inter", fixedSize: size))
	}
}

struct FontBold: ViewModifier {
	
	var weight: Font.Weight = .bold
	
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content
				.fontWeight(weight)
		} else {
			content
				.font(Font.headline.weight(weight))
		}
	}
}

extension View {
	func fontSize(_ size: CGFloat = 18) -> some View {
		modifier(FontSize(size: size))
	}
	
	func fontBold(_ weight: Font.Weight = .bold) -> some View {
		modifier(FontBold(weight: weight))
	}
}
