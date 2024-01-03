//
//  LabelPasswordView.swift
//  blk
//
//  Created by Nabeel Shafique on 06/11/2022.
//

import SwiftUI

struct LabelPasswordView: View {
	@State private var isSecure: Bool = true
	@Binding var password: String
	var label: String = "Password"
	
	var body: some View {
		VStack {
			ZStack {
				HStack {
					ZStack(alignment: .leading) {
						if isSecure {
							SecureField("", text: $password)
								.foregroundColor(ColorX.primaryFg)
								.font(FontX.fontSize(18))
						}
						else {
							TextField("", text: $password)
								.foregroundColor(ColorX.primaryFg)
								.fontSize(18)
						}
					}
					Button(action: {
						isSecure.toggle()
					}, label: {
						Image(systemName: isSecure ? "eye.slash" : "eye")
							.foregroundColor(ColorX.border)
					})
				}
				.frame(height: 65)
				.padding(.horizontal)
				.background(.black)
				.border(width: 1, cornerRadius: 8)
				
				GeometryReader { geo in
					HStack {
						Text(label)
							.foregroundColor(ColorX.selectedFg)
							.padding(.horizontal, 6)
							.background(.black)
							.fontSize(14)
					}
					.offset(x: 10,y: -9)
				}
			}
			.frame(height: 65)
		}
	}
}

struct LabelPasswordView_Previews: PreviewProvider {
    static var previews: some View {
		LabelPasswordView(password: .constant("123456"), label: "Old Password")
    }
}
