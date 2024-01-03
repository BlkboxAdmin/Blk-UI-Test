//
//  ChangePasswordView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import SwiftUI

struct ChangePasswordView: View {
	
	@StateObject var viewModel = SettingsViewModel()
	@State private var oldPassword: String = ""
	@State private var newPasword: String = ""
	@State private var repeatNewPasword: String = ""
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(spacing: 28) {
				LabelPasswordView(password: $oldPassword, label: "Old Password")
				LabelPasswordView(password: $newPasword, label: "New Password")
				LabelPasswordView(password: $repeatNewPasword, label: "Repeat Password")
				
				Spacer()
			}
			.padding(.horizontal, 22)
			.margin(top: 130)
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: {
					viewModel.changePassword(oldPassword: oldPassword, newPassword: newPasword, repeatPassword: repeatNewPasword) {message,status in 
						toastControl.toast(message, status)
					}
					
				}, label: {
					Image("check-square")
				})
			}
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Change Password")
			}
		}
		.adaptsToKeyboard()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
