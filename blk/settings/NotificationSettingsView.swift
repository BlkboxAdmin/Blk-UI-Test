//
//  NotificationSettingsView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct NotificationSettingsView: View {
	@StateObject var viewModel = SettingsViewModel()
	@State var pushNotifications: Bool = true
	@State var smsNotifications: Bool = true
	@State var emailNotifications: Bool = true
	
	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(spacing: 16) {
				SettingRowView(label: "Push Notifications", type: .switchButton, isOn: $pushNotifications) { isOn in
					viewModel.saveSetting("push_notification", isOn ?? false)
				}
//				SettingRowView(label: "SMS Notifications", type: .switchButton, isOn: $smsNotifications) { isOn in
//					viewModel.saveSetting("sms_notification", isOn ?? false)
//				}
				SettingRowView(label: "Email notifications", type: .switchButton, isOn: $emailNotifications) { isOn in
					viewModel.saveSetting("email_notification", isOn ?? false)
				}
				
				Spacer()
			}
			.padding(.horizontal, 22)
			.margin(top: 120)
			.onAppear() {
				viewModel.getSettings()
				pushNotifications = (viewModel.settings?.pushNotification) ?? false
				smsNotifications = (viewModel.settings?.smsNotification) ?? false
				emailNotifications = (viewModel.settings?.emailNotification) ?? false
			}
			
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Notifications")
			}
		}
	}
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
