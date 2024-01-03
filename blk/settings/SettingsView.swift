//
//  SettingsView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct SettingsView: View {
	
	@StateObject var viewModel = SettingsViewModel()
	@State var showOnline: Bool = true
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(spacing: 16) {
				NavigationLink(destination: EditProfileView(), label: {
					SettingRowView(label: "Edit Profile")
				})
				NavigationLink(destination: NotificationSettingsView(), label: {
					SettingRowView(label: "Notifications")
				})
				NavigationLink(destination: PrivacyView(), label: {
					SettingRowView(label: "Privacy policy")
				})
				NavigationLink(destination: BlockListView(), label: {
					SettingRowView(label: "Blocklist")
				})
				NavigationLink(destination: ChangePasswordView(), label: {
					SettingRowView(label: "Change Password")
				})
				NavigationLink(destination: ReportView(), label: {
					SettingRowView(label: "Report")
				})
				SettingRowView(label: "Show Online", type: .switchButton, isOn: $showOnline) { isOn in
					viewModel.saveSetting("show_online", isOn ?? false)
				}
				
				Spacer()
			}
			.padding(.horizontal, 22)
			.margin(top: 20)
			.onAppear() {
				viewModel.getSettings()
				showOnline = (viewModel.settings?.showOnline) ?? false
			}
			CommonView(viewModel: .constant(viewModel))
		}
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Settings")
			}
		}
    }
}

enum SettingType {
case switchButton, navLink
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
