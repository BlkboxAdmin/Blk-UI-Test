//
//  SettingsViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import Foundation
import UIKit

class SettingsViewModel: BaseViewModel {
	
	@Published var settings: User? = nil
	@Published var blockList: [User] = []
	
	func changePassword(oldPassword: String, newPassword: String, repeatPassword: String, callback: callback)
	{
		let formData: [String: Any] = [
			"old_password": oldPassword,
			"password": newPassword,
			"confirm_password": repeatPassword
		]
		putRequest(endPoint: "/api/user/profile/change_password", params: formData) { data, status, message  in
			
			if (status == .success) {
				
			}
			
			callback?(message, status)
		}
	}
	
	func getSettings()
	{
		settings = Common.user
	}
	
	func saveSetting(_ key: String, _ value: Bool)
	{
		let formData: [String: Any] = [
			"\(key)": value
		]
		putRequest(endPoint: "/api/user/profile/settings", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
				Common.user = detail.data
				saveUserPref(Common.userKey, Common.user!)
			}
		}
	}
	
	func uploadProfileImage(image: UIImage, callback: callBackUploadData)
	{
		uploadImageRequest(image: image, fileName: UploadedImage.getFileName(entity: .user) , callback)
	}
	
	func saveProfile(callback: callback)
	{
		if settings == nil {
			callback?("Invalid settings", .error)
			return
		}
		
		if settings!.username!.isEmpty {
			callback?("Username is required", .error)
			return
		}
		
		if settings!.fullname!.isEmpty {
			callback?("Fullname is required", .error)
			return
		}
		
		if settings!.phone!.isEmpty {
			callback?("Phone number is required", .error)
			return
		}
		
		if settings!.dob!.isEmpty {
			callback?("Date of Birth is required", .error)
			return
		}
		
		if settings!.bio!.isEmpty {
			callback?("Bio is required", .error)
			return
		}
		
		let formData: [String: Any] = [
			"username": settings!.username!.lowercased(),
			"fullname": settings!.fullname!,
			"phone": settings!.phone!,
			"dob": settings!.dob!,
			"bio": settings!.bio!,
			"image": settings!.image!
		]
		putRequest(endPoint: "/api/user/profile/update", params: formData) { data, status, message  in
			
			if status == .success {
				Common.user = self.settings
				saveUserPref(Common.userKey, Common.user!)
			}
			
			callback?(message, status)
		}
	}
	
	func getBlockList()
	{
		postRequest(endPoint: "/api/user/blockList") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlockList.self, from: data)
				self.blockList = detail.data ?? []
			}
		}
	}
	
	func unblockUser(_ userId: String, callback: callback)
	{
		let formData: [String: Any] = [
			"blockedUserId": userId
		]
		deleteRequest(endPoint: "/api/user/blockList/delete", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getBlockList()
			}
			
			callback?(message, status)
		}
	}
	
	func report(_ desc: String, callback: callback)
	{
		let formData: [String: Any] = [
			"description": desc
		]
		postRequest(endPoint: "/api/user/report", params: formData) { data, status, message  in
			
			if (status == .success) {
				
			}
			
			callback?(message, status)
		}
	}
}
