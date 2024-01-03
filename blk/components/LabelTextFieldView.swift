//
//  LabelTextFieldView.swift
//  blk
//
//  Created by Nabeel Shafique on 06/11/2022.
//

import iPhoneNumberField
import SwiftUI

struct LabelTextFieldView: View {
	
	@Binding var value: String
	var label: String = ""
	var icon: String = ""
	var isReadOnly: Bool = false
	var keyboardType: UIKeyboardType = .default
	var action: () -> Void = {}
	
    var body: some View {
		VStack {
			ZStack {
				HStack {
					
					if label == "Username" {
						Text("@ ")
							.foregroundColor(ColorX.primaryFg)
							.fontSize(18)
					}
					
					ZStack(alignment: .leading) {
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
							}
						}
						
					}
					
					if !icon.isEmpty {
						Button(action: action, label: {
							Image(icon)
								.foregroundColor(ColorX.border)
						})
					}
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
		}
		.frame(height: 65)
    }
}

struct LabelTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextFieldView(value: Binding.constant("John Doe"), label: "Date of Birth")
    }
}
