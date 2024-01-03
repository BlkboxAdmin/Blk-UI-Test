//
//  CardViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import Foundation

class CardViewModel: BaseViewModel {
	
	@Published var profile: User? = nil
	@Published var tiles: [Story] = []
	@Published var frames: [Story] = []
	
	func getProfile(userId: String, callback: callback)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		postRequest(endPoint: "/api/user/profile/\(id)") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
				self.profile = detail.data
			}
			
			callback?(message, status)
		}
	}
	
	func getTileFeed(userId: String)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		let formData: [String: Any] = [
			"type": "tile",
			"userId": id
		]
		postRequest(endPoint: "/api/stories/listing_by_user/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkStoryData.self, from: data)
				self.tiles = detail.data.rows
			}
		}
	}
	
	func getFrameFeed(userId: String)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		let formData: [String: Any] = [
			"type": "frame",
			"userId": id
		]
		postRequest(endPoint: "/api/stories/listing_by_user/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkStoryData.self, from: data)
				self.frames = detail.data.rows
			}
		}
	}
}
