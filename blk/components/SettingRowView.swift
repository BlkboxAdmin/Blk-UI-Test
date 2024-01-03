//
//  SettingRowView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import SwiftUI

struct SettingRowView: View {
	
	var label: String
	var type: SettingType = .navLink
	var isOn: Binding<Bool>? = nil
	var action: ((Bool?) -> Void)? = nil
	
	
    var body: some View {
		HStack {
			Text(label)
				.foregroundColor(.white)
				.margin(left: 24)
			Spacer()
			
			if type == .navLink
			{
				Image(systemName: "chevron.forward")
					.frame(width: 24, height: 24)
					.foregroundColor(.white)
					.margin(right: 24)
			}
			else
			{
				Toggle(isOn: isOn!, label: {})
					.margin(right: 17)
					.tint(ColorX.selectedFg)
					.onChange(of: isOn?.wrappedValue) { _ in
						action?(isOn?.wrappedValue)
					}
			}
		}
		.frame(height: 72)
		.background(ColorX.secondaryBg)
		.cornerRadius(11)
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
		SettingRowView(label: "Show Online", type: .switchButton, isOn: .constant(true))
    }
}
