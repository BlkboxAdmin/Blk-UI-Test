//
//  signInView.swift
//  blk
//
//  Created by Nabeel Shafique on 30/10/2022.
//

import SwiftUI

struct SignInView: View {
	
	@State private var isForgotPassword: Bool = false
	@State private var showPassword: Bool = false
	@State private var showDatePicker: Bool = false
	@StateObject var toastControl = ToastControl()
	@StateObject var viewModel = SignInViewModel()
	
	var body: some View {
		ZStack {
			if viewModel.isSignedIn {
				ContentView(signInViewModel: viewModel)
			}
			else {
				ZStack {
					background
						.onTapGesture {
							showDatePicker = false
						}
					VStack {
						VStack() {
							if !isForgotPassword {
								signInSignUpForm
							}
							else
							{
								forgotPasswordForm
							}
						}
						.frame(maxWidth: .infinity, minHeight: 100)
						.background(ColorX.secondaryBg)
						.cornerRadius(13)
					}
					.padding(.horizontal, 24.0)
					.onTapGesture {
						showDatePicker = false
					}
					
					if showDatePicker {
						DatePicker("", selection: $viewModel.birthDate)
							.datePickerDesign()
					}
				}
			}
			
			CommonView(viewModel: .constant(viewModel))
			
			ToastView()
		}
		.onAppear() {
			viewModel.isAlreadySignedIn()
		}
		.environmentObject(toastControl)
	}
	
	var signInSignUpForm: some View {
		VStack {
			HStack(alignment: .top) {
				signInTab
				Spacer()
					.frame(width: 53)
				signUpTab
			}
			.frame(maxWidth: .infinity)
			
			Spacer()
				.frame(height: 57)
			
			if viewModel.isSignInTab {
				signInContent
			}
			else {
				signUpContent
			}
		}
	}
	
	var signInTab: some View {
		Button {
			viewModel.isSignInTab.toggle()
		} label: {
			Text("Sign In")
				.foregroundColor(!viewModel.isSignInTab ? ColorX.secondaryFg : ColorX.selectedFg)
				.tabStyle()
				.singleBorder(.top, 3, !viewModel.isSignInTab ? Color.clear : ColorX.selectedFg)
		}
	}
	
	var signUpTab: some View {
		Button {
			viewModel.isSignInTab.toggle()
		} label: {
			Text("Sign Up")
				.foregroundColor(viewModel.isSignInTab ? ColorX.secondaryFg : ColorX.selectedFg)
				.tabStyle()
				.singleBorder(.top, 3, viewModel.isSignInTab ? Color.clear : ColorX.selectedFg)
		}
	}
	
	var signInContent: some View {
		VStack (alignment: .leading) {
			
			TextFieldView(value: $viewModel.username, placeholder: "Username", keyboardType: .emailAddress)
			
			Spacer()
				.frame(height: 16)
			
			PasswordView(password: $viewModel.password)
			
			HStack {
				CheckboxView()
				Text("Remember Me")
					.fontSize(18)
					.foregroundColor(.white)
				
			}
			.margin(top: 26)
			
			PrimaryButtonView(title: "Sign In", action: {
				
				viewModel.signIn() {message,status in
					toastControl.toast(message, status)
				}
			})
			.margin(top: 26)
			
			Button("Forget Something?") {
				isForgotPassword = true
			}
			.frame(maxWidth: .infinity)
			.foregroundColor(ColorX.selectedFg)
			.fontSize(18)
			.fontBold(.medium)
			.margin(top: 28, bottom: 40)
		}
		.padding(.horizontal, 19.0)
	}
	
	var signUpContent: some View {
		VStack {
			TextFieldView(value: $viewModel.username, placeholder: "Username", keyboardType: .emailAddress)
				.margin(bottom: 16)
			
			PasswordView(password: $viewModel.password)
				.margin(bottom: 16)
			
			TextFieldView(value: $viewModel.phone, placeholder: "Phone Number", keyboardType: .phonePad)
				.margin(bottom: 16)
			
			TextFieldView(
				value: $viewModel.birthDate.toString(),
				placeholder: "Date of Birth",
				customIcon: "calendar",
				isReadOnly: true
			) {
				showDatePicker.toggle()
			}
			.margin(bottom: 16)
			
			PrimaryButtonView(title: "Sign Up" ,action: {
				viewModel.signUp() { message, status  in
					toastControl.toast(message, status)
				}
			})
			.margin(bottom: 36)
		}
		.padding(.horizontal, 19.0)
	}
	
	var forgotPasswordForm: some View {
		VStack {
			Text("Forgot your password?")
				.foregroundColor(.white)
				.fontSize(23)
				.margin(top: 41, bottom: 14)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			Text("Don’t worry, enter your email and we will send you a link to reset your password")
				.foregroundColor(ColorX.primaryFg)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontSize(16)
				.margin(bottom: 28)
			
			TextFieldView(value: $viewModel.email, placeholder: "Email Address", keyboardType: .emailAddress)
				.margin(bottom: 22)
			
			PrimaryButtonView( title: "SEND LINK", action: {
				viewModel.forgotPassword() {message,status in
					toastControl.toast(message)
				}
			})
			.margin(bottom: 33)
			
			Button("Back to Sign in", action: {
				isForgotPassword = false
			})
			.margin(bottom: 50)
			.foregroundColor(ColorX.selectedFg)
			.fontSize(18)
			.fontBold(.medium)
		}
		.padding(.horizontal, 19.0)
	}
	
	var background: some View {
		ZStack{
			Color.black
				.ignoresSafeArea()
			GeometryReader { geo in
				Image("signin_bg")
					.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).minY + 130)
			}
			
			GeometryReader { geo in
				Image("logo-166x70")
					.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).maxY - 39)
			}
		}
	}
}

struct signInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
