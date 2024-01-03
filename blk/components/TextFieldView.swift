//
//  TextFieldView.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI
import iPhoneNumberField

struct TextFieldView: View {
	
	@Binding var value: String
	var placeholder: String = ""
	var icon: String = ""
	var customIcon: String = ""
	var isReadOnly: Bool = false
	var keyboardType: UIKeyboardType = .default
	var action: () -> Void = {}
	
    var body: some View {
		HStack {
			ZStack(alignment: .leading) {
				if value.isEmpty {
					Text(placeholder)
						.foregroundColor(ColorX.secondaryFg)
						.fontSize(18)
				}
				
				if isReadOnly {
					Text(value)
						.foregroundColor(ColorX.primaryFg)
						.fontSize(18)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				else {
					
					if keyboardType == .phonePad
					{
						iPhoneNumberField("", text: $value)
							.maximumDigits(10)
							.foregroundColor(ColorX.primaryFg)
							.fontSize(18)
					}
					else
					{
						TextField("", text: $value)
							.foregroundColor(ColorX.primaryFg)
							.fontSize(18)
							.keyboardType(keyboardType)
							.textInputAutocapitalization(.never)
					}
				}
			}
			
			if !icon.isEmpty || !customIcon.isEmpty {
				Button(action: action, label: {
					
					if !icon.isEmpty {
						Image(systemName: icon)
							.foregroundColor(ColorX.border)
					}
					
					if !customIcon.isEmpty {
						Image(customIcon)
							.foregroundColor(ColorX.border)
					}
				})
			}
		}
		
		.frame(height: 65)
		.padding(.horizontal)
		.background(ColorX.secondaryBg)
		.cornerRadius(8)
		.border(width: 1, cornerRadius: 8)
		
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
		TextFieldView(value: Binding.constant("John Doe"), placeholder: "Firstname")
			.margin(left: 22, right: 22)
    }
}
