//
//  TimeStoriesViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 07/11/2022.
//

import Foundation

class TimeStoriesViewModel: BaseViewModel {
	
	@Published var profile: User? = nil
	@Published var timeStories: [TimeStory] = []
	@Published var myTimeStories: [TimeStory] = []
	
	func getProfile(userId: String, callback: callback)
	{
		let id = userId.isEmpty ? Common.user!.id : userId
		postRequest(endPoint: "/api/time_stories/user_profile/\(id)") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
				self.profile = detail.data
			}
			
			callback?(message, status)
		}
	}
	
	func getTimeStories()
	{
		postRequest(endPoint: "/api/time_stories/listing/1") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkTimeStoryData.self, from: data)
				let response = detail.data
				
				self.timeStories = response.rows
			}
		}
	}
	
	func getMyTimeStories(userId: String)
	{
		let formData: [String: Any] = [
			"userId": userId
		]
		postRequest(endPoint: "/api/time_stories/listing_by_user/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkTimeStoryData.self, from: data)
				let response = detail.data
				
				self.myTimeStories = response.rows
			}
		}
	}
	
	func fav(storyId: String, callback: callback)
	{
		putRequest(endPoint: "/api/time_stories/fav/\(storyId)") { data, status, message  in
			
			if (status == .success) {
				self.getTimeStories()
			}
			
			callback?(message, status)
		}
	}
	
	func repost(story: TimeStory, callback: callback)
	{
		let nextDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
		let formData: [String: Any] = [
			"description": story.description,
			"expiring_on": nextDate!.toString(format: "yyyy-MM-dd HH:mm:ss Z")
		]
		putRequest(endPoint: "/api/time_stories/repost/\(story.id)", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getTimeStories()
			}
			
			callback?(message, status)
		}
	}
	
	func viewStory(_ story: TimeStory?)
	{
		if story == nil {
			return
		}
		
		if story!.created_by == Common.user!.id {
			return
		}
		
		putRequest(endPoint: "/api/time_stories/viewed/\(story!.id)") { data, status, message  in
			
			if (status == .success) {
				
			}
		}
	}
}
