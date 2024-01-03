//
//  NavM.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
	
	var backgroundColor: Color?
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.safeAreaInset(edge: .top) {
					backgroundColor
						.frame(height: 90)
						.cornerRadius(22)
				}
				.ignoresSafeArea()
		}
	}
}

extension View {
	
	func navigationBarColor(_ backgroundColor: Color?) -> some View {
		self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
	}
	
}
