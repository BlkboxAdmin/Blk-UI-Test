//
//  PrimaryButtonView.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct PrimaryButtonView: View {
	
	var title: String = "Submit"
	var action: () -> Void
	
    var body: some View {
        Button(action: action
			   , label: {
			Text(title)
				.frame(height: 65)
				.frame(maxWidth: .infinity)
				.padding(.horizontal, 10)
				.background(ColorX.selectedFg)
				.foregroundColor(.black)
				.fontSize(18)
				.fontBold(.bold)
				.textCase(.uppercase)
		})
		.cornerRadius(8)
		
		
		
    }
}

struct PrimaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonView(title: "Sign In", action: {})
    }
}
