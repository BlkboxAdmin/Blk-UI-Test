//
//  BoardViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

class BoardViewModel: BaseViewModel {

	@Published var profile: User? = nil
	@Published var activities: [Activity] = []
	@Published var stories: [Story] = []
	
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
	
	func getActivities(userId: String)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		let formData: [String: Any] = [
			"userId": id
		]
		postRequest(endPoint: "/api/activities/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(ActivityListData.self, from: data)
				let response = detail.data
				self.activities = response.rows
			}
		}
	}
	
	func getBoardData(userId: String)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		
		let formData: [String: Any] = [
			"type": "frame",
			"userId": id
		]
		postRequest(endPoint: "/api/stories/blkboard_by_user/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkStoryData.self, from: data)
				self.stories = detail.data.rows
			}
		}
	}
	
	
	
	func blockUser(callback: callback) {
		let formData: [String: Any] = [
			"blockedUserId": profile!.id
		]
		postRequest(endPoint: "/api/user/blockList/new", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.postRequest(endPoint: "/api/user/profile/\(Common.user!.id)") { data, status, message  in
					
					if (status == .success) {
						let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
						Common.user = detail.data
						saveUserPref(Common.userKey, Common.user!)
						
						self.getProfile(userId: self.profile!.id, callback: nil)
					}
				}
			}
			
			callback?(message, status)
		}
	}
	
	func unblockUser(callback: callback)
	{
		let formData: [String: Any] = [
			"blockedUserId": profile!.id
		]
		deleteRequest(endPoint: "/api/user/blockList/delete", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.postRequest(endPoint: "/api/user/profile/\(Common.user!.id)") { data, status, message  in
					
					if (status == .success) {
						let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
						Common.user = detail.data
						saveUserPref(Common.userKey, Common.user!)
						
						self.getProfile(userId: self.profile!.id, callback: nil)
					}
				}
			}
			
			callback?(message, status)
		}
	}
	
	func invite(callback: callback) {
		let formData: [String: Any] = [
			"receiver_user_id": profile!.id
		]
		postRequest(endPoint: "/api/user/invite", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getProfile(userId: self.profile!.id, callback: nil)
			}
			
			callback?(message, status)
		}
	}
	
	func accept(answer: FriendBtnText, callback: callback) {
		let formData: [String: Any] = [
			"answer": answer.rawValue
		]
		putRequest(endPoint: "/api/user/answer_invite/\(profile!.friendShipData!.data!.id)", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getProfile(userId: self.profile!.id, callback: nil)
			}
			
			callback?(message, status)
		}
	}
	
	func unfriend(callback: callback) {
		let formData: [String: Any] = [
			"friend_id": profile!.id
		]
		deleteRequest(endPoint: "/api/user/unfriend", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getProfile(userId: self.profile!.id, callback: nil)
			}
			
			callback?(message, status)
		}
	}
	
	func friendBtnTxt() -> FriendBtnText
	{
		var btnTxt: FriendBtnText = .addFriend
		
		if (profile?.friendShipData?.isInvited ?? false) {
			btnTxt = .invited
		}
		
		if (profile?.friendShipData?.isFriend ?? false) {
			btnTxt = .unfriend
		}
		
		return btnTxt
	}
}
