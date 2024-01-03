//
//  ToolButtonView.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import SwiftUI

struct ToolButtonView: View {
	
	var icon: String
	var label: String
	@Binding var isOn: Bool
	var action: () -> Void
	
    var body: some View {
		Button(action: action, label: {
			VStack {
				Image(icon)
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor( isOn ? ColorX.selectedFg : .white)
					//.margin(bottom: 10)
					.frame(width: 28, height: 28)
				
				Text(label)
					.foregroundColor( isOn ? ColorX.selectedFg : .white)
					.fontSize(16)
			}
		})
		.frame(height: 80)
		.padding(.horizontal, 19)
		.toggleStyle(.button)
		.tint(.clear)
		.background(isOn ? .black : .clear)
		.cornerRadius(6)
    }
}

struct ToolButtonView_Previews: PreviewProvider {
    static var previews: some View {
		ToolButtonView(icon: "type", label: "Text", isOn: .constant(true), action: {})
    }
}
