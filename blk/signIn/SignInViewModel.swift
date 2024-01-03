//
//  SignInViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI
import SwiftKeychainWrapper

class SignInViewModel: BaseViewModel {
	@Published var username: String = "chknabeel@hotmail.com"
	@Published var password: String = "Qwerty!2"
	@Published var phone: String = ""
	@Published var birthDate: Date = Date()
	@Published var email: String = ""
	@Published var isSignInTab: Bool = true
	
	func isAlreadySignedIn()
	{
		let user = getUserPref(Common.userKey)
		if user == nil {
			return
		}
		
		getUserProfile(userId: user!.id)
	}
	
	func getUserProfile(userId: String)
	{
		postRequest(endPoint: "/api/user/profile/\(userId)") { data, status, message  in
			
			if (status == .success) {
				let mediaDetail = try! JSONDecoder().decode(UploadUrlData.self, from: data)
				let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
				let media = mediaDetail.data.media!
				
				Common.CF_ACCOUNT_HASH = media.cf_account_hash
				Common.CF_IMG_HOST = media.cf_image_host
				Common.CF_VIDEO_HOST = media.cf_video_host
				
				Common.user = detail.data
				saveUserPref(Common.userKey, Common.user!)
				self.isSignedIn = true
			}
		}
	}
	
	func signIn(callback: callback)
	{
		if username.isEmpty {
			callback?("Username is required", .error)
			return
		}
		
		if password.isEmpty {
			callback?("Password is required", .error)
			return
		}
		
		let token: String = KeychainWrapper.standard.string(forKey: Common.deviceTokenKey) ?? ""
		
		let formData: [String: Any] = [
			"email": username.lowercased(),
			"password": password,
			"device_token": token
		]
		postRequest(endPoint: "/api/login", params: formData, authorization: false) { data, status, message  in
			
			if (status == .success) {
				
				let response = try! JSONDecoder().decode(Auth.self, from: data)
				let detail = response.data
				
				let saveSuccessful: Bool = KeychainWrapper.standard.set(detail.accessToken, forKey: Common.jwtKey)
				
				if !saveSuccessful {
					return
				}
				
				self.getUserProfile(userId: detail.user.id)
			}
			
			callback?(message, status)
		}
	}
	
	func signUp(callback: callback)
	{
		if username.isEmpty {
			callback?("Username is required", .error)
			return
		}
		
		if password.isEmpty {
			callback?("Password is required", .error)
			return
		}
		
		if phone.isEmpty {
			callback?("Phone is required", .error)
			return
		}
		
		if birthDate.toString().isEmpty {
			callback?("Date of birth is required", .error)
			return
		}
		
		let token: String = KeychainWrapper.standard.string(forKey: Common.deviceTokenKey) ?? ""
		
		let formData: [String: Any] = [
			"email": username.lowercased(),
			"password": password,
			"phone": phone,
			"dob": birthDate.toString(),
			"device_token": token
		]
		postRequest(endPoint: "/api/new", params: formData, authorization: false) { data, status, message  in
			
			if (status == .success) {
				self.isSignInTab = true
			}
			
			callback?(message, status)
		}
	}
	
	func forgotPassword(callback: callback)
	{
		if email.isEmpty {
			callback?("Email is required", .error)
			return
		}
		
		let formData: [String: Any] = [
			"email": email.lowercased()
		]
		postRequest(endPoint: "/api/forgot-password", params: formData, authorization: false) { data, status, message  in
			
			if (status == .success) {
				self.isSignInTab = true
			}
			
			callback?(message, status)
		}
	}
}
