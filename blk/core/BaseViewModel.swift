//
//  BaseViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 25/11/2022.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import UIKit

class BaseViewModel: ObservableObject {
	
	@Published var isLoading: Bool = false
	@Published var isUploading: Bool = false
	@Published var uploadProgress: Double = 0
	@Published var isSignedIn: Bool = false
	
	// for push notifications
	@Published var navigate: Bool = false
	@Published var isNewMessage: Bool = false
	@Published var isNewFriendRequest: Bool = false
	
	func getRequest(endPoint: String, params: Parameters? = nil, authorization: Bool = true, _ callback: callBackData = nil)
	{
		isLoading = true
		APIManager.shared.request(method: .get, params: params, endPoint: endPoint, authorization: authorization) {data,status,message in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			callback?(data, status, message)
		}
	}
	
	func postRequest(endPoint: String, params: Parameters? = nil, authorization: Bool = true, _ callback: callBackData = nil)
	{
		isLoading = true
		APIManager.shared.request(method: .post, params: params, endPoint: endPoint, authorization: authorization) {data,status,message in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			callback?(data, status, message)
		}
	}
	
	func putRequest(endPoint: String, params: Parameters? = nil, authorization: Bool = true, _ callback: callBackData = nil)
	{
		isLoading = true
		APIManager.shared.request(method: .put, params: params, endPoint: endPoint, authorization: authorization) {data,status,message in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			callback?(data, status, message)
		}
	}
	
	func deleteRequest(endPoint: String, params: Parameters? = nil, authorization: Bool = true, _ callback: callBackData = nil)
	{
		isLoading = true
		APIManager.shared.request(method: .delete, params: params, endPoint: endPoint, authorization: authorization) {data,status,message in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			callback?(data, status, message)
		}
	}
	
	func uploadImageRequest(image: UIImage, fileName: String? ,params: Parameters? = nil, authorization: Bool = true, _ callback: callBackUploadData = nil)
	{
		isLoading = true
		
		postRequest(endPoint: "/api/upload/image/url") { data, status, message  in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(UploadUrlData.self, from: data)
				let response = detail.data
				
				self.isUploading = true
				APIManager.shared.imageUpload(endPoint: response.uploadURL!, image: image, fileName: fileName, params: [:], uploadProgress: { progress in
					
					self.uploadProgress = progress.fractionCompleted * 100
					
					//print("Upload Progress: \(self.uploadProgress)")
				}) {imgData,status,message in
					
					self.isUploading = false
					
					var imageData = imgData
					
					if imageData == nil {
						imageData = UploadResult(id: response.id!)
					}
					
					callback?(imageData, status, message)
				}
			}
		}
	}
	
	func uploadVideoRequest(video: URL, fileName: String? ,params: Parameters? = nil, authorization: Bool = true, _ callback: callBackUploadData = nil)
	{
		isLoading = true
		
		postRequest(endPoint: "/api/upload/video/url") { data, status, message  in
			
			self.isLoading = false
			
			if status == .warning && message == "Token invalid" {
				self.logout()
				return
			}
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(UploadUrlData.self, from: data)
				let response = detail.data
				
				self.isUploading = true
				APIManager.shared.videoUpload(endPoint: response.uploadURL!, video: video, fileName: fileName, params: [:], uploadProgress: { progress in
					
					self.uploadProgress = progress.fractionCompleted * 100
					
					//print("Upload Progress: \(self.uploadProgress)")
				}) {_ ,status,message in
					
					self.isUploading = false
					
					let videoData = UploadResult(id: response.uid!)
					
					callback?(videoData, status, message)
				}
			}
		}
	}
	
	func logout()
	{
		removeUserPref(Common.userKey)
		let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Common.jwtKey)
		
		if removeSuccessful {
			isSignedIn = false
		}
	}
}
