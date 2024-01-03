//
//  PasswordView.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct PasswordView: View {
	
	@State private var isSecure: Bool = true
	@Binding var password: String
	var placeholder: String = "Password"
	
    var body: some View {
		HStack {
			ZStack(alignment: .leading) {
				if password.isEmpty {
					Text(placeholder)
						.foregroundColor(ColorX.secondaryFg)
						.fontSize(18)
				}
				
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
		.background(ColorX.secondaryBg)
		.border(width: 1, cornerRadius: 8)
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(password: .constant("123456"))
    }
}
