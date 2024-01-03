//
//  GenericModifiers.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI
import Combine

struct SingleBorder: ViewModifier {
	
	var width: CGFloat = 1
	var alignment: Alignment = .top
	var color: Color = .black
	
	func body(content: Content) -> some View {
		content
			.overlay(
				Divider()
					.frame(maxWidth: .infinity, maxHeight: width)
					.background(color), alignment: alignment)
	}
}

struct Border: ViewModifier {
	
	var width: CGFloat = 1
	var cornerRadius: CGFloat = 0
	var color: Color = ColorX.border
	
	func body(content: Content) -> some View {
		content
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(color, lineWidth: width)
			)
	}
}

extension View {
	func singleBorder(_ alignment: Alignment = .top, _ width: CGFloat = 1, _ color: Color = .black) -> some View {
		modifier(SingleBorder(width: width, alignment: alignment, color: color))
	}
	
	func border(width: CGFloat = 1, cornerRadius: CGFloat = 0, color: Color = ColorX.border) -> some View {
		modifier(Border(width: width, cornerRadius: cornerRadius,  color: color))
	}
}

struct MarginModifier: ViewModifier {
	let top: CGFloat
	let bottom: CGFloat
	let left: CGFloat
	let right: CGFloat
	
	func body(content: Content) -> some View {
		VStack {
			Spacer()
				.frame(height: top)
			HStack {
				Spacer()
					.frame(width: left)
				content
				Spacer()
					.frame(width: right)
			}
			Spacer()
				.frame(height: bottom)
		}
	}
}

extension View {
	public func margin(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> some View {
		self.modifier(MarginModifier(top: top, bottom: bottom, left: left, right: right))
	}
}

struct XBackground: ViewModifier {
	
	var color: Color = .white
	
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content
				.background(color)
				.scrollContentBackground(.hidden)
		} else {
			content
				.background(color)
		}
	}
}

extension View {
	public func xBackground(_ color: Color = .white) -> some View {
		self.modifier(XBackground(color: color))
	}
}

struct AdaptsToKeyboard: ViewModifier {
	@State var currentHeight: CGFloat = 0
	
	func body(content: Content) -> some View {
		GeometryReader { geometry in
			content
				.padding(.bottom, self.currentHeight)
				.onAppear(perform: {
					NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
						.merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
						.compactMap { notification in
							withAnimation(.easeOut(duration: 0.16)) {
								notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
							}
						}
						.map { rect in
							rect.height - geometry.safeAreaInsets.bottom
						}
						.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
					
					NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
						.compactMap { notification in
							CGFloat.zero
						}
						.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
				})
		}
	}
}

extension View {
	func adaptsToKeyboard() -> some View {
		return modifier(AdaptsToKeyboard())
	}
}
