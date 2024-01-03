//
//  CheckboxView.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct CheckboxView: View {
	
	@State var isOn: Bool = false
	
    var body: some View {
        Button(action: {
			isOn.toggle()
		}, label: {
			Image(systemName: isOn ? "checkmark.square" : "square")
				.resizable()
				.foregroundColor(ColorX.border)
				.frame(width: 20.0, height: 20.0)
		})
    }
}

struct CheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxView()
    }
}
